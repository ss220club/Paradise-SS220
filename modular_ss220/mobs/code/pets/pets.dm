// Named pets
/mob/living/simple_animal/pet/cat/floppa
	name = "Большой Шлёпа"
	desc = "Он выглядит так, будто собирается совершить военное преступление."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "floppa"
	icon_living = "floppa"
	icon_dead = "floppa_dead"
	icon_resting = "floppa_rest"
	tts_seed = "Uther"
	unique_pet = TRUE

/mob/living/simple_animal/pet/cat/fat/iriska
	name = "Ириска"
	desc = "Упитана. Счастлива. Бюрократы её обожают. И похоже даже черезчур сильно."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/pet/cat/white/penny
	name = "Копейка"
	desc = "Любит таскать монетки и мелкие предметы. Успевайте прятать их!"
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
	resting = TRUE

/mob/living/simple_animal/pet/cat/birman/crusher
	name = "Бедокур"
	desc = "Любит крушить всё что не прикручено. Нужно вовремя прибираться."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
	resting = TRUE

/mob/living/simple_animal/pet/dog/bullterrier/genn
	name = "Геннадий"
	desc = "Собачий аристократ. Выглядит очень важным и начитанным. Доброжелательный любимец ассистентов."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
	maxHealth = 5
	health = 5
	resting = TRUE

/mob/living/simple_animal/pet/dog/fox/alisa
	name = "Алиса"
	desc = "Алиса, любимый питомец любого Офицера Специальных Операций. Интересно, что она говорит?"
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "alisa"
	icon_living = "alisa"
	icon_dead = "alisa_dead"
	icon_resting = "alisa_rest"
	faction = list("nanotrasen")
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	melee_damage_lower = 10
	melee_damage_upper = 20

/mob/living/simple_animal/pet/dog/fox/fennec/fenya
	name = "Феня"
	desc = "Миниатюрная лисичка c важным видом и очень большими ушами. Был пойман во время разливания огромного мороженого по формочкам и теперь Магистрат держит его при себе и следит за ним. Но похоже что ему даже нравится быть частью правосудия."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	resting = TRUE
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/pet/dog/brittany/psycho
	name = "Перрито"
	real_name = "Перрито"
	desc = "Собака, обожающая котов, особенно в сапогах, прекрасно лающая на Испанском, прошла терапевтические курсы, готова выслушать все ваши проблемы и выдать вам целебных объятий с завершением в виде почесыванием животика."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	resting = TRUE
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/pet/dog/pug/frank
	name = "Фрэнк"
	real_name = "Фрэнк"
	desc = "Мопс полученный в результате эксперимента ученых в черном. Почему его не забрали интересный вопрос. Похоже он всем надоел своей болтовней, после чего его лишили дара речи."
	resting = TRUE
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/pet/sloth/paperwork
	name = "Пэйперворк"
	desc = "Любимец Карго - ленивец. Примерно так же полезен, как и остальные каргонцы."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "cool_sloth"
	icon_living = "cool_sloth"
	icon_dead = "cool_sloth_dead"
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN

// Pets
/mob/living/simple_animal/pet/cat/fat
	name = "fat cat"
	desc = "Упитана. Счастлива."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "iriska"
	icon_living = "iriska"
	icon_dead = "iriska_dead"
	icon_resting = "iriska"
	gender = FEMALE
	mob_size = MOB_SIZE_LARGE // THICK!!!
	//canmove = FALSE
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat = 8)
	tts_seed = "Huntress"
	maxHealth = 40 // Sooooo faaaat...
	health = 40
	speed = 10 // TOO FAT
	wander = 0 // LAZY
	can_hide = 0
	resting = TRUE
	holder_type = /obj/item/holder/fatcat

/mob/living/simple_animal/pet/cat/fat/handle_automated_action()
	return

/mob/living/simple_animal/pet/cat/white
	name = "white"
	desc = "Белоснежная шерстка. Плохо различается на белой плитке, зато отлично виден в темноте!"
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "penny"
	icon_living = "penny"
	icon_dead = "penny_dead"
	icon_resting = "penny_rest"
	gender = MALE
	holder_type = /obj/item/holder/cak

/mob/living/simple_animal/pet/cat/birman
	name = "birman"
	real_name = "birman"
	desc = "Священная порода Бирма."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "crusher"
	icon_living = "crusher"
	icon_dead = "crusher_dead"
	icon_resting = "crusher_rest"
	gender = MALE
	holder_type = /obj/item/holder/crusher

/mob/living/simple_animal/pet/dog/bullterrier
	name = "bullterrier"
	real_name = "bullterrier"
	desc = "Кого-то его мордочка напоминает..."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "bullterrier"
	icon_living = "bullterrier"
	icon_dead = "bullterrier_dead"
	holder_type = /obj/item/holder/bullterrier

/mob/living/simple_animal/pet/dog/tamaskan
	name = "tamaskan"
	real_name = "tamaskan"
	desc = "Хорошая семейная собака. Уживается с другими собаками и ассистентами."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "tamaskan"
	icon_living = "tamaskan"
	icon_dead = "tamaskan_dead"
	holder_type = /obj/item/holder/bullterrier

/mob/living/simple_animal/pet/dog/german
	name = "german"
	real_name = "german"
	desc = "Немецкая овчарка с помесью двортерьера. Судя по крупу - явно не породистый."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "german"
	icon_living = "german"
	icon_dead = "german_dead"

/mob/living/simple_animal/pet/dog/brittany
	name = "brittany"
	real_name = "brittany"
	desc = "Старая порода, которую любят аристократы."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "brittany"
	icon_living = "brittany"
	icon_dead = "brittany_dead"

/mob/living/simple_animal/pet/dog/fox/fennec
	name = "fennec"
	real_name = "fennec"
	desc = "Миниатюрная лисичка с очень большими ушами. Фенек, фенек, зачем тебе такие большие уши? Чтобы избегать дормитория?"
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "fennec"
	icon_living = "fennec"
	icon_dead = "fennec_dead"
	icon_resting = "fennec_rest"
	see_in_dark = 10
	holder_type = /obj/item/holder/fennec

/mob/living/simple_animal/pet/dog/fox/forest
	name = "forest fox"
	real_name = "forest fox"
	desc = "Лесная дикая лисица. Может укусить."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "fox_forest"
	icon_living = "fox_forest"
	icon_dead = "fox_forest_dead"
	icon_resting = "fox_forest_rest"
	melee_damage_type = BRUTE
	melee_damage_lower = 6
	melee_damage_upper = 12

// Holders
/obj/item/holder/fatcat
	name = "pet"
	desc = "It's a pet"
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "iriska"
	slot_flags = null

/obj/item/holder/cak
	name = "pet"
	desc = "It's a pet"
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "cak"
	origin_tech = "biotech=5"

/obj/item/holder/crusher
	name = "pet"
	desc = "It's a pet"
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "crusher"

/obj/item/holder/bullterrier
	name = "pet"
	desc = "It's a pet"
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "bullterrier"
	slot_flags = null

/obj/item/holder/fennec
	name = "pet"
	desc = "It's a pet"
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "fennec"
	origin_tech = "biotech=4"
