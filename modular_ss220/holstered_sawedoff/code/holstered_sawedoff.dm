/obj/item/gun/projectile/revolver/doublebarrel/sawoff(mob/user)
	. = ..()
	weapon_weight = WEAPON_MEDIUM
	can_holster = TRUE

	/obj/item/gun/projectile/revolver/doublebarrel/improvised/sawoff(mob/user)
	. = ..()
	if(. && sling) //sawing off the gun removes the sling
		new /obj/item/stack/cable_coil(get_turf(src), 10)
		sling = FALSE
		update_icon(UPDATE_ICON_STATE)
		can_holster = TRUE
