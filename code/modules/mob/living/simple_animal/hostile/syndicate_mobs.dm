#define BLOOD_HELMET "helmetblood"
#define BLOOD_MASK "maskblood"
#define BLOOD_ARMOR "armorblood"
#define BLOOD_SUIT "suitblood"
#define BLOOD_HANDS "bloodyhands"
#define BLOOD_SHOES "shoeblood"

#define MELEE_WEAPON_NONE "slapper"
#define MELEE_WEAPON_ESWORD "sword"
#define MELEE_WEAPON_DSWORD "dsword"

#define RANGED_WEAPON_PISTOL "gun"
#define RANGED_WEAPON_C20R "c20r"
#define RANGED_WEAPON_M90 "m90"
#define RANGED_WEAPON_SR "sr"

//////////////////////////////
// MARK: SYNDICATE MOB
//////////////////////////////
/mob/living/simple_animal/hostile/syndicate
	name = "Syndicate Operative"
	desc = "Death to Nanotrasen."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "syndicate"
	icon_living = "syndicate"
	attack_sound = 'sound/weapons/blade1.ogg'
	attacktext = "slashes"
	response_help = "pokes the"
	response_disarm = "shoves the"
	response_harm = "hits the"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0) // We know how to use gasmasks
	faction = list("syndicate")
	move_to_delay = 2.99 // Faster than human by 0.01
	del_on_death = TRUE
	mob_biotypes = MOB_ORGANIC | MOB_HUMANOID
	footstep_type = FOOTSTEP_MOB_SHOE
	sentience_type = SENTIENCE_OTHER
	a_intent = INTENT_HARM
	stat_attack = UNCONSCIOUS
	status_flags = 0
	check_friendly_fire = TRUE
	robust_searching = TRUE
	turns_per_move = 5
	speed = 0
	maxHealth = 200
	health = 200
	unsuitable_atmos_damage = 2 // 4 actually
	damage_coeff = list(BRUTE = 0.9, BURN = 0.9, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0) // Imitates our armor
	melee_damage_lower = 30
	melee_damage_upper = 30
	armour_penetration_percentage = 50
	loot = list(
		/obj/effect/spawner/random/syndie_mob_loot,
		/obj/effect/decal/cleanable/blood/innards,
		/obj/effect/decal/cleanable/blood,
		/obj/effect/gibspawner/generic,
		/obj/effect/gibspawner/generic,
	)
	// What do we perform melee attacks with
	var/melee_type = MELEE_WEAPON_ESWORD
	// What do we perform ranged attacks with
	var/ranged_type
	// Corpse we spawn on death()
	var/corpse = /obj/effect/mob_spawn/human/corpse/syndicate
	// Weapon icon overlay we add when we have a target to attack
	var/weapon
	// Should we add weapon icon when there is no target to attack? Uses "-idle" state of weapon (Depot QM with SR as an example)
	var/weapon_idle
	// Overlay for our swat mask/armor booster visor
	var/visor_overlay = "mask"
	// Whether we play activation/deactivation sound of e/dsword
	var/sword_active
	// %Chance to reflect an energy projectile. Used alongside `MELEE_WEAPON_ESWORD` only
	var/reflect_chance = 10
	// %Chance to deflect a melee hit. Used alongside `MELEE_WEAPON_DSWORD` only
	var/deflect_chance = 15
	// %Chance to fully block a hit
	var/parry_chance = 10
	// Icon we display on melee attack/parry
	var/attack_icon
	// Do we have an energy shield in our hands that will reflect any energy projectiles?
	var/eshield
	// Do we wear a modsuit?
	var/modsuit
	// If our armor booster currently active. Affects `damage_coeff` and overlay, used alongside `modsuit` only
	var/armor_booster
	// Should we apply bloody mask? Used in AttackingTarget()
	var/bloody
	// Which masks to apply on apply_blood()
	var/list/static/bloody_parts
	// For how long we are not being triggered
	var/regen_cycle = 0
	// Are we currently healing ourselves?
	var/healing
	// Last time when we reacted
	var/last_react = 0
	// Do we have an (eternal) adrenal chip?
	var/adrenal
	// Are we affected by adrenal?
	var/adrenal_active
	// For how long we have been under adrenal effect?
	var/adrenal_cycle = 0
	// Color of our blade
	var/sword_color
	// Colors for our blade
	var/list/static/colormap = list(
		1 = LIGHT_COLOR_GREEN,
		2 = LIGHT_COLOR_RED,
		3 = LIGHT_COLOR_LIGHTBLUE,
		4 = LIGHT_COLOR_PURPLE,
	)

