/mob/living/simple_animal/hostile/flesh_biomorph
	faction = list("treacherous_flesh")
	a_intent = INTENT_HARM
	var/weeds_heal_amount = 5
	var/code_name

/mob/living/simple_animal/hostile/flesh_biomorph/Initialize(mapload)
	. = ..()
	var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_TREACHEOUS_FLESH]
	hud.add_hud_to(src)

	code_name = "[pick("Альфа", "Бэта", "Гамма", "Сигма", "Дельта", "Эпсилон", "Дзета", "Йота", "Пси", "Омега")]-[rand(100, 999)]"
	real_name = "[name] ([code_name])"
	name = real_name
	add_language("Разум Улья Биоморфов")
	default_language = GLOB.all_languages["Разум Улья Биоморфов"]

/mob/living/simple_animal/hostile/flesh_biomorph/add_tts_component()
	AddComponent(/datum/component/tts_component, /datum/tts_seed/silero/anubarak)

/mob/living/simple_animal/hostile/flesh_biomorph/Life(seconds, times_fired)
	. = ..()
	if(locate(/obj/structure/alien/weeds/meaty) in loc)
		if(health < maxHealth && weeds_heal_amount)
			heal_organ_damage(weeds_heal_amount / 2, weeds_heal_amount / 2)

/mob/living/simple_animal/hostile/flesh_biomorph/lesser
	mob_biotypes = MOB_ORGANIC
	speak_emote = list("кряхтит")
	emote_hear = list("кряхтит")
	icon = 'modular_ss220/lazarus/icons/treacherous_flesh.dmi'
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 8
	response_help = "гладит"
	response_disarm = "толкает"
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
				morph.code_name = code_name
				morph.real_name = "[initial(name)] ([morph.code_name])"
				morph.name = morph.real_name
		gib()
	return ..(TRUE)

/mob/living/simple_animal/hostile/flesh_biomorph/lesser/small
	name = "Маленький биоморф"
	desc = "Искривлённая конечность, из которой торчит множество щупалец и усиков. Они неестественно извиваются, будто пытаясь ухватиться за что-то поблизости."
	maxHealth = 25
	health = 25
	obj_damage = 10
	melee_damage_lower = 5
	melee_damage_upper = 10
	icon_state = "small"
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB | PASSFLORA
	density = FALSE
	mob_size = MOB_SIZE_TINY
	universal_speak = FALSE
	can_hide = TRUE
	pass_door_while_hidden = TRUE
	weeds_heal_amount = 3

/mob/living/simple_animal/hostile/flesh_biomorph/lesser/medium
	name = "Средний биоморф"
	desc = "Кусок плоти с кучей щупалец и усиков. Они неестественно извиваются, будто пытаясь ухватиться за что-то поблизости."
	maxHealth = 60
	health = 60
	obj_damage = 30
	melee_damage_lower = 10
	melee_damage_upper = 15
	icon_state = "medium"
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE | PASSFLORA
	density = FALSE
	mob_size = MOB_SIZE_SMALL
	split_to = /mob/living/simple_animal/hostile/flesh_biomorph/lesser/small
	weeds_heal_amount = 5

/mob/living/simple_animal/hostile/flesh_biomorph/lesser/medium/Initialize(mapload)
	. = ..()
	var/datum/spell/biomorph/plant_weeds/plant_weeds = new
	AddSpell(plant_weeds)

/mob/living/simple_animal/hostile/flesh_biomorph/lesser/large
	name = "Крупный биоморф"
	desc = "Настоящая гора плоти с кучей щупалец и усиков. Они неестественно извиваются, будто пытаясь ухватиться за что-то поблизости."
	maxHealth = 100
	health = 100
	obj_damage = 50
	melee_damage_lower = 25
	melee_damage_upper = 30
	icon_state = "large"
	mob_size = MOB_SIZE_HUMAN
	split_to = /mob/living/simple_animal/hostile/flesh_biomorph/lesser/medium
	weeds_heal_amount = 8

