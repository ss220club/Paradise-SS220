/datum/weather/ash_storm/sand_storm
	name = "sand storm"
	desc = "Печально известные песчанные бури Хирки."

	telegraph_message = "<span class='boldwarning'>Хирка печально известна своими песчаными бурями. Одну из таких вы примечаете на горизонте в виде стремительно нарастающей стены песка и пыли. Стоит поскорее найти укрытие.</span>"
	telegraph_overlay = "light_sand"

	weather_message = "<span class='userdanger'><i>Буря молниеносно застилает все вокруге, горячий песок обжигает и застилает свет. Планета погружается в полумрак. Без специального снаряжения наружу лучше не выходить...</i></span>"
	weather_overlay = "sand_storm"

	end_message = "<span class='boldannounceic'>Рёв ветра постепенно стихает, песчаные облака улетучиваются всё дальше и дальше. К поверхности снова пробивается свет. Кажется, теперь можно покинуть свое укрытие.</span>"
	end_overlay = "light_sand"

	area_type = /area/awaymission/arrakis/outside
	target_trait = STATION_LEVEL
	weather_color = "#e7de83"
	immunity_type = "sand"

/datum/weather/ash_storm/sand_storm/update_areas()
	for(var/V in impacted_areas)
		var/area/N = V
		N.layer = overlay_layer
		N.plane = overlay_plane
		N.icon = 'modular_ss220/dunes_map/icons/weather.dmi'
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

// это говно теперь работает
/datum/weather/ash_storm/sand_storm/proc/is_blind_immune(atom/L)
	while(L && !isturf(L))
		if(ismecha(L)) //Mechs are immune
			return TRUE
		if(ishuman(L)) //Are you immune?
			var/mob/living/carbon/human/H = L
			var/eye_protection = H.check_eye_prot()
			if(eye_protection >= FLASH_PROTECTION_WELDER)
				return TRUE
		L = L.loc //Matryoshka check
	return FALSE //RIP you

/datum/weather/ash_storm/sand_storm/weather_act(mob/living/carbon/human/L)
	if(!is_ash_immune(L))
		L.adjustFireLoss(1)
		L.SetSlowed(5,5)
		var/blurr_prob = 40
		if (prob(blurr_prob))
			L.AdjustEyeBlurry (rand(2 SECONDS, 8 SECONDS))
	if(is_blind_immune(L))
		return
	L.AdjustEyeBlind (2 SECONDS)
