///////////////////////////////////////////////////////////////
// SS13 Optimized Map loader
//////////////////////////////////////////////////////////////

// As of 3.6.2016
// global datum that will preload variables on atoms instanciation
GLOBAL_VAR_INIT(use_preloader, FALSE)
GLOBAL_DATUM_INIT(_preloader, /datum/dmm_suite/preloader, new())

/**
 * Construct the model map and control the loading process
 *
 * WORKING :
 *
 * 1) Makes an associative mapping of model_keys with model
 *		e.g aa = /turf/simulated/wall{icon_state = "rock"}
 * 2) Read the map line by line, parsing the result (using parse_grid)
 *
 * If `measureOnly` is set, then no atoms will be created, and all this will do
 * is return the bounds after parsing the file
 *
 * If you need to freeze init while you're working, you can use the spacial allocator's
 * "add_dirt" and "remove_dirt" which will put initializations on hold until you say
 * the word. This is important for loading large maps such as the cyberiad, where
 * atmos will attempt to start before it's ready, causing runtimes galore if init is
 * allowed to romp unchecked.
 */
/datum/dmm_suite/proc/load_map(dmm_file, x_offset = 0, y_offset = 0, z_offset = 0, shouldCropMap = FALSE, measureOnly = FALSE)
	var/map_data
	var/fname = "Lambda"
	if(isfile(dmm_file))
		fname = "[dmm_file]"
		// Make sure we dont load a dir up
		var/lastchar = copytext(fname, -1)
		if(lastchar == "/" || lastchar == "\\")
			log_debug("Attempted to load map template without filename (Attempted [dmm_file])")
			return

		// use rustlib to read, parse, process, mapmanip etc
		// this will "crash"/stacktrace on fail
		// is not passed `dmm_file` because byondapi-rs doesn't support resource types yet
		map_data = mapmanip_read_dmm(fname)
		// if rustlib for whatever reason fails and returns null
		// try to load it the old dm way instead
		if(!map_data)
			map_data = wrap_file2text(dmm_file)

		if(!length(map_data))
			throw EXCEPTION("Map path '[fname]' does not exist!")

	if(!x_offset)
		x_offset = 1
	if(!y_offset)
		y_offset = 1
	if(!z_offset)
		z_offset = world.maxz + 1

	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	var/list/grid_models = list()
	var/key_len = 0

	var/datum/dmm_suite/loaded_map/LM = new
	var/expanded_x
	var/expanded_y
	// This try-catch is used as a budget "Finally" clause, as the dirt count
	// needs to be reset
	log_debug("[measureOnly ? "Measuring" : "Loading"] map: [fname]")
	try
		LM.index = 1
		while(dmmRegex.Find(map_data, LM.index))
			LM.index = dmmRegex.next

			// "aa" = (/type{vars=blah})
			if(dmmRegex.group[1]) // Model
				var/key = dmmRegex.group[1]
				if(grid_models[key]) // Duplicate model keys are ignored in DMMs
					continue
				if(key_len != length(key))
					if(!key_len)
						key_len = length(key)
					else
						throw EXCEPTION("Inconsistent key length in DMM")
				if(!measureOnly)
					grid_models[key] = dmmRegex.group[2]

			// (1,1,1) = {"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}
			else if(dmmRegex.group[3]) // Coords
				if(!key_len)
					throw EXCEPTION("Coords before model definition in DMM")

				var/xcrdStart = text2num(dmmRegex.group[3]) + x_offset - 1
				// position of the currently processed square
				var/xcrd
				var/ycrd = text2num(dmmRegex.group[4]) + y_offset - 1
				var/zcrd = text2num(dmmRegex.group[5]) + z_offset - 1

				if(!measureOnly)
					if(zcrd > world.maxz)
						if(shouldCropMap)
							continue
						else
							GLOB.space_manager.increase_max_zlevel_to(zcrd) // create a new z_level if needed

				bounds[MAP_MINX] = min(bounds[MAP_MINX], xcrdStart)
				bounds[MAP_MINZ] = min(bounds[MAP_MINZ], zcrd)
				bounds[MAP_MAXZ] = max(bounds[MAP_MAXZ], zcrd)

				var/list/gridLines = splittext(dmmRegex.group[6], "\n")

				var/leadingBlanks = 0
				while(leadingBlanks < length(gridLines) && gridLines[++leadingBlanks] == "")
				if(leadingBlanks > 1)
					gridLines.Cut(1, leadingBlanks) // Remove all leading blank lines.

				if(!length(gridLines)) // Skip it if only blank lines exist.
					continue

				if(length(gridLines) && gridLines[length(gridLines)] == "")
					gridLines.Cut(length(gridLines)) // Remove only one blank line at the end.

				bounds[MAP_MINY] = min(bounds[MAP_MINY], ycrd)
				ycrd += length(gridLines) - 1 // Start at the top and work down

				if(!shouldCropMap && ycrd > world.maxy)
					if(!measureOnly)
						world.maxy = ycrd // Expand Y here.  X is expanded in the loop below
						expanded_y = TRUE
					bounds[MAP_MAXY] = max(bounds[MAP_MAXY], ycrd)
				else
					bounds[MAP_MAXY] = max(bounds[MAP_MAXY], min(ycrd, world.maxy))

				var/maxx = xcrdStart
				if(measureOnly)
					for(var/line in gridLines)
						maxx = max(maxx, xcrdStart + length(line) / key_len - 1)
				else
					for(var/line in gridLines)
						if(ycrd <= world.maxy && ycrd >= 1)
							xcrd = xcrdStart
							for(var/tpos = 1 to (length(line) - key_len + 1) step key_len)
								if(xcrd > world.maxx)
									if(shouldCropMap)
										break
									else
										world.maxx = xcrd
										expanded_x = TRUE

								if(xcrd >= 1)
									var/model_key = copytext(line, tpos, tpos + key_len)
									if(!grid_models[model_key])
										throw EXCEPTION("Undefined model key in DMM: [model_key]. Map file: [fname].")
									parse_grid(grid_models[model_key], xcrd, ycrd, zcrd, LM)
									// After this call, it is NOT safe to reference `dmmRegex` without another call to
									// "Find" - we might've hit a map loader here and changed its state
									CHECK_TICK

								maxx = max(maxx, xcrd)
								++xcrd
						--ycrd
				bounds[MAP_MAXX] = max(bounds[MAP_MAXX], shouldCropMap ? min(maxx, world.maxx) : maxx)

			CHECK_TICK
	catch(var/exception/e)
		GLOB._preloader.reset()
		// SS220 EDIT START
		// `dmmRegex` is `static` - shared across every load_map() call in the
		// whole codebase (see dmm_suite.dm). Throwing out of the middle of
		// the `while(dmmRegex.Find(...))` loop above (rather than letting a
		// Find() call finish and advance cleanly) can leave its internal
		// match state stuck mid-search. The very next, unrelated load_map()
		// call then reuses that same corrupted regex object and can silently
		// skip/mismatch model definitions - this is exactly the
		// "Coords before model definition in DMM" failure seen on a second
		// load attempt right after a first one that threw. Recreate it so
		// the next call starts clean.
		dmmRegex = new/regex({""(\[a-zA-Z]+)" = \\(((?:.|\n)*?)\\)\n(?!\t)|\\((\\d+),(\\d+),(\\d+)\\) = \\{"(\[a-zA-Z\n]*)"\\}"}, "g")
		// SS220 EDIT END
		throw e

	GLOB._preloader.reset()
	if(bounds[MAP_MINX] == 1.#INF) // Shouldn't need to check every item
		CRASH("Bad Map bounds in [fname], Min x: [bounds[MAP_MINX]], Min y: [bounds[MAP_MINY]], Min z: [bounds[MAP_MINZ]], Max x: [bounds[MAP_MAXX]], Max y: [bounds[MAP_MAXY]], Max z: [bounds[MAP_MAXZ]]")
	else
		if(!measureOnly)
			if(expanded_x || expanded_y)
				SEND_GLOBAL_SIGNAL(COMSIG_GLOB_EXPANDED_WORLD_BOUNDS, expanded_x, expanded_y)

			for(var/t in block(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ], bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))
				var/turf/T = t
				// we do this after we load everything in. if we don't; we'll have weird atmos bugs regarding atmos adjacent turfs
				T.AfterChange(TRUE, keep_cabling = TRUE)
				CHECK_TICK
			// SS220 EDIT START
			// Newly loaded/changed turfs routinely come out with no
			// lighting_corner_NE/SE/SW/NW and lighting_object stuck in a
			// stale state (confirmed via VV: all four corners null,
			// lighting_corners_initialised FALSE) - always pitch dark until
			// an admin manually edits the containing area's dynamic_lighting
			// var via VV (which only works because /area/vv_edit_var()
			// routes that specific edit through set_dynamic_lighting(),
			// which rebuilds lighting for every turf in the area - but only
			// actually does anything when the new value differs from the
			// current one, hence needing two edits, e.g. 2->1->2). Do the
			// same two-step toggle here in code, for every area this load
			// touched, now that all of the map's turfs have actually been
			// assigned to their areas (doing this earlier, e.g. right when
			// each area gets created, would only see whichever handful of
			// turfs happened to be assigned so far).
			//
			// Gated on SSlighting.initialized for the same reason as the
			// generate_missing_corners() call above - touching lighting
			// before SSlighting's own one-time startup scan has run risks
			// colliding with it later.
			if(SSlighting.initialized)
				for(var/area_path in LM.area_list)
					var/area/A = LM.area_list[area_path]
					if(!A)
						continue
					var/original_lighting = A.dynamic_lighting
					var/other_lighting = (original_lighting == DYNAMIC_LIGHTING_DISABLED) ? DYNAMIC_LIGHTING_ENABLED : DYNAMIC_LIGHTING_DISABLED
					A.set_dynamic_lighting(other_lighting)
					A.set_dynamic_lighting(original_lighting)
					CHECK_TICK
		qdel(LM)
		// SS220 EDIT END
		return bounds

