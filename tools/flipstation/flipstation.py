import os
from avulto import DMM, Tile, Path as p # avulto 0.1.11
from tqdm import tqdm

script_dir = os.path.dirname(__file__)
root_dir = os.path.abspath(os.path.join(script_dir, "..", ".."))

stations_dir = os.path.join(root_dir, "_maps", "map_files220", "stations")
generic_dir = os.path.join(root_dir, "_maps", "map_files", "generic")

dest_path = os.path.join(generic_dir, "space.dmm")

stations_to_flip = [
    "boxstation",
    "deltastation",
    "metastation",
]

CABLE_ICON_STATE_FLIPS = {
    "2-4": "2-8",
    "2-8": "2-4",
    "1-8": "1-4",
    "1-4": "1-8",
    "0-8": "0-4",
    "0-4": "0-8",
}

DIR_FLIP = {
    "north": "north",
    "south": "south",
    "west": "east",
    "east": "west",
}

NORTH = 1
SOUTH = 2
EAST = 4
WEST = 8
NORTHEAST = NORTH | EAST
NORTHWEST = NORTH | WEST
SOUTHEAST = SOUTH | EAST
SOUTHWEST = SOUTH | WEST


def flip_dir(prefab_path: p, icon_state, current_dir):
    if prefab_path.child_of("/obj/effect/turf_decal/stripes/corner"):
        if current_dir == WEST:
            return SOUTH
        if current_dir == SOUTHWEST:
            return SOUTHEAST
        if current_dir == SOUTH:
            return WEST
        if current_dir == NORTH:
            return EAST
        if current_dir == EAST:
            return NORTH
        if current_dir == SOUTHEAST:
            return SOUTHWEST
    if prefab_path.child_of("/obj/effect/turf_decal/stripes/line"):
        if current_dir == NORTHEAST:
            return NORTHWEST
        if current_dir == NORTHWEST:
            return NORTHEAST
    if (
        prefab_path.child_of("/turf/simulated/floor/plasteel")
        and icon_state
        and "corner" in icon_state
    ):
        if current_dir == SOUTH:
            return WEST
        if current_dir == WEST:
            return SOUTH
        if current_dir == NORTHWEST:
            return NORTHEAST
        if current_dir == NORTHEAST:
            return NORTHWEST
        if current_dir == NORTH:
            return EAST
        if current_dir == EAST:
            return NORTH
    if prefab_path.child_of("/obj/structure/disposalpipe/segment/corner"):
        if current_dir == SOUTH:
            return EAST
        if current_dir == EAST:
            return SOUTH
        if current_dir == NORTH:
            return WEST
        if current_dir == WEST:
            return NORTH
    if prefab_path.child_of("/obj/machinery/atmospherics/pipe/simple"):
        if current_dir == SOUTHWEST:
            return SOUTHEAST
        if current_dir == NORTHEAST:
            return NORTHWEST
        if current_dir == SOUTHEAST:
            return SOUTHWEST
        if current_dir == NORTHWEST:
            return NORTHEAST

    if prefab_path.child_of("/obj/machinery/atmospherics/trinary"):
        return current_dir

    if prefab_path.child_of("/obj/structure/transit_tube/diagonal"):
        if current_dir == NORTH:
            return EAST
        if current_dir == EAST:
            return NORTH
        if current_dir == SOUTH:
            return WEST
        if current_dir == WEST:
            return SOUTH

    if prefab_path.child_of("/obj/structure/transit_tube"):
        if current_dir == NORTH:
            return SOUTH
        if current_dir == SOUTH:
            return NORTH
        if current_dir == EAST:
            return WEST
        if current_dir == WEST:
            return EAST

    if prefab_path.child_of("/obj/structure/railing/corner"):
        if current_dir == NORTH:
            return EAST
        if current_dir == EAST:
            return NORTH
        if current_dir == SOUTH:
            return WEST
        if current_dir == WEST:
            return SOUTH

    if prefab_path.child_of("/obj/structure/platform/corner"):
        if current_dir == NORTH:
            return SOUTH
        if current_dir == SOUTH:
            return NORTH
        if current_dir == EAST:
            return WEST
        if current_dir == WEST:
            return EAST

    if prefab_path.child_of("/obj/structure/chair/sofa") and str(prefab_path).endswith("corner"):
        if current_dir == NORTH:
            return WEST
        if current_dir == WEST:
            return NORTH
        if current_dir == SOUTH:
            return EAST
        if current_dir == EAST:
            return SOUTH
        if current_dir == NORTHEAST:
            return SOUTHEAST
        if current_dir == SOUTHEAST:
            return NORTHEAST
        if current_dir == NORTHWEST:
            return SOUTHWEST
        if current_dir == SOUTHWEST:
            return NORTHWEST

    if current_dir == EAST:
        return WEST
    if current_dir == WEST:
        return EAST
    if current_dir == NORTHEAST:
        return NORTHWEST
    if current_dir == NORTHWEST:
        return NORTHEAST
    if current_dir == SOUTHEAST:
        return SOUTHWEST
    if current_dir == SOUTHWEST:
        return SOUTHEAST

    return current_dir


