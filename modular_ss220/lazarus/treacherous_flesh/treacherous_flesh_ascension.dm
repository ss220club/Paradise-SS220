/mob/living/simple_animal/hostile/flesh_biomorph/high
	name = "высший биоморф"
	desc = "Отвратительное насекомоподобное создание, вызывающиее ничего кроме ужаса и омерзения."
	icon = 'modular_ss220/lazarus/icons/high_biomorph.dmi'
	icon_state = "high"
	mob_biotypes = MOB_ORGANIC
	stop_automated_movement = TRUE
	status_flags = CANPUSH
	move_resist = MOVE_FORCE_STRONG
	speak_emote = list("кряхтит")
	emote_hear = list("кряхтит")
	maxHealth = 400
	health = 400
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	obj_damage = 50
	melee_damage_lower = 35
	melee_damage_upper = 35
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = INFINITY
	see_in_dark = 8
	attack_sound = 'sound/misc/demon_attack1.ogg'
	death_sound = 'sound/misc/demon_dies.ogg'
	death_sound = 'sound/shadowdemon/shadowdeath.ogg'
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 8
	response_help = "трогает"
	response_disarm = "толкает"
	response_harm = "бьёт"
	attacktext = "бьёт щупальцами"
	attack_sound = 'sound/weapons/bite.ogg'
	pressure_resistance = 200
	weeds_heal_amount = 10

/mob/living/simple_animal/hostile/flesh_biomorph/high/Initialize(mapload)
	. = ..()
	var/datum/spell/biomorph/build_structure/build_structure = new
	AddSpell(build_structure)
	var/datum/spell/biomorph/plant_weeds/plant_weeds = new
	AddSpell(plant_weeds)
	var/datum/spell/fireball/biomorph_tentacle/tentacle = new
	AddSpell(tentacle)
	add_language("Galactic Common")

/mob/living/simple_animal/hostile/flesh_biomorph/high/death(gibbed)
	if(!gibbed)
		gib()
	return ..(TRUE)

/datum/spell/fireball/biomorph_tentacle
	name = "Выстрел щупальцем"
	desc = "Выстреливает щупальцем, который притягивает к вам того, в кого оно попадёт, а также притягивает вас к стенам."
	base_cooldown = 10 SECONDS
	fireball_type = /obj/item/projectile/magic/biomorph_tentacle

	selection_activated_message = "<span class='notice'>Вы отрываете одно из щупалец, готовясь метнуть его...<b>Left-click to cast at a target!</b></span>"
	selection_deactivated_message = "<span class='notice'>Вы присоединили щупальце обратно.</span>"

	action_icon = 'modular_ss220/lazarus/icons/lazarus_actions.dmi'
	action_background_icon = 'modular_ss220/lazarus/icons/lazarus_actions.dmi'
	action_icon_state = "tentacle"
	action_background_icon_state = "bg_flesh"
	sound = null
	invocation_type = "none"
	invocation = null

/datum/spell/fireball/biomorph_tentacle/update_spell_icon()
	return

/obj/item/projectile/magic/biomorph_tentacle
	name = "щупальце биоморфа"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "tentacle_end"
	plane = FLOOR_PLANE
	hitsound = 'sound/weapons/thudswoosh.ogg'
	var/hit = FALSE

/obj/item/projectile/magic/biomorph_tentacle/fire(setAngle)
	if(firer)
		firer.Beam(src, icon_state = "tentacle", time = INFINITY, maxdistance = INFINITY, beam_sleep_time = 1, beam_type = /obj/effect/ebeam/floor)
	return ..()

/obj/item/projectile/magic/biomorph_tentacle/on_hit(atom/target, blocked, hit_zone)
	if(hit)
		return
	hit = TRUE // to prevent double hits from the pull
	. = ..()
	if(!isliving(target))
		firer.throw_at(get_step(target, get_dir(target, firer)), 10, 10)
	if(!.)
		return
	else
		var/mob/living/L = target
		L.Immobilize(2 SECONDS)
		L.apply_damage(40, BRUTE, BODY_ZONE_CHEST)
		L.throw_at(get_step(firer, get_dir(firer, target)), 50, 10)
