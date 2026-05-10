#!/bin/bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
cd ..

RUSTFLAGS="${RUSTFLAGS:--A warnings}" cargo build --release --locked -p dmm-tools-cli --bin dmm-tools