def flip_tile(src: Tile, dest: Tile):
    for atom in src.find("/"):
        prefab_path = src.prefab_path(atom)
        if "/directional/" in str(prefab_path):
            prefab_path = prefab_path.parent / DIR_FLIP[prefab_path.stem]
        elif prefab_path == p("/obj/structure/disposalpipe/junction"):
            prefab_path = p("/obj/structure/disposalpipe/junction/reversed")
        elif prefab_path == p("/obj/structure/disposalpipe/junction/reversed"):
            prefab_path = p("/obj/structure/disposalpipe/junction")

        elif prefab_path == p("/obj/structure/disposalpipe/sortjunction"):
            prefab_path = p("/obj/structure/disposalpipe/sortjunction/reversed")
        elif prefab_path == p("/obj/structure/disposalpipe/sortjunction/reversed"):
            prefab_path = p("/obj/structure/disposalpipe/sortjunction")

        elif prefab_path == p("/obj/machinery/atmospherics/trinary/filter"):
            prefab_path = p("/obj/machinery/atmospherics/trinary/filter/flipped")
        elif prefab_path == p("/obj/machinery/atmospherics/trinary/filter/flipped"):
            prefab_path = p("/obj/machinery/atmospherics/trinary/filter")

        elif prefab_path == p("/obj/machinery/atmospherics/trinary/mixer"):
            prefab_path = p("/obj/machinery/atmospherics/trinary/mixer/flipped")
        elif prefab_path == p("/obj/machinery/atmospherics/trinary/mixer/flipped"):
            prefab_path = p("/obj/machinery/atmospherics/trinary/mixer")

        elif prefab_path == p("/obj/machinery/atmospherics/trinary/tvalve"):
            prefab_path = p("/obj/machinery/atmospherics/trinary/tvalve/flipped")
        elif prefab_path == p("/obj/machinery/atmospherics/trinary/tvalve/flipped"):
            prefab_path = p("/obj/machinery/atmospherics/trinary/tvalve")

        elif prefab_path == p("/obj/machinery/atmospherics/trinary/tvalve/bypass"):
            prefab_path = p("/obj/machinery/atmospherics/trinary/tvalve/flipped/bypass")
        elif prefab_path == p("/obj/machinery/atmospherics/trinary/tvalve/flipped/bypass"):
            prefab_path = p("/obj/machinery/atmospherics/trinary/tvalve/bypass")

        elif prefab_path == p("/obj/machinery/atmospherics/trinary/tvalve/digital"):
            prefab_path = p("/obj/machinery/atmospherics/trinary/tvalve/digital/flipped")
        elif prefab_path == p("/obj/machinery/atmospherics/trinary/tvalve/digital/flipped"):
            prefab_path = p("/obj/machinery/atmospherics/trinary/tvalve/digital")

        elif prefab_path == p("/obj/machinery/atmospherics/trinary/tvalve/digital/bypass"):
            prefab_path = p("/obj/machinery/atmospherics/trinary/tvalve/digital/flipped/bypass")
        elif prefab_path == p("/obj/machinery/atmospherics/trinary/tvalve/digital/flipped/bypass"):
            prefab_path = p("/obj/machinery/atmospherics/trinary/tvalve/digital/bypass")

        elif prefab_path == p("/obj/structure/transit_tube/junction"):
            prefab_path = p("/obj/structure/transit_tube/junction/flipped")
        elif prefab_path == p("/obj/structure/transit_tube/junction/flipped"):
            prefab_path = p("/obj/structure/transit_tube/junction")

        elif prefab_path == p("/obj/structure/transit_tube/curved"):
            prefab_path = p("/obj/structure/transit_tube/curved/flipped")
        elif prefab_path == p("/obj/structure/transit_tube/curved/flipped"):
            prefab_path = p("/obj/structure/transit_tube/curved")

        elif prefab_path == p("/obj/structure/transit_tube/station"):
            prefab_path = p("/obj/structure/transit_tube/station/flipped")
        elif prefab_path == p("/obj/structure/transit_tube/station/flipped"):
            prefab_path = p("/obj/structure/transit_tube/station")

        elif prefab_path == p("/obj/structure/transit_tube/station/reverse"):
            prefab_path = p("/obj/structure/transit_tube/station/reverse/flipped")
        elif prefab_path == p("/obj/structure/transit_tube/station/reverse/flipped"):
            prefab_path = p("/obj/structure/transit_tube/station/reverse")

        elif prefab_path == p("/obj/structure/transit_tube/station/reverse"):
            prefab_path = p("/obj/structure/transit_tube/station/reverse/flipped")
        elif prefab_path == p("/obj/structure/transit_tube/station/reverse/flipped"):
            prefab_path = p("/obj/structure/transit_tube/station/reverse")

        elif prefab_path == p("/obj/structure/transit_tube/station/dispenser"):
            prefab_path = p("/obj/structure/transit_tube/station/dispenser/flipped")
        elif prefab_path == p("/obj/structure/transit_tube/station/dispenser/flipped"):
            prefab_path = p("/obj/structure/transit_tube/station/dispenser")

        elif prefab_path == p("/obj/structure/transit_tube/station/dispenser/reverse"):
            prefab_path = p("/obj/structure/transit_tube/station/dispenser/reverse/flipped")
        elif prefab_path == p("/obj/structure/transit_tube/station/dispenser/reverse/flipped"):
            prefab_path = p("/obj/structure/transit_tube/station/dispenser/reverse")

        elif prefab_path == p("/obj/effect/spawner/airlock/e_to_w"):
            prefab_path = p("/obj/effect/spawner/airlock/w_to_e")
        elif prefab_path == p("/obj/effect/spawner/airlock/w_to_e"):
            prefab_path = p("/obj/effect/spawner/airlock/e_to_w")

        elif prefab_path == p("/obj/effect/spawner/airlock/e_to_w/long"):
            prefab_path = p("/obj/effect/spawner/airlock/w_to_e/long")
        elif prefab_path == p("/obj/effect/spawner/airlock/w_to_e/long"):
            prefab_path = p("/obj/effect/spawner/airlock/e_to_w/long")

        elif prefab_path == p("/obj/effect/spawner/airlock/e_to_w/long/square"):
            prefab_path = p("/obj/effect/spawner/airlock/w_to_e/long/square")
        elif prefab_path == p("/obj/effect/spawner/airlock/w_to_e/long/square"):
            prefab_path = p("/obj/effect/spawner/airlock/e_to_w/long/square")

        elif prefab_path == p("/obj/effect/spawner/airlock/e_to_w/long/square/wide"):
            prefab_path = p("/obj/effect/spawner/airlock/w_to_e/long/square/wide")
        elif prefab_path == p("/obj/effect/spawner/airlock/w_to_e/long/square/wide"):
            prefab_path = p("/obj/effect/spawner/airlock/e_to_w/long/square/wide")

        elif prefab_path.stem == "left":
            prefab_path = prefab_path.parent / "right"
        elif prefab_path.stem == "right":
            prefab_path = prefab_path.parent / "left"
        elif prefab_path.stem == "east":
            prefab_path = prefab_path.parent / "west"
        elif prefab_path.stem == "west":
            prefab_path = prefab_path.parent / "east"

        icon_state = src.get_prefab_var(atom, "icon_state", None)
        if prefab_path.child_of("/turf/simulated/floor/plasteel"):
            if "dir" not in src.prefab_vars(atom):
                src.set_prefab_var(atom, "dir", SOUTH)

        dest.add_path(0, prefab_path)
        for var in src.prefab_vars(atom):
            if prefab_path.child_of("/obj/structure/cable") and var == "icon_state":
                icon_state = src.prefab_var(atom, var)
                dest.set_prefab_var(
                    0, var, CABLE_ICON_STATE_FLIPS.get(icon_state, icon_state)
                )
                continue
            if var == "dir":
                current_dir = src.prefab_var(atom, var)
                dest.set_prefab_var(
                    0, var, flip_dir(prefab_path, icon_state, current_dir)
                )
                continue
            if var == "pixel_x" and src.prefab_var(atom, var):
                dest.set_prefab_var(0, var, -src.prefab_var(atom, var))
                continue

            dest.set_prefab_var(0, var, src.prefab_var(atom, var))


def process_station(station_name: str):
    src_path = os.path.join(stations_dir, f"{station_name}.dmm")
    output_path = os.path.join(stations_dir, f"{station_name}_flipped.dmm")

    src_dmm = DMM.from_file(src_path)
    dest_dmm = DMM.from_file(dest_path)

    coords = list(src_dmm.coords())
    progress_bar = tqdm(coords, desc=f"Processing {station_name}", unit="tile")

    for src_coord in progress_bar:
        src_tile = src_dmm.tiledef(*src_coord)
        dest_coord = (256 - src_coord[0], src_coord[1], src_coord[2])
        dest_tile = dest_dmm.tiledef(*dest_coord)
        dest_tile.make_unique()
        while dest_tile.find("/"):
            dest_tile.del_prefab(0)
        flip_tile(src_tile, dest_tile)

    dest_dmm.save_to(output_path)
    print(f"Saved: {output_path}")


if __name__ == "__main__":
    for station in stations_to_flip:
        process_station(station)
