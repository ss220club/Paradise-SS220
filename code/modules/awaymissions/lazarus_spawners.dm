// Base corpse spawner

/obj/effect/mob_spawn/human/lazarus
	name = "Lazarus corpse spawner"
	mob_name = "Placeholder"
	id_job = "Placeholder"
	brute_damage = 300
	oxy_damage = 300

// Lazarus outfit

/datum/outfit/lazarus
	name = "Lazarus Placeholder"

	back = /obj/item/storage/backpack

	var/list/loot = list()
	var/list/guaranteed_loot = list()
	var/loot_min = 0
	var/loot_max = 0
	var/lootdoubles = 0

/datum/outfit/lazarus/New()
	. = ..()
	var/list/backpack_loot = list()
	for (var/loot in guaranteed_loot)
		backpack_loot += loot
	var/lootcount = rand(loot_min, loot_max)
	while(lootcount)
		var/lootspawn = pickweight(loot)

		if(!lootdoubles)
			loot.Remove(lootspawn)
		if(lootspawn)
			backpack_loot += lootspawn
		lootcount--
	backpack_contents = backpack_loot

// CORPSE SPAWNERS

/obj/effect/mob_spawn/human/lazarus/colonist
	name = "Lazarus Colonist Corpse"
	mob_name = "Colonist"
	id_job = "Colonist"
	outfit = /datum/outfit/lazarus/colonist
	brute_damage = 450

/datum/outfit/lazarus/colonist
	name = "Lazarus Colonist"

	uniform = /obj/item/clothing/under/color/random
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/radio/headset
	id = /obj/item/card/id/assistant

	loot_min = 3
	loot_max = 6

	loot = list(
		// Tools
		/obj/item/screwdriver = 10,
		/obj/item/wrench = 10,
		/obj/item/weldingtool = 10,
		/obj/item/crowbar = 10,
		/obj/item/wirecutters = 10,
		/obj/item/multitool = 10,
		/obj/item/stack/cable_coil/random = 10,
		/obj/item/clothing/head/welding = 3,
		/obj/item/clothing/gloves/color/yellow = 2,
		/obj/item/clothing/gloves/color/fyellow = 5,

		// Food (Lack of food is one of the event ideas)
		/obj/item/food/snacks/applecakeslice = 1,
		/obj/item/food/snacks/cheesecakeslice = 1,
		/obj/item/food/snacks/meatbreadslice = 1,
		/obj/item/food/snacks/creamcheesebreadslice = 1,
		/obj/item/food/snacks/grown/apple = 1,
		/obj/item/food/snacks/grown/berries = 5,
		/obj/item/food/snacks/donkpocket = 1,
		/obj/item/food/snacks/sandwich = 1,
		/obj/item/food/snacks/chips = 1,
		/obj/item/food/snacks/tastybread = 1,
		/obj/item/food/snacks/meat = 5,
		/obj/item/food/snacks/meatsteak = 1,

		// Melee Weapons
		/obj/item/hatchet = 8,
		/obj/item/pickaxe = 5,
		/obj/item/shovel = 12,
		/obj/item/fireaxe = 2,
		/obj/item/pickaxe/diamond = 2,
		/obj/item/claymore = 1,
		/obj/item/spear = 8,
		/obj/item/melee/baton/cattleprod = 6,
		/obj/item/melee/baton/loaded = 3,
		/obj/item/kitchen/knife = 5,

		// Ranged Weapons + Ammo
		/obj/item/gun/energy/disabler = 3,
		/obj/item/gun/projectile/automatic/pistol = 1,
		/obj/item/ammo_box/magazine/m10mm = 4,
		/obj/item/gun/energy/laser = 2,

		// Medicine
		/obj/item/healthanalyzer = 4,
		/obj/item/healthanalyzer/advanced = 2,
		/obj/item/stack/medical/bruise_pack = 10,
		/obj/item/stack/medical/ointment = 10,
		/obj/item/stack/medical/bruise_pack/advanced = 4,
		/obj/item/stack/medical/ointment/advanced = 4,
		/obj/item/reagent_containers/hypospray/autoinjector/epinephrine = 10,

		// Light
		/obj/item/flashlight = 6,
		/obj/item/flashlight/flare/torch = 15,
		/obj/item/flashlight/flare = 15,
		/obj/item/flashlight/lantern = 6,
	)

