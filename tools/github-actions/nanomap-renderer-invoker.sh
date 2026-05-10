#!/bin/bash
set -e
# Generate maps
tools/github-actions/dmm-tools-para minimap --enable minimaps -w 2040 -h 2040 "./_maps/map_files220/stations/boxstation.dmm"
tools/github-actions/dmm-tools-para minimap --enable minimaps -w 2040 -h 2040 "./_maps/map_files220/stations/deltastation.dmm"
tools/github-actions/dmm-tools-para minimap --enable minimaps -w 2040 -h 2040 "./_maps/map_files220/stations/metastation.dmm"
# tools/github-actions/dmm-tools-para minimap --enable minimaps -w 2040 -h 2040 "./_maps/map_files/stations/cerestation.dmm"
# tools/github-actions/dmm-tools-para minimap --enable minimaps -w 2040 -h 2040 "./_maps/map_files/stations/emeraldstation.dmm"
# Move and rename files so the game understands them
mv "data/minimaps/boxstation-1.png" "icons/_minimaps/BoxStation220_minimap_z1.png"
mv "data/minimaps/deltastation-1.png" "icons/_minimaps/DeltaStation220_minimap_z1.png"
mv "data/minimaps/metastation-1.png" "icons/_minimaps/MetaStation220_minimap_z1.png"
# mv "data/minimaps/cerestation-1.png" "icons/_minimaps/CereStation_minimap_z1.png"
# mv "data/minimaps/emeraldstation-1.png" "icons/_minimaps/EmeraldStation_minimap_z1.png"