/mob/living/simple_animal/hostile/flesh_biomorph/lesser/large/Initialize(mapload)
	. = ..()
	var/datum/spell/biomorph/build_structure/build_structure = new
	AddSpell(build_structure)
	var/datum/spell/biomorph/plant_weeds/plant_weeds = new
	AddSpell(plant_weeds)


/datum/spell/biomorph
	action_background_icon_state = "bg_flesh"
	action_icon = 'modular_ss220/lazarus/icons/lazarus_actions.dmi'
	action_background_icon = 'modular_ss220/lazarus/icons/lazarus_actions.dmi'
	clothes_req = FALSE
	human_req = FALSE

/datum/spell/biomorph/plant_weeds
	name = "Распространить плоть"
	desc = "Устанавливает узел плоти на землю для облегчения лечения."
	base_cooldown = 30 SECONDS
	var/atom/weed_type = /obj/structure/alien/weeds/node/meaty
	var/weed_name = "глазной отросток"
	action_icon_state = "weednode"
	var/requires_do_after = TRUE

/datum/spell/biomorph/plant_weeds/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/biomorph/plant_weeds/cast(list/targets, mob/living/carbon/user)
	var/turf/T = user.loc
	if(locate(weed_type) in T)
		to_chat(user, "<span class='noticealien'>There's already \a [weed_name] here.</span>")
		revert_cast()
		return

	if(isspaceturf(T))
		to_chat(user, "<span class='noticealien'>You cannot plant [weed_name]s in space.</span>")
		revert_cast()
		return

	if(!isturf(T))
		to_chat(user, "<span class='noticealien'>You cannot plant [weed_name]s inside something!</span>")
		revert_cast()
		return

	user.visible_message("<span class='warning'>Vines burst from the back of [user], securing themselves to the ground and swarming onto [user.loc].</span>", "<span class='warning'>You begin infesting [user.loc] with [initial(weed_type.name)].</span>")
	if(requires_do_after && !do_mob(user, user, 2 SECONDS))
		revert_cast()
		return

	user.visible_message("<span class='alertalien'>[user] has planted \a [weed_name]!</span>")
	new weed_type(T)

//MARK: Structure build

#define MEATY_WALL "meaty wall"
#define MEATY_DOOR "meaty door"

/datum/spell/biomorph/build_structure
	name = "Создать структуру"
	desc = "Позволяет создавать стены и двери из плоти."
	action_icon_state = "resin_wall-0"
	action_icon = 'modular_ss220/lazarus/icons/meaty_wall.dmi'
	base_cooldown = 10 SECONDS

/datum/spell/biomorph/build_structure/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/biomorph/build_structure/cast(list/targets, mob/user)
	var/static/list/structures = list(MEATY_WALL = image(icon = 'modular_ss220/lazarus/icons/meaty_wall.dmi', icon_state = "resin_wall-0"),
									MEATY_DOOR = image(icon = 'modular_ss220/lazarus/icons/meaty_door.dmi', icon_state = "resin"))
	var/choice = show_radial_menu(user, user, structures, src, radius = 40)
	var/turf/turf_to_spawn_at = user.loc
	if(!choice)
		revert_cast(user)
		return
	if(!do_mob(user, user, 3 SECONDS))
		revert_cast()
		return
	if(isspaceturf(turf_to_spawn_at))
		to_chat(user, "<span class='alertalien'>You cannot build the [choice] while in space!</span>")
		revert_cast(user)
		return
	var/obj/structure/alien/resin/resin_on_turf = locate() in turf_to_spawn_at
	if(resin_on_turf)
		to_chat(user, "<span class='danger'>There is already a meaty construction here.</span>")
		revert_cast(user)
		return
	user.visible_message("<span class='alertalien'>[user] vomits up a thick red substance and shapes it!</span>")
	switch(choice)
		if(MEATY_WALL)
			new /obj/structure/alien/resin/wall/meaty(turf_to_spawn_at)
		if(MEATY_DOOR)
			new /obj/structure/alien/resin/door/meaty(turf_to_spawn_at)

#undef MEATY_WALL
#undef MEATY_DOOR
