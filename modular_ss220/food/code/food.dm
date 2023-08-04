// Reagent Grinder
/obj/machinery/reagentgrinder
	blend_items = list(/obj/item/reagent_containers/food/snacks/grown/buckwheat = list("buckwheat" = -5))

// Buckwheat
/datum/reagent/consumable/buckwheat
	name = "Buckwheat"
	id = "buckwheat"
	description = "Rumors tell soviet people are eating only vodka and... this?"
	reagent_state = SOLID
	nutriment_factor = 3 * REAGENTS_METABOLISM
	color = "#8E633C" // rgb: 142, 99, 60
	taste_description = "dry buckwheat"

/obj/item/reagent_containers/food/snacks/boiledbuckwheat
	name = "boiled buckwheat"
	desc = "'Grechka', or boiled buckwheat. Motherland would be proud of you."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "boiledbuckwheat"
	trash = /obj/item/trash/plate
	filling_color = "#8E633C"
	list_reagents = list("nutriment" = 5, "vitamin" = 1)
	tastes = list("buckwheat" = 1, "motherland" = 1)

/datum/recipe/microwave/boiledbuckwheat
	reagents = list("water" = 5, "buckwheat" = 10)
	result = /obj/item/reagent_containers/food/snacks/boiledbuckwheat

/obj/item/reagent_containers/food/snacks/buckwheat_merchant
	name = "merchant's buckwheat porridge"
	desc = "Hot and steamy, soviet spies are involved. No doubt."
	icon_state = "buckwheat_merchant"
	trash = /obj/item/trash/plate
	filling_color = "#8E633C"
	list_reagents = list("nutriment" = 5, "protein" = 2, "vitamin" = 3)
	tastes = list("buckwheat" = 2, "meat" = 2, "tomato sause" = 1)

/datum/recipe/microwave/buckwheat_merchant
	reagents = list("water" = 5, "buckwheat" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/grown/tomato,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/buckwheat_merchant
