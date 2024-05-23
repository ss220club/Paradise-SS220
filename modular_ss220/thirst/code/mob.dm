/mob
	var/hydration = HYDRATION_LEVEL_GOOD + 50
	var/thirst_drain = THIRST_FACTOR
	var/atom/movable/screen/hydration/hydration_display = null

///Adjust the hydration of a mob
/mob/proc/adjust_hydration(change)
	if(!GLOB.configuration.ss220_misc.hydration_enabled)
		return FALSE
	hydration = clamp(hydration + change, 0, HYDRATION_LEVEL_FULL)

/mob/living/carbon/human/adjust_hydration(change)
	if(HAS_TRAIT(src, TRAIT_NO_THIRST))
		return FALSE
	. = ..()

///Force set the mob hydration
/mob/proc/set_hydration(change)
	if(!GLOB.configuration.ss220_misc.hydration_enabled)
		return FALSE
	hydration = clamp(change, 0, HYDRATION_LEVEL_FULL)

/mob/living/carbon/human/set_hydration(change)
	if(HAS_TRAIT(src, TRAIT_NO_THIRST))
		return FALSE
	. = ..()

/mob/living/carbon/human/set_species(datum/species/new_species, use_default_color, delay_icon_update, skip_same_check, retain_damage, transformation, keep_missing_bodyparts)
	. = ..()
	if(!.)
		return
	thirst_drain = dna.species.thirst_drain

/mob/living/carbon/human/handle_chemicals_in_body()
	. = ..()
	if(!GLOB.configuration.ss220_misc.hydration_enabled)
		return
	if(HAS_TRAIT(src, TRAIT_NO_THIRST))
		if(hydration >= 0 && stat != DEAD)
			handle_thirst_alerts()
	if(!HAS_TRAIT(src, TRAIT_NO_THIRST))
		if(hydration >= 0 && stat != DEAD)
			handle_thirst_alerts()
		adjust_hydration(-thirst_drain)

		if(!isLivingSSD(src) && hydration < HYDRATION_LEVEL_INEFFICIENT)
			var/datum/disease/D = new /datum/disease/critical/dehydration
			ForceContractDisease(D)

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(!GLOB.configuration.ss220_misc.hydration_enabled)
		return
	if(!.)
		return
	if(hydration && stat != DEAD)
		adjust_hydration(-(thirst_drain * 0.1))
		if(m_intent == MOVE_INTENT_RUN)
			adjust_hydration(-(thirst_drain * 0.15))

/mob/living/carbon/human/examine(mob/user)
	. = ..()
	if(hydration < HYDRATION_LEVEL_INEFFICIENT)
		. += span_warning("Выглядит обезвоженным.")

/mob/living/carbon/human/proc/handle_thirst_alerts()
	if(!hydration_display)
		return
	if(HAS_TRAIT(src, TRAIT_NO_THIRST) || !GLOB.configuration.ss220_misc.hydration_enabled)
		hydration_display.icon_state = null
		return
	if(hydration_display.icon_state == "water_notice_me")
		return
	switch(hydration)
		if(HYDRATION_LEVEL_WELL_FED to INFINITY)
			hydration_display.icon_state = "water_full"
		if(HYDRATION_LEVEL_GOOD to HYDRATION_LEVEL_WELL_FED)
			hydration_display.icon_state = "water_well_hydrated"
		if(HYDRATION_LEVEL_MEDIUM to HYDRATION_LEVEL_GOOD)
			hydration_display.icon_state = "water_hydrated"
		if(HYDRATION_LEVEL_SMALL to HYDRATION_LEVEL_MEDIUM)
			hydration_display.icon_state = "water_thirsty"
		else
			hydration_display.icon_state = "water_dehydrated"

/mob/living/rejuvenate()
	. = ..()
	set_hydration(initial(hydration))
