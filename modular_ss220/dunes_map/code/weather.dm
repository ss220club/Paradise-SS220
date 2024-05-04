/datum/weather/ash_storm/sand_storm
	name = "sand storm"
	desc = "An intense atmospheric storm lifts sand off of the planet's surface and billows it down across the area, making it difficult to move and limiting the view."

	telegraph_message = "<span class='boldwarning'>An eerie moon rises on the wind. Sheets of violent hot sand and blacken the horizon. Seek shelter.</span>"
	telegraph_overlay = "light_sand"

	weather_message = "<span class='userdanger'><i>Clouds of scorching sand billow down around you! It's better to wait in the shelter...</i></span>"
	weather_overlay = "sand_storm"

	end_message = "<span class='boldannounceic'>The shrieking wind whips away the last of the sand and falls to its usual murmur. It should be safe to go outside now.</span>"
	end_overlay = "light_sand"

	area_type = /area/awaymission/arrakis/outside
	target_trait = STATION_LEVEL

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

/datum/weather/ash_storm/sand_storm/is_ash_immune(atom/L)
	while(L && !isturf(L))
		if(ismecha(L)) //Mechs are immune
			return TRUE
		if(ishuman(L)) //Are you immune?
			var/mob/living/carbon/human/H = L
			var/thermal_protection = H.get_thermal_protection()
			if(thermal_protection >= FIRE_IMMUNITY_MAX_TEMP_PROTECT)
				return TRUE
		L = L.loc //Matryoshka check
	return FALSE //RIP you

/datum/weather/ash_storm/sand_storm/weather_act(mob/living/L)
	if(is_ash_immune(L))
		return
	L.adjustFireLoss(0.2)
	L.EyeBlurry(1 SECONDS)