/**
 * Fill a given tile with its area/turf/objects/mobs
 * Variable model is one full map line (e.g /turf/simulated/wall{icon_state = "rock"},/area/mine/dangerous/explored)
 *
 * WORKING :
 *
 * 1) Read the model string, member by member (delimiter is ',')
 *
 * 2) Get the path of the atom and store it into a list
 *
 * 3) a) Check if the member has variables (text within '{' and '}')
 *
 * 3) b) Construct an associative list with found variables, if any (the atom index in members is the same as its variables in members_attributes)
 *
 * 4) Instanciates the atom with its variables
 *
 */
/datum/dmm_suite/proc/parse_grid(model = "", xcrd = 0, ycrd = 0, zcrd = 0, datum/dmm_suite/loaded_map/LM)
	/*Method parse_grid()
	- Accepts a text string containing a comma separated list of type paths of the
		same construction as those contained in a .dmm file, and instantiates them.
	*/

	var/list/members // will contain all members (paths) in model (in our example : /turf/simulated/wall and /area/mine/dangerous/explored)
	var/list/members_attributes // will contain lists filled with corresponding variables, if any (in our example : list(icon_state = "rock") and list())
	var/list/cached = modelCache[model]
	var/index

	if(cached)
		members = cached[1]
		members_attributes = cached[2]
	else
		/////////////////////////////////////////////////////////
		// Constructing members and corresponding variables lists
		////////////////////////////////////////////////////////

		members = list()
		members_attributes = list()
		index = 1

		var/old_position = 1
		var/dpos

		do
			// finding next member (e.g /turf/simulated/wall{icon_state = "rock"} or /area/mine/dangerous/explored)
			dpos = find_next_delimiter_position(model, old_position, ",", "{", "}") // find next delimiter (comma here) that's not within {...}

			var/full_def = trim_text(copytext(model, old_position, dpos)) // full definition, e.g : /obj/foo/bar{variables=derp}
			var/variables_start = findtext(full_def, "{")
			var/atom_text = trim_text(copytext(full_def, 1, variables_start))
			var/atom_def = text2path(atom_text) // path definition, e.g /obj/foo/bar
			old_position = dpos + 1

			if(!atom_def) // Skip the item if the path does not exist.  Fix your crap, mappers!
				stack_trace("Bad path: [atom_text] | Source String: [model] | dpos: [dpos]")
				continue
			members.Add(atom_def)

			// transform the variables in text format into a list (e.g {var1="derp"; var2; var3=7} => list(var1="derp", var2, var3=7))
			var/list/fields = list()

			if(variables_start) // if there's any variable
				full_def = copytext(full_def, variables_start + 1, length(full_def)) // removing the last '}'
				fields = readlist(full_def, ";")

				for(var/I in fields)
					var/value = fields[I]
					if(istext(value))
						fields[I] = apply_text_macros(value)

			// then fill the members_attributes list with the corresponding variables
			members_attributes.len++
			members_attributes[index++] = fields

			CHECK_TICK
		while(dpos != 0)

		modelCache[model] = list(members, members_attributes)


	////////////////
	// Instanciation
	////////////////

	// The next part of the code assumes there's ALWAYS an /area AND a /turf on a given tile

	// first instance the /area and remove it from the members list
	index = length(members)

	var/turf/crds = locate(xcrd, ycrd, zcrd)
	if(members[index] != /area/template_noop)
		// We assume `members[index]` is an area path, as above, yes? I will operate
		// on that assumption.
		if(!ispath(members[index], /area))
			throw EXCEPTION("Oh no, I thought this was an area!")

		GLOB._preloader.setup(members_attributes[index]) // preloader for assigning  set variables on atom creation
		var/atom/instance = LM.area_path_to_real_area(members[index])

		if(crds)
			instance.contents.Add(crds)

		if(GLOB.use_preloader && instance)
			GLOB._preloader.load(instance)

	// then instance the /turf and, if multiple tiles are presents, simulates the DMM underlays piling effect

	var/first_turf_index = 1
	while(!ispath(members[first_turf_index], /turf)) // find first /turf object in members
		first_turf_index++

	// instanciate the first /turf
	var/turf/T
	if(members[first_turf_index] != /turf/template_noop)
		T = instance_atom(members[first_turf_index], members_attributes[first_turf_index], xcrd, ycrd, zcrd)

	if(T)
		// if others /turf are presents, simulates the underlays piling effect
		index = first_turf_index + 1
		var/mlen = length(members) - 1
		while(index <= mlen) // Last item is an /area
			var/underlay
			if(isturf(T)) // I blame this on the stupid clown who coded the BYOND map editor
				underlay = T.appearance
			T = instance_atom(members[index], members_attributes[index], xcrd, ycrd, zcrd) // instance new turf
			if(ispath(members[index], /turf))
				T.underlays += underlay

			index++

	// finally instance all remainings objects/mobs
	for(index in 1 to first_turf_index - 1)
		instance_atom(members[index], members_attributes[index], xcrd, ycrd, zcrd)
		CHECK_TICK

