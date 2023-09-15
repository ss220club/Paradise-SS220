// Reagents
/datum/reagent/consumable/buckwheat
	name = "Гречка"
	id = "buckwheat"
	description = "Ходят слухи, что советские люди жрут только водку и... это?"
	reagent_state = SOLID
	nutriment_factor = 3 * REAGENTS_METABOLISM
	color = "#8E633C"
	taste_description = "сухая гречка"

// Slices
/obj/item/reagent_containers/food/snacks/cucumberslice
 	name = "cucumber slice"
 	desc = "A slice from a cucumber."
 	icon_state = "cucumberslice"
 	filling_color = "#00DB00"
 	bitesize = 6
 	list_reagents = list("kelotane" = 1)
 	tastes = list("cucumber" = 1)
