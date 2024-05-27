

// --------------------------------------------------------------------------------
// --------------------- TERROR SPIDERS: DEFAULTS ---------------------------------
// --------------------------------------------------------------------------------
// Because: http://tvtropes.org/pmwiki/pmwiki.php/Main/SpidersAreScary

/mob/living/simple_animal/hostile/poison/terror_spider
	//COSMETIC
	name = "Паучок"
	desc = "Стандартный паук. Если ты это видишь, это баг."
	gender = FEMALE
	icon = 'modular_ss220/events/icons/terrorspider.dmi'
	icon_state = "terror_red"
	icon_living = "terror_red"
	icon_dead = "terror_red_dead"
	attacktext = "кусает"
	attack_sound = 'modular_ss220/events/sound/creatures/terrorspiders/bite.ogg'
	deathmessage = "Screams in pain and slowly stops moving."
	death_sound = 'modular_ss220/events/sound/creatures/terrorspiders/death.ogg'
	damaged_sound = list('modular_ss220/events/sound/creatures/spider_attack1.ogg', 'modular_ss220/events/sound/creatures/spider_attack2.ogg')
	spider_intro_text = "Если ты это видишь, это баг."
	speak_chance = 0 // quiet but deadly
	speak_emote = list("hisses")
	emote_hear = list("hisses")
	sentience_type = SENTIENCE_OTHER
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	friendly = "осторожно проводит лапками по"
	footstep_type = FOOTSTEP_MOB_CLAW
	talk_sound = list('modular_ss220/events/sound/creatures/terrorspiders/speech_1.ogg', 'modular_ss220/events/sound/creatures/terrorspiders/speech_2.ogg', 'modular_ss220/events/sound/creatures/terrorspiders/speech_3.ogg', 'modular_ss220/events/sound/creatures/terrorspiders/speech_4.ogg', 'modular_ss220/events/sound/creatures/terrorspiders/speech_5.ogg', 'modular_ss220/events/sound/creatures/terrorspiders/speech_6.ogg')
	damaged_sound = list('modular_ss220/events/sound/creatures/terrorspiders/speech_1.ogg', 'modular_ss220/events/sound/creatures/terrorspiders/speech_2.ogg', 'modular_ss220/events/sound/creatures/terrorspiders/speech_3.ogg', 'modular_ss220/events/sound/creatures/terrorspiders/speech_4.ogg', 'modular_ss220/events/sound/creatures/terrorspiders/speech_5.ogg', 'modular_ss220/events/sound/creatures/terrorspiders/speech_6.ogg')

	//HEALTH
	maxHealth = 120
	health = 120
	a_intent = INTENT_HARM
	var/regeneration = 2 //pure regen on life
	//also regenerates by using /datum/status_effect/terror/food_regen when wraps a carbon, wich grants full health witin ~25 seconds
	damage_coeff = list(BRUTE = 0.75, BURN = 1.25, TOX = 1, CLONE = 0, STAMINA = 0, OXY = 0.2)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)

	//ATTACK
	melee_damage_lower = 15
	melee_damage_upper = 20

	//MOVEMENT
	pass_flags = PASSTABLE
	turns_per_move = 3 // number of turns before AI-controlled spiders wander around. No effect on actual player or AI movement speed!
	move_to_delay = 6
	speed = 0
	// AI spider speed at chasing down targets. Higher numbers mean slower speed. Divide 20 (server tick rate / second) by this to get tiles/sec.


	//SPECIAL
	var/list/special_abillity = list()  //has spider unique abillities?
	var/can_wrap = TRUE   //can spider wrap corpses and objects?
	delay_web = 25 // delay between starting to spin web, and finishing
	faction = list("terrorspiders")

	// Vision
	vision_range = 10
	aggro_vision_range = 10
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	sight = SEE_MOBS


	var/spider_awaymission = 0 // if 1, limits certain behavior in away missions
	var/spider_uo71 = 0 // if 1, spider is in the UO71 away mission
	var/spider_unlock_id_tag = "" // if defined, unlock awaymission blast doors with this tag on death

	// AI variables designed for use in procs



	var/datum/action/innate/terrorspider/web/web_action
	var/datum/action/innate/terrorspider/wrap/wrap_action

	// Temperature
	heat_damage_per_tick = 6.5 // Takes 250% normal damage from being in a hot environment ("kill it with fire!")


// --------------------------------------------------------------------------------
// --------------------- TERROR SPIDERS: SHARED ATTACK CODE -----------------------
// --------------------------------------------------------------------------------

/mob/living/simple_animal/hostile/poison/terror_spider/New()
	. = ..()
	for(var/spell in special_abillity)
		src.AddSpell(new spell)

/mob/living/simple_animal/hostile/poison/terror_spider/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	// Forces terrors to use the 'bite' graphic when attacking something. Same as code/modules/mob/living/carbon/alien/larva/larva_defense.dm#L34
	if(!no_effect && !visual_effect_icon)
		visual_effect_icon = ATTACK_EFFECT_BITE
	..()

