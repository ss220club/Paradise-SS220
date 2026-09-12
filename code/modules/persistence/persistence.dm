/*
* Returns a byond list that can be passed to the "deserialize" proc
* to bring a new instance of this atom to its original state
*
* If we want to store this info, we can pass it to `json_encode` or some other
* interface that suits our fancy, to make it into an easily-handled string
*/
/datum/proc/serialize()
	var/data = list("type" = "[type]")
	return data

/*
* This is given the byond list from above, to bring this atom to the state
* described in the list.
* This will be called after `New` but before `initialize`, so linking and stuff
* would probably be handled in `initialize`
*
* Also, this should only be called by `list_to_object` in persistence.dm - at least
* with current plans - that way it can actually initialize the type from the list
*/
/datum/proc/deserialize(list/data)
	return

// This is so specific atoms can override these, and ignore certain ones
/atom/proc/vars_to_save()
	return list("color","dir","icon","icon_state","name","pixel_x","pixel_y")

/atom/proc/map_important_vars()
	// A list of important things to save in the map editor
	return list("color","dir","icon","icon_state","layer","name","pixel_x","pixel_y")

/area/map_important_vars()
	// Keep the area default icons, to keep things nice and legible
	return list("name")

// No need to save any state of an area by default
/area/vars_to_save()
	return list("name")

/atom/serialize()
	var/list/data = ..()
	for(var/thing in vars_to_save())
		if(vars[thing] != initial(vars[thing]))
			data[thing] = vars[thing]
	return data


/atom/deserialize(list/data)
	for(var/thing in vars_to_save())
		if(thing in data)
			vars[thing] = data[thing]
	..()


/*
Whoops, forgot to put documentation here.
What this does, is take a JSON string produced by running
BYOND's native `json_encode` on a list from `serialize` above, and
turns that string into a new instance of that object.

You can also easily get an instance of this string by calling "Serialize Marked Datum"
in the "Debug" tab.

If you're clever, you can do neat things with SDQL and this, though be careful -
some objects, like humans, are dependent that certain extra things are defined
in their list
*/
/proc/json_to_object(json_data, loc)
	var/data = json_decode(json_data)
	return list_to_object(data, loc)

/proc/list_to_object(list/data, loc)
	if(!islist(data))
		throw EXCEPTION("You didn't give me a list, bucko")
	if(!("type" in data))
		throw EXCEPTION("No 'type' field in the data")
	var/path = text2path(data["type"])
	if(!path)
		throw EXCEPTION("Path not found: [data["type"]]")

	// Since Initialize() eats the first argument
	// we need to pass loc twice for organs, otherwise
	// they'll never attach to the mob. But if it's passed
	// for everything, it'll break shit cause it gets passed random args.
	//
	// SS220 EDIT START
	// /obj/item/storage/internal has the exact same situation:
	// Initialize(mapload, obj/item/MI) also eats the first arg as mapload,
	// and needs a second, non-null arg for MI (master_item) - without it,
	// master_item stays null, `loc = master_item` sends the object to
	// nullspace instead of its intended container, and reading
	// master_item.name right after throws ("Cannot read null.name").
	// SS220 EDIT END
	var/atom/movable/thing
	// SS220 EDIT START
	// Nested atoms (e.g. items inside a saved storage/box's "content" list)
	// get created HERE, recursively, from inside the OUTER atom's own
	// still-in-progress deserialize()/load() - meaning GLOB.use_preloader
	// can still be TRUE at this point, left over from the outer atom's own
	// preloader pass. The maploader's preloader is explicitly documented
	// as "not re-entrant" (see /datum/dmm_suite/preloader in reader.dm) -
	// if this nested atom's own New()/Initialize() chain also consults
	// GLOB.use_preloader / GLOB._preloader, it can pick up stale state
	// meant for the outer atom, corrupting its own init (this is the
	// suspected source of "Cannot read null.name" on nested storage/
	// internal atoms, and possibly of duplicated contents). Suspend the
	// flag around nested construction so it behaves like an ordinary,
	// non-preloaded spawn; deserialize() below still applies the real
	// saved data for this nested atom explicitly, so nothing is lost.
	var/prev_use_preloader = GLOB.use_preloader
	GLOB.use_preloader = FALSE
	if(ispath(path, /obj/item/organ) || ispath(path, /obj/item/storage/internal)) // SS220 EDIT END
		thing = new path(loc, loc)
	else
		thing = new path(loc)
	GLOB.use_preloader = prev_use_preloader // SS220 EDIT START
	if(thing) // SS220 EDIT END
		thing.deserialize(data)
	return thing
