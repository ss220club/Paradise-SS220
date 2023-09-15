// Reagent Grinder
/obj/machinery/reagentgrinder/Initialize(mapload)
	. = ..()
	blend_items = list(/obj/item/reagent_containers/food/snacks/grown/buckwheat = list("buckwheat" = -5)) + blend_items

// Vending
/obj/machinery/economy/vending/dinnerware/Initialize(mapload)
	products += list(
		/obj/item/reagent_containers/food/condiment/herbs = 2,)
	. = ..()

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

// Doner
/obj/item/reagent_containers/food/snacks/shawarma
	name = "шаурма"
	desc = "Великолепное сочетание мяса с гриля и свежих овощей. Не спрашивайте о мясе."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "shawarma"
	filling_color = "#c0720c"
	list_reagents = list("protein" = 4, "nutriment" = 4, "vitamin" = 2, "tomatojuice" = 4)
	tastes = list("счастье" = 3, "мясо" = 2, "овощи" = 1)

/datum/recipe/microwave/shawarma
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/grown/cabbage,
		/obj/item/reagent_containers/food/snacks/onion_slice,
		/obj/item/reagent_containers/food/snacks/grown/tomato,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/shawarma

// Doner - Cheese
/obj/item/reagent_containers/food/snacks/doner_cheese
	name = "сырная шаурма"
	desc = "Фирменное блюдо от шеф-повара - мясо с гриля и свежие овощи с теплым сырным соусом. Вкусно!"
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "doner_cheese"
	filling_color = "#c0720c"
	list_reagents = list("protein" = 4, "nutriment" = 6, "vitamin" = 2, "tomatojuice" = 4)
	tastes = list("счастье" = 3, "сыр" = 2, "мясо" = 2, "овощи" = 1)

/datum/recipe/microwave/doner_cheese
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/grown/cabbage,
		/obj/item/reagent_containers/food/snacks/grown/tomato,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/doner_cheese

// Doner - Mushroom
/obj/item/reagent_containers/food/snacks/doner_mushroom
	name = "шаурма с грибами"
	desc = "Мясо с гриля, свежие овощи и грибы. Грибы немного вытеснили мясо, но всё так же вкусно!"
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "doner_mushroom"
	filling_color = "#c0720c"
	list_reagents = list("protein" = 4, "nutriment" = 4, "plantmatter" = 2, "vitamin" = 2, "tomatojuice" = 4)
	tastes = list("счастье" = 3, "мясо" = 2, "овощи" = 2, "томат" = 1)

/datum/recipe/microwave/doner_mushroom
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/grown/mushroom,
		/obj/item/reagent_containers/food/snacks/grown/mushroom,
		/obj/item/reagent_containers/food/snacks/grown/mushroom,
		/obj/item/reagent_containers/food/snacks/grown/cabbage,
		/obj/item/reagent_containers/food/snacks/onion_slice,
		/obj/item/reagent_containers/food/snacks/grown/tomato,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/doner_mushroom

// Doner - Vegetable
/obj/item/reagent_containers/food/snacks/doner_vegan
	name = "овощная шаурма"
	desc = "Свежие овощи, завернутые в длинный рулет. Мясо в комплект не входит!"
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "doner_vegan"
	filling_color = "#c0720c"
	list_reagents = list("nutriment" = 4, "plantmatter" = 4, "vitamin" = 4, "tomatojuice" = 8)
	tastes = list("овощи" = 2, "томат" = 1, "перец" = 1)

/datum/recipe/microwave/doner_vegan
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/grown/cabbage,
		/obj/item/reagent_containers/food/snacks/onion_slice,
		/obj/item/reagent_containers/food/snacks/onion_slice,
		/obj/item/reagent_containers/food/snacks/grown/tomato,
		/obj/item/reagent_containers/food/snacks/grown/tomato,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/doner_vegan

