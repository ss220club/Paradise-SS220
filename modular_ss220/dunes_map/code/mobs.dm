// Спавнеры депредов
/obj/structure/spawner/desert_depretarors
	name = "спавнер депредов"
	desc = "страшное описание."
	icon = 'icons/mob/nest.dmi'
	icon_state = "hole"

	faction = list("depredators")
	max_mobs = 2
	max_integrity = 300
	density = FALSE
	invisibility = 101
	mob_types = list(/mob/living/simple_animal/hostile/duna)

	spawn_time = 480 SECONDS

/obj/structure/spawner/desert_depretarors/range
	mob_types = list(/mob/living/simple_animal/hostile/duna/range)

/obj/structure/spawner/desert_depretarors/altar
	name = "пульсирующий маяк"
	desc = "Спиральный монолит из черного камня. В его высокотехнологичных вкраплениях, слово по жилам, протекает невиданная ранее энергия - продукт симбиоза блюспейса и редспейса. Кажется, он используется депредаторами как маяк навигации."
	icon = 'modular_ss220/dunes_map/icons/marker_normal.dmi'
	icon_state = "marker_depred"
	density = TRUE
	invisibility = 0
	spawn_time = 30 SECONDS
	layer = ABOVE_MOB_LAYER

	light_power = 2
	light_range = 3
	light_color = COLOR_VIOLET

/obj/structure/spawner/desert_depretarors/altar/range
	mob_types = list(/mob/living/simple_animal/hostile/duna/range)

// Снаряды депредов
/obj/item/projectile/beam/depredator
	name = "depredator beam"
	icon_state = "purple_laser"
	damage = 10

/obj/item/projectile/beam/depredator_laser
	name = "depredator laser"
	icon_state = "sniperlaser"
	damage = 9
	impact_effect_type = /obj/effect/temp_visual/impact_effect/purple_laser
	light_color = COLOR_PURPLE

/obj/effect/projectile/muzzle/depredator
	icon_state = "muzzle_hcult"

/obj/effect/projectile/tracer/depredator
	name = "depredator beam"
	icon_state = "hcult"

/obj/effect/projectile/impact/depredator
	name = "depredator impact"
	icon_state = "impact_hcult"

/obj/item/projectile/beam/depredator/hitscan
	color = LIGHT_COLOR_PURPLE
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/depredator
	tracer_type = /obj/effect/projectile/tracer/depredator
	impact_type = /obj/effect/projectile/impact/depredator
	impact_effect_type = null
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = LIGHT_COLOR_PURPLE
	muzzle_flash_intensity = 6
	muzzle_flash_range = 2
	muzzle_flash_color_override = LIGHT_COLOR_PURPLE
	impact_light_intensity = 7
	impact_light_range = 2.5
	impact_light_color_override = LIGHT_COLOR_PURPLE

// Депреды
/mob/living/simple_animal/hostile/duna
	var/list/alert_sounds
	var/alert_cooldown = 3 SECONDS
	var/alert_cooldown_time
	name = "депредатор"
	desc = "Высокое злобное существо, пришедшее из неизведанных глубин космоса. Тварь представляет из себя жуткое переплетение темно-фиолетовой плоти и бугристых пучков мышц. Они постоянно пульсируют, неустанно перегоняя под кожей бледные зеленоватые отсветы. Что бы это ни было - оно отвратительно."
	icon = 'modular_ss220/dunes_map/icons/mobs.dmi'
	icon_state = "osminogmeele"
	icon_living = "osminogmeele"
	icon_dead = "osminogmeele"
	maxbodytemp = INFINITY
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mob_size = MOB_SIZE_LARGE
	sentience_type = SENTIENCE_OTHER
	status_flags = CANPUSH
	del_on_death = TRUE
	dodging = TRUE
	unsuitable_atmos_damage = 0
	minbodytemp = 0
	maxbodytemp = 3500
	check_friendly_fire = TRUE
	a_intent = INTENT_HARM
	loot = list(/obj/effect/decal/cleanable/blood/gibs/xeno/down)
	faction = list("depredators")
	turns_per_move = 3
	move_to_delay = 2.8
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	maxHealth = 150
	health = 150
	see_in_dark = 8
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 20
	attacktext = "разрывает"
	attack_sound = 'modular_ss220/mobs/sound/creatures/zombie_attack.ogg'
	rapid_melee = 2
	footstep_type = FOOTSTEP_MOB_SHOE
	alert_cooldown = 10 SECONDS
	alert_sounds = list(
		'modular_ss220/dunes_map/sound/mobs/dep1.ogg',
		'modular_ss220/dunes_map/sound/mobs/dep2.ogg',
		'modular_ss220/dunes_map/sound/mobs/dep3.ogg',
		'modular_ss220/dunes_map/sound/mobs/dep4.ogg',
		'modular_ss220/dunes_map/sound/mobs/dep5.ogg',
		'modular_ss220/dunes_map/sound/mobs/dep6.ogg',
	)
	layer = 4.49

