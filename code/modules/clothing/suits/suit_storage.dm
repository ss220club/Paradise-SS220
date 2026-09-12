/obj/item/clothing/suit/storage
	var/obj/item/storage/internal/pockets = /obj/item/storage/internal
	w_class = WEIGHT_CLASS_NORMAL //we don't want these to be able to fit in their own pockets.

/obj/item/clothing/suit/storage/Initialize(mapload)
	. = ..()
	// SS220 EDIT START
	// `deserialize()` (see below) and `Initialize()` race against each
	// other during map load - which one runs first is not consistent
	// between spawns (deferred vs immediate atom init). If deserialize()
	// already ran and replaced `pockets` with a real, loaded instance, do
	// NOT blindly recreate it here:
	// - `new pockets(...)` would throw ("new() called with an object of
	//   type ... instead of the type path itself"), since `pockets` is no
	//   longer a type path at that point.
	// - Even if it didn't throw, it would silently orphan the already-
	//   loaded pockets (with its real, saved contents) inside src.contents,
	//   while a second, fresh, empty pockets took over the `pockets` var -
	//   which is exactly the "duplicated inventory" symptom (both the
	//   orphaned and the fresh one ending up populated/visible).
	if(!istype(pockets))
		// SS220 EDIT END
		pockets = new pockets(src, src)
		pockets.storage_slots = 2	//two slots
		pockets.max_w_class = WEIGHT_CLASS_SMALL		//fit only pocket sized items
		pockets.max_combined_w_class = 4
	ADD_TRAIT(src, TRAIT_ADJACENCY_TRANSPARENT, ROUNDSTART_TRAIT)

/obj/item/clothing/suit/storage/Destroy()
	QDEL_NULL(pockets)
	return ..()

/obj/item/clothing/suit/storage/attack_hand(mob/user as mob)
	if(pockets?.handle_attack_hand(user))
		..(user)

/obj/item/clothing/suit/storage/MouseDrop(obj/over_object as obj)
	if(pockets?.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/suit/storage/equipped(mob/user, slot)
	..()
	pockets?.update_viewers()

/obj/item/clothing/suit/storage/Moved(atom/oldloc, dir, forced = FALSE)
	. = ..()
	pockets?.update_viewers()

/obj/item/clothing/suit/storage/AltClick(mob/user)
	..()
	if(ishuman(user) && Adjacent(user) && !user.incapacitated(FALSE, TRUE))
		pockets?.open(user)
		add_fingerprint(user)
		return
	if(isobserver(user))
		pockets?.show_to(user)

/obj/item/clothing/suit/storage/attack_ghost(mob/user)
	if(isobserver(user))
		// Revenants don't get to play with the toys.
		pockets.show_to(user)
	return ..()

/obj/item/clothing/suit/storage/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	// Inserts shouldn't be added into the inventory of the pockets if they're attaching.
	if(istype(used, /obj/item/smithed_item/insert) && length(inserts) != insert_max)
		return NONE

	return pockets?.attackby__legacy__attackchain(used, user, modifiers)

/obj/item/clothing/suit/storage/emp_act(severity)
	..()
	pockets?.emp_act(severity)

/obj/item/clothing/suit/storage/hear_talk(mob/M, list/message_pieces)
	pockets?.hear_talk(M, message_pieces)
	..()

/obj/item/clothing/suit/storage/hear_message(mob/M, msg)
	pockets?.hear_message(M, msg)
	..()

/obj/item/clothing/suit/storage/proc/return_inv()

	var/list/L = list()


	for(var/obj/item/I in src.contents)
		if(!istype(I, /obj/item/smithed_item/insert)) // We don't want people to pull inserts out without calling the proper signals, so they shouldn't be displayed in storage.
			L += I
	for(var/obj/item/storage/S in src)
		L += S.return_inv()
	for(var/obj/item/small_delivery/gift/G in src)
		L += G.wrapped
		if(isstorage(G.wrapped))
			L += G.wrapped:return_inv()
	return L

/obj/item/clothing/suit/storage/serialize()
	var/list/data = ..()
	data["pockets"] = pockets?.serialize()
	return data

/obj/item/clothing/suit/storage/deserialize(list/data)
	// SS220 EDIT START
	// `pockets` starts out as a raw type-path literal (see the var
	// declaration above) and only becomes an actual instance in
	// Initialize(). Atom init for mapload'ed atoms is deferred (see the
	// "freeze on initialization until the map's done loading" comment in
	// map_template.dm) - so deserialize() runs BEFORE Initialize() has had
	// a chance to create the real `pockets` object. qdel()'ing a bare
	// type-path instead of a datum reference throws a runtime, which the
	// map loader's broad try/catch around deserialize() then misreports as
	// "Bad json data". Only qdel an actual instance.
	if(!ispath(pockets))
		// SS220 EDIT END
		qdel(pockets)
	pockets = list_to_object(data["pockets"], src)
