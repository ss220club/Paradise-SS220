/mob/living/simple_animal/hostile/flesh_biomorph
	faction = list("treacherous_flesh")
	icon = 'modular_ss220/lazarus/icons/treacherous_flesh.dmi'

/mob/living/simple_animal/hostile/flesh_biomorph/Initialize(mapload)
	. = ..()
	var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_TREACHEOUS_FLESH]
	hud.add_hud_to(src)

/mob/living/simple_animal/hostile/flesh_biomorph/lesser
	mob_biotypes = MOB_ORGANIC
	speak_emote = list("кряхтит")
	emote_hear = list("кряхтит")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 8
	response_help = "гладит"
	response_disarm = "нежно толкает"
	response_harm = "бьёт"
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	attacktext = "кусает"
	attack_sound = 'sound/weapons/bite.ogg'
	pressure_resistance = 200

	/// Type that will be spawner after death. If null, spawns nothing
	var/split_to

/mob/living/simple_animal/hostile/flesh_biomorph/lesser/death(gibbed)
	if(!gibbed)
		if(!isnull(split_to))
			var/amount = rand(2, 3)
			var/mob/living/simple_animal/hostile/flesh_biomorph/morph
			for(var/i = 0, i < amount, i++)
				morph = new split_to(loc)
			if(client)
				morph.client = client
		gib()
	return ..(TRUE)

/mob/living/simple_animal/hostile/flesh_biomorph/lesser/small
	name = "Маленький биоморф"
	desc = "Искривлённая конечность, из которой торчит множество щупалец и усиков. Они неестественно извиваются, будто пытаясь ухватиться за что-то поблизости."
	maxHealth = 30
	health = 30
	obj_damage = 15
	melee_damage_lower = 5
	melee_damage_upper = 10
	icon_state = "small"
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	density = FALSE
	mob_size = MOB_SIZE_TINY

/mob/living/simple_animal/hostile/flesh_biomorph/lesser/medium
	name = "Средний биоморф"
	desc = "Кусок плоти с кучей щупалец и усиков. Они неестественно извиваются, будто пытаясь ухватиться за что-то поблизости."
	maxHealth = 80
	health = 80
	obj_damage = 50
	melee_damage_lower = 15
	melee_damage_upper = 20
	icon_state = "medium"
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE
	density = FALSE
	mob_size = MOB_SIZE_SMALL
	split_to = /mob/living/simple_animal/hostile/flesh_biomorph/lesser/small

/mob/living/simple_animal/hostile/flesh_biomorph/lesser/large
	name = "Крупный биоморф"
	desc = "Настоящая гора плоти с кучей щупалец и усиков. Они неестественно извиваются, будто пытаясь ухватиться за что-то поблизости."
	maxHealth = 150
	health = 150
	obj_damage = 70
	melee_damage_lower = 30
	melee_damage_upper = 35
	icon_state = "large"
	mob_size = MOB_SIZE_HUMAN
	split_to = /mob/living/simple_animal/hostile/flesh_biomorph/lesser/medium
