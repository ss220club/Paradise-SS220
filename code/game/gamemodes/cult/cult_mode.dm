/datum/game_mode
	/// A list of all minds currently in the cult
	var/list/datum/mind/cult = list()
	var/datum/cult_objectives/cult_objs = new
	/// Does the cult have glowing eyes
	var/cult_risen = FALSE
	/// Does the cult have halos
	var/cult_ascendant = FALSE
	/// How many crew need to be converted to rise
	var/rise_number
	/// How many crew need to be converted to ascend
	var/ascend_number
	/// Used for the CentComm announcement at ascension
	var/ascend_percent

/proc/iscultist(mob/living/M)
	return istype(M) && M.mind && SSticker && SSticker.mode && (M.mind in SSticker.mode.cult)

/proc/is_convertable_to_cult(datum/mind/mind)
	if(!mind)
		return FALSE
	if(!mind.current)
		return FALSE
	if(is_sacrifice_target(mind))
		return FALSE
	if(iscultist(mind.current))
		return TRUE //If they're already in the cult, assume they are convertable
	if(HAS_MIND_TRAIT(mind.current, TRAIT_HOLY))
		return FALSE
	if(ishuman(mind.current))
		var/mob/living/carbon/human/H = mind.current
		if(ismindshielded(H)) //mindshield protects against conversions unless removed
			return FALSE
	if(mind.offstation_role)
		return FALSE
	if(issilicon(mind.current))
		return FALSE //can't convert machines, that's ratvar's thing
	if(isguardian(mind.current))
		var/mob/living/simple_animal/hostile/guardian/G = mind.current
		if(iscultist(G.summoner))
			return TRUE //can't convert it unless the owner is converted
	if(isgolem(mind.current))
		return FALSE
	if(isanimal(mind.current))
		return FALSE
	return TRUE

