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
	mob_types = list(/mob/living/simple_animal/hostile/duna/depredator)

	spawn_time = 180 SECONDS

/obj/structure/spawner/desert_depretarors/range
	mob_types = list(/mob/living/simple_animal/hostile/duna/depredator/range)

/mob/living/simple_animal/hostile/duna
	var/list/alert_sounds
	var/alert_cooldown = 3 SECONDS
	var/alert_cooldown_time

/mob/living/simple_animal/hostile/duna/Initialize(mapload)
	. = ..()
	add_language("Sol Common")
	default_language = GLOB.all_languages["Sol Common"]

	speed = pick(-1.2, -1, -0.5, 0, 0.5, 1, 1.5, 2, 2.5)

/mob/living/simple_animal/hostile/duna/Aggro()
	if(!alert_sounds)
		return
	if(world.time > alert_cooldown_time)
		playsound(src, pick(alert_sounds), 150, ignore_walls = FALSE)
		alert_cooldown_time = world.time + alert_cooldown


/mob/living/simple_animal/hostile/duna/depredator
	name = "депредатор"
	desc = "Ебанина"
	icon = 'modular_ss220/dunes_map/icons/mobs.dmi'
	icon_state = "osminog_meele"
	icon_living = "osminog_meele"
	icon_dead = "osminog_meele"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	sentience_type = SENTIENCE_OTHER
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
	unsuitable_atmos_damage = 0
	minbodytemp = 0
	maxbodytemp = 3500
	check_friendly_fire = 1
	status_flags = CANPUSH
	del_on_death = TRUE
	dodging = TRUE
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

/mob/living/simple_animal/hostile/duna/depredator/range
	projectiletype = /obj/item/projectile/beam/immolator/weak/hitscan
	projectilesound = 'modular_ss220/aesthetics_sounds/sound/mobs/vortigaunt/attack_shoot4.ogg'
	ranged_cooldown_time = 2.5 SECONDS
	ranged = TRUE
	dodging = TRUE
	rapid = 3
	harm_intent_damage = 15
	melee_damage_lower = 10
	melee_damage_upper = 10
	retreat_distance = 8
	minimum_distance = 10
	aggro_vision_range = 10
	vision_range = 10
