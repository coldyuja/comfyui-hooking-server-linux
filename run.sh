#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

PYTHON_BIN="${PYTHON_BIN:-python3}"

mkdir -p \
  workflow \
  current_work \
  workflow_backup \
  frontend \
  logs \
  mode_workflow \
  current_mode_workflow \
  asset_data \
  asset \
  auto_complete \
  pose_data \
  chain_presets \
  key \
  customprompt

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "[ERROR] Python executable not found: $PYTHON_BIN" >&2
  exit 1
fi

if [ ! -f "venv/bin/activate" ]; then
  echo "[SETUP] Creating virtual environment..."
  rm -rf venv
  "$PYTHON_BIN" -m venv venv --clear
fi

# shellcheck disable=SC1091
source venv/bin/activate

python -m pip install --upgrade pip
pip install -r requirements.txt

export NO_BROWSER="${NO_BROWSER:-1}"
export REAL_COMFY_HOST="${REAL_COMFY_HOST:-127.0.0.1}"
export REAL_COMFY_PORT="${REAL_COMFY_PORT:-8188}"

exec python server.py
