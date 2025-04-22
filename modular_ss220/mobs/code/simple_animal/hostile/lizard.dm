/mob/living/simple_animal/hostile/lizard
	name = "игуана"
	desc = "Грациозный предок космодраконов. Её взгляд не вызывает никаких враждебных подозрений... Но она по прежнему хочет съесть вас."
	icon = 'modular_ss220/mobs/icons/mob/animal.dmi'
	icon_state = "iguana"
	icon_living = "iguana"
	icon_dead = "iguana_dead"
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	speak_emote = list("growls", "roars")
	emote_hear = list("rawrs","grumbles","grawls")
	emote_see = list("stares ferociously", "stomps")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/food/monstermeat/lizardmeat = 3, /obj/item/stack/sheet/animalhide/lizard = 1)
	response_help  = "погладил"
	response_disarm = "аккуратно оттолкнул"
	response_harm   = "ударил"
	stop_automated_movement_when_pulled = 0
	speed = 2
	maxHealth = 40
	health = 40
	blood_volume = BLOOD_VOLUME_NORMAL
	obj_damage = 60
	melee_damage_lower = 20
	melee_damage_upper = 30
	attacktext = "терзает"
	attack_sound = 'sound/weapons/bite.ogg'
	death_sound = 'modular_ss220/mobs/sound/creatures/lizard_death_big.ogg'
	talk_sound = list('modular_ss220/mobs/sound/creatures/lizard_angry1.ogg', 'modular_ss220/mobs/sound/creatures/lizard_angry2.ogg', 'modular_ss220/mobs/sound/creatures/lizard_angry3.ogg')
	damaged_sound = list('modular_ss220/mobs/sound/creatures/lizard_damaged.ogg')
	footstep_type = FOOTSTEP_MOB_CLAW

	minbodytemp = 250 //Weak to cold
	maxbodytemp = T0C + 200

	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/simple_animal/hostile/lizard/gator
	name = "аллигатор"
	desc = "Величавый аллигатор, так и норовящийся оторвать от вас самый лакомый кусочек. Или кусок. Не путать с крокодилом!"
	icon_state = "gator"
	icon_living = "gator"
	icon_dead = "gator_dead"
	butcher_results = list(/obj/item/food/monstermeat/lizardmeat = 7, /obj/item/stack/sheet/animalhide/lizard = 5)
	speed = 4
	maxHealth = 200
	health = 200
	obj_damage = 80
	melee_damage_lower = 30
	melee_damage_upper = 80

/mob/living/simple_animal/hostile/lizard/croco
	name = "крокодил"
	desc = "Не стоит сувать голову ему в пасть! Это негативно сказывается на умственных способностях"
	icon_state = "steppy"
	icon_living = "steppy"
	icon_dead = "steppy_dead"
	butcher_results = list(/obj/item/food/monstermeat/lizardmeat = 5, /obj/item/stack/sheet/animalhide/lizard = 3)
	maxHealth = 100
	health = 100
	obj_damage = 80
	melee_damage_lower = 20
	melee_damage_upper = 50







