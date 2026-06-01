from pathlib import Path
import subprocess

from avulto import DMM, DME

RENDERER = Path("tools/github-actions/dmm-tools-para")
SCALE = 8


# Папка, для которой нужно добавлять суффикс 220
MAP_FOLDER_220 = Path("_maps/map_files220")
STATION_MAP_FOLDERS = {
    Path("_maps/map_files/stations"),
    Path("_maps/map_files220/stations"),
}
NANOMAPS_DIR = Path("icons/_nanomaps")
RUIN_NANOMAPS_DIR = NANOMAPS_DIR / "ruins"


def render_command(map_path: Path) -> list[str]:
    dmm = DMM.from_file(map_path)
    width = dmm.size.x * SCALE
    height = dmm.size.y * SCALE
    return [
        str(RENDERER),
        "minimap",
        "--enable",
        "nanomaps",
        "-w",
        str(width),
        "-h",
        str(height),
        str(map_path),
    ]


if __name__ == "__main__":
    commands = []

    print("parsing DME...")
    dme = DME.from_file("paradise.dme")

    print("inspecting station maps...")
    for pth in dme.subtypesof("/datum/map"):
        td = dme.types[pth]
        map_path = Path(td.var_decl("map_path").const_val)
        if map_path.parent not in STATION_MAP_FOLDERS:
            print(f"skipping non-station map: {map_path}")
            continue

        technical_name = td.var_decl("technical_name").const_val
        commands.append(render_command(map_path))
        commands.append([
            "mv",
            f"data/nanomaps/{map_path.stem}_nanomap_z1.png",
            f"icons/_nanomaps/{technical_name}_nanomap_z1.png",
        ])

    print("inspecting ruins...")
    for pth in dme.subtypesof("/datum/map_template/ruin"):
        td = dme.types[pth]
        ruin_id = td.var_decl("id").const_val
        if not ruin_id:
            continue

        prefix = td.var_decl("prefix").const_val
        suffix = td.var_decl("suffix").const_val
        if not prefix or not suffix:
            continue

        map_path = Path(prefix) / suffix
        if not map_path.exists():
            print(f"skipping missing ruin map: {map_path}")
            continue

        suffix_220 = "220" if MAP_FOLDER_220 in map_path.parents else ""
        commands.append(render_command(map_path))
        commands.append([
            "mv",
            f"data/nanomaps/{map_path.stem}_nanomap_z1.png",
            f"icons/_nanomaps/ruins/{ruin_id}{suffix_220}_nanomap_z1.png",
        ])

    print("executing...")
    for command in commands:
        subprocess.run(command, check=True)

    print("complete.")
