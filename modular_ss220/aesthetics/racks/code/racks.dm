/obj/structure/rack
	icon = 'modular_ss220/aesthetics/racks/icons/racks.dmi'

/obj/structure/rack/gunrack
	name = "gun rack"
	desc = "A gun rack for storing guns."
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
		to_chat(user, span_warning("This item doesn't fit!"))
		return
	. = ..()
	if(.)
		add_fingerprint(user)
		var/obj/item/gun/our_gun = O
		our_gun.place_on_rack()

/obj/structure/rack/gunrack/attackby(obj/item/W, mob/user, params) //TODO: fix logic
	if(!(istype(W, /obj/item/gun)))
		to_chat(user, span_warning("This item doesn't fit!"))
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
	name = "gun rack parts"
	desc = "Parts of a gun rack."
	icon = 'modular_ss220/aesthetics/racks/icons/racks.dmi'
	icon_state = "gunrack_parts"

/obj/item/rack_parts/gunrack_parts/attack_self(mob/user)
	if(building)
		return
	building = TRUE
	to_chat(user, "<span class='notice'>You start constructing a gun rack...</span>")
	if(do_after(user, 50, target = user, progress=TRUE))
		if(!user.drop_item(src))
			return
		var/obj/structure/rack/gunrack/R = new /obj/structure/rack/gunrack(user.loc)
		user.visible_message("<span class='notice'>[user] assembles \a [R].\
			</span>", "<span class='notice'>You assemble \a [R].</span>")
		R.add_fingerprint(user)
		qdel(src)
	building = FALSE

/obj/structure/rack/shelving
	name = "shelving"
	desc = "A shelving for storing various goods"
	icon_state = "shelving"

/obj/structure/rack/shelving/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(W.loc == get_turf(src))
		add_fingerprint(user)
		var/list/click_params = params2list(params)
		//Center the icon where the user clicked.
		if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
			return
		//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
		W.pixel_x = clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
		W.pixel_y = clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)

/obj/structure/rack/shelving/deconstruct(disassembled = TRUE)
	if(!(flags & NODECONSTRUCT))
		density = FALSE
		var/obj/item/rack_parts/shelving_parts/newparts = new(loc)
		transfer_fingerprints_to(newparts)
	qdel(src)

/obj/item/rack_parts/shelving_parts
	name = "shelving parts"
	desc = "Parts of a shelving"
	icon = 'modular_ss220/aesthetics/racks/icons/racks.dmi'
	icon_state = "shelving_parts"

/obj/item/rack_parts/shelving_parts/attack_self(mob/user)
	if(building)
		return
	building = TRUE
	to_chat(user, "<span class='notice'>You start constructing a shelving...</span>")
	if(do_after(user, 50, target = user, progress=TRUE))
		if(!user.drop_item(src))
			return
		var/obj/structure/rack/shelving/R = new /obj/structure/rack/shelving(user.loc)
		user.visible_message("<span class='notice'>[user] assembles \a [R].\
			</span>", "<span class='notice'>You assemble \a [R].</span>")
		R.add_fingerprint(user)
		qdel(src)
	building = FALSE
