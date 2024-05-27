// ---------- ACTIONS FOR ALL SPIDERS
/datum/action/innate/terrorspider
	background_icon_state = "bg_terror"

// ---------- GREEN ACTIONS

/datum/action/innate/terrorspider/greeneggs
	name = "Lay Green Eggs"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "eggs"

/datum/action/innate/terrorspider/greeneggs/Activate()
	var/mob/living/simple_animal/hostile/poison/terror_spider/healer/user = owner
	user.DoLayGreenEggs()

// ---------- KNIGHT ACTIONS
/datum/action/innate/terrorspider/knight/defaultm
	name = "Default"
	icon_icon = 'icons/mob/terrorspider.dmi'
	button_icon_state = "terror_princess1"

/datum/action/innate/terrorspider/knight/defaultm/Activate()
	var/mob/living/simple_animal/hostile/poison/terror_spider/knight/user = owner
	user.activate_mode(0)

/datum/action/innate/terrorspider/knight/attackm
	name = "Rage"
	icon_icon = 'icons/mob/actions/actions.dmi'
	button_icon_state = "attack"

/datum/action/innate/terrorspider/knight/attackm/Activate()
	var/mob/living/simple_animal/hostile/poison/terror_spider/knight/user = owner
	user.activate_mode(1)

/datum/action/innate/terrorspider/knight/defencem
	name = "Keratosis"
	icon_icon = 'icons/mob/actions/actions.dmi'
	button_icon_state = "defence"

/datum/action/innate/terrorspider/knight/defencem/Activate()
	var/mob/living/simple_animal/hostile/poison/terror_spider/knight/user = owner
	user.activate_mode(2)

// ---------- BOSS ACTIONS

/datum/action/innate/terrorspider/ventsmash
	name = "Smash Welded Vent"
	icon_icon = 'icons/atmos/vent_pump.dmi'
	button_icon_state = "map_vent"

/datum/action/innate/terrorspider/ventsmash/Activate()
	var/mob/living/simple_animal/hostile/poison/terror_spider/user = owner
	user.DoVentSmash()

/datum/action/innate/terrorspider/remoteview
	name = "Remote View"
	icon_icon = 'icons/obj/eyes.dmi'
	button_icon_state = "heye"

/datum/action/innate/terrorspider/remoteview/Activate()
	var/mob/living/simple_animal/hostile/poison/terror_spider/user = owner
	user.DoRemoteView()

// ---------- QUEEN ACTIONS

/datum/action/innate/terrorspider/queen/queennest
	name = "Nest"
	icon_icon = 'icons/mob/terrorspider.dmi'
	button_icon_state = "terror_queen"

/datum/action/innate/terrorspider/queen/queennest/Activate()
	var/mob/living/simple_animal/hostile/poison/terror_spider/queen/user = owner
	user.NestPrompt()

/datum/action/innate/terrorspider/queen/queensense
	name = "Hive Sense"
	icon_icon = 'icons/mob/actions/actions.dmi'
	button_icon_state = "mindswap"

/datum/action/innate/terrorspider/queen/queensense/Activate()
	var/mob/living/simple_animal/hostile/poison/terror_spider/queen/user = owner
	user.DoHiveSense()

/datum/action/innate/terrorspider/queen/queeneggs
	name = "Lay Queen Eggs"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "eggs"

/datum/action/innate/terrorspider/queen/queeneggs/Activate()
	var/mob/living/simple_animal/hostile/poison/terror_spider/queen/user = owner
	user.LayQueenEggs()


// ---------- EMPRESS

/datum/action/innate/terrorspider/queen/empress/empresserase
	name = "Empress Erase Brood"
	icon_icon = 'icons/effects/blood.dmi'
	button_icon_state = "mgibbl1"

/datum/action/innate/terrorspider/queen/empress/empresserase/Activate()
	var/mob/living/simple_animal/hostile/poison/terror_spider/queen/empress/user = owner
	user.EraseBrood()

/datum/action/innate/terrorspider/queen/empress/empresslings
	name = "Empresss Spiderlings"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "spiderling"

/datum/action/innate/terrorspider/queen/empress/empresslings/Activate()
	var/mob/living/simple_animal/hostile/poison/terror_spider/queen/empress/user = owner
	user.EmpressLings()


// ---------- WEB

/obj/structure/spider/terrorweb/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()

	if(checkpass(mover))
		return TRUE

	if(istype(mover, /mob/living/simple_animal/hostile/poison/giant_spider) || isterrorspider(mover))
		return TRUE

	if(istype(mover, /obj/item/projectile/terrorspider))
		return TRUE

	if(isliving(mover))
		var/mob/living/living_mover = mover
		if(living_mover.lying_angle)
			return TRUE

		if(prob(80))
			to_chat(mover, span_danger("You get stuck in [src] for a moment."))
			living_mover.Weaken(2 SECONDS) // 2 seconds, wow
			living_mover.Slowed(10 SECONDS)
			if(iscarbon(mover))
				web_special_ability(mover)
			return TRUE

		return FALSE

	if(isprojectile(mover))
		return prob(20)








