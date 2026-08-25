#!/usr/bin/env bash
# Bootstrap pptx skill: verify pre-bundled node_modules + ensure a Chromium-based
# browser is available.
#
# Browser strategy (no browser is bundled in the skill — it would blow the size
# limit). In priority order:
#   1. Reuse an existing browser found by scripts/chromium-finder.js
#      (PHOENIX_BROWSER_PATH, ~/.accio/browser/builtin, or a system Chrome/Edge/
#      Brave/Chromium/…).
#   2. If none is found, download Chrome-for-Testing ONCE via playwright into
#      ~/.accio/browser/builtin so chromium-finder picks it up on the next run.
#      cdp-browser.js then drives it over CDP — playwright is only the downloader
#      and is NOT bundled into the skill.
#   3. If the download fails (e.g. offline / slow network), fall back to a clear
#      manual instruction instead of a cryptic runtime error.
#
# Dependencies:
#   - pptxgenjs (in node_modules/, pre-bundled)
#   - A Chromium-based browser (reused or auto-downloaded as above)
#
# Tunables (env vars):
#   PHOENIX_BROWSER_PATH            explicit browser binary; highest priority
#   PPTX_SKIP_BROWSER_DOWNLOAD=1    never auto-download; only reuse/instruct
#   PPTX_BROWSER_DOWNLOAD_TIMEOUT   seconds before the download is aborted (default 600)
#   PLAYWRIGHT_DOWNLOAD_HOST        mirror host for the browser binary (helps in CN)
#
# Works on macOS (zsh/bash), Linux (bash), and Git Bash on Windows.

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SKILL_DIR"

ACCIO_BUILTIN_DIR="${HOME}/.accio/browser/builtin"
DOWNLOAD_TIMEOUT="${PPTX_BROWSER_DOWNLOAD_TIMEOUT:-180}"

# ─── Preflight ───────────────────────────────────────────
if ! command -v node >/dev/null 2>&1; then
  echo "[bootstrap] ERROR: node not found in PATH" >&2
  exit 1
fi

NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]')"
if [ "$NODE_MAJOR" -lt 18 ]; then
  echo "[bootstrap] ERROR: Node >= 18.17 required, got $(node -v)" >&2
  exit 1
fi

# ─── 1. Verify pre-bundled node_modules ──────────────────
if [ ! -d node_modules ]; then
  cat >&2 <<EOF
