#define DMM_IGNORE_AREAS 	(1<<0)
#define DMM_IGNORE_TURFS 	(1<<1)
#define DMM_IGNORE_OBJS 	(1<<2)
#define DMM_IGNORE_NPCS 	(1<<3)
#define DMM_IGNORE_PLAYERS 	(1<<4)
#define DMM_IGNORE_MOBS 	(DMM_IGNORE_NPCS | DMM_IGNORE_PLAYERS)
#define DMM_USE_JSON 		(1<<5)

// json_encode() escapes any non-ASCII character as a \uXXXX sequence, but
// BYOND's own json_decode() doesn't parse that escape form back - see the
// comment where this is called in check_attributes() below for the runtime
// error that confirmed it. Converts each \uXXXX back into the actual UTF-8
// character it represents, leaving everything else untouched.
/proc/unescape_json_unicode(text)
	if(!findtext(text, "\\u"))
		return text
	var/result = ""
	var/i = 1
	var/len = length(text)
	while(i <= len)
		if(i <= len - 5 && copytext(text, i, i + 2) == "\\u")
			var/hex = copytext(text, i + 2, i + 6)
			var/codepoint = hex2num(hex)
			if(!isnull(codepoint))
				result += ascii2text(codepoint)
				i += 6
				continue
		result += copytext(text, i, i + 1)
		i++
	return result

/datum/dmm_suite/proc/save_map(turf/t1, turf/t2, map_name = "", flags = 0, list/included_tiles = null)
	// Check for illegal characters in file name... in a cheap way.
	if(!((ckeyEx(map_name) == map_name) && ckeyEx(map_name)))
		CRASH("Invalid text supplied to proc save_map, invalid characters or empty string.")
	// Check for valid turfs.
	if(!isturf(t1) || !isturf(t2))
		CRASH("Invalid arguments supplied to proc save_map, arguments were not turfs.")

	var/map_prefix = "_maps/quicksave/"
	var/map_path = "[map_prefix][map_name].dmm"
	if(fexists(map_path))
		fdel(map_path)
	var/saved_map = wrap_file(map_path)
	var/map_text = write_map(t1, t2, flags, included_tiles)
	saved_map << map_text
	return saved_map

