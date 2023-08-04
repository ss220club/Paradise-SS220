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