////////////////
// Helpers procs
////////////////

// Instance an atom at (x, y, z) and gives it the variables in attributes
/datum/dmm_suite/proc/instance_atom(path, list/attributes, x, y, z)
	var/atom/instance
	GLOB._preloader.setup(attributes, path)

	var/turf/T = locate(x, y, z)
	if(T)
		// Turfs need special attention
		if(ispath(path, /turf))
			T.ChangeTurf(path, defer_change = TRUE, keep_icon = FALSE, copy_existing_baseturf = FALSE)
			instance = T
			// SS220 EDIT START
			// Confirmed via VV on a freshly-loaded dark tile: all four
			// lighting_corner_NE/SE/SW/NW were null and
			// lighting_corners_initialised was FALSE. Corners are supposed to
			// get lazily created by generate_missing_corners() whenever a
			// light source comes into view (lighting_source.dm), but that
			// isn't happening here for whatever reason (possibly turfs from
			// this loader being considered opaque, or something else upstream
			// we haven't chased down) - a real flashlight in the room never
			// fixed it. generate_missing_corners() is idempotent (checks each
			// corner before creating it) and is exactly the proc responsible
			// for fixing this exact state, so just call it directly rather
			// than relying on it happening on its own.
			//
			// MUST be gated on SSlighting.initialized: if some map gets
			// loaded through us before SSlighting's own one-time startup
			// scan (create_all_lighting_objects(), which walks every turf
			// in the world once) has run, this call jumps the gun and
			// creates a lighting_object early - then SSlighting's own scan
			// hits that same turf later and finds one already there
			// ("a lighting object was assigned to a turf that already had
			// a lighting object!"), exactly what broke the CI test run at
			// server boot. Skip entirely until SSlighting has done its own
			// setup - same guard already used nearby in ChangeTurf().
			if(SSlighting.initialized)
				T.generate_missing_corners()
				// SS220 EDIT END
		else
			// Anything that isnt an area, init!
			if(!ispath(path, /area))
				instance = new path(T) // first preloader pass

	if(GLOB.use_preloader && instance) // second preloader pass, for those atoms that don't ..() in New()
		// SS220 EDIT START
		// A single bad atom's saved data (e.g. corrupt/incompatible
		// deserialize() data) used to be able to throw an exception all the
		// way up through the whole load_map() loop, silently aborting the
		// ENTIRE rest of the map load - every turf/obj/decal after the bad
		// one in iteration order would simply never get instantiated. That's
		// the "only half the map's decals loaded" symptom. Isolate each
		// atom's preloader pass instead: log and move on to the next atom,
		// don't let one bad object take the whole map down with it.
		try // SS220 EDIT START
			GLOB._preloader.load(instance)
		catch(var/exception/e) // SS220 EDIT END
			stack_trace("Failed to apply preloaded data to [instance] ([path]) at ([x],[y],[z]): [e]")
			GLOB._preloader.reset()
			// SS220 EDIT END

	return instance