/mob/living/simple_animal/hostile/duna/Initialize(mapload)
	. = ..()
	add_language("Sol Common")
	default_language = GLOB.all_languages["Sol Common"]

	speed = pick(-1.2, -1, -0.5, 0, 0.5, 1, 1.5, 2, 2.5)

	var/list/meele_type= list("gold", "silver", "platinum")
	icon_state = "osminogmeele_[pick(meele_type)]"

	ADD_TRAIT(src, TRAIT_QUICKSAND_IMMUNE, "innate")

/mob/living/simple_animal/hostile/duna/Aggro()
	if(!alert_sounds)
		return
	if(world.time > alert_cooldown_time)
		playsound(src, pick(alert_sounds), 200, ignore_walls = FALSE)
		alert_cooldown_time = world.time + alert_cooldown

/mob/living/simple_animal/hostile/duna/add_tts_component()
	AddComponent(/datum/component/tts_component, /datum/tts_seed/silero/kazamon)


/mob/living/simple_animal/hostile/duna/range
	icon_state = "osminogrange_gold"
	var/list/range_type= list("gold", "silver", "platinum")
	projectiletype = /obj/item/projectile/beam/depredator/hitscan
	projectilesound = 'modular_ss220/aesthetics_sounds/sound/mobs/vortigaunt/attack_shoot4.ogg'
	ranged_cooldown_time = 2.5 SECONDS
	ranged = TRUE
	maxHealth = 120
	health = 120
	rapid = 2
	rapid_fire_delay = 1 SECONDS
	harm_intent_damage = 15
	melee_damage_lower = 10
	melee_damage_upper = 10
	retreat_distance = 8
	minimum_distance = 10
	aggro_vision_range = 10
	vision_range = 10

/mob/living/simple_animal/hostile/duna/range/Initialize(mapload)
	. = ..()

	var/list/range_type= list("gold", "silver", "platinum")
	icon_state = "osminogrange_[pick(range_type)]"

/mob/living/simple_animal/hostile/duna_tower
	name = "сторожевой маяк"
	desc = "Спиральный монолит из черного камня. В его высокотехнологичных вкраплениях, слово по жилам, протекает невиданная ранее энергия - продукт симбиоза блюспейса и редспейса. Кажется, он используется депредаторами как защитная установка."
	icon = 'modular_ss220/dunes_map/icons/marker_normal.dmi'
	icon_state = "marker_depred_range"
	icon_living = "marker_depred_range"
	icon_dead = "marker_depred_range"
	mob_biotypes = MOB_PLANT
	sentience_type = SENTIENCE_OTHER
	move_resist = INFINITY
	mob_size = MOB_SIZE_LARGE
	del_on_death = TRUE
	dodging = FALSE
	unsuitable_atmos_damage = 0
	minbodytemp = 0
	maxbodytemp = 3500
	check_friendly_fire = TRUE
	a_intent = INTENT_HARM
	faction = list("depredators")
	turns_per_move = 0
	move_to_delay = 2.8
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	maxHealth = 300
	health = 300
	see_in_dark = 8
	ranged_cooldown_time = 5 SECONDS
	ranged = TRUE
	rapid = 3
	rapid_fire_delay = 0.5 SECONDS
	harm_intent_damage = 0
	melee_damage_lower = 3
	melee_damage_upper = 5
	retreat_distance = 0
	minimum_distance = 20
	aggro_vision_range = 11
	vision_range = 15
	wander = FALSE
	stop_automated_movement = TRUE
	projectiletype = /obj/item/projectile/beam/depredator_laser
	projectilesound = 'sound/weapons/resonator_blast.ogg'
	anchored = TRUE

	light_power = 2
	light_range = 3
	light_color = COLOR_VIOLET