/datum/dmm_suite/proc/write_map(turf/t1, turf/t2, flags = 0, list/included_tiles = null)
	// Check for valid turfs.
	if(!isturf(t1) || !isturf(t2))
		CRASH("Invalid arguments supplied to proc write_map, arguments were not turfs.")

	var/turf/ne = locate(max(t1.x, t2.x), max(t1.y, t2.y), max(t1.z, t2.z)) // Outer corner
	var/turf/sw = locate(min(t1.x, t2.x), min(t1.y, t2.y), min(t1.z, t2.z)) // Inner corner
	var/list/templates[0]
	var/list/template_buffer = list()
	var/template_buffer_text
	var/dmm_text = ""

	var/total_timer = start_watch()
	var/timer = start_watch()
	log_debug("Reading turfs...")

	// Read the contents of all the turfs we were given
	for(var/pos_z in sw.z to ne.z)
		for(var/pos_y in ne.y to sw.y step -1) // We're reversing this because the map format is silly
			for(var/pos_x in sw.x to ne.x)
				var/turf/test_turf = locate(pos_x, pos_y, pos_z)
				var/test_template
				// `included_tiles` is an optional associative set (turf =
				// TRUE) coming from the new area/point selection in
				// buildmode's Save mode - lets a selection have "holes"
				// (e.g. the inside of a donut-shaped ship) without those
				// holes' actual contents ending up in the file.
				//
				// The .dmm grid format is positional - every coordinate in
				// the bounds needs SOME entry, or every following column in
				// the row shifts. /turf/template_noop and
				// /area/template_noop are the existing "don't touch this
				// tile at all on load" markers the reader already
				// recognises (see instance_atom()/parse_grid() in
				// reader.dm) - using them for excluded tiles means Load
				// leaves whatever's already there completely alone,
				// instead of overwriting it with blank space.
				if(included_tiles && !included_tiles[test_turf])
					test_template = "/turf/template_noop,/area/template_noop"
				else
					test_template = make_template(test_turf, flags)
				var/template_number = templates.Find(test_template)
				if(!template_number)
					templates.Add(test_template)
					template_number = length(templates)
				template_buffer += "[template_number],"
				CHECK_TICK
			template_buffer += ";"
		template_buffer += "."

	template_buffer_text = jointext(template_buffer, "")
	log_debug("Reading turfs took [stop_watch(timer)]s.")

	if(length(templates) == 0)
		CRASH("No templates found!")

	var/key_length = round(log(length(letter_digits), max(length(templates) - 1, 1)) + 1) // or floor
	var/list/keys[length(templates)]

	// Write the list of key/model pairs to the file
	timer = start_watch()
	log_debug("Writing out key/model pairs to file header...")
	var/list/key_models = list()
	for(var/key_pos in 1 to length(templates))
		keys[key_pos] = get_model_key(key_pos, key_length)
		key_models += "\"[keys[key_pos]]\" = ([templates[key_pos]])\n"
		CHECK_TICK

	dmm_text += jointext(key_models,"")
	log_debug("Writing key/model pairs complete, took [stop_watch(timer)]s.")

	var/z_level = 0
	// Loop over all z in our zone
	timer = start_watch()
	log_debug("Writing out key map...")

	var/list/key_map = list()
	var/z_pos = 1
	while(TRUE)
		if(z_pos >= length(template_buffer_text))
			break

		if(z_level)
			key_map += "\n"

		key_map += "\n(1,1,[++z_level]) = {\"\n"

		var/z_block = copytext(template_buffer_text, z_pos, findtext(template_buffer_text, ".", z_pos))
		var/y_pos = 1
		while(TRUE)
			if(y_pos >= length(z_block))
				break

			var/y_block = copytext(z_block, y_pos, findtext(z_block, ";", y_pos))
			// A row of keys
			y_pos = findtext(z_block, ";", y_pos) + 1
			var/x_pos = 1
			while(TRUE)
				if(x_pos >= length(y_block))
					break

				var/x_block = copytext(y_block, x_pos, findtext(y_block, ",", x_pos))
				var/key_number = text2num(x_block)
				var/temp_key = keys[key_number]
				key_map += temp_key
				CHECK_TICK
				x_pos = findtext(y_block, ",", x_pos) + 1
			key_map += "\n"
		key_map += "\"}"
		z_pos = findtext(template_buffer_text, ".", z_pos) + 1

	dmm_text += jointext(key_map, "")
	log_debug("Writing key map complete, took [stop_watch(timer)]s.")
	log_debug("TOTAL TIME: [stop_watch(total_timer)]s.")

	return dmm_text

/datum/dmm_suite/proc/make_template(turf/model, flags = 0)
	var/use_json = (flags & DMM_USE_JSON) ? TRUE : FALSE

	var/template = ""
	var/turf_template = ""
	var/list/obj_template = list()
	var/list/mob_template = list()
	var/area_template = ""

	// Turf
	if(!(flags & DMM_IGNORE_TURFS))
		turf_template = "[model.type][check_attributes(model,use_json=use_json)],"
	else
		turf_template = "[world.turf],"

	// Objects loop
	if(!(flags & DMM_IGNORE_OBJS))
		for(var/obj/O in model.contents)
			if(QDELETED(O))
				continue

			obj_template += "[O.type][check_attributes(O,use_json=use_json)],"

	// Area
	if(!(flags & DMM_IGNORE_AREAS))
		var/area/m_area = model.loc
		area_template = "[m_area.type][check_attributes(m_area,use_json=use_json)]"
	else
		area_template = "[world.area]"

	template = "[jointext(obj_template,"")][jointext(mob_template,"")][turf_template][area_template]"
	return template

