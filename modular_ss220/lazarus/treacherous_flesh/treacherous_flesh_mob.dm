#define PRIMALIS_CHEM_REGEN 2
#define PRIMALIS_CHEM_MAX 200

#define EVOLUTION_STAGE_0 0		///These are used both as required amount of evo points and macro for stage checks
#define EVOLUTION_STAGE_1 300
#define EVOLUTION_STAGE_2 900
#define EVOLUTION_STAGE_3 2100
#define EVOLUTION_STAGE_4 3600

#define EVOLUTION_GROWTH 1

/mob/living/treacherous_flesh
	name = "Meaty worm"
	icon = 'icons/mob/mob.dmi'
	icon_state = "headslug"
	hud_type = /datum/hud/simple_animal/treacherous_flesh
	health = 60
	maxHealth = 60
	see_in_dark = 6
	layer = MOB_LAYER
	faction = list("treacherous_flesh")
	lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT

	var/mob/living/carbon/human/host
	var/chemicals = 0

	var/evolution_points = 0
	var/evolution_stage = EVOLUTION_STAGE_0

	/// If TRUE, some actions will start to spread infection
	var/infecting = FALSE
	/// if TRUE, the host obey parasite orders
	var/host_enslaved = FALSE
	/// Holder for host trapped mind
	var/mob/living/trapped_mind/trapped_mind

/mob/living/treacherous_flesh/add_tts_component()
	AddComponent(/datum/component/tts_component, /datum/tts_seed/silero/anubarak)

/mob/living/treacherous_flesh/Initialize(mapload)
	. = ..()
	var/datum/atom_hud/U = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	U.add_hud_to(src)
	grant_skills()
	real_name = "[pick("Альфа", "Бэта", "Гамма", "Сигма", "Дельта", "Эпсилон", "Дзета", "Йота", "Пси", "Омега")]-[rand(100, 999)]"
	name = real_name
	SSticker.mode.ling_infestors.Add(src)
	add_language("Разум Улья Биоморфов")

/mob/living/treacherous_flesh/Destroy()
	disinfest(FALSE)
	. = ..()

/mob/living/treacherous_flesh/Life(second, times_fired)
	..()
	if(host)
		if(infecting)
			chemicals = clamp(chemicals - PRIMALIS_CHEM_REGEN * 2, 0, PRIMALIS_CHEM_MAX)
		else
			chemicals = clamp(chemicals + PRIMALIS_CHEM_REGEN, 0, PRIMALIS_CHEM_MAX)
		handle_evolution()
	if(chemicals == 0)
		disable_passive_abilities()


/mob/living/treacherous_flesh/proc/handle_evolution()
	if(evolution_stage < EVOLUTION_STAGE_4)
		evolution_points += EVOLUTION_GROWTH
	switch(evolution_stage)
		if(EVOLUTION_STAGE_0)
			if(evolution_points > EVOLUTION_STAGE_1)
				evolution_stage = EVOLUTION_STAGE_1
				to_chat(src, span_biggerdanger("Мы немного освоились в теле носителя. Теперь мы не просто наблюдатели. Мы можем сообщать в разум носителя мысли и образы, а также использовать наши силы для помощи носителю."))
				SEND_SOUND(src, 'sound/ambience/antag/ling_alert.ogg')
				grant_skills()
		if(EVOLUTION_STAGE_1)
			if(evolution_points > EVOLUTION_STAGE_2)
				evolution_stage = EVOLUTION_STAGE_2
				to_chat(src, span_biggerdanger("Мы забираемся всё глубже внутрь носителя. Его иммунная система сдалась, и мы получили контроль над тканями его тела. Теперь мы можем отращивать на теле носителя новые ткани, преобразуя его в нечто более совершенное."))
				SEND_SOUND(src, 'sound/ambience/antag/ling_alert.ogg')
				grant_skills()
		if(EVOLUTION_STAGE_2)
			if(evolution_points > EVOLUTION_STAGE_3)
				evolution_stage = EVOLUTION_STAGE_3
				to_chat(src, span_biggerdanger("Мы окончательно укоренились в теле носителя. Теперь мы способны на короткий промежуток времени брать его под контроль. Более того, теперь мы способны заражать нашими отпрысками и других гуманойдов и видеть живых существ сквозь стены."))
				SEND_SOUND(src, 'sound/ambience/antag/ling_alert.ogg')
				sight = SEE_MOBS
				grant_skills()
		if(EVOLUTION_STAGE_3)
			if(evolution_points > EVOLUTION_STAGE_4)
				evolution_stage = EVOLUTION_STAGE_4
				to_chat(src, span_biggerdanger("Носитель был ассимилирован. Теперь это не более чем оболочка, сдерживающее наше полностью выросшее, совершенное тело. Носитель более неспособен сопротивляться нашему контролю. Мы готовы вознестись в любой момент."))
				SEND_SOUND(src, 'sound/ambience/antag/ling_alert.ogg')
				grant_skills()


