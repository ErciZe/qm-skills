#!/usr/bin/env bash
# Bootstrap docx skill: verify the pre-bundled node_modules.
# No npm install, no network access.
#
# The sole dependency (`docx`) is committed under node_modules/ as pure JS.
# Maintainers refresh that bundle via `scripts/bundle-deps.sh`.
#
# Works on macOS (zsh/bash), Linux (bash), and Git Bash on Windows.

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SKILL_DIR"

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

# ─── Verify pre-bundled node_modules ─────────────────────
if [ ! -d node_modules ]; then
  cat >&2 <<EOF
[bootstrap] ERROR: node_modules/ is missing.
This skill ships node_modules/ pre-bundled in git. Your checkout is
incomplete — re-clone the repo, or if you are a maintainer refreshing
deps, run \`bash scripts/bundle-deps.sh\`.
EOF
  exit 1
fi

# ─── Smoke test ──────────────────────────────────────────
node -e "
  require('docx');
  console.log('[bootstrap] docx require() OK');
"

echo "[bootstrap] done"