// text trimming (both directions) helper proc
// optionally removes quotes before and after the text (for variable name)
/datum/dmm_suite/proc/trim_text(what, trim_quotes = FALSE)
	if(trim_quotes)
		return trimQuotesRegex.Replace(what, "")
	else
		return trimRegex.Replace(what, "")

// find the position of the next delimiter, skipping whatever is comprised between opening_escape and closing_escape
// returns 0 if reached the last delimiter
/datum/dmm_suite/proc/find_next_delimiter_position(text, initial_position = 0, delimiter = ",", opening_escape = quote, closing_escape = quote)
	var/position = initial_position
	var/next_delimiter = findtext(text, delimiter, position, 0)
	var/next_opening = findtext(text, opening_escape, position, 0)

	while((next_opening != 0) && (next_opening < next_delimiter))
		position = findtext(text, closing_escape, next_opening + 1, 0) + 1
		next_delimiter = findtext(text, delimiter, position, 0)
		next_opening = findtext(text, opening_escape, position, 0)

	return next_delimiter

// build a list from variables in text form (e.g {var1="derp"; var2; var3=7} => list(var1="derp", var2, var3=7))
// return the filled list
/datum/dmm_suite/proc/readlist(text, delimiter = ",")
	var/list/to_return = list()

	var/delimiter_position
	var/old_position = 1

	do
		// find next delimiter that is not within  "..."
		delimiter_position = find_next_delimiter_position(text, old_position, delimiter)

		// check if this is a simple variable (as in list(var1, var2)) or an associative one (as in list(var1="foo", var2=7))
		var/equal_position = findtext(text, "=", old_position, delimiter_position)

		// Take the left value of the association or just the value if it isn't an association
		var/left_value = copytext(text, old_position, (equal_position ? equal_position : delimiter_position))
		old_position = delimiter_position + 1

		if(equal_position) // associative var, so do the association
			left_value = trim_text(left_value, TRUE) // the name of the variable, must trim quotes to build a BYOND compliant associatives list
			var/trim_right = trim_text(copytext(text, equal_position + 1, delimiter_position)) // the content of the variable

			to_return[left_value] = parse_value(trim_right)

		else// simple var
			to_return += parse_value(trim_text(left_value)) // Don't trim the quotes

	while(delimiter_position != 0)

	return to_return