// Slime Pie
/obj/item/reagent_containers/food/snacks/sliceable/slimepie
	name = "слаймовый пирог"
	desc = "Блюрп блоб блуп блеп блоп. Можно нарезать."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "slimepie"
	slice_path = /obj/item/reagent_containers/food/snacks/slimepieslice
	slices_num = 5
	bitesize = 3
	filling_color = "#00d9ff"
	list_reagents = list("nutriment" = 20, "vitamin" = 5)
	tastes = list("slime" = 5, "sweetness" = 1, "jelly" = 1)

/obj/item/reagent_containers/food/snacks/slimepieslice
	name = "кусочек слаймового пирога"
	desc = "Блюрп блоб блуп блеп блоп."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "slimepieslice"
	trash = /obj/item/trash/plate
	filling_color = "#00d9ff"
	tastes = list("slime" = 5, "sweetness" = 1, "jelly" = 1)

/datum/recipe/oven/slimepie
	reagents = list("custard" = 1, "milk" = 5, "sugar" = 15)
	items = list(/obj/item/organ/internal/heart/slime)
	result = /obj/item/reagent_containers/food/snacks/sliceable/slimepie

// Kidan Ragu
/obj/item/reagent_containers/food/snacks/kidanragu
	name = "острое хитиновое рагу"
	desc = "Рагу из очень жесткого хитинового мяса и тушеных овощей."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "kidanragu"
	list_reagents = list("nutriment" = 8, "vitamin" = 4, "protein" = 4)
	tastes = list("insect" = 3, "vegetable" = 2)

/datum/recipe/microwave/kidan_ragu
	reagents = list("water" = 10, "sodiumchloride" = 1)
	items = list(
		/obj/item/organ/internal/heart/kidan,
		/obj/item/reagent_containers/food/snacks/grown/potato,
		/obj/item/reagent_containers/food/snacks/grown/potato,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/grown/tomato,
		/obj/item/reagent_containers/food/snacks/grown/chili)
	result = /obj/item/reagent_containers/food/snacks/kidanragu

// Fried Unathi Meat
/obj/item/reagent_containers/food/snacks/sliceable/lizard
	name = "жареное мясо унатха"
	desc = "Сочный стейк из мяса крупной ящерицы, вызывающий желание полежать на теплых камнях. Можно нарезать."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "lizard_steak"
	slice_path = /obj/item/reagent_containers/food/snacks/lizardslice
	slices_num = 5
	list_reagents = list("protein" = 20, "nutriment" = 10, "vitamin" = 5)
	tastes = list("мясо ящерицы" = 4, "курятина" = 2)

/obj/item/reagent_containers/food/snacks/lizardslice
	name = "стейк из унатха"
	desc = "Порция мяса унатхи."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "lizard_slice"
	trash = /obj/item/trash/plate
	filling_color = "#a55f3a"
	tastes = list("мясо ящерицы" = 2, "курятина" = 1)

/datum/deepfryer_special/unathi
	input = /obj/item/organ/external
	output = /obj/item/reagent_containers/food/snacks/sliceable/lizard

/datum/deepfryer_special/unathi/validate(obj/item/I)
	if(!..())
		return FALSE
	var/obj/item/organ/external/E = I
	return istype(E.dna.species, /datum/species/unathi)

// Tajaroni
/obj/item/reagent_containers/food/snacks/tajaroni
	name = "таярони"
	desc = "Острая вяленая колбаса с перцем и... Оно только что мяукнуло?"
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "tajaroni"
	list_reagents = list("nutriment" = 4, "vitamin" = 2, "protein" = 2)
	tastes = list("сухое мясо" = 3, "кошатина" = 2)

/datum/deepfryer_special/tajaroni
	input = /obj/item/organ/external
	output = /obj/item/reagent_containers/food/snacks/tajaroni

/datum/deepfryer_special/tajaroni/validate(obj/item/I)
	if(!..())
		return FALSE
	var/obj/item/organ/external/E = I
	return istype(E.dna.species, /datum/species/tajaran)

// Vulpixes
/obj/item/reagent_containers/food/snacks/vulpix
	name = "вульпиксы"
	desc = "Аппетитно выглядящие мясные шарики в тесте... Главное - не думать о том, из кого они сделаны!"
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "vulpix"
	list_reagents = list("nutriment" = 4, "vitamin" = 2, "protein" = 4)
	tastes = list("булка" = 2, "собачатина" = 3)

