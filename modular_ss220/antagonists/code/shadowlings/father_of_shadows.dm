/mob/living/simple_animal/demon/shadow_father	// Can't inherit from demon/shadow because of 'initialize' proc
	name = "отец теней"
	desc = "Крупное демоническое существо, сотканное из теней. Из его красных глаз сочится потусторонняя энергия."
	icon = 'modular_ss220/antagonists/icons/shadowlings/father_of_shadows.dmi'
	icon_state = "father_of_shadows"
	icon_living = "father_of_shadows"
	a_intent = INTENT_HARM
	mob_biotypes = MOB_ORGANIC | MOB_HUMANOID
	stop_automated_movement = TRUE
	status_flags = CANPUSH
	attack_sound = 'sound/misc/demon_attack1.ogg'
	death_sound = 'sound/misc/demon_dies.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = INFINITY
	faction = list("demon")
	move_resist = MOVE_FORCE_STRONG
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	see_in_dark = 10
	death_sound = 'sound/shadowdemon/shadowdeath.ogg'
	speed = 1

	var/thrown_alert

/mob/living/simple_animal/demon/shadow_father/Initialize(mapload)
	. = ..()
	add_overlay(emissive_appearance(icon, "father_of_shadows_eye_glow_overlay"))
	var/datum/spell/bloodcrawl/shadow_crawl/S = new
	AddSpell(S)
	whisper_action.button_overlay_icon_state = "shadow_whisper"
	whisper_action.button_background_icon_state = "shadow_demon_bg"

/mob/living/simple_animal/demon/shadow_father/Life(seconds, times_fired)
	. = ..()
	var/lum_count = check_darkness()
	var/damage_mod = istype(loc, /obj/effect/dummy/slaughter) ? 0.5 : 1
	if(lum_count > 0.2)
		adjustBruteLoss(40 * damage_mod) // 10 seconds in light
		SEND_SOUND(src, sound('sound/weapons/sear.ogg'))
		to_chat(src, "<span class='biggerdanger'>The light scalds you!</span>")
	else
		adjustBruteLoss(-20)

/mob/living/simple_animal/demon/shadow_father/proc/check_darkness()
	var/turf/T = get_turf(src)
	var/lum_count = T.get_lumcount()
	if(lum_count > 0.2)
		if(!thrown_alert)
			thrown_alert = TRUE
			throw_alert("light", /atom/movable/screen/alert/lightexposure)
		alpha = 255
		speed = initial(speed)
	else
		if(thrown_alert)
			thrown_alert = FALSE
			clear_alert("light")
		alpha = 125
		speed = 0.5
	return lum_count
