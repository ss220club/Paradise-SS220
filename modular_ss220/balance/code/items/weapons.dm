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

//lasergun change
/obj/item/ammo_casing/energy/lasergun_hs
	fire_sound = 'modular_ss220/balance/code/items/sound/laser.ogg'
	projectile_type = /obj/projectile/beam/player_laser
	muzzle_flash_strength = MUZZLE_FLASH_STRENGTH_NORMAL
	muzzle_flash_range = 2
	delay = 1.2 SECONDS

//recoil
/obj/item/gun/projectile/shotgun
	recoil = 1.4

/obj/item/gun/projectile/shotgun/pump(mob/M)
	if(QDELETED(M))
		return
	playsound(M, 'modular_ss220/balance/code/items/sound/shotgunpump.ogg', 60, TRUE)
	pump_unload()
	pump_reload()

/obj/item/gun/projectile/shotgun/automatic/combat
	recoil = 1.1

/obj/item/gun/projectile/automatic/wt550
	recoil = 0.8

/obj/item/gun/projectile/automatic/pistol/beretta
	recoil = 0.5

//changed sounds
/obj/item/ammo_casing/energy/laser
	fire_sound = 'modular_ss220/balance/code/items/sound/energy.ogg'

/obj/item/ammo_casing/energy/disabler
	fire_sound = 'modular_ss220/balance/code/items/sound/taser2.ogg'

/obj/item/gun/projectile/automatic/wt550
	magin_sound = 'modular_ss220/balance/code/items/sound/batrifle_magin.ogg'
	magout_sound = 'modular_ss220/balance/code/items/sound/batrifle_magout.ogg'

/obj/item/gun/projectile/shotgun
	fire_sound = 'modular_ss220/balance/code/items/sound/gunshot_shotgun.ogg'

/obj/item/gun/projectile/automatic/pistol/beretta
	fire_sound = 'modular_ss220/balance/code/items/sound/beretta_shot.ogg'
	magin_sound = 'modular_ss220/balance/code/items/sound/pistol_magin.ogg'
	magout_sound = 'modular_ss220/balance/code/items/sound/pistol_magout.ogg'
