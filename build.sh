#!/bin/bash
set -euo pipefail

OPENCLAW_DIR="${OPENCLAW_DIR:-openclaw}"

echo "=== Build ==="

TAG=$(git -C "$OPENCLAW_DIR" describe --tags --exact-match 2>/dev/null || git -C "$OPENCLAW_DIR" tag --points-at HEAD 2>/dev/null | head -n1 || echo "unknown")
echo "Building openclaw:latest base image (tag: ${TAG})..."
docker build "$OPENCLAW_DIR" -t openclaw:latest -t "openclaw:${TAG}"

echo "Building docker compose project..."
docker compose build

echo "=== Done ==="