// Крокодил
/obj/structure/spawner/gator
	name = "спавнер аллигаторов"
	desc = "они умирают от бури."
	icon = 'icons/mob/nest.dmi'
	icon_state = "hole"

	faction = list("hostile")
	max_mobs = 1
	max_integrity = 300
	density = FALSE
	invisibility = 101
	mob_types = list(/mob/living/simple_animal/hostile/lizard/gator/desert)

	spawn_time = 120 SECONDS
/mob/living/simple_animal/hostile/lizard/gator/desert
	del_on_death = TRUE
	butcher_results = null
	maxbodytemp = INFINITY
	icon_state = "gator"
	icon_living = "gator"
	icon_dead = "gator_dead"

// ТАНЯ

/mob/living/simple_animal/hostile/retaliate/tanya_cc
	name = "Дельта 8-1-7"
	desc = "Боевой юнит-андроид проекта ''Delta 8-1-7'', идеально подходящий для выполнения любых поставленных задач. Судя по глазам, этот экземпляр находится на боевом дежурстве и действует автономно."
	icon =  'modular_ss220/dunes_map/icons/tanya_cc.dmi'
	icon_state = "tanya_cc"
	icon_living = "tanya_cc"
	icon_dead = "tanya_cc"
	faction = list("neutral")
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	sentience_type = SENTIENCE_OTHER
	turns_per_move = 3
	speed = -0.5
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	maxHealth = 150
	health = 150
	harm_intent_damage = 15
	melee_damage_lower = 20
	melee_damage_upper = 25
	minbodytemp = 0
	maxbodytemp = 3500
	a_intent = INTENT_HARM
	check_friendly_fire = 1
	status_flags = CANPUSH
	del_on_death = TRUE
	loot = list(/obj/effect/gibspawner/robot)
	dodging = TRUE
	rapid_melee = 2
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	footstep_type = FOOTSTEP_MOB_SHOE
	ranged = TRUE
	ranged_cooldown_time = 15
	rapid = 3
	retreat_distance = 8
	minimum_distance = 8
	casingtype = /obj/item/ammo_casing/a556
	projectilesound = 'sound/weapons/gunshots/gunshot_mg.ogg'
	wander = FALSE

/mob/living/simple_animal/hostile/retaliate/tanya_cc/Initialize(mapload)
	. = ..()
	add_language("Galactic Common")
	default_language = GLOB.all_languages["Galactic Common"]

/mob/living/simple_animal/hostile/retaliate/tanya_cc/add_tts_component()
	AddComponent(/datum/component/tts_component, /datum/tts_seed/silero/cerys)

/mob/living/simple_animal/hostile/retaliate/tanya_death   // Не от tanya_cc т.к. баллистические снаряды перезаписывают энергетические - разделить их никак нельзя
	name = "Дельта 8-1-7"
	desc = "Боевой юнит-андроид проекта ''Delta 8-1-7'', облаченный в тяжелую штурмовую броню. Судя по глазам, этот экземпляр находится на боевом дежурстве и действует автономно."
	icon =  'modular_ss220/dunes_map/icons/tanya_cc.dmi'
	icon_state = "tanya_cc_death"
	icon_living = "tanya_cc_death"
	icon_dead = "tanya_cc_death"
	faction = list("neutral")
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	sentience_type = SENTIENCE_OTHER
	turns_per_move = 3
	speed = -0.5
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	harm_intent_damage = 15
	melee_damage_lower = 20
	melee_damage_upper = 25
	minbodytemp = 0
	maxbodytemp = 3500
	a_intent = INTENT_HARM
	check_friendly_fire = 1
	status_flags = CANPUSH
	del_on_death = TRUE
	loot = list(/obj/effect/gibspawner/robot)
	dodging = TRUE
	rapid_melee = 2
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	footstep_type = FOOTSTEP_MOB_SHOE
	ranged = TRUE
	ranged_cooldown_time = 15
	rapid = 1
	wander = FALSE
	maxHealth = 300
	health = 300
	retreat_distance = 8
	minimum_distance = 8
	projectiletype = /obj/item/projectile/beam/pulse
	projectilesound = 'sound/weapons/emitter2.ogg'