/**
 * Tries to parse the given value_text. Will fallback on the value_text as a string if it fails
 */
/datum/dmm_suite/proc/parse_value(value_text)
	// Check for string
	// Make it read to the next delimiter, instead of the quote
	if(findtext(value_text, quote, 1, 2))
		var/endquote = findtext(value_text, quote, -1)
		if(!endquote)
			stack_trace("Terminating quote not found!")
		// Our map writer escapes quotes and curly brackets to avoid
		// letting our simple parser choke on meanly-crafted names/etc
		// - so we decode it here so it's back to good ol' legibility
		. = dmm_decode(copytext(value_text, 2, endquote))

	// Check for number
	else if(isnum(text2num(value_text)))
		. = text2num(value_text)

	// Check for null
	else if(value_text == "null")
		. = null

	// Check for list
	else if(copytext(value_text, 1, 5) == "list")
		. = readlist(copytext(value_text, 6, length(value_text)))

	// Check for file
	else if(copytext(value_text, 1, 2) == "'")
		. = wrap_file(copytext(value_text, 2, length(value_text)))

	// Check for path
	else if(ispath(text2path(value_text)))
		. = text2path(value_text)

	else
		. = value_text // Assume it is a string without quotes

/datum/dmm_suite/Destroy()
	..()
	return QDEL_HINT_HARDDEL_NOW

