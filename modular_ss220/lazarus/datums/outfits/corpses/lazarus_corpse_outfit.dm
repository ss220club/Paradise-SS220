/datum/outfit/lazarus/corpse
	name = "Lazarus Placeholder"

	back = /obj/item/storage/backpack

	var/list/guaranteed_loot = list()
	var/loot_min = 3
	var/loot_max = 6
	var/lootdoubles = 0

	var/list/loot = list(
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

		// Other
		/obj/item/stock_parts/cell = 6,
		/obj/item/stock_parts/cell/high = 4,
		/obj/item/reagent_containers/spray/cleaner = 3,
		/obj/item/radio/off = 7,
		/obj/item/extinguisher/mini = 4,
		/obj/item/stack/rods{amount = 10} = 8,
		/obj/item/stack/sheet/metal{amount = 10} = 8,
		/obj/item/stack/sheet/glass{amount = 10} = 8,

		// Trash
		/obj/item/camera = 15,
		/obj/item/paper = 10,
		/obj/item/storage/fancy/cigarettes/cigpack_robust = 8,
		/obj/item/lighter = 8,
		/obj/item/lighter/zippo = 2,
		/obj/item/storage/photo_album = 10,
		/obj/item/stack/tape_roll = 10,
		/obj/item/coin/silver = 10,
		/obj/item/assembly/timer = 10,
	)

/datum/outfit/lazarus/corpse/New()
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
