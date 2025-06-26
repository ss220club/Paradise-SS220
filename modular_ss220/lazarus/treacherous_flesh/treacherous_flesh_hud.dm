// Why not /datum/atom_hud/antag?
// We need to save antag hud unchanged in case if treacherous flesh will spawn in round of cult, for example.

/datum/atom_hud/treacherous_flesh
	hud_icons = list(TREACHEOUS_FLESH_HUD)

/mob/living/carbon/human/Initialize(mapload, datum/species/new_species)
	hud_possible.Add(TREACHEOUS_FLESH_HUD)
	. = ..()

/datum/hud
	var/atom/movable/screen/treacherous_flesh_evolution

/atom/movable/screen/treacherous_flesh_evolution
	name = "evolution status"
	icon_state = "power_display"
	screen_loc = "WEST:6,CENTER-2:15"

/atom/movable/screen/treacherous_flesh_evolution/Click()
	if(!istype(usr, /mob/living/treacherous_flesh))
		return
	var/mob/living/treacherous_flesh/user = usr
	to_chat(user, span_info("Ваш уровень эволюции: [user.get_evolution_state()]\nПрогресс до следующего уровня: [user.evolution_points]/[user.get_evolution_requirements()]\n"))

/datum/hud/simple_animal/treacherous_flesh/New(mob/user)
	..()
	lingchemdisplay = new /atom/movable/screen/ling/chems()
	lingchemdisplay.invisibility = 0
	infodisplay += lingchemdisplay

	treacherous_flesh_evolution = new /atom/movable/screen/treacherous_flesh_evolution()
	treacherous_flesh_evolution.invisibility = 0
	infodisplay += treacherous_flesh_evolution

/mob/living/treacherous_flesh/Life(second, times_fired)
	..()
	if(hud_used?.lingchemdisplay)
		hud_used.lingchemdisplay.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font face='Small Fonts' color='#dd66dd'>[round(chemicals)]</font></div>"
	if(hud_used?.treacherous_flesh_evolution)
		hud_used.treacherous_flesh_evolution.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font face='Small Fonts' color='#dd66dd'>[get_evolution_state()]</font></div>"

// Yep, it's awful
/mob/living/treacherous_flesh/proc/get_evolution_state()
	switch(evolution_stage)
		if(EVOLUTION_STAGE_0)
			return 0
		if(EVOLUTION_STAGE_1)
			return 1
		if(EVOLUTION_STAGE_2)
			return 2
		if(EVOLUTION_STAGE_3)
			return 3
		if(EVOLUTION_STAGE_4)
			return 4
	return 0

/mob/living/treacherous_flesh/proc/get_evolution_requirements()
	switch(evolution_stage)
		if(EVOLUTION_STAGE_0)
			return EVOLUTION_STAGE_1
		if(EVOLUTION_STAGE_1)
			return EVOLUTION_STAGE_2
		if(EVOLUTION_STAGE_2)
			return EVOLUTION_STAGE_3
		if(EVOLUTION_STAGE_3)
			return EVOLUTION_STAGE_4
		if(EVOLUTION_STAGE_4)
			return "MAX"
	return 0