/datum/recipe/oven/vuplix
	reagents = list("blackpepper" = 1, "sodiumchloride" = 1, "herbsmix" = 1, "tsauce" = 1, "cream" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/organ/internal/liver/vulpkanin)
	result = /obj/item/reagent_containers/food/snacks/vulpix

// Cheese Vulpixes
/obj/item/reagent_containers/food/snacks/vulpix/cheese
	name = "сырные вульпыксы"
	desc = "Аппетитно выглядящие мясные шарики в тесте с начинкой из сыра... Главное - не думать о том, из кого они сделаны!"
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "vulpix_cheese"
	list_reagents = list("nutriment" = 4, "vitamin" = 2, "protein" = 4)
	tastes = list("булка" = 2, "собачатина" = 3, "сыр" = 2)

/datum/recipe/oven/vulpixcheese
	reagents = list("blackpepper" = 1, "sodiumchloride" = 1, "herbsmix" = 1, "csauce" = 1, "cream" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/organ/internal/liver/vulpkanin,
		/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/vulpix/cheese

// Bacon Vulpixes
/obj/item/reagent_containers/food/snacks/vulpix/bacon
	name = "вульпиксы с беконом"
	desc = "Аппетитно выглядящие мясные шарики в тесте с начинкой... Главное - не думать о том, из кого они сделаны!"
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "vulpix_bacon"
	list_reagents = list("nutriment" = 4, "vitamin" = 2, "protein" = 4)
	tastes = list("булка" = 2, "собачатина" = 3, "бекон" = 2, "грибы" = 2)

/datum/recipe/oven/vulpixbacon
	reagents = list("blackpepper" = 1, "sodiumchloride" = 1, "herbsmix" = 1, "msauce" = 1, "cream" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/organ/internal/liver/vulpkanin,
		/obj/item/reagent_containers/food/snacks/raw_bacon,
		/obj/item/reagent_containers/food/snacks/grown/mushroom)
	result = /obj/item/reagent_containers/food/snacks/vulpix/bacon

// Chilli Vulpixes
/obj/item/reagent_containers/food/snacks/vulpix/chilli
	name = "вульпиксы-чилли"
	desc = "Аппетитно выглядящие мясные шарики в тесте... Главное - не думать о том, из кого они сделаны! Язык обжигает."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "vulpix_chillie"
	list_reagents = list("nutriment" = 4, "vitamin" = 2, "protein" = 4)
	tastes = list("булка" = 2, "собачатина" = 3, "чилли" = 2)

/datum/recipe/oven/vulpixchilli
	reagents = list("blackpepper" = 1, "sodiumchloride" = 1, "herbsmix" = 1, "dsauce" = 1, "cream" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/organ/internal/liver/vulpkanin,
		/obj/item/reagent_containers/food/snacks/grown/chili)
	result = /obj/item/reagent_containers/food/snacks/vulpix/chilli

// Seafood Pizza
/obj/item/reagent_containers/food/snacks/sliceable/pizza/seafood
	name = "пицца с морепродуктами"
	desc = "Дары космических озер, сыр и немного кислинки."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "fishpizza"
	slice_path = /obj/item/reagent_containers/food/snacks/seapizzaslice
	list_reagents = list("nutriment" = 30, "vitamin" = 15, "protein" = 15)
	filling_color = "#ffe45d"
	tastes = list("crust" = 1, "garlic" = 1, "cheese" = 2, "seafood" = 1, "sourness" = 1)

/obj/item/reagent_containers/food/snacks/seapizzaslice
	name = "кусочек пиццы с морепродуктами"
	desc = "Аппетитный кусочек пиццы с морепродуктами и сыром..."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "fishpizzaslice"
	filling_color = "#ffe45d"
	tastes = list("crust" = 1, "garlic" = 1, "cheese" = 2, "seafood" = 1, "sourness" = 1)

/datum/recipe/oven/seapizza
	reagents = list("herbs" = 1, "garlic_sauce" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/salmonmeat,
		/obj/item/reagent_containers/food/snacks/salmonmeat,
		/obj/item/reagent_containers/food/snacks/boiled_shrimp,
		/obj/item/reagent_containers/food/snacks/grown/citrus/lemon)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/seafood

// Bacon Pizza
/obj/item/reagent_containers/food/snacks/sliceable/pizza/bacon
	name = "пицца с беконом"
	desc = "Классическая пицца, один из ингредиентов которой был заменен на жареный бекон."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "baconpizza"
	slice_path = /obj/item/reagent_containers/food/snacks/baconpizzaslice
	list_reagents = list("nutriment" = 40, "vitamin" = 5, "protein" = 15)
	filling_color = "#ffe45d"
	tastes = list("crust" = 1, "mushroom" = 1, "cheese" = 2, "bacon" = 1)

/obj/item/reagent_containers/food/snacks/baconpizzaslice
	name = "кусочек пиццы с беконом"
	desc = "Аппетитный кусок пиццы с беконом и грибами..."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "baconpizzaslice"
	filling_color = "#ffe45d"
	tastes = list("crust" = 1, "mushroom" = 1, "cheese" = 2, "bacon" = 1)

/datum/recipe/oven/baconpizza
	reagents = list("mushroom_sauce" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/grown/mushroom,
		/obj/item/reagent_containers/food/snacks/grown/mushroom,
		/obj/item/reagent_containers/food/snacks/raw_bacon,
		/obj/item/reagent_containers/food/snacks/raw_bacon)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/bacon

// Pizza Tajaroni
/obj/item/reagent_containers/food/snacks/sliceable/pizza/tajaroni
	name = "пицца с таярони"
	desc = "Острые колбаски таярони с сыром и оливками. Что из этого ужаснее, еще предстоит решить."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "tajarpizza"
	slice_path = /obj/item/reagent_containers/food/snacks/tajpizzaslice
	list_reagents = list("nutriment" = 30, "vitamin" = 15, "protein" = 15)
	filling_color = "#ffe45d"
	tastes = list("crust" = 1, "tomato" = 1, "cheese" = 2, "tajaroni" = 1, "olives" = 1)

/obj/item/reagent_containers/food/snacks/tajpizzaslice
	name = "кусочек пиццы с таярони"
	desc = "Вкуснейший кусок пиццы с таярони и оливками..."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "tajarpizzaslice"
	filling_color = "#ffe45d"
	tastes = list("crust" = 1, "tomato" = 1, "cheese" = 2, "tajaroni" = 1, "olives" = 1)

/datum/recipe/oven/tajarpizza
	reagents = list("herbs" = 1, "tomato_sauce" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/tajaroni,
		/obj/item/reagent_containers/food/snacks/grown/olive,)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/tajaroni

// Diablo Pizza
/obj/item/reagent_containers/food/snacks/sliceable/pizza/diablo
	name = "пицца 'Диабло'"
	desc = "Невероятно жгучая пицца с кусочками мяса, некоторые утверждают, что она может отправить вас в рэдспейс."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "diablopizza"
	slice_path = /obj/item/reagent_containers/food/snacks/diablopizzaslice
	list_reagents = list("nutriment" = 30, "vitamin" = 15, "protein" = 15, "capsaicin" = 15)
	filling_color = "#ffe45d"
	tastes = list("crust" = 1, "hotness" = 1, "cheese" = 2, "meat" = 1, "spice" = 1)

/obj/item/reagent_containers/food/snacks/diablopizzaslice
	name = "кусочек пиццы 'Диабло'"
	desc = "Аппетитный кусок пиццы с соусом 'Диабло' и мясом..."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "diablopizzaslice"
	filling_color = "#ffe45d"
	tastes = list("crust" = 1, "hotness" = 1, "cheese" = 2, "meat" = 1, "spice" = 1)

/datum/recipe/oven/diablopizza
	reagents = list("herbs" = 1, "diablo_sauce" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/grown/tomato,
		/obj/item/reagent_containers/food/snacks/grown/chili,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/diablo
