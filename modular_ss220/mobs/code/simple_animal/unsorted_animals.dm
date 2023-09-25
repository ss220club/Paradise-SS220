/mob/living/simple_animal/pig/sanya
	name = "Саня"
	desc = "Старый добрый хряк с сединой. Слегка подслеповат, но нюх и харизма по прежнему с ним. Чудом не пущен на мясо и дожил до почтенного возраста."
	icon = 'modular_ss220/mobs/icons/animals.dmi'
	icon_state = "pig_old"
	icon_living = "pig_old"
	icon_dead = "pig_old_dead"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/ham/old = 10)
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
	maxHealth = 80
	health = 80

/mob/living/simple_animal/cow/betsy
	name = "Бетси"
	desc = "Старая добрая старушка. Нескончаемый источник природного молока без ГМО. Ну почти без ГМО..."
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/chicken/wife
	name = "Галя"
	desc = "Почетная наседка. Жена Коммандора, следующая за ним в коммандировки по космическим станциям."
	icon_state = "chicken_white"
	icon_living = "chicken_white"
	icon_dead = "chicken_white_dead"
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
	maxHealth = 20
	health = 20

/mob/living/simple_animal/chicken/clucky
	name = "Коммандор Клакки"
	desc = "Его великая армия бесчисленна. Ко-ко-ко."
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
	maxHealth = 40 // Veteran
	health = 40

/mob/living/simple_animal/goose/scientist
	name = "Гуськор"
	desc = "Учёный Гусь. Везде учусь. Крайне умная птица. Обожает генетику. Надеемся это не бывший пропавший генетик..."
	icon = 'modular_ss220/mobs/icons/animals.dmi'
	icon_state = "goose_labcoat"
	icon_living = "goose_labcoat"
	icon_dead = "goose_labcoat_dead"
	icon_resting = "goose_labcoat_rest"
	attacktext = "умно щипает"
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
	maxHealth = 80
	health = 80
	resting = TRUE

/mob/living/simple_animal/lizard/axolotl
	name = "Аксолотль"
	desc = "Маленький милый аксолотль."
	icon = 'modular_ss220/mobs/icons/animals.dmi'
	icon_state = "axolotl"
	icon_living = "axolotl"
	icon_dead = "axolotl_dead"
	holder_type = /obj/item/holder/axolotl
