#!/bin/bash
set -e
# Generate maps
tools/github-actions/nanomap-renderer minimap -w 2040 -h 2040 "./_maps/map_files220/stations/boxstation.dmm"
tools/github-actions/nanomap-renderer minimap -w 2040 -h 2040 "./_maps/map_files220/stations/deltastation.dmm"
tools/github-actions/nanomap-renderer minimap -w 2040 -h 2040 "./_maps/map_files220/stations/metastation.dmm"
# tools/github-actions/nanomap-renderer minimap -w 2040 -h 2040 "./_maps/map_files/stations/cerestation.dmm"
# tools/github-actions/nanomap-renderer minimap -w 2040 -h 2040 "./_maps/map_files/stations/emeraldstation.dmm"
# Move and rename files so the game understands them
cd "data/nanomaps"
mv "boxstation_nanomap_z1.png" "BoxStation220_nanomap_z1.png"
mv "deltastation_nanomap_z1.png" "DeltaStation220_nanomap_z1.png"
mv "metastation_nanomap_z1.png" "MetaStation220_nanomap_z1.png"
# mv "cerestation_nanomap_z1.png" "CereStation_nanomap_z1.png"
# mv "emeraldstation_nanomap_z1.png" "EmeraldStation_nanomap_z1.png"
cd "../../"
cp "data/nanomaps/BoxStation220_nanomap_z1.png" "icons/_nanomaps"
cp "data/nanomaps/DeltaStation220_nanomap_z1.png" "icons/_nanomaps"
cp "data/nanomaps/MetaStation220_nanomap_z1.png" "icons/_nanomaps"
# cp "data/nanomaps/CereStation_nanomap_z1.png" "icons/_nanomaps"
# cp "data/nanomaps/EmeraldStation_nanomap_z1.png" "icons/_nanomaps"
