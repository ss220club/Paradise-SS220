/datum/crafting_recipe/improvisedslug
	name = "Improvised Shotgun Shell"
	result = list(/obj/item/ammo_casing/shotgun/improvised)
	reqs = list(/obj/item/grenade/chem_grenade = 1,
				/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/cable_coil = 1,
				/datum/reagent/fuel = 10)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/improvisedslugoverload
	name = "Overload Improvised Shell"
	result = list(/obj/item/ammo_casing/shotgun/improvised/overload)
	reqs = list(/obj/item/ammo_casing/shotgun/improvised = 1,
				/datum/reagent/blackpowder = 10,
				/datum/reagent/plasma_dust = 20)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/obj/item/ammo_casing/shotgun/improvised
	name = "improvised shell"
	desc = "An extremely weak shotgun shell with multiple small pellets made out of metal shards."
	icon_state = "improvshell"
	projectile_type = /obj/item/projectile/bullet/pellet/weak
	materials = list(MAT_METAL=250)
	pellets = 10
	variance = 35
	muzzle_flash_strength = MUZZLE_FLASH_STRENGTH_NORMAL
	muzzle_flash_range = MUZZLE_FLASH_RANGE_NORMAL

/obj/item/ammo_casing/shotgun/improvised/overload
	name = "overloaded improvised shell"
	desc = "An extremely weak shotgun shell with multiple small pellets made out of metal shards. This one has been packed with even more \
	propellant. It's like playing russian roulette, with a shotgun."
	icon_state = "improvshell"
	projectile_type = /obj/item/projectile/bullet/pellet/overload
	materials = list(MAT_METAL=250)
	pellets = 4
	variance = 40
	muzzle_flash_strength = MUZZLE_FLASH_STRENGTH_NORMAL
	muzzle_flash_range = MUZZLE_FLASH_RANGE_STRONG

/obj/item/projectile/bullet/pellet/weak
	tile_dropoff = 0.55		//Come on it does 6 damage don't be like that.
	damage = 6

/obj/item/projectile/bullet/pellet/weak/New()
	range = rand(1, 8)
	..()

/obj/item/projectile/bullet/pellet/weak/on_range()
	do_sparks(1, 1, src)
	..()

/obj/item/projectile/bullet/pellet/overload
	damage = 3

/obj/item/projectile/bullet/pellet/overload/New()
	range = rand(1, 10)
	..()

/obj/item/projectile/bullet/pellet/overload/on_hit(atom/target, blocked = 0)
	..()
	explosion(target, 0, 0, 2)

/obj/item/projectile/bullet/pellet/overload/on_range()
	explosion(src, 0, 0, 2)
	do_sparks(3, 3, src)
	..()