//////////////////
// Preloader datum
//////////////////

// This ain't re-entrant, but we had this before the maploader update
/datum/dmm_suite/preloader
	var/list/attributes
	var/target_path
	var/json_ready = 0

/datum/dmm_suite/preloader/proc/setup(list/the_attributes, path)
	if(length(the_attributes))
		json_ready = 0
		if("map_json_data" in the_attributes)
			json_ready = 1
		GLOB.use_preloader = TRUE
		// SS220 EDIT START
		// `the_attributes` is not a private, per-instance list - parse_grid()
		// caches parsed model attribute lists in the `static` (server-lifetime,
		// shared across every load, not just this one) modelCache and hands
		// out the SAME list object to every atom that uses that model, here
		// and in every future load that happens to reuse the same model text.
		// load() below mutates this list in place (`attributes -= "..."`,
		// which modifies a DM list in place rather than returning a copy) to
		// strip out keys it's already consumed (map_json_data, saved_decals).
		// Without copying here, the FIRST atom to use a given model
		// permanently strips those keys from the shared cached list -
		// corrupting every other atom (this load or a future one) that
		// reuses the same model. Copy so mutations stay local to this atom.
		attributes = the_attributes.Copy()
		// SS220 EDIT END
		target_path = path

/datum/dmm_suite/preloader/proc/load(atom/A)
	if(json_ready)
		var/json_data = dmm_decode(attributes["map_json_data"])
		// SS220 EDIT START
		// Reverse the bracket-escaping done in writer.dm's check_attributes()
		// before handing this off to json_decode() - see the comment there
		// for why '[' / ']' need separate handling from dmm_encode/dmm_decode.
		json_data = replacetext(json_data, "#?lsb;", "\[")
		json_data = replacetext(json_data, "#?rsb;", "\]")
		// SS220 EDIT END
		attributes -= "map_json_data"
		try
			A.deserialize(json_decode(json_data))
		catch(var/exception/E)
			stack_trace("Bad json data on [A] ([A.type]): '[json_data]' -- exception: [E] (file: [E.file], line: [E.line])") // SS220 EDIT
			throw E
	// SS220 EDIT START
	var/decal_json
	if("saved_decals" in attributes)
		decal_json = dmm_decode(attributes["saved_decals"])
		decal_json = replacetext(decal_json, "#?lsb;", "\[")
		decal_json = replacetext(decal_json, "#?rsb;", "\]")
		attributes -= "saved_decals"
	// SS220 EDIT END
	for(var/attribute in attributes)
		var/value = attributes[attribute]
		if(islist(value))
			value = deepCopyList(value)
		A.vars[attribute] = value
	// SS220 EDIT START
	// Turf decals aren't a real var on the turf - "saved_decals" would just
	// get silently dumped into A.vars[] as junk (or error) by the loop
	// above, so it's pulled out separately and handled here instead.
	//
	// Dir used to be passed as the SECOND constructor arg
	// (`new decal_type(T, decal_entry["dir"])`), relying on it reaching
	// /obj/effect/turf_decal/Initialize()'s `_dir` parameter - exactly the
	// same fragile path that lost `master_item` for nested
	// /obj/item/storage/internal atoms (see persistence.dm / internal.dm):
	// under deferred/batched atom init, extra constructor args beyond
	// `loc` don't reliably survive to Initialize(). When `_dir` arrives
	// null, Initialize() fell back to the atom's own freshly-defaulted
	// `dir` (SOUTH) - every decal collapsed to the same rotation regardless
	// of what was actually saved.
	//
	// Setting `.dir` on the returned reference right after new() doesn't
	// work either: if Initialize() happens to run immediately (rather than
	// deferred), it's already read `_dir || dir` and self-deleted
	// (INITIALIZE_HINT_QDEL) before control even returns here - too late
	// either way.
	//
	// `loc` is the one thing that survives regardless of deferred timing
	// (see the master_item fix), so queue the intended dir on the turf
	// itself and have Initialize() consume it from there instead of from
	// its own constructor arg - see turf_decal.dm. FIFO order matches
	// creation order for this batch (each decal is queued immediately
	// before its own new() call, in order).
	if(decal_json)
		var/turf/T = A
		if(istype(T))
			// Defensive reset: whatever's currently in decal_save_list (and
			// any leftover pending_decal_dirs from an interrupted previous
			// attempt) gets thrown away before spawning this batch fresh.
			// Without this, stale/duplicate entries can accumulate across
			// successive loads onto the same turf - each extra stale entry
			// throws off the FIFO pairing between newly-queued dirs and the
			// decals actually being (re)spawned right now, which is a
			// plausible source of both "decals keep coming back with the
			// wrong rotation" and "fewer and fewer decals survive each
			// generation".
			T.decal_save_list = null
			// Must be list(), NOT null: `null += <number>` in DM does
			// ARITHMETIC (null treated as 0), not list append - only
			// `null += <list>` promotes null to a list. decal_save_list
			// above is fine because its RHS is always a list; this one's
			// RHS is a bare number (decal_entry["dir"]), which silently
			// summed all the queued dirs together into a single number
			// instead of building a list - length() on that number then
			// read as 0, so the queue always looked empty and every decal
			// fell through to the default SOUTH fallback. This was the
			// actual cause of "decals reset to base rotation".
			T.pending_decal_dirs = list()
			try
				var/list/decals = json_decode(decal_json)
				for(var/list/decal_entry in decals)
					var/decal_type = text2path(decal_entry["type"])
					if(decal_type)
						T.pending_decal_dirs += decal_entry["dir"]
						new decal_type(T)
			catch(var/exception/E)
				stack_trace("Bad saved_decals data: '[decal_json]' ([E])")
