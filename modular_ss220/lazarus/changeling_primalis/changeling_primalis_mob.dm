#define PRIMALIS_CHEM_REGEN 0.5
#define PRIMALIS_CHEM_MAX 150

#define EVOLUTION_STAGE_0 0		///These are used both as required amount of evo points and macro for stage checks
#define EVOLUTION_STAGE_1 250
#define EVOLUTION_STAGE_2 1000
#define EVOLUTION_STAGE_3 3000
#define EVOLUTION_STAGE_4 10000

#define EVOLUTION_GROWTH 4

/mob/living/simple_animal/changeling_primalis
	name = "Meaty worm"
	icon = 'icons/mob/mob.dmi'
	icon_state = "headslug"
	icon_living = "headslug"
	icon_dead = "headslug_dead"
	hud_type = /datum/hud/simple_animal/changeling_primalis
	health = 60
	maxHealth = 60
	melee_damage_lower = 30
	melee_damage_upper = 35
	melee_damage_type = STAMINA
	attacktext = "gnaws"
	attack_sound = 'sound/weapons/bite.ogg'
	see_in_dark = 6
	layer = MOB_LAYER

	var/mob/living/carbon/human/host
	var/chemicals = 0

	var/evolution_points = 0
	var/evolution_stage = EVOLUTION_STAGE_0

/mob/living/simple_animal/changeling_primalis/Initialize()
	. = ..()
	var/datum/atom_hud/U = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	U.add_hud_to(src)
	grant_basic_skills()
	real_name = "[pick("Альфа", "Бэта", "Гамма", "Сигма", "Дельта", "Эпсилон", "Дзета", "Йота", "Пси", "Омега")]-[rand(100, 999)]"
	name = real_name
	SSticker.mode.ling_infestors.Add(src)
	add_language("Changeling")

/mob/living/simple_animal/changeling_primalis/Destroy()
	var/datum/atom_hud/U = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	U.remove_hud_from(src)
	SSticker.mode.ling_infestors.Remove(src)
	disinfest()
	. = ..()

/mob/living/simple_animal/changeling_primalis/Life(second, times_fired)
	..()
	if(host)
		chemicals = clamp(chemicals + PRIMALIS_CHEM_REGEN, 0, PRIMALIS_CHEM_MAX)
	if(hud_used?.lingchemdisplay)
		hud_used.lingchemdisplay.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font face='Small Fonts' color='#dd66dd'>[round(chemicals)]</font></div>"
	handle_evolution()

/mob/living/simple_animal/changeling_primalis/proc/handle_evolution()
	evolution_points += EVOLUTION_GROWTH
	switch(evolution_stage)
		if(EVOLUTION_STAGE_0)
			if(evolution_points > EVOLUTION_STAGE_1)
				evolution_stage = EVOLUTION_STAGE_1
				to_chat(src, span_biggerdanger("Мы немного освоились в теле носителя. Теперь мы не просто наблюдатели. Мы можем сообщать в разум носителя мысли и образы, а также использовать наши силы для помощи носителю."))
				SEND_SOUND(src, 'sound/ambience/antag/ling_alert.ogg')
		if(EVOLUTION_STAGE_1)
			if(evolution_points > EVOLUTION_STAGE_2)
				evolution_stage = EVOLUTION_STAGE_2
				to_chat(src, span_biggerdanger("Мы забираемся всё глубже внутрь носителя. Его иммунная система сдалась, и мы получили контроль над тканями его тела. Теперь мы можем отращивать на теле носителя новые ткани, преобразуя его в нечто более совершенное."))
				SEND_SOUND(src, 'sound/ambience/antag/ling_alert.ogg')
		if(EVOLUTION_STAGE_2)
			if(evolution_points > EVOLUTION_STAGE_3)
				evolution_stage = EVOLUTION_STAGE_3
				to_chat(src, span_biggerdanger("Мы окончательно укоренились в теле носителя. Теперь мы способны на короткий промежуток времени брать его под контроль. Более того, теперь мы способны заражать нашими отпрысками и других гуманойдов."))
				SEND_SOUND(src, 'sound/ambience/antag/ling_alert.ogg')
		if(EVOLUTION_STAGE_3)
			if(evolution_points > EVOLUTION_STAGE_4)
				evolution_stage = EVOLUTION_STAGE_4
				to_chat(src, span_biggerdanger("Носитель был ассимилирован. Теперь это не более чем оболочка, сдерживающее наше полностью выросшее, совершенное тело. Носитель более неспособен сопротивляться нашему контролю. Мы готовы вознестись в любой момент."))
				SEND_SOUND(src, 'sound/ambience/antag/ling_alert.ogg')


/mob/living/simple_animal/changeling_primalis/proc/infest(var/mob/living/carbon/human/new_host)
	if(!new_host?.changeling_primalis)
		if(host != null)
			host.changeling_primalis = null
		forceMove(new_host)
		host = new_host
		new_host.changeling_primalis = src
		SSticker.mode.ling_hosts.Add(host)
		for(var/datum/language/lang in host.languages)
			src.add_language(lang.name)
		RegisterSignal(host, COMSIG_MOB_DEATH, PROC_REF(on_host_death), override = TRUE)

/mob/living/simple_animal/changeling_primalis/proc/disinfest()
	if(host)
		UnregisterSignal(host, COMSIG_MOB_DEATH)
		for(var/datum/language/lang in host.languages)
			src.remove_language(lang.name)
		host.changeling_primalis = null
		SSticker.mode.ling_hosts.Remove(host)
		host = null
		qdel(src)

/mob/living/simple_animal/changeling_primalis/proc/on_host_death()
	SIGNAL_HANDLER
	disinfest()

/mob/living/simple_animal/changeling_primalis/get_default_language()
	if(default_language)
		return default_language
	return GLOB.all_languages["Changeling"]

/mob/living/simple_animal/changeling_primalis/UnarmedAttack(mob/living/carbon/human/M)
	if(istype(M))
		to_chat(src, span_notice("Вы анализируете жизненные показатели [M]."))
		healthscan(src, M, 1, TRUE)

/mob/living/simple_animal/changeling_primalis/say(message, verb, sanitize, ignore_speech_problems, ignore_atmospherics, ignore_languages)
	if(istype(get_default_language(), /datum/language/ling))
		return ..()
	return

/mob/living/simple_animal/changeling_primalis/emote(emote_key, type_override, message, intentional, force_silence)
	to_chat(src, span_warning("Вы не способны на выражение эмоций"))

/mob/living/simple_animal/changeling_primalis/whisper(message as text)
	to_chat(src, span_warning("Вы не способны шептать"))

// Evolution

/mob/living/simple_animal/changeling_primalis/proc/grant_basic_skills()
	var/list/primalis_abilities = list()

	primalis_abilities += new /datum/action/changeling_primalis/message_host(src)
	primalis_abilities += new /datum/action/changeling_primalis/contact_host(src)
	primalis_abilities += new /datum/action/changeling_primalis/speed_up_evolution(src)

	for(var/datum/action/changeling_primalis/ability in primalis_abilities)
		ability.Grant(src)

#undef PRIMALIS_CHEM_REGEN
#undef PRIMALIS_CHEM_MAX

#undef EVOLUTION_STAGE_0
#undef EVOLUTION_STAGE_1
#undef EVOLUTION_STAGE_2
#undef EVOLUTION_STAGE_3
#undef EVOLUTION_STAGE_4
#undef EVOLUTION_GROWTH
