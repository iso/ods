#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/openclaw/openclaw.git"
GITHUB_API="https://api.github.com/repos/openclaw/openclaw/releases/latest"
OPENCLAW_DIR="${OPENCLAW_DIR:-openclaw}"

echo "=== Update OpenClaw ==="

# Fetch latest release from GitHub
echo "Checking for latest release ..."
LATEST_TAG=$(curl -fsSL "$GITHUB_API" | grep '"tag_name":' | head -n1 | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_TAG" ]; then
    echo "ERROR: Could not determine latest release tag." >&2
    exit 1
fi

# Check current version
CURRENT_TAG=""
if [ -d "$OPENCLAW_DIR/.git" ]; then
    CURRENT_TAG=$(git -C "$OPENCLAW_DIR" describe --tags --exact-match 2>/dev/null || git -C "$OPENCLAW_DIR" tag --points-at HEAD 2>/dev/null | head -n1 || true)
fi

if [ "$CURRENT_TAG" = "$LATEST_TAG" ]; then
    echo "Already up to date (${CURRENT_TAG})."
    exit 0
fi

echo "New release available: ${CURRENT_TAG:-none} -> ${LATEST_TAG}"

# Re-clone with new tag
echo "Cloning ${LATEST_TAG} ..."
rm -rf "$OPENCLAW_DIR"
git clone --depth 1 --branch "$LATEST_TAG" "$REPO_URL" "$OPENCLAW_DIR"

# Build base image
echo "Building openclaw:latest (+ ${LATEST_TAG}) ..."
docker build "$OPENCLAW_DIR" -t openclaw:latest -t "openclaw:${LATEST_TAG}"

# Build compose project
echo "Building docker compose project ..."
docker compose build

echo "=== Update complete (${LATEST_TAG}) ==="
