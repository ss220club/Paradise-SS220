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
	desc = "Жирный кролик в зимней шубке. Самое то для перекуса, правда, догнать тяжело..."
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

/mob/living/simple_animal/hostile/prey/proc/start_biomorphing()
	visible_message("<span class='danger'>[src] падает замертво и начинает неестественно расширяться! О БОЖЕ!</span>")
	death(FALSE)
	do_jitter_animation(1000, -1)
	playsound(loc, "bonebreak", 75, TRUE)
	playsound(loc, 'sound/machines/hiss.ogg', 75, TRUE)
	addtimer(CALLBACK(src, PROC_REF(end_biomorphing)), 5 SECONDS)
	var/matrix/M = transform
	M.Scale(1.8, 1.2)
	animate(src, time = 5 SECONDS, transform = M, easing = SINE_EASING)

/mob/living/simple_animal/hostile/prey/proc/end_biomorphing()
	visible_message("<span class='danger'>Туша разрывается на куски и из неё появляется отвратительный ком плоти!</span>")
	playsound(loc, 'modular_ss220/lazarus/sound/biomorph_burst.ogg', 75, TRUE)
	gib()
	new /mob/living/simple_animal/hostile/flesh_biomorph/lesser/medium(loc)

/mob/living/simple_animal/hostile/prey/deer/infested
	desc = "Крупный лесной олень. Пугливый, но безвредный. Поверхность его тела неестественно колышется"
	vision_range = 4

/mob/living/simple_animal/hostile/prey/deer/infested/GiveTarget(new_target)
	target = new_target
	if(isnull(target))
		return
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.faction.Find("treacherous_flesh"))
		return
	start_biomorphing()

/mob/living/simple_animal/hostile/prey/bunny/infested
	desc = "Жирный кролик в зимней шубке. Самое то для перекуса, правда, догнать тяжело... Поверхность его тела неестественно колышется"
	vision_range = 4

/mob/living/simple_animal/hostile/prey/bunny/infested/GiveTarget(new_target)
	target = new_target
	if(isnull(target))
		return
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.faction.Find("treacherous_flesh"))
		return
	start_biomorphing()