/mob/living/simple_animal/hostile/retaliate/tanya_death/Initialize(mapload)
	. = ..()
	add_language("Galactic Common")
	default_language = GLOB.all_languages["Galactic Common"]

/mob/living/simple_animal/hostile/retaliate/tanya_death/add_tts_component()
	AddComponent(/datum/component/tts_component, /datum/tts_seed/silero/cerys)

// Скорпиончики

/mob/living/simple_animal/hostile/poison/giant_scorpio
	name = "гигантский скорпион"
	desc = "Огромная восьмилапая тварь, закованная в хитиновый панцырь. Этот выглядит особенно защищенным. Остерегайтесь его сильных клешней и смертоносного жала на хвосте!"
	icon = 'modular_ss220/dunes_map/icons/scorpio.dmi'
	icon_state = "yellow_scorpion"
	icon_living = "yellow_scorpion"
	icon_dead = "yellow_scorpion"
	mob_biotypes = MOB_ORGANIC | MOB_BUG
	speak_emote = list("chitters")
	emote_hear = list("chitters")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	footstep_type = FOOTSTEP_MOB_CLAW
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "hits"
	loot = list(/obj/effect/decal/cleanable/blood/gibs/xeno)
	maxHealth = 200
	health = 200
	obj_damage = 60
	melee_damage_lower = 15
	melee_damage_upper = 20
	minbodytemp = 0
	maxbodytemp = 600
	faction = list("scorpio")
	pass_flags = PASSTABLE
	move_to_delay = 6
	del_on_death = TRUE
	attacktext = "strikes"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	gold_core_spawnable = HOSTILE_SPAWN
	maxbodytemp = INFINITY
	var/venom_per_bite = 0

/mob/living/simple_animal/hostile/poison/giant_scorpio/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_QUICKSAND_IMMUNE, "innate")

/mob/living/simple_animal/hostile/poison/giant_scorpio/AttackingTarget()
	. = ..()
	if(. && venom_per_bite > 0 && iscarbon(target) && (!client || a_intent == INTENT_HARM))
		var/mob/living/carbon/C = target
		var/inject_target = pick("chest", "head")
		if(C.can_inject(null, FALSE, inject_target, FALSE))
			C.reagents.add_reagent("toxin", venom_per_bite)

/*
/mob/living/simple_animal/hostile/poison/giant_scorpio/AttackingTarget()
	. = ..()
	flick("scorpion_attack",src)
*/

/mob/living/simple_animal/hostile/poison/giant_scorpio/poison
	desc = "Огромная восьмилапая тварь, закованная в хитиновый панцырь. Этот кажется особенно ядовитым. Остерегайтесь его сильных клешней и смертоносного жала на хвосте!"
	icon_state = "scorpion"
	icon_living = "scorpion"
	icon_dead = "scorpion"
	maxHealth = 120
	health = 120
	maxbodytemp = 600
	venom_per_bite = 20
	melee_damage_lower = 10
	melee_damage_upper = 20
	move_to_delay = 5


/mob/living/simple_animal/hostile/poison_snake/scorpio_mini
	name = "скорпион"
	desc = "Небольшое проворливое членистоногое обитающие в засушливом климате. Для охоты и защиты использует жало с сильным нейропаралитическим ядом."
	icon = 'modular_ss220/dunes_map/icons/scorpio.dmi'
	icon_state = "y_scorpion_mini"
	icon_living = "y_scorpion_mini"
	icon_dead = "y_scorpion_mini"
	speak_emote = list("chitters")
	faction = list("scorpio")
	del_on_death = TRUE
	loot = list(/obj/effect/decal/cleanable/spiderling_remains)
	maxbodytemp = INFINITY

/mob/living/simple_animal/hostile/poison_snake/scorpio_mini/purpl
	icon_state = "scorpion_mini"
	icon_living = "scorpion_mini"
	icon_dead = "scorpion_mini"
