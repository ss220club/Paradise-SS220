
/datum/weather/ash_storm/blizzard
	name = "blizzard"
	desc = "Снежная буря, окутываюшая снежный лес"

	telegraph_message = "<span class='boldwarning'>Ветер на улице начинает усиливаться. Лучше не рисковать и оставаться в укрытии.</span>"
	telegraph_overlay = "light_snow"

	weather_message = "<span class='userdanger'><i>На улице началась настоящая метель. Лучше оставаться в укрытии и не рисковать.</i></span>"
	weather_overlay = "snow_storm"

	end_message = "<span class='boldannounceic'>Рёв ветра постепенно стихает, а землю укрывает одеяло из осевшего снега. Теперь вновь возможно выйти на улицу.</span>"
	end_overlay = "light_snow"

	area_type = /area/lazarus/outdoors
	target_trait = STATION_LEVEL
	weather_color = "#fcfcfc"
	immunity_type = "snow"

/datum/weather/ash_storm/blizzard/update_areas()
	for(var/V in impacted_areas)
		var/area/N = V
		N.layer = overlay_layer
		N.plane = overlay_plane
		N.icon = 'icons/effects/weather_effects.dmi'
		N.invisibility = 0
		N.color = weather_color
		switch(stage)
			if(WEATHER_STARTUP_STAGE)
				N.icon_state = telegraph_overlay
			if(WEATHER_MAIN_STAGE)
				N.icon_state = weather_overlay
			if(WEATHER_WIND_DOWN_STAGE)
				N.icon_state = end_overlay
			if(WEATHER_END_STAGE)
				N.color = null
				N.icon_state = ""
				N.icon = 'icons/turf/areas.dmi'
				N.layer = initial(N.layer)
				N.plane = initial(N.plane)
				N.set_opacity(FALSE)

/datum/weather/ash_storm/blizzard/proc/is_blind_immune(atom/L)
	while(L && !isturf(L))
		if(ismecha(L))
			return TRUE
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/eye_protection = H.check_eye_prot()
			if(eye_protection >= FLASH_PROTECTION_WELDER)
				return TRUE
		L = L.loc
	return FALSE

/datum/weather/ash_storm/blizzard/weather_act(mob/living/L)
	if(issimple_animal(L))
		return
	if(is_blind_immune(L))
		return
	if(!is_ash_immune(L))
		L.adjustFireLoss(1)
		L.SetSlowed(5,5)
		var/blurr_prob = 40
		if (prob(blurr_prob))
			L.AdjustEyeBlurry (rand(2 SECONDS, 8 SECONDS))
	L.AdjustEyeBlind (2 SECONDS)
