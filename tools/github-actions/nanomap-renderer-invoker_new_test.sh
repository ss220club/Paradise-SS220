#!/bin/bash
set -euo pipefail

if [ -n "${PYTHON:-}" ]; then
	PYTHON_BIN="$PYTHON"
elif command -v python3 >/dev/null 2>&1; then
	PYTHON_BIN="python3"
elif command -v python >/dev/null 2>&1; then
	PYTHON_BIN="python"
else
	echo "Unable to find Python. Set PYTHON or install python3/python." >&2
	exit 127
fi

"$PYTHON_BIN" tools/github-actions/render_nanomaps.py
