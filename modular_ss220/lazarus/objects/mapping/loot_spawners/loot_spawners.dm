/obj/effect/spawner/lootdrop/lazarus
	icon = 'modular_ss220/lazarus/icons/mapping.dmi'
	icon_state = "lootmark"

/obj/effect/spawner/lootdrop/lazarus/trash
	name = "trash spawner"
	icon_state = "trash"

	lootcount = 1
	loot = list(
		/obj/item/stack/cable_coil {amount = 1} = 10,
		/obj/item/stack/cable_coil {amount = 2} = 10,
		/obj/item/stack/cable_coil {amount = 5} = 10,
		/obj/item/stack/cable_coil {amount = 10} = 5,
		/obj/item/stack/rods{amount = 1} = 10,
		/obj/item/stack/rods{amount = 2} = 10,
		/obj/item/stack/rods{amount = 3} = 10,
		/obj/item/stack/rods{amount = 5} = 5,
		/obj/item/stack/sheet/metal{amount = 1} = 20,
		/obj/item/stack/sheet/cardboard{amount = 1} = 20,
		/obj/item/stack/ore/glass{amount = 1} = 40,
		/obj/item/cigbutt = 60,
		/obj/item/trash/popcorn = 10,
		/obj/item/trash/candy = 10,
		/obj/item/trash/cheesie = 10,
		/obj/item/trash/chips = 10,
		/obj/item/trash/twimsts = 10,
		/obj/item/trash/sosjerky = 10,
		/obj/item/trash/spacetwinkie = 10,
		/obj/item/trash/plate = 10,
		/obj/item/trash/liquidfood = 10,
		/obj/item/trash/can = 10,
		/obj/item/trash/tapetrash = 10,
		/obj/item/trash/spentcasing = 30,
	)

/obj/effect/spawner/lootdrop/lazarus/medical
	name = "medicine spawner"
	icon_state = "medical"

	lootcount = 1
	loot = list(
		// FIRST AID KITS
		/obj/item/storage/firstaid/regular = 15,
		/obj/item/storage/firstaid/fire = 5,
		/obj/item/storage/firstaid/brute = 5,
		/obj/item/storage/firstaid/o2 = 5,
		/obj/item/storage/firstaid/toxin = 5,
		/obj/item/storage/firstaid/adv = 5,

		// MED KITS
		/obj/item/stack/medical/bruise_pack = 30,
		/obj/item/stack/medical/bruise_pack/advanced = 30,
		/obj/item/stack/medical/ointment = 30,
		/obj/item/stack/medical/ointment/advanced = 30,
		/obj/item/stack/medical/splint = 10,

		// MENDERS
		/obj/item/reagent_containers/applicator/brute = 15,
		/obj/item/reagent_containers/applicator/burn = 15,

		// OTHER
		/obj/item/reagent_containers/hypospray/autoinjector/epinephrine = 30,
		/obj/item/healthanalyzer = 10,
		/obj/item/healthanalyzer/advanced = 10,
		/obj/item/reagent_containers/glass/bottle/oculine = 10,
		/obj/item/reagent_containers/glass/bottle/morphine = 10,
		/obj/item/reagent_containers/glass/bottle/reagent/lazarus_reagent = 10,
		/obj/item/vending_refill/medical = 10,
	)

/obj/effect/spawner/lootdrop/lazarus/engineering
	name = "engi loot spawner"
	icon_state = "engineering"

	lootcount = 1
	loot = list(
		// BOXES
		/obj/item/storage/toolbox/mechanical = 10,
		/obj/item/storage/toolbox/electrical = 10,
		/obj/item/storage/toolbox/emergency = 10,
		/obj/item/storage/firstaid/machine = 5,

		// TOOLS
		/obj/item/crowbar = 5,
		/obj/item/wirecutters = 5,
		/obj/item/wrench = 5,
		/obj/item/screwdriver = 5,
		/obj/item/multitool = 5,
		/obj/item/weldingtool = 3,
		/obj/item/weldingtool/largetank = 2,

		// EQUIPMENT
		/obj/item/clothing/head/welding = 4,
		/obj/item/clothing/glasses/welding = 4,
		/obj/item/clothing/gloves/color/fyellow = 5,
		/obj/item/clothing/gloves/color/yellow = 3,

		// MATERIALS
		/obj/item/stack/rods{amount = 10} = 8,
		/obj/item/stack/metal{amount = 10} = 8,
		/obj/item/stack/glass{amount = 10} = 8,
	)

/obj/effect/spawner/lootdrop/lazarus/food
	name = "food spawner"
	icon_state = "food"

	lootcount = 1
	loot = list(
		// FOOD
		/obj/item/food/snacks/boiledbuckwheat = 10,
		/obj/item/food/snacks/friedegg = 10,
		/obj/item/food/snacks/meatsteak = 10,
		/obj/item/food/snacks/breadslice = 10,
		/obj/item/food/snacks/sliceable/bread = 2,
		/obj/item/food/snacks/vegisalad = 10,
		/obj/item/food/snacks/oliviersalad = 10,

		// DRINKS
		/obj/item/reagent_containers/drinks/chicken_soup = 15,
		/obj/item/reagent_containers/drinks/cans/cola = 10,
		/obj/item/reagent_containers/drinks/cans/beer = 10,
		/obj/item/reagent_containers/drinks/cans/kvass = 10,
	)
