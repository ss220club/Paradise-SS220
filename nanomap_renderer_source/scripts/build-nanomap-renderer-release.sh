#!/bin/bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
cd ..

RUSTFLAGS="${RUSTFLAGS:--A warnings}" cargo build --release -p dmm-tools-cli --bin dmm-tools
