// Reagent Grinder
/obj/machinery/reagentgrinder/Initialize(mapload)
	. = ..()
	blend_items = list(/obj/item/reagent_containers/food/snacks/grown/buckwheat = list("buckwheat" = -5)) + blend_items

// Boiled Buckwheat
/obj/item/reagent_containers/food/snacks/boiledbuckwheat
	name = "варённая гречка"
	desc = "Это просто варённая гречка, ничего необычного."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "boiledbuckwheat"
	trash = /obj/item/trash/plate
	filling_color = "#8E633C"
	list_reagents = list("nutriment" = 5, "vitamin" = 1)
	tastes = list("гречка" = 1)

/datum/recipe/microwave/boiledbuckwheat
	reagents = list("water" = 5, "buckwheat" = 10)
	result = /obj/item/reagent_containers/food/snacks/boiledbuckwheat

// Merchant Buckwheat
/obj/item/reagent_containers/food/snacks/buckwheat_merchant
	name = "гречка по-купечески"
	desc = "Тушённая гречка с овощами и мясом."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "buckwheat_merchant"
	trash = /obj/item/trash/plate
	filling_color = "#8E633C"
	list_reagents = list("nutriment" = 5, "protein" = 2, "vitamin" = 3)
	tastes = list("гречка" = 2, "мясо" = 2, "томатный соус" = 1)

/datum/recipe/microwave/buckwheat_merchant
	reagents = list("water" = 5, "buckwheat" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/grown/tomato,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/buckwheat_merchant

// Olivier Salad
/obj/item/reagent_containers/food/snacks/oliviersalad
	name = "салат оливье"
	desc = "Не трогай, это на новый год!"
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "oliviersalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#C2CFAB"
	bitesize = 3
	list_reagents = list("nutriment" = 10, "kelotane" = 2, "vitamin" = 3)
	tastes = list("варённая картошка" = 1, "огурец" = 1, "морковка" = 1, "яйцо" = 1, "Новый Год" = 1)

/datum/recipe/microwave/oliviersalad
	reagents = list("cream" = 10, "sodiumchloride" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/pickles,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/grown/potato,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/sausage)
	result = /obj/item/reagent_containers/food/snacks/oliviersalad

// Weird Olivier Salad
/obj/item/reagent_containers/food/snacks/weirdoliviersalad
	name = "странный салат оливье"
	desc = "Что ты сделал с этим оливье, чудовище?"
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "oliviersalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#C2CFAB"
	bitesize = 3
	list_reagents = list("nutriment" = 12, "kelotane" = 2, "vitamin" = 3)
	tastes = list("варённая картошка" = 1, "огурец" = 1, "морковка" = 1, "яйца" = 1, "странно" = 1, "Новый Год" = 1)

/datum/recipe/microwave/weirdoliviersalad
	reagents = list("cream" = 10, "sodiumchloride" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/pickles,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/grown/potato,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/grown/apple)
	result = /obj/item/reagent_containers/food/snacks/weirdoliviersalad

// Vegetable Salad
/obj/item/reagent_containers/food/snacks/vegisalad
	name = "овощной салат"
	desc = "Идеальная комбинация томатов и огурцов."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "validsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#C2CFAB"
	bitesize = 3
	list_reagents = list("nutriment" = 4, "kelotane" = 1, "vitamin" = 1)
	tastes = list("томат" = 2, "маринованные огурцы" = 2, "сметана" = 2)

/datum/recipe/microwave/vegisalad
	reagents = list("cream" = 10, "sodiumchloride" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/grown/cucumber,
		/obj/item/reagent_containers/food/snacks/grown/tomato)
	result = /obj/item/reagent_containers/food/snacks/vegisalad

// Pickles
/obj/item/reagent_containers/food/snacks/pickles
	name = "маринованные огурцы"
	desc = "Черт, тут много маринованных огурчиков."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "pickles"
	trash = /obj/item/reagent_containers/food/snacks/brine
	filling_color = "#C2CFAB"
	bitesize = 8
	list_reagents = list("nutriment" = 2, "vitamin" = 1)
	tastes = list("pickles" = 1)

/obj/item/reagent_containers/food/snacks/brine
	name = "рассол"
	desc = "Самое то после бурной ночи."
	consume_sound = 'sound/items/drink.ogg'
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "brine"
	filling_color = "#C2CFAB"
	bitesize = 4
	list_reagents = list("nutriment" = 1, "antihol" = 2)
	tastes = list("brine" = 3)

/datum/crafting_recipe/pickles
	name = "Маринованные огурцы"
	result = list(/obj/item/reagent_containers/food/snacks/pickles)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/cucumber = 3,
		/datum/reagent/water = 10,
		/datum/reagent/consumable/sodiumchloride = 10)
	time = 1 SECONDS
	category = CAT_FOOD
	subcategory = CAT_MISCFOOD

// Pickle Soup
/obj/item/reagent_containers/food/snacks/soup/rassolnik
	name = "рассольник"
	desc = "Популярен в СССП."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "rassolnik"
	filling_color = "#F1FC72"
	list_reagents = list("nutriment" = 6, "kelotane" = 1, "vitamin" = 2)
	tastes = list("картошка" = 1, "огурцы" = 1, "рис" = 1)

/datum/recipe/microwave/rassolnik
	reagents = list("water" = 10, "rice" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/grown/potato,
		/obj/item/reagent_containers/food/snacks/grown/cucumber)
	result = /obj/item/reagent_containers/food/snacks/soup/rassolnik