/obj/effect/mob_spawn/human/colonist/winter
	name = "Lazarus Colonist Corpse"
	mob_name = "Colonist"
	id_job = "Colonist"
	outfit = /datum/outfit/lazarus/colonist

/datum/outfit/lazarus/colonist/winter
	name = "Lazarus Winter Colonist"

	suit = /obj/item/clothing/suit/hooded/wintercoat
	head = /obj/item/clothing/head/hooded/winterhood
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/winterboots

/obj/effect/mob_spawn/human/lazarus/security
	name = "Lazarus Security Corpse"
	mob_name = "Security Guard"
	id_job = "Security Guard"
	outfit = /datum/outfit/lazarus/security

/datum/outfit/lazarus/security
	name = "Lazarus Colonist"

	uniform = /obj/item/clothing/under/rank/security/officer
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/black
	id = /obj/item/card/id/security
	suit = /obj/item/clothing/suit/hooded/wintercoat/security
	head = /obj/item/clothing/head/helmet
	belt = /obj/item/storage/belt/security
	l_ear = /obj/item/radio/headset/headset_sec/alt
	back = /obj/item/storage/backpack/security

	loot_min = 3
	loot_max = 6

	loot = list(
		// Tools
		/obj/item/screwdriver = 10,
		/obj/item/wrench = 10,
		/obj/item/weldingtool = 10,
		/obj/item/crowbar = 10,
		/obj/item/wirecutters = 10,
		/obj/item/multitool = 10,
		/obj/item/stack/cable_coil/random = 10,
		/obj/item/clothing/head/welding = 3,
		/obj/item/clothing/gloves/color/yellow = 2,
		/obj/item/clothing/gloves/color/fyellow = 5,

		// Food (Lack of food is one of the event ideas)
		/obj/item/food/snacks/applecakeslice = 1,
		/obj/item/food/snacks/cheesecakeslice = 1,
		/obj/item/food/snacks/meatbreadslice = 1,
		/obj/item/food/snacks/creamcheesebreadslice = 1,
		/obj/item/food/snacks/grown/apple = 1,
		/obj/item/food/snacks/grown/berries = 5,
		/obj/item/food/snacks/donkpocket = 1,
		/obj/item/food/snacks/sandwich = 1,
		/obj/item/food/snacks/chips = 1,
		/obj/item/food/snacks/tastybread = 1,
		/obj/item/food/snacks/meat = 5,
		/obj/item/food/snacks/meatsteak = 1,

		// Melee Weapons
		/obj/item/hatchet = 8,
		/obj/item/pickaxe = 5,
		/obj/item/shovel = 12,
		/obj/item/fireaxe = 2,
		/obj/item/pickaxe/diamond = 2,
		/obj/item/claymore = 1,
		/obj/item/spear = 8,
		/obj/item/melee/baton/cattleprod = 6,
		/obj/item/melee/baton/loaded = 50,
		/obj/item/kitchen/knife = 5,

		// Ranged Weapons + Ammo
		/obj/item/gun/energy/disabler = 40,
		/obj/item/gun/projectile/automatic/pistol = 1,
		/obj/item/ammo_box/magazine/m10mm = 4,
		/obj/item/gun/energy/laser = 20,
		/obj/item/gun/projectile/automatic/pistol/enforcer/lethal = 15,
		/obj/item/ammo_box/magazine/enforcer/lethal = 45,

		// Medicine
		/obj/item/healthanalyzer = 4,
		/obj/item/healthanalyzer/advanced = 2,
		/obj/item/stack/medical/bruise_pack = 10,
		/obj/item/stack/medical/ointment = 10,
		/obj/item/stack/medical/bruise_pack/advanced = 4,
		/obj/item/stack/medical/ointment/advanced = 4,
		/obj/item/reagent_containers/hypospray/autoinjector/epinephrine = 10,

		// Light
		/obj/item/flashlight = 6,
		/obj/item/flashlight/flare/torch = 15,
		/obj/item/flashlight/flare = 15,
		/obj/item/flashlight/lantern = 6,
	)