/mob/living/simple_animal/hostile/poison/terror_spider/AttackingTarget()
	if(isterrorspider(target))
		if(target in enemies)
			enemies -= target
		var/mob/living/simple_animal/hostile/poison/terror_spider/T = target
		if(T.spider_tier > spider_tier)
			visible_message("<span class='notice'>[src] cowers before [target].</span>")
		else if(T.spider_tier == spider_tier)
			visible_message("<span class='notice'>[src] nuzzles [target].</span>")
		else if(T.spider_tier < spider_tier && spider_tier >= 4)
			target.attack_animal(src)
		else
			visible_message("<span class='notice'>[src] harmlessly nuzzles [target].</span>")
		T.CheckFaction()
		CheckFaction()
	else if(istype(target, /obj/structure/spider/royaljelly))
		consume_jelly(target)
	else if(istype(target, /obj/structure/spider)) // Prevents destroying coccoons (exploit), eggs (horrible misclick), etc
		to_chat(src, "Destroying things created by fellow spiders would not help us.")
	else if(istype(target, /obj/machinery/door/firedoor))
		var/obj/machinery/door/firedoor/F = target
		if(F.density)
			if(F.welded)
				to_chat(src, "The fire door is welded shut.")
			else
				visible_message("<span class='danger'>[src] pries open the firedoor!</span>")
				F.open()
		else
			to_chat(src, "Closing fire doors does not help.")
	else if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/A = target
		try_open_airlock(A)
	else if(isliving(target) && (!client || a_intent == INTENT_HARM))
		var/mob/living/G = target
		if(issilicon(G))
			G.attack_animal(src)
			return
		else if(G.reagents && (iscarbon(G)))
			var/can_poison = 1
			if(ishuman(G))
				var/mob/living/carbon/human/H = G
				if(!(H.dna.species.reagent_tag & PROCESS_ORG) || (!H.dna.species.tox_mod))
					can_poison = 0
			spider_specialattack(G,can_poison)
		else
			G.attack_animal(src)
	else
		target.attack_animal(src)

// --------------------------------------------------------------------------------
// --------------------- TERROR SPIDERS: PROC OVERRIDES ---------------------------
// --------------------------------------------------------------------------------

/mob/living/simple_animal/hostile/poison/terror_spider/examine(mob/user)
	. = ..()
	if(stat != DEAD)
		if(key)
			. += "<span class='warning'>[p_they(TRUE)] regards [p_their()] surroundings with a curious intelligence.</span>"
		if(health > (maxHealth*0.95))
			. += "<span class='notice'>[p_they(TRUE)] is in excellent health.</span>"
		else if(health > (maxHealth*0.75))
			. += "<span class='notice'>[p_they(TRUE)] has a few injuries.</span>"
		else if(health > (maxHealth*0.55))
			. += "<span class='warning'>[p_they(TRUE)] has many injuries.</span>"
		else if(health > (maxHealth*0.25))
			. += "<span class='warning'>[p_they(TRUE)] is barely clinging on to life!</span>"
		if(degenerate)
			. += "<span class='warning'>[p_they(TRUE)] appears to be dying.</span>"
		if(killcount >= 1)
			. += "<span class='warning'>[p_they(TRUE)] has blood dribbling from [p_their()] mouth.</span>"


/mob/living/simple_animal/hostile/poison/terror_spider/Life(seconds, times_fired)
	. = ..()
	if(health < maxHealth)
		adjustBruteLoss(-regeneration)

/mob/living/simple_animal/hostile/poison/terror_spider/handle_dying()
	if(!hasdied)
		hasdied = 1
		GLOB.ts_count_dead++
		GLOB.ts_death_last = world.time
		if(spider_awaymission)
			GLOB.ts_count_alive_awaymission--
		else
			GLOB.ts_count_alive_station--

/mob/living/simple_animal/hostile/poison/terror_spider/give_intro_text()
	to_chat(src, "<center><span class='userdanger'>Вы паук ужаса!</span></center>")
	to_chat(src, "<center>Работайте сообща, помогайте своим братьям и сёстрам, саботируйте станцию, убивайте экипаж, превратите это место в своё гнездо!</center>")
	to_chat(src, "<center><span class='big'>[spider_intro_text]</span></center><br>")
	SEND_SOUND(src, sound('sound/ambience/antag/terrorspider.ogg'))

/mob/living/simple_animal/hostile/poison/terror_spider/death(gibbed)
	if(can_die())
		if(!gibbed)
			msg_terrorspiders("[src] has died in [get_area(src)].")
		handle_dying()
	return ..()


/mob/living/simple_animal/hostile/poison/terror_spider/ObjBump(obj/O)
	if(istype(O, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/L = O
		if(L.density) // must check density here, to avoid rapid bumping of an airlock that is in the process of opening, instantly forcing it closed
			return try_open_airlock(L)
	if(istype(O, /obj/machinery/door/firedoor))
		var/obj/machinery/door/firedoor/F = O
		if(F.density && !F.welded)
			F.open()
			return 1
	. = ..()

/mob/living/simple_animal/hostile/poison/terror_spider/get_spacemove_backup()
	. = ..()
	// If we don't find any normal thing to use, attempt to use any nearby spider structure instead.
	if(!.)
		for(var/obj/structure/spider/S in range(1, get_turf(src)))
			return S

/mob/living/simple_animal/hostile/poison/terror_spider/Stat()
	..()
	// Determines what shows in the "Status" tab for player-controlled spiders. Used to help players understand spider health regeneration mechanics.
	// Uses <font color='#X'> because the status panel does NOT accept <span class='X'>.
	if(statpanel("Status") && ckey && stat == CONSCIOUS)
		if(degenerate)
			stat(null, "<font color='#eb4034'>Hivemind Connection Severed! Dying...</font>") // color=red
			return


/mob/living/simple_animal/hostile/poison/terror_spider/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(istype(mover, /obj/item/projectile/terrorspider))
		return TRUE

/obj/item/projectile/terrorspider
	name = "basic"
	damage = 0
	icon_state = "toxin"
	damage_type = TOX