/*
	- [+] абилка атаки вокруг босса
	- [+] абилка атаки в определенную область (возможно чардж)
	- [+] автонаводящийся снаряд
	- [+] спавн адов
	- [+] абилка как шёпот у ксеносов, но босс говорит на всю карту ттсом и реплика сопровождается ЗДОРОВЕННОЙ ФРАЗОЙ В ЧАТЕ вместе с криповым звуком.
	- [+] для боевых абилок желателен делей перед кастом, в идеале конечно визуал еще, но это уже влажные мечты
	- [+] сам бос милишный
	- [+] с регеном, если можно
	- [+] скорость низкая
	- [+] толкать его нельзя
*/

/mob/living/simple_animal/hostile/cthulhu
	// Visual
	name = "Старший"
	desc = "Мы обречены..."
	attack_sound = 'sound/misc/demon_attack1.ogg'
	icon = 'modular_ss220/dunes_map/icons/cthulhu.dmi'
	icon_state = "act"
	icon_living = "act"
	pixel_x = -140
	pixel_y = -120
	layer = ABOVE_ALL_MOB_LAYER
	wander = FALSE
	see_in_dark = 8

	// Balance
	move_force = MOVE_FORCE_OVERPOWERING
	move_resist = MOVE_FORCE_OVERPOWERING
	pull_force = MOVE_FORCE_OVERPOWERING
	mob_size = MOB_SIZE_LARGE
	speed = 2.5
	maxHealth = 3000
	health = 3000
	var/regeneration_per_second = 5
	melee_damage_lower = 30
	melee_damage_upper = 45
	a_intent = INTENT_HARM
	sentience_type = SENTIENCE_BOSS
	faction = list("depredators")
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	flying = TRUE
	minbodytemp = 0
	maxbodytemp = INFINITY
	var/should_die = FALSE

	var/list/datum/spell/spells = list(
								/datum/spell/fireball/homing/cthulhu,
								/datum/spell/leap/cthulhu,
								/datum/spell/global_annouce,
								/datum/spell/aoe/conjure/duna,
								/datum/spell/pulse_circle,
								/datum/spell/meterorite_rain
								)

/mob/living/simple_animal/hostile/cthulhu/Initialize(mapload)
	. = ..()
	for(var/datum/spell/path as anything in spells)
		var/datum/spell/spell = new path()
		AddSpell(spell)

/mob/living/simple_animal/hostile/cthulhu/add_tts_component()
	AddComponent(/datum/component/tts_component, /datum/tts_seed/silero/ornn)

//mob/living/simple_animal/hostile/cthulhu/Login()
//	. = ..()
//	client.view = "27x21"

/mob/living/simple_animal/hostile/cthulhu/Life(seconds, times_fired)
	. = ..()
	adjustHealth(-regeneration_per_second * seconds)

