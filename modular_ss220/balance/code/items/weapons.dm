/obj/item/gun/projectile/revolver/doublebarrel/sawoff(mob/user)
	. = ..()
	if(sawn_state == SAWN_OFF)
		can_holster = TRUE
		w_class = WEAPON_MEDIUM

// MARK: Energy
/obj/item/gun/energy/gun
	w_class = WEIGHT_CLASS_BULKY

/obj/item/gun/energy/immolator
	w_class = WEIGHT_CLASS_BULKY

/obj/item/gun/energy/gun/hos
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/gun/energy/gun/blueshield
	w_class = WEIGHT_CLASS_NORMAL

// MARK: Laser
/obj/item/gun/energy/laser
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun_hs)

/obj/item/gun/energy/xray
	w_class = WEIGHT_CLASS_BULKY

/obj/item/gun/energy/laser/captain
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/gun/energy/laser/tag
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/gun/energy/laser/practice
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/gun/energy/laser/awaymission_aeg/rnd
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/ammo_casing/energy/lasergun_hs
	name = "LG-5 laser cell"
	desc = "A special energy cell designed specifically for the LG-5 laser carbine. Fires a precise, hitscan laser beam."
	icon_state = "laser"
	caliber = "energy"
	projectile_type = /obj/item/projectile/beam/laser/player_laser
	muzzle_flash_strength = MUZZLE_FLASH_STRENGTH_NORMAL
	muzzle_flash_range = 2
	delay = 1.2 SECONDS