/datum/dmm_suite/proc/check_attributes(atom/A, use_json = FALSE)
	var/list/attributes = list()
	if(!use_json)
		for(var/V in A.vars)
			CHECK_TICK
			if((!issaved(A.vars[V])) || (A.vars[V] == initial(A.vars[V])))
				continue

			// `var_to_dmm` returns "" (or null) for types it can't serialize into
			// DM literal syntax (lists, datum refs, etc). List vars in particular
			// will ALWAYS look "changed from initial" because list equality in DM
			// is by-reference, not by-content - so this branch gets hit constantly.
			// If we don't filter here, an empty string ends up in `attributes`,
			// and `jointext(attributes, "; ")` turns that into a blank entry like
			// "{; dir = 4}" - a variable with an empty name, which the reader
			// can't parse and runtimes/crashes on load ("Undefined variable .../var/").
			var/entry = var_to_dmm(A.vars[V], V)
			if(!entry)
				continue
			attributes += entry
	else
		var/list/to_encode = A.serialize()
		// We'll want to write out vars that are important to the editor
		// So that the map is legible as before
		for(var/T in A.map_important_vars())
			// Save vars that are important for the map editor, so that
			// json-encoded maps are legible for standard editors
			if(A.vars[T] != initial(A.vars[T]))
				to_encode -= T
				var/entry = var_to_dmm(A.vars[T], T)
				if(!entry)
					continue
				attributes += entry

		// Remove useless info
		to_encode -= "type"
		if(length(to_encode))
			var/json_stuff = json_encode(to_encode)
			// json_encode() escapes any non-ASCII character (Cyrillic names,
			// etc) as a \uXXXX sequence - but BYOND's own json_decode()
			// doesn't actually parse \uXXXX escapes back (confirmed via
			// runtime: "json_decode error: Expected comma or } at
			// character N" landing exactly inside a \uXXXX sequence for a
			// Cyrillic ID card owner name). The engine's own encoder and
			// decoder don't agree with each other on this. Convert \uXXXX
			// back to the real UTF-8 character right here - BYOND handles
			// raw UTF-8 text in strings (and in json_decode()) just fine,
			// it's specifically the escape-sequence FORM it can't read back.
			json_stuff = unescape_json_unicode(json_stuff)
			// dmm_encode() (called inside var_to_dmm below) only escapes
			// quotes and curly braces - it does NOT touch square brackets.
			// But an unescaped '[' inside a DM string literal starts an
			// embedded expression (string interpolation), and json_encode()
			// always emits raw '[' / ']' for JSON arrays. The fast Rust
			// "spacemandmm" reader parses that literally as DM code and
			// chokes on it ("got '?', expected one of: operator, term, ']'"
			// as soon as it hits the next #?xxx; token). Escape brackets
			// here with the same placeholder style dmm_encode already uses;
			// reversed in reader.dm right after dmm_decode(), before
			// json_decode().
			json_stuff = replacetext(json_stuff, "\[", "#?lsb;")
			json_stuff = replacetext(json_stuff, "\]", "#?rsb;")
			var/entry = var_to_dmm(json_stuff, "map_json_data")
			if(entry)
				attributes += entry

	// Turf decals (/obj/effect/turf_decal) self-delete right after
	// Initialize() - by the time Save runs, there's nothing left in the
	// turf's contents to capture, only the (invisible to us) element they
	// registered. The turf remembers what was painted onto it in
	// decal_save_list (see turf_decal.dm) - encode that here as its own
	// JSON attribute, independent of `use_json`, since it's list-shaped
	// data a plain var=value entry can't express either way.
	if(isturf(A))
		var/turf/T = A
		if(length(T.decal_save_list))
			var/decal_json = json_encode(T.decal_save_list)
			// Same bracket-escaping reasoning as map_json_data above - a
			// JSON array's raw '[' / ']' would otherwise be misread as a DM
			// embedded expression by the strict rust map parser.
			decal_json = replacetext(decal_json, "\[", "#?lsb;")
			decal_json = replacetext(decal_json, "\]", "#?rsb;")
			var/entry = var_to_dmm(decal_json, "saved_decals")
			if(entry)
				attributes += entry

	if(length(attributes) == 0)
		return

	return "{[jointext(attributes,"; ")]}"

/datum/dmm_suite/proc/get_model_key(which, key_length)
	var/list/key = list()
	var/working_digit = which - 1
	for(var/digit_pos in key_length to 1 step -1)
		var/place_value = round/*floor*/(working_digit / (length(letter_digits) ** (digit_pos - 1)))
		working_digit -= place_value * (length(letter_digits) ** (digit_pos - 1))
		key += letter_digits[place_value + 1]

	return jointext(key,"")

/datum/dmm_suite/proc/var_to_dmm(attr, name)
	if(istext(attr))
		// dmm_encode will strip out characters that would be capable of disrupting
		// parsing - namely, quotes and curly braces
		return "[name] = \"[dmm_encode(attr)]\""
	else if(isnum(attr) || ispath(attr))
		return "[name] = [attr]"
	else if(isicon(attr) || isfile(attr))
		if(length("[attr]") == 0)
			// The DM map reader is unable to read files that have a '' file/icon entry
			return
		return "[name] = '[attr]'"
	else
		return ""

#undef DMM_IGNORE_AREAS
#undef DMM_IGNORE_TURFS
#undef DMM_IGNORE_OBJS
#undef DMM_IGNORE_NPCS
#undef DMM_IGNORE_PLAYERS
#undef DMM_IGNORE_MOBS
#undef DMM_USE_JSON
