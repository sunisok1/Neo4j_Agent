#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

if [[ ! -d ".venv" ]]; then
  python3 -m venv .venv
fi

. .venv/bin/activate
python -m pip install -q --upgrade pip
python -m pip install -q -r requirements.txt

ARGS=("$@")

# If Docker isn't available (common in corp networks) and user didn't opt out,
# fall back to assuming local Neo4j is already running.
if ! printf '%s\n' "${ARGS[@]:-}" | grep -q -- '--no-start'; then
  if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
    ARGS+=(--no-start)
  fi
fi

python scripts/pull_from_remote.py "${ARGS[@]}"
