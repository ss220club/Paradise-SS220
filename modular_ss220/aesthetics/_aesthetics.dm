/datum/modpack/aesthetics
	name = "Эстетика"
	desc = "Обновление визуального ряда"
	author = "larentoun, Aylong220"

/datum/modpack/aesthetics/initialize()
	GLOB.wood_recipes += list(
		null,
		new /datum/stack_recipe("oak wood floor tile", /obj/item/stack/tile/wood/oak, 1, 4, 20),
		new /datum/stack_recipe("birch wood floor tiles", /obj/item/stack/tile/wood/birch, 1, 4, 20),
		new /datum/stack_recipe("cherry wood floor tiles", /obj/item/stack/tile/wood/cherry, 1, 4, 20),
		new /datum/stack_recipe("fancy oak wood floor tiles", /obj/item/stack/tile/wood/fancy/oak, 1, 4, 20),
		new /datum/stack_recipe("fancy birch wood floor tiles", /obj/item/stack/tile/wood/fancy/birch, 1, 4, 20),
		new /datum/stack_recipe("fancy cherry wood floor tiles", /obj/item/stack/tile/wood/fancy/cherry, 1, 4, 20),
		new /datum/stack_recipe("fancy light oak wood floor tiles", /obj/item/stack/tile/wood/fancy/light, 1, 4, 20),
		new /datum/stack_recipe("parquet wood floor tiles", /obj/item/stack/tile/wood/parquet, 1, 4, 20),
		new /datum/stack_recipe("tiled parquet wood floor tiles", /obj/item/stack/tile/wood/parquet/tile, 1, 4, 20),
		null)