/datum/game_mode/cult
	name = "cult"
	config_tag = "cult"
	restricted_jobs = list("Chaplain", "AI", "Cyborg", "Internal Affairs Agent", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Blueshield", "Nanotrasen Representative", "Magistrate", "Nanotrasen Navy Officer", "Special Operations Officer", "Syndicate Officer", "Solar Federation General")
	protected_jobs = list()
	required_players = 30
	required_enemies = 3
	recommended_enemies = 4

	var/const/min_cultists_to_start = 3
	var/const/max_cultists_to_start = 4

/datum/game_mode/cult/announce()
	to_chat(world, "<B>The current game mode is - Cult!</B>")
	to_chat(world, "<B>Some crewmembers are attempting to start a cult!<BR>\nCultists - complete your objectives. Convert crewmembers to your cause by using the offer rune. Remember - there is no you, there is only the cult.<BR>\nPersonnel - Do not let the cult succeed in its mission. Brainwashing them with holy water reverts them to whatever CentComm-allowed faith they had.</B>")

/datum/game_mode/cult/pre_setup()
	if(GLOB.configuration.gamemode.prevent_mindshield_antags)
		restricted_jobs += protected_jobs

	var/list/cultists_possible = get_players_for_role(ROLE_CULTIST)
	for(var/cultists_number = 1 to max_cultists_to_start)
		if(!length(cultists_possible))
			break
		var/datum/mind/cultist = pick(cultists_possible)
		cultists_possible -= cultist
		cult += cultist
		cultist.restricted_roles = restricted_jobs
		cultist.special_role = SPECIAL_ROLE_CULTIST
	return (length(cult) > 0)

/datum/game_mode/cult/post_setup()
	modePlayer += cult
	cult_objs.setup()

	for(var/datum/mind/cult_mind in cult)
		SEND_SOUND(cult_mind.current, sound('sound/ambience/antag/bloodcult.ogg'))
		to_chat(cult_mind.current, CULT_GREETING)
		equip_cultist(cult_mind.current)
		cult_mind.current.faction |= "cult"
		cult_mind.add_mind_objective(/datum/objective/servecult)

		if(cult_mind.assigned_role == "Clown")
			to_chat(cult_mind.current, "<span class='cultitalic'>Тёмная сила позволила вам перебороть свою клоунскую натуру, позволяя вам пользоваться оружием без риска пораниться.</span>")
			cult_mind.current.dna.SetSEState(GLOB.clumsyblock, FALSE)
			singlemutcheck(cult_mind.current, GLOB.clumsyblock, MUTCHK_FORCED)
			var/datum/action/innate/toggle_clumsy/A = new
			A.Grant(cult_mind.current)

		add_cult_actions(cult_mind)
		update_cult_icons_added(cult_mind)
		cult_objs.study(cult_mind.current)
		to_chat(cult_mind.current, "<span class='motd'>Для большей информации, проконсультруйтесь со страницей на вики: ([GLOB.configuration.url.wiki_url]/index.php/Cultist)</span>")
	cult_threshold_check()
	addtimer(CALLBACK(src, PROC_REF(cult_threshold_check)), 2 MINUTES) // Check again in 2 minutes for latejoiners
	..()

/datum/game_mode/proc/equip_cultist(mob/living/carbon/human/H, metal = TRUE)
	if(!istype(H))
		return
	. += cult_give_item(/obj/item/melee/cultblade/dagger, H)
	if(metal)
		. += cult_give_item(/obj/item/stack/sheet/runed_metal/ten, H)
	to_chat(H, "<span class='cult'>Это вам поможет начать культ на станции. Используйте их с умом, и помните - вы не единственный.</span>")

/datum/game_mode/proc/cult_give_item(obj/item/item_path, mob/living/carbon/human/H)
	var/list/slots = list(
		"backpack" = SLOT_HUD_IN_BACKPACK,
		"left pocket" = SLOT_HUD_LEFT_STORE,
		"right pocket" = SLOT_HUD_RIGHT_STORE)
	var/T = new item_path(H)
	var/item_name = initial(item_path.name)
	var/where = H.equip_in_one_of_slots(T, slots)
	if(!where)
		to_chat(H, "<span class='userdanger'>К сожалению, вы не смогли получить [item_name]. Это очень плохо и вы должны немедленно написать админтикет (F1 -> adminhelp).</span>")
		return FALSE
	else
		to_chat(H, "<span class='danger'>У вас есть [item_name] в вашем [where].</span>")
		return TRUE


/datum/game_mode/proc/add_cultist(datum/mind/cult_mind)
	if(!istype(cult_mind))
		return FALSE

	if(!ascend_percent) // If the rise/ascend thresholds haven't been set (non-cult rounds)
		cult_objs.setup()
		cult_threshold_check()

	if(!(cult_mind in cult))
		cult += cult_mind
		cult_mind.current.faction |= "cult"
		cult_mind.special_role = SPECIAL_ROLE_CULTIST

		if(cult_mind.assigned_role == "Clown")
			to_chat(cult_mind.current, "<span class='cultitalic'>Тёмная сила позволила вам перебороть свою клоунскую натуру, позволяя вам пользоваться оружием без риска пораниться.</span>")
			cult_mind.current.dna.SetSEState(GLOB.clumsyblock, FALSE)
			singlemutcheck(cult_mind.current, GLOB.clumsyblock, MUTCHK_FORCED)
			var/datum/action/innate/toggle_clumsy/A = new
			A.Grant(cult_mind.current)
		SEND_SOUND(cult_mind.current, sound('sound/ambience/antag/bloodcult.ogg'))
		cult_mind.current.create_attack_log("<span class='danger'>Был обращён в культ!</span>")
		cult_mind.current.create_log(CONVERSION_LOG, "Converted to the cult")

		if(jobban_isbanned(cult_mind.current, ROLE_CULTIST) || jobban_isbanned(cult_mind.current, ROLE_SYNDICATE))
			replace_jobbanned_player(cult_mind.current, ROLE_CULTIST)
		if(!cult_objs.cult_status && ishuman(cult_mind.current))
			cult_objs.setup()
		update_cult_icons_added(cult_mind)
		add_cult_actions(cult_mind)
		cult_mind.add_mind_objective(/datum/objective/servecult)

		if(cult_risen)
			rise(cult_mind.current)
			if(cult_ascendant)
				ascend(cult_mind.current)
		check_cult_size()
		cult_objs.study(cult_mind.current)
		to_chat(cult_mind.current, "<span class='motd'>For more information, check the wiki page: ([GLOB.configuration.url.wiki_url]/index.php/Cultist)</span>")
		return TRUE

/datum/game_mode/proc/remove_cultist(datum/mind/cult_mind, show_message = TRUE, remove_gear = FALSE, mob/target_mob)
	if(!(cult_mind in cult)) // Not actually a cultist in the first place
		return

	var/mob/cultist = target_mob
	if(!cultist)
		cultist = cult_mind.current
	cult -= cult_mind
	cultist.faction -= "cult"
	cult_mind.special_role = null
	cult_mind.objective_holder.clear(/datum/objective/servecult)
	for(var/datum/action/innate/cult/C in cultist.actions)
		qdel(C)
	update_cult_icons_removed(cult_mind)

	if(ishuman(cultist))
		var/mob/living/carbon/human/H = cultist
		REMOVE_TRAIT(H, CULT_EYES, null)
		H.change_eye_color(H.original_eye_color, FALSE)
		H.update_eyes()
		H.remove_overlay(HALO_LAYER)
		H.update_body()
		if(remove_gear) // No flagellants robe for non-cultists
			for(var/I in H.contents)
				if(is_type_in_list(I, CULT_CLOTHING))
					H.unEquip(I)
		if(cult_mind.assigned_role == "Clown")
			to_chat(H, "<span class='sans'>Вы свободны от тёмных сил, сдерживающие вашу клоунскую натуру. Вы снова неуклюжи! Хонк!</span>")
			H.dna.SetSEState(GLOB.clumsyblock, TRUE)
			singlemutcheck(H, GLOB.clumsyblock, MUTCHK_FORCED)
			for(var/datum/action/innate/toggle_clumsy/A in H.actions)
				A.Remove(H)
		cult_mind.current.create_log(CONVERSION_LOG, "Деконвертирован")
	check_cult_size()
	if(show_message)
		cultist.visible_message("<span class='cult'>[cultist] looks like [cultist.p_they()] just reverted to [cultist.p_their()] old faith!</span>",
		"<span class='userdanger'>Незнакомый белый свет светит в ваш разум, очищая его от следов [SSticker.cultdat ? SSticker.cultdat.entity_title1 : "Нар'Си"] и вместе с этим ваши воспоминания как её слуга.</span>")

/datum/game_mode/proc/add_cult_immunity(mob/living/target)
	ADD_TRAIT(target, TRAIT_CULT_IMMUNITY, CULT_TRAIT)
	addtimer(CALLBACK(src, PROC_REF(remove_cult_immunity), target), 1 MINUTES)

/datum/game_mode/proc/remove_cult_immunity(mob/living/target)
	REMOVE_TRAIT(target, TRAIT_CULT_IMMUNITY, CULT_TRAIT)


/**
  * Decides at the start of the round how many conversions are needed to rise/ascend.
  *
  * The number is decided by (Percentage * (Players - Cultists)), so for example at 110 players it would be 11 conversions for rise. (0.1 * (110 - 4))
  * These values change based on population because 20 cultists are MUCH more powerful if there's only 50 players, compared to 120.
  *
  * Below 100 players, [CULT_RISEN_LOW] and [CULT_ASCENDANT_LOW] are used.
  * Above 100 players, [CULT_RISEN_HIGH] and [CULT_ASCENDANT_HIGH] are used.
  */
/datum/game_mode/proc/cult_threshold_check()
	var/list/living_players = get_living_players(exclude_nonhuman = TRUE, exclude_offstation = TRUE)
	var/players = length(living_players)
	var/cultists = get_cultists() // Don't count the starting cultists towards the number of needed conversions
	if(players >= CULT_POPULATION_THRESHOLD)
		// Highpop
		ascend_percent = CULT_ASCENDANT_HIGH
		rise_number = round(CULT_RISEN_HIGH * (players - cultists))
		ascend_number = round(CULT_ASCENDANT_HIGH * (players - cultists))
	else
		// Lowpop
		ascend_percent = CULT_ASCENDANT_LOW
		rise_number = round(CULT_RISEN_LOW * (players - cultists))
		ascend_number = round(CULT_ASCENDANT_LOW * (players - cultists))

/**
  * Returns the current number of cultists and constructs.
  *
  * Returns the number of cultists and constructs in a list ([1] = Cultists, [2] = Constructs), or as one combined number.
  *
  * * separate - Should the number be returned as a list with two separate values (Humans and Constructs) or as one number.
  */
/datum/game_mode/proc/get_cultists(separate = FALSE)
	var/cultists = 0
	var/constructs = 0
	for(var/I in cult)
		var/datum/mind/M = I
		if(ishuman(M.current) && !M.current.has_status_effect(STATUS_EFFECT_SUMMONEDGHOST))
			cultists++
		else if(isconstruct(M.current))
			constructs++
	if(separate)
		return list(cultists, constructs)
	else
		return cultists + constructs

/datum/game_mode/proc/check_cult_size()
	var/cult_players = get_cultists()

	if(cult_ascendant)
		// The cult only falls if below 1/2 of the rising, usually pretty low. e.g. 5% on highpop, 10% on lowpop
		if(cult_players < rise_number / 2)
			cult_fall()
		return

	if((cult_players >= rise_number) && !cult_risen)
		cult_rise()
		return

	if(cult_players >= ascend_number)
		cult_ascend()

/datum/game_mode/proc/cult_rise()
	cult_risen = TRUE
	for(var/datum/mind/M in cult)
		if(!ishuman(M.current))
			continue
		SEND_SOUND(M.current, sound('sound/hallucinations/i_see_you2.ogg'))
		to_chat(M.current, "<span class='cultlarge'>Завеса слабеет, культ растёт, ваши глаза начинают светиться...</span>")
		addtimer(CALLBACK(src, PROC_REF(rise), M.current), 20 SECONDS)


/datum/game_mode/proc/cult_ascend()
	cult_ascendant = TRUE
	for(var/datum/mind/M in cult)
		if(!ishuman(M.current))
			continue
		SEND_SOUND(M.current, sound('sound/hallucinations/im_here1.ogg'))
		to_chat(M.current, "<span class='cultlarge'>Ваш культ вознёсся и приближается красная жатва. Вы больше не можете скрывать вашу истинную сущность!</span>")
		addtimer(CALLBACK(src, PROC_REF(ascend), M.current), 20 SECONDS)
	GLOB.major_announcement.Announce("Замечена паранормальная активность, связанная с культом [SSticker.cultdat ? SSticker.cultdat.entity_name : "Нар'Си"], с вашей станции. Данные предполагают, что как минимум [ascend_percent * 100] процентов экипажа станции была конвертирована. Служба безопасности имеет полное право использовать летальную силу против культистов. Остальной экипаж должен готовиться к обороне себя и своей рабочей зоны от враждебных культистов. Самооборона разрешает экипажу использовать летальную силу в качестве крайней меры, но он должен приоритизировать защиту своей рабочей зоны, а не охоту на культистов. Мёртвые члены экипажа должны быть возрождены и деконвертированы как только ситуация стабилизируется.", "Отдел ЦК по Делам Высших Измерений", 'sound/AI/commandreport.ogg')

/datum/game_mode/proc/cult_fall()
	cult_ascendant = FALSE
	for(var/datum/mind/M in cult)
		if(!ishuman(M.current))
			continue
		SEND_SOUND(M.current, sound('sound/hallucinations/wail.ogg'))
		to_chat(M.current, "<span class='cultlarge'>Завеса восстанавливается, мощь культа падает...</span>")
		addtimer(CALLBACK(src, PROC_REF(descend), M.current), 20 SECONDS)
	GLOB.major_announcement.Announce("Паранормальная активность вернулась к минимальному уровню. \
									Служба безопасности должна минимизировать летальную силу по культистам, по возможности используя нелетальную силу. \
									Все мёртвые культисты должны быть доставлены в медицинский отдел или робототехнику для немедленного воскрешения и деконвертации. \
									Остальной экипаж имеет право на самозащиту, но они должны приоритизровать покидание зон с культистами и докладам о них службе безопасности. \
									Самооборона позволяет экипажу использовать летальную силу как крайнюю меру. За охоту на культистов служба безопасности может посадить вас за массовое убийство. \
									Все доступы, полученные во время паранормальной активности, должны быть отозваны. \
									Любое выданное снаряжение должно быть возвращено. И последнее, всё оружие (в том числе самодельное) должно быть изъято у экипажа.",
									"Отдел ЦК по Делам Высших Измерений", 'sound/AI/commandreport.ogg')

/datum/game_mode/proc/rise(cultist)
	if(!ishuman(cultist) || !iscultist(cultist))
		return
	var/mob/living/carbon/human/H = cultist
	if(!H.original_eye_color)
		H.original_eye_color = H.get_eye_color()
	H.change_eye_color(BLOODCULT_EYE, FALSE)
	H.update_eyes()
	ADD_TRAIT(H, CULT_EYES, CULT_TRAIT)
	H.update_body()

/datum/game_mode/proc/ascend(cultist)
	if(!ishuman(cultist) || !iscultist(cultist))
		return
	var/mob/living/carbon/human/H = cultist
	new /obj/effect/temp_visual/cult/sparks(get_turf(H), H.dir)
	H.update_halo_layer()

/datum/game_mode/proc/descend(cultist)
	if(!ishuman(cultist) || !iscultist(cultist))
		return
	var/mob/living/carbon/human/H = cultist
	new /obj/effect/temp_visual/cult/sparks(get_turf(H), H.dir)
	H.update_halo_layer()
	to_chat(cultist, "<span class='userdanger'>Нимб над вашей головой рассыпается!</span>")
	playsound(cultist, "shatter", 50, TRUE)

/datum/game_mode/proc/update_cult_icons_added(datum/mind/cult_mind)
	var/datum/atom_hud/antag/culthud = GLOB.huds[ANTAG_HUD_CULT]
	if(cult_mind.current)
		culthud.join_hud(cult_mind.current)
		set_antag_hud(cult_mind.current, "hudcultist")

/datum/game_mode/proc/update_cult_icons_removed(datum/mind/cult_mind)
	var/datum/atom_hud/antag/culthud = GLOB.huds[ANTAG_HUD_CULT]
	if(cult_mind.current)
		culthud.leave_hud(cult_mind.current)
		set_antag_hud(cult_mind.current, null)

/datum/game_mode/proc/add_cult_actions(datum/mind/cult_mind)
	if(cult_mind.current)
		var/datum/action/innate/cult/comm/C = new
		var/datum/action/innate/cult/check_progress/D = new
		C.Grant(cult_mind.current)
		D.Grant(cult_mind.current)
		if(ishuman(cult_mind.current))
			var/datum/action/innate/cult/blood_magic/magic = new
			magic.Grant(cult_mind.current)
			var/datum/action/innate/cult/use_dagger/dagger = new
			dagger.Grant(cult_mind.current)
		cult_mind.current.update_action_buttons(TRUE)


/datum/game_mode/cult/declare_completion()
	if(cult_objs.cult_status == NARSIE_HAS_RISEN)
		SSticker.mode_result = "cult win - cult win"
		to_chat(world, "<span class='danger'> <FONT size = 3>Культ одерживает победу! Им удалось вызвать божество [SSticker.cultdat.entity_name]!</FONT></span>")
	else if(cult_objs.cult_status == NARSIE_HAS_FALLEN)
		SSticker.mode_result = "cult draw - narsie died, nobody wins"
		to_chat(world, "<span class='danger'> <FONT size = 3>Никто не выигрывает! [SSticker.cultdat.entity_name] было вызвано, но испарилось!</FONT></span>")
	else
		SSticker.mode_result = "cult loss - staff stopped the cult"
		to_chat(world, "<span class='warning'> <FONT size = 3>Экипажу удалось одолеть культ!</FONT></span>")

	var/list/endtext = list()
	endtext += "<br><b>Цели культа были:</b>"
	for(var/datum/objective/obj in cult_objs.presummon_objs)
		endtext += "<br>[obj.explanation_text] - "
		if(!obj.check_completion())
			endtext += "<font color='red'>Провал.</font>"
		else
			endtext += "<font color='green'><B>Успех!</B></font>"
	if(cult_objs.cult_status >= NARSIE_NEEDS_SUMMONING)
		endtext += "<br>[cult_objs.obj_summon.explanation_text] - "
		if(!cult_objs.obj_summon.check_completion())
			endtext+= "<font color='red'>Провал.</font>"
		else
			endtext += "<font color='green'><B>Успех!</B></font>"

	to_chat(world, endtext.Join(""))
	..()
