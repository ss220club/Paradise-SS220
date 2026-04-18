#!/bin/bash
set -euo pipefail

# This script loops through every subdir here to generate a list of all maps programatically to avoid the list getting out of date

cd _maps
find | grep -Ei ".dmm" | grep -v -e ".before" -e ".backup" > ci_map_testing.dm
sed -i -e 's/.*/#include \"&\"/' ci_map_testing.dm
MAP_COUNT=$(wc -l < ci_map_testing.dm)
echo "Generated map compile file with ${MAP_COUNT} maps"

# Run compilation and capture output
COMPILE_OUTPUT=$(DM -M_compile paradise.dme 2>&1)
COMPILE_STATUS=$?

if [ $COMPILE_STATUS -eq 0 ]; then
    echo "✅ Compilation successful!"
    echo "$COMPILE_OUTPUT"
    exit 0
else
    echo "❌ Compilation failed with errors!"
    echo "$COMPILE_OUTPUT"

    # Optionally extract and display just the error lines
    echo -e "\n--- Error summary ---"
    echo "$COMPILE_OUTPUT" | grep -E "error:" | head -20
    exit 1
fi
