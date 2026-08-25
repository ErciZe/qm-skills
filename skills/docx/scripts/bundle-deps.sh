#!/usr/bin/env bash
# Maintainer script: refresh node_modules after package.json changes.
# All deps are pure JS (no native binaries), so a single `npm install`
# produces a cross-platform bundle. Run, then `git add node_modules`
# and commit.
#
# Requirements: node, npm. Run from anywhere — it cd's to the skill root.

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SKILL_DIR"

echo "[bundle-deps] reinstalling deps..."
rm -rf node_modules
npm install --no-audit --no-fund --ignore-scripts

echo "[bundle-deps] smoke test..."
node -e "require('./node_modules/docx'); console.log('[bundle-deps] docx OK');"

SIZE="$(du -sh node_modules | awk '{print $1}')"
echo "[bundle-deps] OK — node_modules size: ${SIZE}"
echo "[bundle-deps] next: git add node_modules && git commit"
