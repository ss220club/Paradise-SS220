// Skrellian carbine
/obj/item/gun/energy/gun/skrell_carbine
	name = "\improper skrellian carbine"
	desc = "The Vuu'Xqu*ix T-3, known as 'VT-3' by TSF. Rarely seen out in the wild by anyone outside of a Skrellian SDTF. "
	icon = 'modular_ss220/objects/icons/guns.dmi'
	lefthand_file = 'modular_ss220/objects/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/objects/icons/inhands/guns_righthand.dmi'
	item_state = "skrell_carbine"
	icon_state = "skrell_carbine"
	cell_type = /obj/item/stock_parts/cell/skrell_carbine_cell
	ammo_type = list(/obj/item/ammo_casing/energy/laser/skrell_light, /obj/item/ammo_casing/energy/laser/skrell_assault)
	origin_tech = "combat=6;magnets=5"
	modifystate = 2
	execution_speed = 3 SECONDS

/obj/item/gun/energy/gun/skrell_carbine/elite
	name = "\improper elite skrellian carbine"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/skrell_light/elite, /obj/item/ammo_casing/energy/laser/skrell_assault/elite)

/obj/item/ammo_casing/energy/laser/skrell_light
	projectile_type = /obj/item/projectile/beam/laser/skrell_light
	muzzle_flash_color = LIGHT_COLOR_LAVENDER
	select_name = "light"
	e_cost

/obj/item/ammo_casing/energy/laser/skrell_assault
	projectile_type = /obj/item/projectile/beam/pulse/skrell_laser_assault
	muzzle_flash_color = LIGHT_COLOR_LAVENDER
	select_name = "assault"
	e_cost = 1600

/obj/item/ammo_casing/energy/laser/skrell_light/elite
	e_cost = 60

/obj/item/ammo_casing/energy/laser/skrell_assault/elite
	e_cost = 200

/obj/item/projectile/beam/laser/skrell_light
	name = "laser"
	icon_state = "bluelaser"
	damage = 23
	impact_effect_type = /obj/effect/temp_visual/impact_effect/purple_laser
	light_color = LIGHT_COLOR_LAVENDER
	forcedodge = 1

/obj/item/projectile/beam/pulse/skrell_laser_assault
	name = "heavy laser"
	icon_state = "u_laser_alt"
	damage = 10
	stamina = 60
	impact_effect_type = /obj/effect/temp_visual/impact_effect/purple_laser
	light_color = LIGHT_COLOR_LAVENDER
	weakened_against_rwalls = TRUE

/obj/item/stock_parts/cell/skrell_carbine_cell
	name = "\improper Vuu'Xqu*ix T-3 gun power cell"
	maxcharge = 1600

// Skrellian railgun rifle

/obj/item/gun/projectile/automatic/sniper_rifle/skrell_rifle
	name = "\improper skrellian rifle"
	desc = "The Zquiv*Tzuuli-8, or ZT-8, is a railgun rarely seen by anyone other than those within Skrellian SDTF ranks. The rotary magazine houses a cylinder with individual chambers, that press against the barrel when loaded."
	icon = 'modular_ss220/objects/icons/guns.dmi'
	lefthand_file = 'modular_ss220/objects/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/objects/icons/inhands/guns_righthand.dmi'
	icon_state = "sniper"
	item_state = "sniper"
	fire_sound = 'modular_ss220/objects/sound/weapons/gunshots/railgun.ogg'
	recoil = 0
	fire_delay = 25
	zoomable = FALSE
	can_suppress = FALSE
	mag_type = /obj/item/ammo_box/magazine/skrell_magazine

/obj/item/gun/projectile/automatic/sniper_rifle/skrell_rifle/elite
	fire_delay = 15
	zoomable = TRUE
	mag_type = /obj/item/ammo_box/magazine/skrell_magazine/skrell_magazine_elite

/obj/item/ammo_box/magazine/skrell_magazine
	name = "flechette cylinder"
	desc = "A magazine containing flechettes, the design harkening back to cylinders on revolvers."
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "skrell_magazine"
	multi_sprite_step = 3
	ammo_type = /obj/item/ammo_casing/railgun
	max_ammo = 4
	caliber = "railgun"
	multiload = 1

/obj/item/ammo_box/magazine/skrell_magazine/skrell_magazine_elite
	icon_state = "skrell_magazine_elite"
	multi_sprite_step = 7
	max_ammo = 8

/obj/item/ammo_casing/railgun
	name = "railgun bullet"
	desc = "A bullet for a high-tech railgun. It consists of a striking element and a detachable magnetic stabilizer."
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "railgun-casing"
	caliber = "railgun"
	projectile_type = /obj/item/projectile/bullet/railgun

/obj/item/projectile/bullet/railgun
	damage = 45
	weaken = 0.5 SECONDS
	armour_penetration_flat = 30
	pass_flags = PASSTABLE | PASSGRILLE | PASSGIRDER
	speed = 0.5
