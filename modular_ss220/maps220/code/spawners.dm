// MARK: Food
/obj/effect/spawner/random/ccfood


/obj/effect/spawner/random/ccfood/dessert
	spawn_loot_count = 3
	loot = list(
		/obj/item/food/baguette,
		/obj/item/food/applepie,
		/obj/item/food/sliced/banana_bread,
		/obj/item/food/sliced/banana_cake,
		/obj/item/food/sliced/carrot_cake,
		/obj/item/food/croissant,
		/obj/item/reagent_containers/drinks/cans/cola,
		)

/obj/effect/spawner/random/ccfood/meat
	spawn_loot_count = 3
	loot = list(
		/obj/item/food/lasagna,
		/obj/item/food/burger/bigbite,
		/obj/item/food/fishandchips,
		/obj/item/food/fishburger,
		/obj/item/food/hotdog,
		/obj/item/food/meatpie,
		/obj/item/reagent_containers/drinks/cans/cola,
		)

/obj/effect/spawner/random/ccfood/alcohol
	spawn_loot_count = 1
	loot = list(
		/obj/item/reagent_containers/drinks/flask/detflask,
		/obj/item/reagent_containers/drinks/cans/tonic,
		/obj/item/reagent_containers/drinks/cans/thirteenloko,
		/obj/item/reagent_containers/drinks/cans/synthanol,
		/obj/item/reagent_containers/drinks/cans/space_mountain_wind,
		/obj/item/reagent_containers/drinks/cans/lemon_lime,
		)

// MARK: Loot
/obj/effect/spawner/random/loot
	icon = 'icons/effects/random_spawners.dmi'

/obj/effect/spawner/random/loot/modkit
	name = "random modkit"
	icon_state = "donkpocket_single" // i'm not gonna sprite this!
	loot = list(
		/obj/item/borg/upgrade/modkit/range,
		/obj/item/borg/upgrade/modkit/damage,
		/obj/item/borg/upgrade/modkit/tracer,
		/obj/item/borg/upgrade/modkit/tracer/adjustable,
		/obj/item/borg/upgrade/modkit/lifesteal,
		/obj/item/borg/upgrade/modkit/cooldown,
		/obj/item/borg/upgrade/modkit/chassis_mod,
		/obj/item/borg/upgrade/modkit/chassis_mod/orange,
		/obj/item/borg/upgrade/modkit/aoe/turfs,
	)

/obj/effect/spawner/random/loot/laser
	name = "laser 60pc"
	icon_state = "stetchkin"
	spawn_loot_chance = 60
	loot = list(/obj/item/gun/energy/laser)

/obj/effect/spawner/random/loot/laser/retro
	loot = list(/obj/item/gun/energy/laser/retro)

/obj/effect/spawner/random/loot/laser/advanced
	loot = list(
		/obj/item/gun/energy/laser,
		/obj/item/gun/energy/lasercannon,
	)

/obj/effect/spawner/random/loot/docs
	icon_state = "folder"

/obj/effect/spawner/random/loot/docs/syndie
	name = "syndie documents"
	loot = list(
		/obj/item/documents/syndicate,
		/obj/item/documents/syndicate/red,
		/obj/item/documents/syndicate/blue,
		/obj/item/documents/syndicate/yellow,
		/obj/item/documents/syndicate/mining,
	)

/obj/effect/spawner/random/maintenance
	icon = 'modular_ss220/maps220/icons/spawner_icons.dmi'

// MARK: Office toys spawners
/obj/effect/spawner/random/officetoys
	name = "office desk toy spawner"
	icon = 'modular_ss220/maps220/icons/spawner_icons.dmi'
	icon_state = "officetoy"
	loot = list(
		/obj/item/toy/desk/officetoy,
		/obj/item/toy/desk/dippingbird,
		/obj/item/toy/desk/newtoncradle,
		/obj/item/toy/desk/fan,
		/obj/item/hourglass
	)

// MARK: Random spawners
/obj/effect/spawner/random/mod
	icon = 'modular_ss220/maps220/icons/spawner_icons.dmi'
	icon_state = "mod"

/obj/item/reagent_containers/pill/random_drugs
	icon = 'modular_ss220/maps220/icons/spawner_icons.dmi'
	icon_state = "pills"

/obj/item/reagent_containers/pill/random_drugs/Initialize(mapload)
	icon = 'icons/obj/chemical.dmi'
	. = ..()

/obj/item/reagent_containers/drinks/bottle/random_drink
	icon = 'modular_ss220/maps220/icons/spawner_icons.dmi'
	icon_state = "drinks"

/obj/item/reagent_containers/drinks/bottle/random_drink/Initialize(mapload)
	icon = 'icons/obj/drinks.dmi'
	. = ..()

/obj/effect/spawner/random/hostile_fauna
	name = "hostile fauna spawner"
	icon = 'icons/effects/spawner_icons.dmi'
	icon_state = "Carp"
	spawn_loot_chance = 65
	loot = list(
		/mob/living/simple_animal/hostile/faithless/ww = 30,
		/mob/living/simple_animal/hostile/creature/ww = 20,
		/mob/living/simple_animal/hostile/netherworld/ww = 10,
		/mob/living/simple_animal/hostile/netherworld/migo/ww = 10,
		/mob/living/simple_animal/hostile/hellhound/ww = 5,

		// always least chance
		/mob/living/simple_animal/hostile/hellhound/tear/ww,
	)

// MARK: Misc
/obj/effect/spawner/random/trash
	icon = 'modular_ss220/maps220/icons/spawner_icons.dmi'

/obj/effect/spawner/random/trash/Initialize(mapload)
	. = ..()
	loot += list(
		list(
			/obj/item/trash/bowl,
			/obj/item/trash/can,
			/obj/item/trash/candle,
			/obj/item/trash/candy,
			/obj/item/trash/cheesie,
			/obj/item/trash/chips,
			/obj/item/trash/fried_vox,
			/obj/item/trash/gum,
			/obj/item/trash/liquidfood,
			/obj/item/trash/pistachios,
			/obj/item/trash/plate,
			/obj/item/trash/popcorn,
			/obj/item/trash/raisins,
			/obj/item/trash/semki,
			/obj/item/trash/snack_bowl,
			/obj/item/trash/sosjerky,
			/obj/item/trash/spacetwinkie,
			/obj/item/trash/spentcasing,
			/obj/item/trash/syndi_cakes,
			/obj/item/trash/tapetrash,
			/obj/item/trash/tastybread,
			/obj/item/trash/tray,
			/obj/item/trash/waffles,
			/obj/item/trash/vulpix_chips,
			/obj/item/trash/foodtray,
		) = 5,
	)