/mob/living/simple_animal/hostile/syndicate/Initialize(mapload)
	. = ..()
	update_icon(UPDATE_OVERLAYS)
	if(loot) // Prevents us from adding loot if there is none yet
		if(prob(50))
			loot |= /obj/item/salvage/loot/syndicate
		loot |= corpse

/mob/living/simple_animal/hostile/syndicate/proc/apply_blood()
	var/list/static/bloody_parts
	if(modsuit)
		bloody_parts = list(
			BLOOD_HELMET,
			BLOOD_ARMOR,
			BLOOD_HANDS,
			BLOOD_SHOES,
		)
	else
		bloody_parts = list(
			BLOOD_MASK,
			BLOOD_HELMET,
			BLOOD_SUIT,
			BLOOD_HANDS,
			BLOOD_SHOES,
		)

	for(var/bloody_part in bloody_parts)
		var/mutable_appearance/bloodsies = mutable_appearance('icons/effects/blood.dmi', icon_state = bloody_part)
		bloodsies.color = bloody
		add_overlay(bloodsies)

	// Other overlays should be always above blood
	cut_overlay(weapon)
	cut_overlay(weapon_idle)
	cut_overlay("eshield")

	update_icon(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/syndicate/proc/apply_visor()
	if(!modsuit || armor_booster)
		cut_overlay("[visor_overlay]-off")
		add_overlay(visor_overlay)
	else if(modsuit && !armor_booster)
		cut_overlay(visor_overlay)
		add_overlay("[visor_overlay]-off")

/mob/living/simple_animal/hostile/syndicate/proc/apply_weapon()
	if(!attack_icon)
		if(melee_type == MELEE_WEAPON_NONE)
			attack_icon = MELEE_WEAPON_NONE
		else
			sword_color = rand(1,4)
			attack_icon = "[melee_type][sword_color]"

	if(target)
		if(weapon_idle)
			cut_overlay(weapon_idle)
		if(ranged)
			if(!weapon)
				weapon = ranged_type
			add_overlay(weapon)
		else
			if(melee_type != MELEE_WEAPON_NONE)
				if(!weapon)
					weapon = "[sword_color][melee_type]"
				add_overlay(weapon)
				if(sword_color)
					set_light(2, l_color = colormap[sword_color])
				if(!sword_active)
					sword_active = TRUE
	else
		if(sword_color)
			set_light(0)
		if(weapon)
			cut_overlay(weapon)
		if(weapon_idle)
			add_overlay(weapon_idle)
		if(sword_active)
			sword_active = FALSE

/mob/living/simple_animal/hostile/syndicate/proc/apply_eshield()
	if(eshield)
		add_overlay("eshield")

/mob/living/simple_animal/hostile/syndicate/proc/apply_heal(amount, heal_sound)
	adjustHealth(-amount)
	if(heal_sound)
		playsound(src, pick('sound/goonstation/items/mender.ogg', 'sound/goonstation/items/mender2.ogg'), 50, TRUE)
	if(health == maxHealth && healing)
		healing = FALSE
		regen_cycle = 0
	react_sound()

/mob/living/simple_animal/hostile/syndicate/proc/use_adrenal()
	if(!adrenal_active)
		adrenal_active = TRUE
		move_to_delay = ranged ? 2.5 : 1.8
		if(!ranged)
			dodging = FALSE

/mob/living/simple_animal/hostile/syndicate/proc/react_sound()
	if(last_react > world.time)
		return
	if(prob(round(100-(health/maxHealth*100))/4))
		last_react = world.time + 10 SECONDS
		if(adrenal_active)
			playsound(src, 'sound/effects/mob_effects/knuckles.ogg', 50, TRUE)
			custom_emote(EMOTE_VISIBLE, "хрустит пальцами.")
		else if(health >= maxHealth*0.75)
			playsound(src, pick('modular_ss220/emotes/audio/male/yawn_male_1.ogg', 'modular_ss220/emotes/audio/male/yawn_male_2.ogg'), 50, TRUE)
			custom_emote(EMOTE_VISIBLE, "зевает...")
		else if(health >= maxHealth*0.375)
			playsound(src, 'modular_ss220/emotes/audio/male/sigh_male.ogg', 50, TRUE)
			custom_emote(EMOTE_VISIBLE, "вздыхает.")
		else if(health >= maxHealth*0.125)
			playsound(src, pick('modular_ss220/emotes/audio/male/choke_male_1.ogg', 'modular_ss220/emotes/audio/male/choke_male_2.ogg', 'modular_ss220/emotes/audio/male/choke_male_3.ogg'), 50, TRUE)
			custom_emote(EMOTE_VISIBLE, "подавился!")
		else
			playsound(src, pick('modular_ss220/emotes/audio/male/moan_male_1.ogg', 'modular_ss220/emotes/audio/male/moan_male_2.ogg', 'modular_ss220/emotes/audio/male/moan_male_3.ogg'), 50, TRUE)
			custom_emote(EMOTE_VISIBLE, "стонет!")

/mob/living/simple_animal/hostile/syndicate/proc/jedi_spin()
	for(var/i in list(NORTH, SOUTH, EAST, WEST, EAST, SOUTH, NORTH, SOUTH, EAST, WEST, EAST, SOUTH))
		setDir(i)
		if(i == WEST)
			SpinAnimation(7, 1)
		sleep(1)

/mob/living/simple_animal/hostile/syndicate/update_overlays()
	. = ..()
	apply_visor()
	apply_eshield()
	apply_weapon()

/mob/living/simple_animal/hostile/syndicate/handle_environment(datum/gas_mixture/readonly_environment)
	. = ..()
	var/pressure = readonly_environment.return_pressure()
	var/enough_pressure = FALSE
	if(pressure > HAZARD_LOW_PRESSURE && pressure < HAZARD_HIGH_PRESSURE)
		enough_pressure = TRUE
	if(modsuit)
		if(!enough_pressure && armor_booster)
			armor_booster = FALSE
			damage_coeff[BRUTE] += 0.2
			damage_coeff[BURN] += 0.1
			playsound(src, 'sound/mecha/mechmove03.ogg', 25, TRUE)
			apply_visor()
		else if(enough_pressure && !armor_booster)
			armor_booster = TRUE
			damage_coeff[BRUTE] -= 0.2
			damage_coeff[BURN] -= 0.1
			playsound(src, 'sound/mecha/mechmove03.ogg', 25, TRUE)
			apply_visor()
	else if(!enough_pressure)
		adjustHealth(unsuitable_atmos_damage)

/mob/living/simple_animal/hostile/syndicate/ListTargetsLazy()
	// The normal ListTargetsLazy ignores walls, which is very bad. So we override it.
	return ListTargets()

/mob/living/simple_animal/hostile/syndicate/AIShouldSleep(list/possible_targets)
	FindTarget(possible_targets, TRUE)
	return FALSE

/mob/living/simple_animal/hostile/syndicate/Aggro()
	. = ..()
	if(target)
		playsound(src, 'sound/misc/for_the_syndicate.ogg', 70, TRUE)
		if(melee_type != MELEE_WEAPON_NONE && !sword_active)
			playsound(src, 'sound/weapons/saberon.ogg', 35, TRUE)
	update_icon(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/syndicate/AttackingTarget()
	if(ranged)
		if(ranged_cooldown <= world.time)
			OpenFire(target)
		return
	. = ..()
	if(.)
		if(!ranged && !bloody && ishuman(target) && melee_damage_upper)
			var/mob/living/carbon/human/victim = target
			bloody = victim.dna.species.blood_color
			apply_blood()
		if(melee_type == MELEE_WEAPON_DSWORD && prob(50))
			jedi_spin()

/mob/living/simple_animal/hostile/syndicate/LoseTarget()
	. = ..()
	if(sword_active && melee_type != MELEE_WEAPON_NONE)
		playsound(src, 'sound/weapons/saberoff.ogg', 35, TRUE)
	update_icon(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/syndicate/Life(seconds, times_fired)
	. = ..()
	if(stat != DEAD)
		if(adrenal_active)
			adrenal_cycle++
			apply_heal(2) // Second breath
			if(adrenal_cycle >= 15)
				adrenal_active = FALSE
				adrenal_cycle = 0
				move_to_delay = initial(move_to_delay)
				if(!ranged)
					dodging = TRUE
		if(!target && maxHealth > health && !healing)
			if(regen_cycle >= 15)
				healing = TRUE
				react_sound()
			else
				regen_cycle++

		else if(target)
			if(healing)
				healing = FALSE
			if(regen_cycle > 0)
				regen_cycle = 0

		else if(healing)
			var/datum/callback/cb = CALLBACK(src, PROC_REF(apply_heal), 8, TRUE)
			var/delay = SSnpcpool.wait / 2
			for(var/i in 1 to 2)
				addtimer(cb, (i - 1)*delay)

/mob/living/simple_animal/hostile/syndicate/adjustHealth(damage, updating_health = TRUE)
	. = ..()
	if(damage > 0)
		if(adrenal && prob(clamp(round(100-(health/maxHealth*100)),0,25)))
			use_adrenal()
		if(healing)
			healing = FALSE
		if(regen_cycle > 0)
			regen_cycle = 0
		if(health < maxHealth*0.4)
			react_sound()

// Huge copypaste starts
/mob/living/simple_animal/hostile/syndicate/do_attack_animation(atom/A, visual_effect_icon, used_item = attack_icon, no_effect)
	if(!no_effect && (visual_effect_icon || used_item))
		do_item_attack_animation(A, visual_effect_icon, used_item)

	if(A == src)
		return
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/turn_dir = 1

	var/direction = get_dir(src, A)
	if(direction & NORTH)
		pixel_y_diff = 8
		turn_dir = prob(50) ? -1 : 1
	else if(direction & SOUTH)
		pixel_y_diff = -8
		turn_dir = prob(50) ? -1 : 1

	if(direction & EAST)
		pixel_x_diff = 8
	else if(direction & WEST)
		pixel_x_diff = -8
		turn_dir = -1

	var/matrix/initial_transform = matrix(transform)
	var/matrix/rotated_transform = transform.Turn(5 * turn_dir)
	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, transform = rotated_transform, time = 0.1 SECONDS, easing = CUBIC_EASING)
	animate(pixel_x = pixel_x - pixel_x_diff, pixel_y = pixel_y - pixel_y_diff, transform = initial_transform, time = 0.2 SECONDS, easing = SINE_EASING)

/mob/living/simple_animal/hostile/syndicate/do_item_attack_animation(atom/A, visual_effect_icon, used_item)
	var/image/I
	if(visual_effect_icon)
		I = image('icons/effects/effects.dmi', A, visual_effect_icon, A.layer + 0.1)
	else if(used_item)
		I = image(icon, A, used_item, A.layer + 0.1)
		I.plane = GAME_PLANE

		I.transform *= 0.75
		I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

		var/direction = get_dir(src, A)
		if(direction & NORTH)
			I.pixel_y = -16
		else if(direction & SOUTH)
			I.pixel_y = 16

		if(direction & EAST)
			I.pixel_x = -16
		else if(direction & WEST)
			I.pixel_x = 16

		if(!direction)
			I.pixel_z = 16

	if(!I)
		return

	var/list/viewing = list()
	for(var/mob/M in viewers(A))
		if(M.client && M.client.prefs.toggles2 & PREFTOGGLE_2_ITEMATTACK)
			viewing |= M.client

	I.appearance_flags |= RESET_TRANSFORM | KEEP_APART
	flick_overlay(I, viewing, 7)

	var/t_color = "#ffffff"
	if(ismob(src) && ismob(A) && !used_item)
		var/mob/M = src
		t_color = M.a_intent == INTENT_HARM ? "#ff0000" : "#ffffff"
	animate(I, alpha = 175, pixel_x = 0, pixel_y = 0, pixel_z = 0, time = 0.3 SECONDS, color = t_color)
	animate(time = 0.1 SECONDS)
	animate(alpha = 0, time = 0.3 SECONDS, easing = CIRCULAR_EASING | EASE_OUT)
// Huge copypaste ends

/mob/living/simple_animal/hostile/syndicate/attack_hand(mob/living/user)
	if(melee_type == MELEE_WEAPON_DSWORD && prob(deflect_chance))
		visible_message("<span class='boldwarning'>[src] deflects [user]'s punch with its double-bladed sword!</span>")
		do_attack_animation(src)
		user.changeNext_move(CLICK_CD_MELEE)
		user.attack_animal(src)
		playsound(src, 'sound/weapons/parry.ogg', clamp(maxHealth-health, 40, 120))
		return FINISH_ATTACK

	if(prob(parry_chance))
		visible_message("<span class='boldwarning'>[src] parries [user]!</span>")
		do_attack_animation(src)
		user.changeNext_move(CLICK_CD_MELEE)
		user.do_attack_animation(src)
		playsound(src, 'sound/weapons/parry.ogg', clamp(maxHealth-health, 40, 120))
		return FINISH_ATTACK

	return ..()

/mob/living/simple_animal/hostile/syndicate/attack_by(obj/item/O, mob/living/user, params)
	if(melee_type == MELEE_WEAPON_DSWORD && prob(deflect_chance))
		visible_message("<span class='boldwarning'>[src] deflects [O] with its double-bladed sword!</span>")
		do_attack_animation(src)
		user.changeNext_move(CLICK_CD_MELEE)
		user.attack_animal(src)
		playsound(src, 'sound/weapons/parry.ogg', clamp(maxHealth-health, 40, 120))
		return FINISH_ATTACK

	if(prob(parry_chance))
		visible_message("<span class='boldwarning'>[src] parries [O]!</span>")
		do_attack_animation(src)
		user.changeNext_move(CLICK_CD_MELEE)
		user.do_attack_animation(src)
		playsound(src, 'sound/weapons/parry.ogg', clamp(maxHealth-health, 40, 120))
		return FINISH_ATTACK

	return ..()

/mob/living/simple_animal/hostile/syndicate/bullet_act(obj/item/projectile/Proj)
	if(!Proj)
		return
	if(((melee_type == MELEE_WEAPON_DSWORD || eshield) || (melee_type == MELEE_WEAPON_ESWORD && prob(reflect_chance))) && Proj.is_reflectable(REFLECTABILITY_ENERGY))
		if(melee_type == MELEE_WEAPON_ESWORD)
			do_attack_animation(src)
			playsound(src, 'sound/weapons/effects/ric3.ogg', clamp(maxHealth-health, 40, 120), TRUE)
		Proj.reflect_back(src)
		visible_message("<span class='danger'>[src] reflects [Proj] with its [eshield ? "shield" : "sword"]!</span>")
		return -1

	if(melee_type != MELEE_WEAPON_NONE && prob(parry_chance))
		do_attack_animation(src)
		visible_message("<span class='danger'>[src] parries [Proj]!</span>")
		playsound(src, 'sound/weapons/parry.ogg', clamp(maxHealth-health, 40, 120))
		return

	return ..()

//////////////////////////////
// MARK: ESHIELD
//////////////////////////////
/mob/living/simple_animal/hostile/syndicate/shield
	eshield = TRUE

//////////////////////////////
// MARK: RANGED
//////////////////////////////
/mob/living/simple_animal/hostile/syndicate/ranged
	ranged = TRUE
	ranged_type = RANGED_WEAPON_C20R
	melee_type = MELEE_WEAPON_NONE
	parry_chance = 20
	rapid = 2
	retreat_distance = 5
	minimum_distance = 5
	casingtype = /obj/item/ammo_casing/c45
	projectilesound = 'sound/weapons/gunshots/gunshot_smg.ogg'

//////////////////////////////
// MARK: MODSUIT
//////////////////////////////
/mob/living/simple_animal/hostile/syndicate/modsuit
	name = "Syndicate Commando"
	damage_coeff = list(BRUTE = 0.7, BURN = 0.9, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	maxbodytemp = FIRE_SUIT_MAX_TEMP_PROTECT
	minbodytemp = 0
	icon_state = "syndicate_mod"
	icon_living = "syndicate_mod"
	death_sound = 'sound/mecha/mechmove03.ogg'
	visor_overlay = "armor_booster"
	eshield = TRUE
	modsuit = TRUE
	corpse = /obj/effect/mob_spawn/human/corpse/syndicate/modsuit

/mob/living/simple_animal/hostile/syndicate/modsuit/Process_Spacemove(movement_dir = 0, continuous_move = FALSE)
	return TRUE

//////////////////////////////
// MARK: MODSUIT RANGED
//////////////////////////////
/mob/living/simple_animal/hostile/syndicate/modsuit/ranged
	ranged = TRUE
	ranged_type = RANGED_WEAPON_C20R
	melee_type = MELEE_WEAPON_NONE
	parry_chance = 20
	rapid = 2
	retreat_distance = 5
	minimum_distance = 5
	casingtype = /obj/item/ammo_casing/c45
	projectilesound = 'sound/weapons/gunshots/gunshot_smg.ogg'

//////////////////////////////
// MARK: ELITE MODSUIT
//////////////////////////////
/mob/living/simple_animal/hostile/syndicate/modsuit/elite
	name = "Syndicate Quartermaster"
	damage_coeff = list(BRUTE = 0.6, BURN = 0.6, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	icon_state = "syndicate_elite"
	icon_living = "syndicate_elite"
	visor_overlay = "elite_armor_booster"
	adrenal = TRUE
	eshield = FALSE
	melee_type = MELEE_WEAPON_DSWORD
	melee_damage_lower = 34
	melee_damage_upper = 34
	corpse = /obj/effect/mob_spawn/human/corpse/syndicate/modsuit/elite

/mob/living/simple_animal/hostile/syndicate/modsuit/elite/Initialize(mapload)
	loot ^= list(/obj/effect/spawner/random/syndie_mob_loot) // No Billy, you can't get two elite modsuits from a single mob
	loot |= list(/obj/effect/spawner/random/pool/spaceloot/syndicate/armory/elite) // Random armory tier loot
	if(prob(50))
		ranged = TRUE
		ranged_type = RANGED_WEAPON_SR
		melee_type = MELEE_WEAPON_NONE
		weapon_idle = "sr-idle"
		parry_chance = 25
		retreat_distance = 2
		minimum_distance = 2
		casingtype = /obj/item/ammo_casing/penetrator
		projectilesound = 'sound/weapons/gunshots/gunshot_sniper.ogg'
	. = ..()

//////////////////////////////
// MARK: DEPOT
//////////////////////////////
/mob/living/simple_animal/hostile/syndicate/depot
	var/area/syndicate_depot/core/depotarea
	var/raised_alert
	var/alert_on_death
	var/alert_on_timeout = TRUE
	var/alert_on_spacing = TRUE
	var/alert_on_shield_breach
	var/seen_enemy
	var/seen_enemy_name
	var/seen_revived_enemy
	var/aggro_cycles = 0
	var/scan_cycles = 0
	var/shield_key
	var/turf/spawn_turf

/mob/living/simple_animal/hostile/syndicate/depot/Initialize(mapload)
	. = ..()
	depotarea = get_area(src)
	spawn_turf = get_turf(src)

/mob/living/simple_animal/hostile/syndicate/depot/Aggro()
	. = ..()
	if(!istype(depotarea))
		return
	if(target)
		if(!seen_enemy)
			seen_enemy = TRUE
			if(alert_on_shield_breach)
				if(length(depotarea.shield_list))
					raise_alert("[name] reports that [target] is trying to breach the armory shield!")
					alert_on_shield_breach = FALSE
					raised_alert = FALSE
					alert_on_death = TRUE
			if(isliving(target))
				var/mob/living/M = target
				depotarea.list_add(M, depotarea.hostile_list)
				if(M.mind && M.mind.special_role == SPECIAL_ROLE_TRAITOR)
					depotarea.saw_double_agent(M)
			depotarea.declare_started()
		seen_enemy_name = target.name
		if(ismecha(target))
			depotarea.saw_mech(target)
		if(depotarea.list_includes(target, depotarea.dead_list))
			seen_revived_enemy = TRUE
			raise_alert("[name] reports intruder [target] has returned from death!")
			depotarea.list_remove(target, depotarea.dead_list)
		if(!atoms_share_level(src, target) && prob(20))
			// This prevents someone from aggroing a depot mob, then hiding in a locker, perfectly safe, while the mob stands there getting killed by their friends.
			LoseTarget()

/mob/living/simple_animal/hostile/syndicate/depot/handle_automated_action()
	. = ..()
	if(!.)
		return
	if(!istype(depotarea))
		return
	if(seen_enemy)
		aggro_cycles++
		if(alert_on_timeout && !raised_alert && aggro_cycles >= 60)
			raise_alert("[name] has reported contact with hostile entity: [seen_enemy_name]")
	if(scan_cycles >= 15)
		scan_cycles = 0
		if(!atoms_share_level(src, spawn_turf))
			if(istype(loc, /obj/structure/closet))
				var/obj/structure/closet/O = loc
				forceMove(get_turf(src))
				visible_message("<span class='boldwarning'>[src] smashes their way out of [O]!</span>")
				qdel(O)
				raise_alert("[src] reported being trapped in a locker.")
				raised_alert = FALSE
				return
			if(alert_on_spacing)
				raise_alert("[src] lost in space.")
			death()
			return
		for(var/mob/living/body in hearers(vision_range, targets_from))
			if(body.stat != DEAD)
				continue
			if(depotarea.list_includes(body, depotarea.dead_list))
				continue
			if(faction_check_mob(body))
				continue
			say("Target [body]... terminated.")
			depotarea.list_add(body, depotarea.dead_list)
	else
		scan_cycles++

/mob/living/simple_animal/hostile/syndicate/depot/proc/raise_alert(reason)
	if(istype(depotarea) && (!raised_alert || seen_revived_enemy) && !depotarea.used_self_destruct)
		raised_alert = TRUE
		say("Intruder!")
		depotarea.increase_alert(reason)

/mob/living/simple_animal/hostile/syndicate/depot/drop_loot()
	// If a depot syndicate dies after the depot has been destroyed, assume it
	// was gibbed as part of the destruction and don't drop its loot.
	if(istype(depotarea) && depotarea.destroyed)
		return

	return ..()

/mob/living/simple_animal/hostile/syndicate/depot/death()
	if(!istype(depotarea))
		return ..()
	if(alert_on_death)
		if(seen_enemy_name)
			raise_alert("[name] has died in combat with [seen_enemy_name].")
		else
			raise_alert("[name] has died.")
	if(shield_key && depotarea)
		depotarea.shields_key_check()
	if(depotarea)
		depotarea.list_remove(src, depotarea.guard_list)
	new /obj/effect/gibspawner/human(get_turf(src))
	return ..()

/mob/living/simple_animal/hostile/syndicate/depot/CanPass(atom/movable/mover, border_dir)
	if(isliving(mover))
		var/mob/living/blocker = mover
		if(faction_check_mob(blocker))
			return TRUE
	return ..()

//////////////////////////////
// MARK: DEPOT MODSUIT
//////////////////////////////
/mob/living/simple_animal/hostile/syndicate/depot/modsuit
	name = "Syndicate Commando"
	damage_coeff = list(BRUTE = 0.7, BURN = 0.9, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	maxbodytemp = FIRE_SUIT_MAX_TEMP_PROTECT
	minbodytemp = 0
	icon_state = "syndicate_mod"
	icon_living = "syndicate_mod"
	death_sound = 'sound/mecha/mechmove03.ogg'
	visor_overlay = "armor_booster"
	eshield = TRUE
	modsuit = TRUE
	corpse = /obj/effect/mob_spawn/human/corpse/syndicate/modsuit

/mob/living/simple_animal/hostile/syndicate/depot/modsuit/Process_Spacemove(movement_dir = 0, continuous_move = FALSE)
	return TRUE

//////////////////////////////
// MARK: DEPOT BACKUP
//////////////////////////////
/mob/living/simple_animal/hostile/syndicate/depot/modsuit/backup
	wander = FALSE
	alert_on_spacing = FALSE // So it chasing players in space doesn't make depot explode.
	alert_on_timeout = FALSE // So random fauna doesn't make depot explode.
	corpse = null
	loot = list() // Explodes, doesn't drop loot.

/mob/living/simple_animal/hostile/syndicate/depot/modsuit/backup/death()
	visible_message("<span class='warning'>[src] explodes!</span>")
	playsound(src, 'sound/items/timer.ogg', 30, FALSE)
	explosion(src, 0, 4, 4, flame_range = 2, adminlog = FALSE)
	qdel(src)

//////////////////////////////
// MARK: DEPOT OFFICER
//////////////////////////////
/mob/living/simple_animal/hostile/syndicate/depot/officer
	name = "Syndicate Officer"
	eshield = TRUE
	alert_on_death = TRUE

/mob/living/simple_animal/hostile/syndicate/depot/officer/Initialize(mapload)
	if(prob(50))
		// 50% chance of switching to ranged variant.
		ranged = TRUE
		ranged_type = RANGED_WEAPON_M90
		melee_type = MELEE_WEAPON_NONE
		parry_chance = 20
		rapid = 3
		retreat_distance = 5
		minimum_distance = 3
		casingtype = /obj/item/ammo_casing/a556
		projectilesound = 'sound/weapons/gunshots/gunshot_rifle.ogg'
	. = ..()

//////////////////////////////
// MARK: DEPOT QM
//////////////////////////////
/mob/living/simple_animal/hostile/syndicate/depot/modsuit/elite
	name = "Syndicate Quartermaster"
	damage_coeff = list(BRUTE = 0.6, BURN = 0.6, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	icon_state = "syndicate_elite"
	icon_living = "syndicate_elite"
	visor_overlay = "elite_armor_booster"
	alert_on_shield_breach = TRUE
	adrenal = TRUE
	eshield = FALSE
	melee_type = MELEE_WEAPON_DSWORD
	melee_damage_lower = 34
	melee_damage_upper = 34
	corpse = /obj/effect/mob_spawn/human/corpse/syndicate/modsuit/elite

/mob/living/simple_animal/hostile/syndicate/depot/modsuit/elite/Initialize(mapload)
	if(prob(50))
		// 50% chance of switching to extremely dangerous ranged variant
		ranged = TRUE
		ranged_type = RANGED_WEAPON_SR
		melee_type = MELEE_WEAPON_NONE
		weapon_idle = "sr-idle"
		parry_chance = 25
		retreat_distance = 2
		minimum_distance = 2
		casingtype = /obj/item/ammo_casing/penetrator // Ignores cover.
		projectilesound = 'sound/weapons/gunshots/gunshot_sniper.ogg'
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/mob/living/simple_animal/hostile/syndicate/depot/modsuit/elite/LateInitialize()
	if(istype(depotarea))
		var/list/key_candidates = list()
		for(var/mob/living/simple_animal/hostile/syndicate/depot/officer/O in GLOB.alive_mob_list)
			key_candidates += O
		if(length(key_candidates))
			var/mob/living/simple_animal/hostile/syndicate/depot/officer/O = pick(key_candidates)
			O.shield_key = TRUE
			depotarea.shields_up()

/mob/living/simple_animal/hostile/syndicate/depot/modsuit/elite/death()
	if(!istype(depotarea))
		return ..()
	if(!length(depotarea.shield_list)) // Not opening lockers without getting shields down
		depotarea.unlock_lockers()
	return ..()

//////////////////////////////
// MARK: VISCERATOR
//////////////////////////////
/mob/living/simple_animal/hostile/viscerator
	name = "viscerator"
	desc = "A small, twin-bladed machine capable of inflicting very deadly lacerations."
	icon = 'icons/mob/critter.dmi'
	icon_state = "viscerator_attack"
	icon_living = "viscerator_attack"
	pass_flags = PASSTABLE | PASSMOB
	a_intent = INTENT_HARM
	mob_biotypes = MOB_ROBOTIC
	health = 15
	maxHealth = 15
	obj_damage = 0
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "cuts"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	faction = list("syndicate")
	minbodytemp = 0
	mob_size = MOB_SIZE_TINY
	bubble_icon = "syndibot"
	gold_core_spawnable = HOSTILE_SPAWN
	del_on_death = TRUE
	deathmessage = "is smashed into pieces!"

	initial_traits = list(TRAIT_FLYING)

/mob/living/simple_animal/hostile/viscerator/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/swarming)

#undef BLOOD_HELMET
#undef BLOOD_MASK
#undef BLOOD_ARMOR
#undef BLOOD_SUIT
#undef BLOOD_HANDS
#undef BLOOD_SHOES
#undef MELEE_WEAPON_NONE
#undef MELEE_WEAPON_ESWORD
#undef MELEE_WEAPON_DSWORD
#undef RANGED_WEAPON_PISTOL
#undef RANGED_WEAPON_C20R
#undef RANGED_WEAPON_M90
#undef RANGED_WEAPON_SR