/mob/living/simple_animal/hostile/cthulhu/update_icon_state()
	. = ..()
	switch(health)
		if(0 to 1000)
			icon_state = "act3"
		if(1001 to 2000)
			icon_state = pick("act2", "act2-1)
		else
			icon_state = "act"

/mob/living/simple_animal/hostile/cthulhu/adjustHealth(damage, updating_health)
	. = ..()
	update_icon_state()

/mob/living/simple_animal/hostile/cthulhu/can_die()
	. = ..()
	return should_die & .

/obj/effect/temp_visual/target_cthulhu
	icon = 'icons/mob/actions/actions.dmi'
	icon_state = "sniper_zoom"
	color = "#3333ff"
	layer = BELOW_MOB_LAYER
	duration = 0.5 SECONDS

/datum/spell/fireball/homing/cthulhu
	invocation_type = "none"
	base_cooldown = 10 SECONDS
	var/preparation_time = 0.5 SECONDS
	fireball_type = /obj/item/projectile/homing/magic/homing_fireball/cthulhu


/obj/item/projectile/homing/magic/homing_fireball/cthulhu
	layer = ABOVE_ALL_MOB_LAYER
	explosion_devastate = 0
	explosion_heavy = 0
	explosion_light = 2
	explosion_flash = 4
	explosion_fire = 3

/datum/spell/fireball/homing/cthulhu/cast(list/targets, mob/living/user)
	for(var/atom/atom in targets)
		new /obj/effect/temp_visual/target_cthulhu(get_turf(atom))
	if(!do_after(user, preparation_time, FALSE, allow_moving = TRUE))
		return FALSE
	. = ..()


/datum/spell/leap/cthulhu
	var/preparation_time = 0.5 SECONDS

/datum/spell/leap/cthulhu/cast(list/targets, mob/living/user)
	animate_wiggle_then_reset(user, 1, 1, 1, 1)
	user.pixel_x = initial(user.pixel_x)
	user.pixel_y = initial(user.pixel_y)
	if(!do_after(user, preparation_time, FALSE, allow_moving = TRUE))
		return FALSE
	. = ..()
	user.pixel_y = initial(user.pixel_y)

/datum/spell/global_annouce
	name = "Волна мысли"
	action_icon_state = "resonant_shriek"
	base_cooldown = 0
	clothes_req = FALSE

/datum/spell/global_annouce/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/global_annouce/cast(list/targets, mob/user)
	var/message = tgui_input_text(user, "Сообщение для отправки", "Волна мысли")
	var/spanned_message = span_narsie(message)
	for(var/mob/player as anything in GLOB.player_list)
		user.cast_tts(player, message)
		to_chat(player, spanned_message)
	sound_to_playing_players(sound('modular_ss220/dunes_map/sound/mobs/boss_roar.ogg'), 100)

/datum/spell/aoe/conjure/duna
	name = "Призвать прислужников"
	action_icon_state = "shadow_boxing"
	human_req = FALSE
	clothes_req = FALSE
	base_cooldown = 40 SECONDS
	aoe_range = 4
	summon_amt = 3
	summon_type = list(/mob/living/simple_animal/hostile/duna,
						/mob/living/simple_animal/hostile/duna/range)

/datum/spell/pulse_circle
	name = "Ego autem non ascendit cum nomine"
	action_icon_state = "magicm"
	base_cooldown = 5 SECONDS
	clothes_req = FALSE
	var/obj/item/projectile/projectile_type = /obj/item/projectile/energy/mindflayer

/datum/spell/pulse_circle/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/pulse_circle/proc/shoot(user, angle)
	var/obj/item/projectile/P = new projectile_type(get_turf(user))
	P.firer = user
	P.fire(angle)

/datum/spell/pulse_circle/cast(list/targets, mob/user)
	var/static/list/directional_shot_angles = list(1, 45, 90, 135, 180, 225, 270, 315)
	for(var/angle in directional_shot_angles)
		shoot(user, angle)

/datum/spell/meterorite_rain
	name = "Метеоритный дождь"
	clothes_req = FALSE
	base_cooldown = 20 SECONDS
	action_icon_state = "sniper_zoom"
	var/aoe = 4
	var/probability = 25

/datum/spell/meterorite_rain/create_new_targeting()
	. = ..()
	var/datum/spell_targeting/clicked_atom/external/C = new()
	C.range = 25
	return C

/datum/spell/meterorite_rain/cast(list/targets, mob/user)
	. = ..()
	var/turf/target = targets[1]
	for(var/turf/turf in range(aoe, get_turf(target)))
		if(prob(probability))
			new /obj/effect/temp_visual/target_cthulhu_meteor(turf)

/obj/effect/temp_visual/target_cthulhu_meteor
	icon = 'icons/effects/effects.dmi'
	icon_state = "target_circle"
	duration = 1 SECONDS
	var/damage = 20

/obj/effect/temp_visual/target_cthulhu_meteor/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/fleshtostone.ogg', 80, TRUE)
	new /obj/effect/temp_visual/fireball(T)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/effect/temp_visual/target_cthulhu_meteor, fall), T), duration)

/obj/effect/temp_visual/target_cthulhu_meteor/proc/fall(turf/T)
	playsound(T, "explosion", 80, TRUE)
	new /obj/effect/hotspot(T)
	T.hotspot_expose(700, 50, 1)
	for(var/mob/living/L in T.contents)
		L.adjustFireLoss(damage)

/mob/living/simple_animal/cow/desert
	name = "Пустынная корова"
	desc = "Особо стойкая порода коров, способная выдерживать адские температуры."
	maxbodytemp = INFINITY
	var/milk_capacity