/mob/living/treacherous_flesh/proc/infest(mob/living/carbon/human/new_host)
	if(!new_host?.treacherous_flesh)
		if(host != null)
			host.treacherous_flesh = null
		forceMove(new_host)
		host = new_host
		new_host.treacherous_flesh = src
		for(var/datum/language/lang in host.languages)
			src.add_language(lang.name)
		RegisterSignal(host, COMSIG_MOB_DEATH, PROC_REF(on_host_death), override = TRUE)
		var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_TREACHEOUS_FLESH]
		hud.add_hud_to(src)
		var/image/holder = host.hud_list[TREACHEOUS_FLESH_HUD]
		holder.icon_state = "active_hud"

/mob/living/treacherous_flesh/proc/disinfest(delete = TRUE)
	if(!host)
		return
	var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_TREACHEOUS_FLESH]
	hud.remove_from_hud(host)
	if(host_enslaved)
		to_chat(host, "<span class='biggerdanger'>Мой владыка покинул меня... Что теперь со мной будет? Погодите-ка, а что вообще было? Почему я здесь? Я вновь ощущая себя... собой.</span>")
	host.faction.Remove("treacherous_flesh")
	UnregisterSignal(host, COMSIG_MOB_DEATH)
	host.treacherous_flesh = null
	SSticker.mode.ling_hosts.Remove(host)
	host = null
	if(delete)
		qdel(src)

/mob/living/treacherous_flesh/proc/on_host_death(mob/source, gibbed)
	SIGNAL_HANDLER
	if(gibbed)
		qdel(src)

/mob/living/treacherous_flesh/get_default_language()
	if(default_language)
		return default_language
	return GLOB.all_languages["Разум Улья Биоморфов"]

/mob/living/treacherous_flesh/UnarmedAttack(mob/living/carbon/human/M)
	if(istype(M))
		to_chat(src, span_notice("Мы анализируем жизненные показатели [M]."))
		healthscan(src, M, 1, TRUE)

/mob/living/treacherous_flesh/say(message, verb, sanitize, ignore_speech_problems, ignore_atmospherics, ignore_languages)
	if(istype(get_default_language(), /datum/language/treacherous_flesh))
		return ..()
	return

/mob/living/treacherous_flesh/emote(emote_key, type_override, message, intentional, force_silence)
	to_chat(src, span_warning("Мы не способны на выражение эмоций"))

/mob/living/treacherous_flesh/whisper(message as text)
	to_chat(src, span_warning("Мы не способны шептать"))

/mob/living/treacherous_flesh/proc/disable_passive_abilities()
	for(var/datum/action/treacherous_flesh/passive/A in actions)
		A.disable()

// Evolution

/mob/living/treacherous_flesh/proc/grant_skills()
	var/list/primalis_abilities = list()
	switch(evolution_stage)
		if(EVOLUTION_STAGE_0)
			primalis_abilities += new /datum/action/treacherous_flesh/message_host(src)
			primalis_abilities += new /datum/action/treacherous_flesh/contact_host(src)
			primalis_abilities += new /datum/action/treacherous_flesh/speed_up_evolution(src)
			primalis_abilities += new /datum/action/treacherous_flesh/leave_the_body(src)
			primalis_abilities += new /datum/action/treacherous_flesh/passive/emit_pheromones(src)
		if(EVOLUTION_STAGE_1)
			primalis_abilities += new /datum/action/treacherous_flesh/fleshmend(src)
			primalis_abilities += new /datum/action/treacherous_flesh/adrenaline(src)
			primalis_abilities += new /datum/action/treacherous_flesh/panacea(src)
			primalis_abilities += new /datum/action/treacherous_flesh/heat_up(src)
		if(EVOLUTION_STAGE_2)
			primalis_abilities += new /datum/action/treacherous_flesh/regrow_organs(src)
			primalis_abilities += new /datum/action/treacherous_flesh/toggle/armblade(src)
			primalis_abilities += new /datum/action/treacherous_flesh/toggle/chitin_armor(src)
			primalis_abilities += new /datum/action/treacherous_flesh/passive/passive_infest(src)
		if(EVOLUTION_STAGE_3)
			primalis_abilities += new /datum/action/treacherous_flesh/take_control(src)
			primalis_abilities += new /datum/action/treacherous_flesh/enslave_mind(src)
		if(EVOLUTION_STAGE_4)
			primalis_abilities += new /datum/action/treacherous_flesh/ascension(src)
	for(var/datum/action/treacherous_flesh/ability in primalis_abilities)
		ability.Grant(src)

#undef PRIMALIS_CHEM_REGEN
#undef PRIMALIS_CHEM_MAX

#undef EVOLUTION_GROWTH
