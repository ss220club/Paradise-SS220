/obj/structure/rack
	icon = 'modular_ss220/aesthetics/racks/icons/racks.dmi'
	var/parts_type = /obj/item/rack_parts

/obj/structure/rack/deconstruct(disassembled = TRUE)
	if(flags & NODECONSTRUCT)
		return

	density = FALSE
	var/obj/item/rack_parts/newparts = new parts_type(loc)
	transfer_fingerprints_to(newparts)
	del(src)

/obj/structure/rack/attackby(obj/item/item, mob/user, params)
	. = ..()
	if(item.loc != get_turf(src))
		return

	add_fingerprint(user)
	var/list/click_params = params2list(params)
	if(!length(click_params))
		return

	var/click_icon_x = click_params["icon-x"]
	var/click_icon_y = click_params["icon-y"]

	//Center the icon where the user clicked.
	if(!click_icon_x || !click_icon_y)
		return

	var/max_pixelshift =  world.icon_size / 2
	var/min_pixelshift = -max_pixelshift

	//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
	item.pixel_x = clamp(text2num(click_icon_x) - 16, min_pixelshift, max_pixelshift)
	item.pixel_y = clamp(text2num(click_icon_y) - 16, min_pixelshift, max_pixelshift)

/obj/item/rack_parts
	var/rack_type = /obj/structure/rack

/obj/item/rack_parts/attack_self(mob/user)
	if(building)
		return

	building = TRUE
	to_chat(user, span_notice("Вы начинаете строительство..."))

	if(!do_after(user, 50, target = user, progress=TRUE) || !user.drop_item(src))
		building = FALSE
		return

	var/obj/structure/rack/rack = new rack_type(user.loc)
	user.visible_message(span_notice("[user] собирает [rack]."), span_notice("Вы закончили собирать [rack]."))
	rack.add_fingerprint(user)
	qdel(src)

/obj/structure/rack/shelving
	name = "shelving"
	desc = "Стеллаж для хранения различных вещей."
	icon_state = "shelving"
	parts_type = /obj/item/rack_parts/shelf

/obj/structure/rack/gunrack
	name = "gun rack"
	desc = "Стойка для хранения оружия."
	icon_state = "gunrack"
	parts_type = /obj/item/rack_parts/gun

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

	if(user.a_intent != INTENT_HARM)
		var/obj/item/gun/our_gun = W
		our_gun.place_on_rack()
		W.pixel_y = 0

/obj/structure/rack/gunrack/Initialize(mapload)
	. = ..()
	if(!mapload)
		return
	for(var/obj/item/gun/gun_inside in loc.contents)
		gun_inside.place_on_rack()

/obj/structure/rack/gunrack/deconstruct(disassembled = TRUE)
	for(var/obj/item/I in loc.contents)
		if(istype(I, /obj/item/gun))
			var/obj/item/gun/to_remove = I
			to_remove.remove_from_rack()
	. = ..()

/obj/item/rack_parts/shelf
	name = "shelving parts"
	desc = "Детали для сборки стеллажа."
	icon = 'modular_ss220/aesthetics/racks/icons/racks.dmi'
	icon_state = "shelving_parts"
	rack_type = /obj/structure/rack/shelving

/obj/item/rack_parts/gun
	name = "gun rack parts"
	desc = "Детали для сборки оружейной стойки."
	icon = 'modular_ss220/aesthetics/racks/icons/racks.dmi'
	icon_state = "gunrack_parts"
	rack_type = /obj/structure/rack/gunrack
