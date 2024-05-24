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

	spawn_time = 180 SECONDS

/obj/structure/spawner/desert_depretarors/range
	mob_types = list(/mob/living/simple_animal/hostile/duna/range)

/obj/item/projectile/beam/depredator
	name = "depredator laser"
	icon_state = "purple_laser"
	damage = 10

/obj/effect/projectile/muzzle/depredator
	icon_state = "muzzle_hcult"

/obj/effect/projectile/tracer/depredator
	name = "depredator laser"
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

/mob/living/simple_animal/hostile/duna
	var/list/alert_sounds
	var/alert_cooldown = 3 SECONDS
	var/alert_cooldown_time
	name = "депредатор"
	desc = "Ебанина"
	icon = 'modular_ss220/dunes_map/icons/mobs.dmi'
	icon_state = "osminogmeele"
	icon_living = "osminogmeele"
	icon_dead = "osminogmeele"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	sentience_type = SENTIENCE_OTHER
	status_flags = CANPUSH
	del_on_death = TRUE
	dodging = TRUE
	unsuitable_atmos_damage = 0
	minbodytemp = 0
	maxbodytemp = 3500
	check_friendly_fire = TRUE
	a_intent = INTENT_HARM
	loot = list(/obj/effect/gibspawner/xeno)
	faction = list("depredators")
	turns_per_move = 3
	move_to_delay = 2.8
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	maxHealth = 150
	health = 150
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 20
	attacktext = "разрывает"
	attack_sound = 'modular_ss220/mobs/sound/creatures/zombie_attack.ogg'
	a_intent = INTENT_HARM
	loot = list(/obj/effect/gibspawner/xeno)
	faction = list("depredators")
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
	layer = ABOVE_ALL_MOB_LAYER

/mob/living/simple_animal/hostile/duna/Initialize(mapload)
	. = ..()
	add_language("Sol Common")
	default_language = GLOB.all_languages["Sol Common"]

	speed = pick(-1.2, -1, -0.5, 0, 0.5, 1, 1.5, 2, 2.5)

	var/list/meele_type= list("gold", "silver", "platinum")
	icon_state = "osminogmeele_[pick(meele_type)]"

/mob/living/simple_animal/hostile/duna/Aggro()
	if(!alert_sounds)
		return
	if(world.time > alert_cooldown_time)
		playsound(src, pick(alert_sounds), 200, ignore_walls = FALSE)
		alert_cooldown_time = world.time + alert_cooldown


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
	icon_state = "gator"
	icon_living = "gator"
	icon_dead = "gator_dead"
