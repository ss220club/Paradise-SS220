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
	weather_color = "#fff262"
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

// это говно не работает, я допилю
/datum/weather/ash_storm/sand_storm/proc/is_blind_immune(atom/L)
	while(L && !isturf(L))
		if(ismecha(L)) //Mechs are immune
			return TRUE
		if(ishuman(L)) //Are you immune?
			var/mob/living/carbon/human/H = L
			var/eye_protection = H.get_head_slots()
			var/helmet = list (/obj/item/clothing/head/helmet/swat/raider_helmet/raider_kidan, /obj/item/clothing/glasses/sunglasses, /obj/item/clothing/head/helmet/space)
			//var/wear = H.equip_to_slot ()
			if(istype(eye_protection, helmet))
				return TRUE
		L = L.loc //Matryoshka check
	return FALSE //RIP you

/datum/weather/ash_storm/sand_storm/weather_act(mob/living/carbon/human/L)
	//var/blurr_prob = 40
	//var/blind_prob = 15
	L.adjustFireLoss(0.8)
	L.SetSlowed(5,5)
	//if (prob(blurr_prob))
		//L.AdjustEyeBlurry (rand(6 SECONDS, 8 SECONDS))

	if(is_blind_immune(L))
		return
	L.AdjustEyeBlind (2 SECONDS)








/*	if (istype(L) ||L.head == helmet)
		return
	else if (prob(blind_prob))
		L.AdjustEyeBlind (2 SECONDS)
if(prob(blind_prob))
		L.AdjustEyeBlind (2 SECONDS)

	else if (prob(blurr_prob))
		L.AdjustEyeBlurry (rand(6 SECONDS, 8 SECONDS))
*/
