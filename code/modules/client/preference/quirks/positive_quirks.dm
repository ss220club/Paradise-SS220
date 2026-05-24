/datum/quirk/skittish
	name = "Skittish"
	desc = "Вы можете спрятаться в ящике лёжа или запрыгнуть в шкаф на бегу, если столкнётесь с ним."
	cost = 4
	trait_to_apply = TRAIT_SKITTISH

/datum/quirk/freerunner
	name = "Freerunner"
	desc = "Вы умеете перепрыгивать через препятствия."
	cost = 4
	trait_to_apply = TRAIT_FREERUNNER

/datum/quirk/crafty
	name = "Crafty"
	desc = "Вы можете создавать предметы в два раза быстрее."
	cost = 2
	trait_to_apply = TRAIT_CRAFTY

/datum/quirk/alcohol_tolerance/heavy_drinker
	name = "Heavy Drinker"
	desc = "Вы привыкли к воздействию алкоголя и пьянеете медленнее, чем другие."
	cost = 1
	alcohol_modifier = 0.7

/datum/quirk/meal_prepper
	name = "Meal Prepper"
	desc = "Вы заранее продумали свой рацион на день."
	cost = 1
	item_to_give = /obj/item/storage/box/papersack/prepped_meal

/datum/quirk/glutton
	name = "Glutton"
	desc = "Вы можете есть быстрее и не страдать от последствий избыточного веса. Несовместимо с расой КПБ."
	cost = 2
	trait_to_apply = TRAIT_GLUTTON
	species_flags = QUIRK_MACHINE_INCOMPATIBLE

/obj/item/storage/box/papersack/prepped_meal
	name = "packed meal"
	var/list/entree_options = list(
		/obj/item/food/sandwich,
		/obj/item/food/toastedsandwich,
		/obj/item/food/jellysandwich,
		/obj/item/food/grilledcheese,
		/obj/item/food/burger/cheese,
		/obj/item/food/blt,
		/obj/item/food/philly_cheesesteak,
		/obj/item/food/sliced/hawaiian_pizza,
		/obj/item/food/sliced/pepperoni_pizza,
		/obj/item/food/meatkebab,
		/obj/item/food/salmonsteak, // If anyone microwaves their leftover fish in the workplace it should be on sight
		/obj/item/food/shrimp_skewer,
		/obj/item/food/omelette,
	)
	var/list/snack_options = list(
		/obj/item/food/chips,
		/obj/item/food/sosjerky,
		/obj/item/food/pistachios,
		/obj/item/food/no_raisin,
		/obj/item/food/stroopwafel,
		/obj/item/food/candy/toffee,
		/obj/item/food/candy/chocolate_orange,
		/obj/item/food/sliced/mothmallow,
		/obj/item/food/sliced/apple_cake,
		/obj/item/food/sliced/banarnarbread,
	)
	var/list/drink_options = list(
		/obj/item/reagent_containers/drinks/h_chocolate,
		/obj/item/reagent_containers/drinks/tea,
		/obj/item/reagent_containers/drinks/cans/cola,
		/obj/item/reagent_containers/drinks/cans/space_mountain_wind,
		/obj/item/reagent_containers/drinks/cans/dr_gibb,
		/obj/item/reagent_containers/drinks/cans/space_up,
		/obj/item/reagent_containers/drinks/cans/iced_tea,
		/obj/item/reagent_containers/drinks/cans/starkist,
		/obj/item/reagent_containers/drinks/bottle/beer, // Don't tell your boss
		/obj/item/reagent_containers/drinks/carton/apple,
		/obj/item/reagent_containers/drinks/carton/banana,
		/obj/item/reagent_containers/drinks/carton/berry,
		/obj/item/reagent_containers/drinks/carton/carrot,
		/obj/item/reagent_containers/drinks/carton/grape,
		/obj/item/reagent_containers/drinks/carton/lemonade,
		/obj/item/reagent_containers/drinks/carton/orange,
		/obj/item/reagent_containers/drinks/carton/pineapple,
		/obj/item/reagent_containers/drinks/carton/plum,
		/obj/item/reagent_containers/drinks/carton/tomato,
		/obj/item/reagent_containers/drinks/carton/vegetable,
		/obj/item/reagent_containers/drinks/carton/watermelon,
	)

/obj/item/storage/box/papersack/prepped_meal/populate_contents()
	var/entree = pick(entree_options)
	var/snack = pick(snack_options)
	var/drink = pick(drink_options)
	new entree (src)
	new snack (src)
	new drink (src)

/datum/quirk/upgraded_lungs
	name = "Upgraded Cybernetic Lungs"
	desc  = "Ваши легкие заменены на продвинутые кибернетические."
	cost = 3
	species_flags = QUIRK_MACHINE_INCOMPATIBLE
	organ_to_give = /obj/item/organ/internal/lungs/cybernetic/upgraded

/datum/quirk/upgraded_lungs/give_organ(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	if(spawned != owner)
		return
	var/obj/item/organ/internal/lungs/cybernetic/new_lungs = new organ_to_give
	if(isvox(owner))
		new_lungs.configure_species("vox")
	if(isplasmaman(owner))
		new_lungs.configure_species("plasmamen")
	INVOKE_ASYNC(new_lungs, TYPE_PROC_REF(/obj/item/organ/internal, insert), owner, TRUE)

/datum/quirk/culinary_implant
	name = "IPC Culinary Implant"
	desc = "То ли вы, то ли ваш создатель хотели, чтобы вы выглядели более естественно, и установили вам искусственный рот и живот."
	cost = 2
	species_flags = QUIRK_ORGANIC_INCOMPATIBLE
	organ_to_give = /obj/item/organ/internal/cyberimp/chest/ipc_food

/datum/quirk/home_cook
	name = "Home Cook"
	desc = "У вас есть опыт работы на кухне, и вы можете проверить кухонную технику, чтобы убедиться, что из продуктов внутри получится полноценное блюдо. Шеф-повара уже умеют это делать."
	cost = 1
	trait_to_apply = TRAIT_KNOWS_COOKING_RECIPES

/datum/quirk/pet_owner
	name = "Animal Lover"
	desc = "Сегодня вы привели на работу одного из своих питомцев! Не забудьте дать ему ошейник."
	cost = 1
	item_to_give = /obj/item/petcollar
	var/list/possible_pets = list(/mob/living/simple_animal/pet/dog/corgi, /mob/living/simple_animal/pet/cat, /mob/living/simple_animal/pet/dog/pug,
							/mob/living/simple_animal/pet/dog/fox, /mob/living/basic/chick, /mob/living/basic/bunny, /mob/living/basic/turkey)

/datum/quirk/pet_owner/apply_quirk_effects()
	mob_to_spawn = pick(possible_pets)
	..()

/datum/quirk/cool
	name = "Cool"
	desc = "Вы можете сделать сальто с любого трамплина. Вы такой крутой!"
	cost = 1
	trait_to_apply = TRAIT_COOL

/datum/quirk/breathing_tube
	name = "Breathing Tube"
	desc  = "Вам вживили дыхательную трубку."
	cost = 2
	species_flags = QUIRK_MACHINE_INCOMPATIBLE
	organ_to_give = /obj/item/organ/internal/cyberimp/mouth/breathing_tube
