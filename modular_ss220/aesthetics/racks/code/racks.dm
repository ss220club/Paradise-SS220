/obj/structure/rack
	icon = 'modular_ss220/aesthetics/racks/icons/racks.dmi'

/obj/structure/rack/gunrack
	name = "оружейная стойка"
	desc = "Стойка для хранения оружия."
	icon_state = "gunrack"

/obj/item/gun
	var/on_rack = FALSE

/obj/item/gun/proc/place_on_rack()
	on_rack = TRUE
	var/matrix/M = matrix()
	M.Turn(-90)
	transform = M

/obj/item/gun/proc/remove_from_rack()
	if(on_rack)
		var/matrix/M = matrix()
		transform = M
		on_rack = FALSE

/obj/item/gun/pickup(mob/user)
	. = ..()
	remove_from_rack()

/obj/structure/rack/gunrack/MouseDrop_T(obj/O, mob/user)
	if(!(istype(O, /obj/item/gun)))
		to_chat(user, span_warning("Этот предмет не помещается!"))
		return
	. = ..()
	if(.)
		add_fingerprint(user)
		var/obj/item/gun/our_gun = O
		our_gun.place_on_rack()

/obj/structure/rack/gunrack/attackby(obj/item/W, mob/user, params) //TODO: fix logic
	if(!(istype(W, /obj/item/gun)))
		to_chat(user, span_warning("Этот предмет не помещается!"))
		return
	. = ..()
	if(W.loc == get_turf(src))
		add_fingerprint(user)
		var/obj/item/gun/our_gun = W
		our_gun.place_on_rack()
		var/list/click_params = params2list(params)
		//Center the icon where the user clicked.
		if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
			return
		//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
		W.pixel_x = clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
		W.pixel_y = 0

/obj/structure/rack/gunrack/Initialize(mapload)
	. = ..()
	if(!mapload)
		return
	for(var/obj/item/gun/gun_inside in loc.contents)
		gun_inside.place_on_rack()

/obj/structure/rack/gunrack/deconstruct(disassembled = TRUE)
	if(!(flags & NODECONSTRUCT))
		density = FALSE
		var/obj/item/rack_parts/gunrack_parts/newparts = new(loc)
		transfer_fingerprints_to(newparts)
	for(var/obj/item/I in loc.contents)
		if(istype(I, /obj/item/gun))
			var/obj/item/gun/to_remove = I
			to_remove.remove_from_rack()
	qdel(src)

/obj/item/rack_parts/gunrack_parts
	name = "детали оружейной стойки"
	desc = "Детали для сборки оружейной стойки."
	icon = 'modular_ss220/aesthetics/racks/icons/racks.dmi'
	icon_state = "gunrack_parts"

/obj/item/rack_parts/gunrack_parts/attack_self(mob/user)
	if(building)
		return
	building = TRUE
	to_chat(user, span_notice("Вы начинаете собирать оружейную стойку..."))
	if(do_after(user, 50, target = user, progress=TRUE) && user.drop_item(src))
		var/obj/structure/rack/gunrack/G = new /obj/structure/rack/gunrack(user.loc)
		user.visible_message(span_notice("[user] собирает оружейную стойку."), span_notice("Вы закончили собирать оружейную стойку."))
		G.add_fingerprint(user)
		building = FALSE
		qdel(src)
	else
		building = FALSE
		return

/obj/structure/rack/shelving
	name = "стеллаж"
	desc = "Стеллаж для хранения различных вещей."
	icon_state = "shelving"

/obj/structure/rack/shelving/attackby(obj/item/V, mob/user, params)
	. = ..()
	if(V.loc == get_turf(src))
		add_fingerprint(user)
		var/list/click_params = params2list(params)
		//Center the icon where the user clicked.
		if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
			return
		//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
		V.pixel_x = clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
		V.pixel_y = clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)

/obj/structure/rack/shelving/deconstruct(disassembled = TRUE)
	if(!(flags & NODECONSTRUCT))
		density = FALSE
		var/obj/item/rack_parts/shelving_parts/newparts = new(loc)
		transfer_fingerprints_to(newparts)
	qdel(src)

/obj/item/rack_parts/shelving_parts
	name = "детали стеллажа"
	desc = "Детали для сборки стеллажа."
	icon = 'modular_ss220/aesthetics/racks/icons/racks.dmi'
	icon_state = "shelving_parts"

/obj/item/rack_parts/shelving_parts/attack_self(mob/user)
	if(building)
		return
	building = TRUE
	to_chat(user, span_notice("Вы начинаете собирать стеллаж..."))
	if(do_after(user, 50, target = user, progress=TRUE) && user.drop_item(src))
		var/obj/structure/rack/shelving/S = new /obj/structure/rack/shelving(user.loc)
		user.visible_message(span_notice("[user] собирает стеллаж."), span_notice("Вы закончили собирать стеллаж."))
		S.add_fingerprint(user)
		building = FALSE
		qdel(src)
	else
		building = FALSE
		return