// SS220 EDIT END
	GLOB.use_preloader = FALSE

// If the map loader fails, make this safe
/datum/dmm_suite/preloader/proc/reset()
	GLOB.use_preloader = FALSE
	attributes = list()
	target_path	= null

// A datum for use within the context of loading a single map,
// so that one can have separate "unpowered" areas for ruins or whatever,
// yet have a single area type for use of mapping, instead of creating
// a new area type for each new ruin
/datum/dmm_suite/loaded_map
	var/list/area_list = list()
	var/index = 1 // To store the state of the regex

/datum/dmm_suite/loaded_map/proc/area_path_to_real_area(area/A)
	if(!ispath(A, /area))
		throw EXCEPTION("Wrong argument to `area_path_to_real_area`")

	if(!(A in area_list))
		var/area/newly_created // SS220 EDIT
		if(initial(A.there_can_be_many))
			newly_created = new A // SS220 EDIT START
			area_list[A] = newly_created // SS220 EDIT END
		else
			if(!GLOB.all_unique_areas[A])
				newly_created = new A // No locate here else it will find a subtype of the one we're looking for // SS220 EDIT START
				GLOB.all_unique_areas[A] = newly_created // SS220 EDIT END
			area_list[A] = GLOB.all_unique_areas[A]

	return area_list[A]

/area/template_noop
	name = "Area Passthrough"

/turf/template_noop
	name = "Turf Passthrough"
	icon_state = "noop"
