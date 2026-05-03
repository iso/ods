#!/bin/bash
set -euo pipefail

OPENCLAW_DIR="${OPENCLAW_DIR:-openclaw}"

echo "=== Build ==="

echo "Building openclaw:stable base image..."
docker build "$OPENCLAW_DIR" -t openclaw:stable

echo "Building docker compose project..."
docker compose build

echo "=== Done ==="
