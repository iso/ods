#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/openclaw/openclaw.git"
GITHUB_API="https://api.github.com/repos/openclaw/openclaw/releases/latest"
OPENCLAW_DIR="${OPENCLAW_DIR:-openclaw}"

echo "=== Clone latest OpenClaw release ==="

if [ -d "$OPENCLAW_DIR" ] && [ -n "$(ls -A "$OPENCLAW_DIR" 2>/dev/null || true)" ]; then
    echo "Directory '${OPENCLAW_DIR}' already exists and is not empty — skipping."
    exit 0
fi

echo "Fetching latest release from GitHub API ..."
LATEST_TAG=$(curl -fsSL "$GITHUB_API" | grep '"tag_name":' | head -n1 | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_TAG" ]; then
    echo "ERROR: Could not determine latest release tag." >&2
    exit 1
fi

echo "Latest release: ${LATEST_TAG}"
echo "Cloning shallow checkout..."
rm -rf "$OPENCLAW_DIR"
git clone --depth 1 --branch "$LATEST_TAG" "$REPO_URL" "$OPENCLAW_DIR"

echo "=== Done ==="
