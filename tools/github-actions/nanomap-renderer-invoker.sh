#!/bin/bash
set -e
# Generate maps
tools/github-actions/dmm-tools-para minimap --enable nanomaps -w 2040 -h 2040 "./_maps/map_files220/stations/boxstation.dmm"
tools/github-actions/dmm-tools-para minimap --enable nanomaps -w 2040 -h 2040 "./_maps/map_files220/stations/deltastation.dmm"
tools/github-actions/dmm-tools-para minimap --enable nanomaps -w 2040 -h 2040 "./_maps/map_files220/stations/metastation.dmm"
# tools/github-actions/dmm-tools-para minimap --enable nanomaps -w 2040 -h 2040 "./_maps/map_files/stations/cerestation.dmm"
# tools/github-actions/dmm-tools-para minimap --enable nanomaps -w 2040 -h 2040 "./_maps/map_files/stations/emeraldstation.dmm"
# Move and rename files so the game understands them
mv "data/nanomaps/boxstation_nanomap_z1.png" "icons/_nanomaps/BoxStation220_nanomap_z1.png"
mv "data/nanomaps/deltastation_nanomap_z1.png" "icons/_nanomaps/DeltaStation220_nanomap_z1.png"
mv "data/nanomaps/metastation_nanomap_z1.png" "icons/_nanomaps/MetaStation220_nanomap_z1.png"
# mv "data/nanomaps/cerestation_nanomap_z1.png" "icons/_nanomaps/CereStation_nanomap_z1.png"
# mv "data/nanomaps/emeraldstation_nanomap_z1.png" "icons/_nanomaps/EmeraldStation_nanomap_z1.png"
