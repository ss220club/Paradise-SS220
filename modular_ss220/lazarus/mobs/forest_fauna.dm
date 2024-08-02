/mob/living/simple_animal/hostile/prey
	melee_damage_lower = 0
	melee_damage_upper = 0
	vision_range = 8
	retreat_distance = 12
	minimum_distance = 12

/mob/living/simple_animal/hostile/prey/deer
	name = "лесной олень"
	desc = "Крупный лесной олень. Пугливый, но безвредный."
	icon = 'icons/mob/winter_mob.dmi'
	icon_state = "reindeer"
	icon_living = "reindeer"
	icon_dead = "reindeer-dead"
	butcher_results = list(/obj/item/food/meat = 12, /obj/item/stack/sheet/leather = 10)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"
	move_to_delay = 4
	maxHealth = 50
	health = 50
	pass_flags = PASSFLORA
	mob_biotypes = MOB_ORGANIC | MOB_BEAST
	mob_size = MOB_SIZE_HUMAN
	environment_smash = ENVIRONMENT_SMASH_NONE


/mob/living/simple_animal/hostile/prey/bunny
	name = "кролик"
	desc = "Жирный кролик с зимней шубе. Самое то для перекуса, правда, догнать тяжело..."
	icon_state = "m_bunny"
	icon_living = "m_bunny"
	icon_dead = "bunny_dead"
	butcher_results = list(/obj/item/food/meat = 5, /obj/item/stack/sheet/leather = 3)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"
	move_to_delay = 2
	maxHealth = 20
	health = 20
	density = FALSE
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB | PASSFLORA
	mob_biotypes = MOB_ORGANIC | MOB_BEAST
	mob_size = MOB_SIZE_TINY
	environment_smash = ENVIRONMENT_SMASH_NONE