[bootstrap] ERROR: node_modules/ is missing.
This skill ships node_modules/ pre-bundled. Your install is
incomplete — re-install the skill, or if you are a maintainer
refreshing deps, run \`bash scripts/bundle-deps.sh\`.
EOF
  exit 1
fi

# ─── helpers ─────────────────────────────────────────────

# Echo the discovered browser path (or empty). Never fails the script.
find_browser() {
  node scripts/chromium-finder.js 2>/dev/null \
    | node -e "let s='';process.stdin.on('data',d=>s+=d).on('end',()=>{try{process.stdout.write(JSON.parse(s).executablePath||'')}catch(e){}})" \
    || true
}

# Download Chrome-for-Testing into ACCIO_BUILTIN_DIR via playwright.
# Returns 0 on success (browser then discoverable), non-zero otherwise.
download_browser() {
  if ! command -v npm >/dev/null 2>&1; then
    echo "[bootstrap] npm not found — cannot auto-download a browser." >&2
    return 1
  fi

  local tmp_pw
  tmp_pw="$(mktemp -d "${TMPDIR:-/tmp}/pptx-pw-XXXXXX")"
  # Always clean the throwaway playwright install dir; the downloaded browser
  # lives in ACCIO_BUILTIN_DIR, not here.
  trap 'rm -rf "$tmp_pw"' RETURN

  echo "[bootstrap] no browser found — downloading Chromium (~170MB, one-time)…" >&2
  [ -n "${PLAYWRIGHT_DOWNLOAD_HOST:-}" ] && \
    echo "[bootstrap] using mirror PLAYWRIGHT_DOWNLOAD_HOST=${PLAYWRIGHT_DOWNLOAD_HOST}" >&2

  mkdir -p "$ACCIO_BUILTIN_DIR"

  # Pick a timeout runner. macOS has neither `timeout` nor `gtimeout` by default,
  # so fall back to a pure-bash watchdog that kills the job after DOWNLOAD_TIMEOUT.
  local TIMEOUT_BIN=""
  if command -v timeout >/dev/null 2>&1; then TIMEOUT_BIN="timeout"
  elif command -v gtimeout >/dev/null 2>&1; then TIMEOUT_BIN="gtimeout"; fi

  # run_with_timeout <seconds> <cmd...> — runs cmd, killing it (and its tree)
  # if it exceeds <seconds>. Returns 124 on timeout, else the cmd's exit code.
  run_with_timeout() {
    local secs="$1"; shift
    if [ -n "$TIMEOUT_BIN" ]; then
      "$TIMEOUT_BIN" "${secs}s" "$@"
      return $?
    fi
    # Portable fallback: background job + watchdog that records whether it fired.
    local fired_flag
    fired_flag="$(mktemp "${TMPDIR:-/tmp}/pptx-wd-XXXXXX")"
    "$@" &
    local job=$!
    (
      sleep "$secs"
      if kill -0 "$job" 2>/dev/null; then
        echo 1 > "$fired_flag"
        kill -TERM "$job" 2>/dev/null
        sleep 2
        kill -KILL "$job" 2>/dev/null
      fi
    ) &
    local watchdog=$!
    local rc=0
    wait "$job" 2>/dev/null || rc=$?
    # Job finished first — cancel the watchdog.
    kill "$watchdog" 2>/dev/null || true
    wait "$watchdog" 2>/dev/null || true
    # If the watchdog fired, report a timeout (124) regardless of the kill signal.
    if [ -s "$fired_flag" ]; then rc=124; fi
    rm -f "$fired_flag"
    return $rc
  }

  (
    cd "$tmp_pw"
    npm init -y >/dev/null 2>&1 || true
    # playwright-core ships the `install` CLI without pulling browsers on npm install.
    if ! npm install --no-save --no-audit --no-fund playwright-core >/dev/null 2>&1; then
      echo "[bootstrap] failed to fetch playwright-core (downloader)." >&2
      exit 1
    fi

    export PLAYWRIGHT_BROWSERS_PATH="$ACCIO_BUILTIN_DIR"
    local cli="node_modules/playwright-core/cli.js"
    if [ ! -f "$cli" ]; then
      echo "[bootstrap] playwright-core CLI missing after install." >&2
      exit 1
    fi

    if run_with_timeout "$DOWNLOAD_TIMEOUT" node "$cli" install chromium; then
      :
    else
      rc=$?
      if [ "$rc" = "124" ]; then
        echo "[bootstrap] browser download timed out after ${DOWNLOAD_TIMEOUT}s." >&2
      else
        echo "[bootstrap] browser download failed (exit ${rc})." >&2
      fi
      exit 1
    fi
  )
}

# ─── 2. Ensure a browser ─────────────────────────────────
EXEC_PATH="$(find_browser)"

if [ -z "$EXEC_PATH" ] && [ "${PPTX_SKIP_BROWSER_DOWNLOAD:-0}" != "1" ]; then
  if download_browser; then
    EXEC_PATH="$(find_browser)"
  fi
fi

if [ -n "$EXEC_PATH" ]; then
  echo "[bootstrap] browser ready: ${EXEC_PATH}"
else
  cat >&2 <<EOF
[bootstrap] WARNING: no Chromium-based browser available.
html2pptx / thumbnail_html need Chrome, Edge, Brave, or Chromium.
Resolve with ONE of:
  • Install Google Chrome, Microsoft Edge, or Brave, then re-run bootstrap.
  • Point PHOENIX_BROWSER_PATH at an existing Chromium binary and re-run.
  • Re-run bootstrap with network access so it can auto-download Chromium
    (set PLAYWRIGHT_DOWNLOAD_HOST to a mirror if the default CDN is slow).
EOF
fi

# ─── 3. Smoke test ───────────────────────────────────────
node -e "
  require('pptxgenjs');
  console.log('[bootstrap] pptxgenjs require() OK');
"

echo "[bootstrap] done"
