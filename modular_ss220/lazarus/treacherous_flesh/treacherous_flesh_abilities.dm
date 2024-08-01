#define EVOLUTION_BONUS 150

// Basic

/datum/action/treacherous_flesh
	/// Amount of chemicals required to use
	var/chemical_cost = 0

	/// Reference to user
	var/mob/living/treacherous_flesh/user = null

	/// Usable in case of host death
	var/ignore_death = FALSE

	button_background_icon_state = "bg_flesh"
	button_overlay_icon = 'modular_ss220/lazarus/icons/lazarus_actions.dmi'
	button_background_icon = 'modular_ss220/lazarus/icons/lazarus_actions.dmi'

/datum/action/treacherous_flesh/New(var/mob/living/treacherous_flesh/new_user)
	user = new_user

/datum/action/treacherous_flesh/proc/activate()
	return TRUE

/datum/action/treacherous_flesh/Trigger(left_click)
	if(!..())
		return FALSE
	if(!user.host)
		to_chat(user, span_warning("У вас отсутствует носитель. Этого быть не должно. Обратитесь к эвент-мастеру, чтобы вам помогли."))
		return FALSE
	if(!ignore_death && user.host.stat == DEAD)
		to_chat(user, span_warning("Ваш носитель должен быть жив для совершения данного действия."))
		return FALSE
	return activate()


/datum/action/treacherous_flesh/proc/take_chems()
	if(user.chemicals < chemical_cost)
		to_chat(usr, span_warning("Для этого вам нужно [chemical_cost] химикатов."))
		return FALSE
	user.chemicals -= chemical_cost
	return TRUE

/datum/action/treacherous_flesh/toggle
	var/is_active = FALSE

// Message host

/datum/action/treacherous_flesh/message_host
	name = "Сообщить носителю"
	desc = "Мы подключаемся к мозгу носителя, и посылаем ему некоторое сообщение. Носитель будет воспринимать наши слова как странный голос в голове. Носитель не может ответить нам без слов , пока мы не установим с ним контакт, но может использовать шёпот, чтобы скрыть разговор с нами."
	button_overlay_icon_state = "message"
	chemical_cost = 0

/datum/action/treacherous_flesh/message_host/activate()
	var/msg = clean_input("Сообщение:", "Сообщение для носителя")
	if(!msg)
		return
	if(user.host.client)
		if(user.host.client.holder)
			to_chat(user.host, "<b>Вы слышите голос в своей голове... <i>[msg]</i></b>")
	return TRUE

// Contact host

/datum/action/treacherous_flesh/contact_host
	name = "Установить контакт"
	desc = "Мы закрепляемся в сознании нашего носителя, раскрывая своё существование и устанавливая постоянный контакт. После этого носитель будет знать, что мы находимся в нём и сможет коммуницировать с нами посредством телепатии. Однако наша истинная природа будет ему неизвестна."
	button_overlay_icon_state = "contact_host"
	chemical_cost = 0
	var/in_use = FALSE

/datum/action/treacherous_flesh/contact_host/activate()
	if(!in_use)
		in_use = TRUE
		var/confirm = alert(usr, "Вы уверены, что хотите установить контакт с носителем? Он моментально узнает о нашем присутствии и сможет телепатически общаться с нами.","Установить контакт?","Да","Нет")
		if(confirm == "Да")
			Remove(user)
			for(var/datum/action/treacherous_flesh/message_host/mes_host in user.actions)
				mes_host.Remove(user)
			var/datum/action/com_host = new /datum/action/treacherous_flesh/communicate_host(user)
			var/datum/action/com_parasite = new /datum/action/communicate_parasite(user)
			com_host.Grant(user)
			com_parasite.Grant(user.host)
			return TRUE
		in_use = FALSE
	return FALSE


// Communicate host

/datum/action/treacherous_flesh/communicate_host
	name = "Разговаривать с носителем"
	desc = "Мы транслируем сообщение в разум носителя. Носитель поймёт, что оно исходит от нас."
	button_overlay_icon_state = "message"
	chemical_cost = 0

/datum/action/treacherous_flesh/communicate_host/activate()
	var/msg = clean_input("Сообщение:", "Сообщение для носителя")
	if(!msg)
		return
	to_chat(user, "<b>[user.name]: <i>[msg]</i></b>")
	to_chat(user.host, "<b>[user.name]: <i>[msg]</i></b>")

// Communicate parasite

/datum/action/communicate_parasite
	name = "Разговаривать с гостем"
	desc = "Проговорив фразу про себя, вы способны передать её гостю, что обитает в вашем сознании."
	button_overlay_icon_state = "message"

/datum/action/communicate_parasite/Trigger(left_click)
	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/host = src
		if(host.treacherous_flesh)
			var/msg = clean_input("Сообщение:", "Сообщение для гостя")
			if(!msg)
				return
			to_chat(host, "<b>[host.name]: <i>[msg]</i></b>")
			to_chat(host.treacherous_flesh, "<b>[host.name]: <i>[msg]</i></b>")

// Speed Up Evolution

/datum/action/treacherous_flesh/speed_up_evolution
	name = "Ускорить эволюцию"
	desc = "Ускоряет процесс нашего развития за счёт химикатов. Даёт намёк на заражение носителю и окружающим людям. Может нанести вред носителю. Используйте тогда, когда ваш носитель и окружающие его люди заняты. Стоит 100 химикатов"
	button_overlay_icon_state = "speed_up_evolution"
	chemical_cost = 100

/datum/action/treacherous_flesh/speed_up_evolution/activate()
	if(!take_chems())
		return FALSE
	to_chat(user, span_notice("Мы бросаем все наши силы на то, чтобы углубиться в тело носителя, сливаясь с его организмом в единое целое."))
	switch(rand(0, 5))
		if(0 to 2)
			to_chat(user, span_notice("Эволюционный скачок произошёл без проблем. В этот раз нам повезло"))
		if(3)
			to_chat(user, span_attack("В ходе эволюционного скачка мы случайно задели нерв в голове носителя, повредив его мозг. Наверное это было больно."))
			to_chat(user.host, span_attack("Голову пронзает невероятноя боль. Вы едва не теряете сознание от этого. Будто что-то скребёт внутри..."))
			user.host.adjustBrainLoss(10)
			user.host.adjustStaminaLoss(50)
			user.host.pain("head", 90)
			user.host.emote("scream")
		if(4)
			to_chat(user, span_attack("В ходе эволюционного скачка мы случайно повредили вестибулярный аппарат носителя. Это сильно дизориентирует его."))
			to_chat(user.host, span_attack("Внезапно всё вокруг вас начинает двигаться, а ноги обмякать. Вы теряете равновесие..."))
			user.host.AdjustDizzy(10 SECONDS)
			user.host.adjustStaminaLoss(100)
			user.host.AdjustConfused(10 SECONDS)
			user.host.emote("scream")
		if(5)
			to_chat(user, span_attack("В ходе эволюционного скачка мы случайно отделили от себя незавимого биоморфа, который сразу же начал вырываться наружу из тела носителя."))
			to_chat(user.host, span_attack("Вы чувствуете острую боль в груди. Через мгновение до вас доходит: непонятное насекомовидное существо прогрызает путь наружу через вашу плоть."))
			user.host.emote("scream")
			user.host.adjustBruteLoss(20)
			user.host.Jitter(5 SECONDS)
			sleep(5 SECONDS)
			user.host.emote("scream")
			user.host.adjustBruteLoss(20)
			playsound(user.host.loc, 'sound/effects/bone_break_5.ogg', 100, 0)
			new /mob/living/simple_animal/hostile/flesh_biomorph/lesser/small(user.host.loc)
	user.evolution_points += EVOLUTION_BONUS
	return TRUE

// Fleshmend

/datum/action/treacherous_flesh/fleshmend
	name = "Быстрое исцеление"
	desc = "Мы быстро исцеляем нашего носителя. Не лечит переломы, внутреннее кровотечение и органы. При частом использовании эффективность снижается. Стоит 30 химикатов."
	button_overlay_icon_state = "fleshmend"
	chemical_cost = 30

/datum/action/treacherous_flesh/fleshmend/activate()
	if(!take_chems())
		return FALSE
	to_chat(user, span_notice("Вы заставляете тело носителя быстро восстанавливаться."))
	to_chat(user.host, span_notice("Ваше тело странным образом начало очень быстро регенерировать"))
	if(user.host.has_status_effect(STATUS_EFFECT_FLESHMEND))
		to_chat(user, span_notice("Из-за слишком частого использования эффективность снизлась"))
		to_chat(user.host, span_notice("Похоже регенерация происходит не так хорошо как раньше..."))
	user.host.apply_status_effect(STATUS_EFFECT_FLESHMEND)
	return TRUE

// Adrenaline

/datum/action/treacherous_flesh/adrenaline
	name = "Передозировка адреналином"
	desc = "Мы вводим в носителя ударную дозу адреналина, снимая оглушение и ускоряя передвижение. При частом использовании может навредить носителю. Стоит 50 химикатов"
	button_overlay_icon_state = "adrenaline"
	chemical_cost = 50

/datum/action/treacherous_flesh/adrenaline/activate()
	if(!take_chems())
		return FALSE
	to_chat(user, "<span class='notice'>От адреналина в крови сердце носителя начинает бешено колотиться.</span>")
	to_chat(user.host, "<span class='warning'>Вы внезапно чувствуете огромный прилив сил и энергии.</span>")
	user.host.SetSleeping(0)
	user.host.WakeUp()
	user.host.SetParalysis(0)
	user.host.SetStunned(0)
	user.host.SetWeakened(0)
	user.host.setStaminaLoss(0)
	user.host.SetKnockDown(0)
	user.host.stand_up(TRUE)
	SEND_SIGNAL(user.host, COMSIG_LIVING_CLEAR_STUNS)
	user.host.reagents.add_reagent("synaptizine", 15)
	user.host.reagents.add_reagent("stimulative_cling", 1)
	return TRUE


// Panacea

/datum/action/treacherous_flesh/panacea
	name = "Анатомическая панацея"
	desc = "Мы вводим в тело носителя ряд биоактивных элементов, вычищая из него токсины, радиацию и мутировавшие трани, а также восстанавливая нервную систему. Стоит 50 химикатов"
	button_overlay_icon_state = "panacea"
	chemical_cost = 50

/datum/action/treacherous_flesh/panacea/activate()
	if(!take_chems())
		return FALSE
	to_chat(user, "<span class='notice'>Панацея распространяется по телу, зачищая его от ядов.</span>")
	to_chat(user.host, "<span class='notice'>По телу расплывается приятное прохладное ощущение.</span>")

	var/obj/item/organ/internal/body_egg/egg = user.host.get_int_organ(/obj/item/organ/internal/body_egg)
	if(egg)
		egg.remove(user)
		if(iscarbon(user))
			var/mob/living/carbon/human/C = user.host
			C.vomit()
		egg.forceMove(get_turf(user))
	user.host.reagents.add_reagent("mutadone", 1)
	user.host.apply_status_effect(STATUS_EFFECT_PANACEA)
	for(var/thing in user.host.viruses)
		var/datum/disease/D = thing
		if(D.severity == NONTHREAT)
			continue
		D.cure()

	return TRUE

// Regrow Organs

/datum/action/treacherous_flesh/regrow_organs
	name = "Отрастить органы"
	desc = "Мы вводим в организм большое колличество вещества, стимулярующего производство стволовых клеток. Носитель отращивает все потерянные конечности, а также восстанавлиет и отращивает все органы. Стоит 150 химикатов."
	button_overlay_icon_state = "regrow_organs"
	chemical_cost = 100

/datum/action/treacherous_flesh/regrow_organs/activate()
	if(!take_chems())
		return FALSE
	to_chat(user, "<span class='notice'>Химикаты растекаются по телу, за секунды формируя новые ткани, а затем и сложные структуры.</span>")
	to_chat(user.host, "<span class='warning'>Вы чувствуете невероятную боль. Кожа пузырится и на месте отсутствующих культей формируются новый, здоровые конечности. Вас тошнит.</span>")
	user.host.emote("scream")

	user.host.check_and_regenerate_organs(src)

	return TRUE

// Heat Up

/datum/action/treacherous_flesh/heat_up
	name = "Органическая грелка"
	desc = "Повышает температуру тела носителя на 1500 единиц, помогая тому согреться или дольше продержаться на улице. Стоит 20 химикатов."
	button_overlay_icon_state = "heat_up"
	chemical_cost = 20

/datum/action/treacherous_flesh/heat_up/activate()
	if(!take_chems())
		return FALSE
	to_chat(user, "<span class='notice'>Вы тратите часть химикатов на повышения температуры тела носителя</span>")
	to_chat(user.host, "<span class='notice'>По телу пробегает странная волна тепла. Вам становится очень комфортно.</span>")
	user.host.frostbite = clamp(user.host.frostbite + 1500, 0, FROSTBITE_WARM)
	return TRUE

// Armblade

/datum/action/treacherous_flesh/toggle/armblade
	name = "Рука-лезвие"
	desc = "Мы преобразуем руку носителя в смертельное лезвие. Стоит 25 химикатов. Поддержание не стоит химикатов."
	button_overlay_icon_state = "armblade"
	chemical_cost = 25

/datum/action/treacherous_flesh/toggle/armblade/activate()
	if(is_active)
		to_chat(user, "<span class='notice'>Мы преобразуем руку-клинок обратно в нормальную конечность.</span>")
		to_chat(user.host, "<span class='warning'>Вы вновь чувствуете невероятную боль в руке. Похоже, странная рука-лезвие вновь превратилось в вашу обычную конечность.</span>")
		user.host.emote("scream")
		playsound(user.host.loc, 'sound/effects/bone_break_2.ogg', 100, TRUE)
		if(istype(user.host.l_hand, /obj/item/melee/arm_blade))
			qdel(user.host.l_hand)
			user.host.update_inv_l_hand()
		if(istype(user.host.r_hand, /obj/item/melee/arm_blade))
			qdel(user.host.r_hand)
			user.host.update_inv_r_hand()
		is_active = FALSE
	else
		if(!take_chems())
			return FALSE
		to_chat(user, "<span class='notice'>Используя податливые ткани носителя, мы формируем острый клинок из его руки.</span>")
		to_chat(user.host, "<span class='warning'>Вы чувствуете невероятную боль в своей руке. Плоть пузырится и рвётся, преобразуя вашу конечность в острое лезвие.</span>")
		user.host.emote("scream")
		SEND_SIGNAL(user.host, COMSIG_MOB_WEAPON_APPEARS)
		if(!user.host.drop_item())
			to_chat(user, "[user.host.get_active_hand()] застрял в руке носителя. Мы не можем вырастить руку-лезвие на ней.")
			return FALSE
		var/obj/item/W = new /obj/item/melee/arm_blade(user.host, src)
		user.host.put_in_hands(W)
		playsound(user.host.loc, 'sound/effects/bone_break_1.ogg', 100, TRUE)
		is_active = TRUE
		return TRUE

// Chitinous Armor

/datum/action/treacherous_flesh/toggle/chitin_armor
	name = "Хитиновый панцирь"
	desc = "Мы покрываем тело носителя прочным хитиновым панцирем. Стоит 40 химикатов. Поддержание не стоит химикатов."
	button_overlay_icon_state = "chitin_armor"
	chemical_cost = 40

/datum/action/treacherous_flesh/toggle/chitin_armor/activate()
	if(is_active)
		to_chat(user, "<span class='notice'>Мы разрушаем панцирь, вновь обнажая уязвимую плоть носителя миру.</span>")
		to_chat(user.host, "<span class='warning'>Вы вновь чувствуете невероятную боль по всему телу. Панцирь начинает раскалываться и вскоре полностью спадает.</span>")
		user.host.emote("scream")
		qdel(user.host.head)
		qdel(user.host.wear_suit)
		is_active = FALSE
	else
		if(!take_chems())
			return FALSE
		if(!user.host.unEquip(user.host.wear_suit))
			to_chat(user, "\the [user.host.wear_suit] застрял на теле, мы не можем вырастить панцирь на нём!")
			return FALSE
		if(!user.unEquip(user.host.head))
			to_chat(user, "\the [user.host.head] застрял на голове, мы не можем вырастить панцирь на ней!")
			return FALSE

		to_chat(user, "<span class='notice'>Используя податливые ткани носителя, мы формируем прочный панцирь из его эпидермиса.</span>")
		to_chat(user.host, "<span class='warning'>Вы чувствуете невероятную боль по всему телу. Плоть пузырится и рвётся, покрывая вас неким подобием хитинового панциря.</span>")
		user.host.emote("scream")
		user.host.unEquip(user.host.head)
		user.host.unEquip(user.host.wear_suit)
		user.host.equip_to_slot_if_possible(new /obj/item/clothing/suit/armor/changeling(user), SLOT_HUD_OUTER_SUIT, TRUE, TRUE)
		user.host.equip_to_slot_if_possible(new /obj/item/clothing/head/helmet/changeling(user), SLOT_HUD_HEAD, TRUE, TRUE)
		is_active = TRUE
		return TRUE

/datum/action/treacherous_flesh/passive/proc/disable()
	return

// Passive Infestation

/datum/action/treacherous_flesh/passive/passive_infest
	name = "Пассивное заражение"
	desc = "Переключается режим пассивного заражения. Если включено, то вся пища, медикаменты, жидкости и оперируемые пациенты, которых трогал наш носитель, будут заражаться образцами наших тканей. Потребляет много химикатов пока активно."
	button_overlay_icon_state = "passive_infest_off"

/datum/action/treacherous_flesh/passive/passive_infest/activate()
	if(user.infecting)
		to_chat(user, "<span class='notice'>Мы прекратили выделять заражающие ткани.</span>")
		user.infecting = FALSE
		button_overlay_icon_state = "passive_infest_off"
	else
		if(user.chemicals > 2)
			to_chat(user, "<span class='notice'>Мы начинаем выделять заражающие ткани.</span>")
			user.infecting = TRUE
			button_overlay_icon_state = "passive_infest_on"
	UpdateButtons()
	return TRUE

/datum/action/treacherous_flesh/passive/passive_infest/disable()
	if(user.infecting)
		to_chat(user, "<span class='notice'>Мы больше не можем поддерживать выделение заражающих тканей</span>")
		user.infecting = FALSE
		button_overlay_icon_state = "passive_infest_off"
		UpdateButtons()

// Enslave Mind

/datum/action/treacherous_flesh/enslave_mind
	name = "Поработить разум"
	desc = "Мы ассимилируем центральную нервную систему носителя, превращая того в послушного раба, подчиняющегося всем нашим приказам. Во время подчинения носитель будет странно себя вести. Не работает на носителей имлпанта \"Щит разума\". Стоит 150 химикатов. Проверить на наличие импланта можно без траты химикатов."
	button_overlay_icon_state = "enslave_mind"
	chemical_cost = 150
	var/in_use = FALSE

/datum/action/treacherous_flesh/enslave_mind/activate()
	if(ismindshielded(user.host))
		to_chat(user, "<span class='warning'>Какая-то железка в мозгу носителя не даёт нам начать ассимиляцию!</span>")
		return FALSE
	if(in_use)
		return FALSE
	in_use = TRUE
	var/confirm = alert(usr, "Мы уверены что хотим поработить разум носителя? Столь грубое вмешательство в его организм не может остаться незамеченным как для него, так и для окружающих.","Поработить разум?","Да","Нет")
	if(confirm != "Да")
		in_use = FALSE
		return FALSE
	if(!take_chems())
		in_use = FALSE
		return FALSE
	to_chat(user, "<span class='notice'>Мы начинаем ассимиляцию нервной системы носителя. Он, вероятно, испытывает сейчас невероятную боль.</span>")
	to_chat(user.host, "<span class='boldwarning'>Внезапный порыв боли пронзает всё ваше тело. Вы не знаете что происходит, но каждую секунду агония становится всё сильнее.</span>")
	user.host.emote("scream")
	user.host.adjustStaminaLoss(30)

	sleep(10 SECONDS)

	user.host.emote("scream")
	user.host.adjustStaminaLoss(30)
	user.host.Jitter(45 SECONDS)
	to_chat(user.host, "<span class='boldwarning'>Всё ваше тело будто варят заживо, а внутренности разрывают на куски. Вы хотите содрать с себя кожу.</span>")

	sleep(5 SECONDS)

	user.host.emote("gasp")
	user.host.adjustStaminaLoss(30)

	sleep(5 SECONDS)

	user.host.emote("scream")
	to_chat(user.host, "<span class='biggerdanger'>Вы хотите умереть.</span>")
	user.host.adjustStaminaLoss(30)

	sleep(10 SECONDS)

	user.host.emote("laugh")
	SEND_SOUND(user.host, 'sound/ambience/antag/ling_alert.ogg')
	to_chat(user, "<span class='notice'>Мы окончательно подавили сопротивление носителя. Теперь он будет слушать все наши приказы.</span>")
	to_chat(user.host, "<span class='biggerdanger'>Боль открыла мне глаза. В моём теле находится величайшее благославление вселенной. Я мессия, призванный принести в этот мир нечто прекрасное. Голос в моей голове скажет что мне нужно делать. Я должен во всём ему подчиняться. Он - мой хозяин и владыка. Мораль, семья, служба - всё это неважно. Я повинуюсь своему господину.</span>")
	user.host_enslaved = TRUE
	qdel(src)
	return TRUE

// Leave the body

/datum/action/treacherous_flesh/leave_the_body
	name = "Покинуть тело"
	desc = "Мы экстренно покидаем тело носителя, вырываясь в несформированном состоянии низшего биоморфа. При этом мы теряем любой контроль над носителем и сильно раним его тело. Можно использовать даже при смерти носителя."
	button_overlay_icon_state = "leave_the_body"
	ignore_death = TRUE
	var/in_use = FALSE

/datum/action/treacherous_flesh/leave_the_body/activate()
	if(in_use)
		return FALSE
	in_use = TRUE
	var/confirm = alert(usr, "Мы уверены что хотим покинуть тело? Мы не сможем вернуться и навсегда останемся недоразвитым куском мяса.","Покинуть тело?","Да","Нет")
	if(confirm != "Да")
		in_use = FALSE
		return FALSE
	user.host.Jitter(8 SECONDS)
	sleep(8 SECONDS)
	playsound(user.host.loc, 'sound/effects/bone_break_5.ogg', 100, 0)
	user.host.emote("scream")
	user.host.adjustStaminaLoss(100)
	var/mob/living/simple_animal/hostile/flesh_biomorph/lesser/M
	switch(user.evolution_stage)
		if(EVOLUTION_STAGE_0 to EVOLUTION_STAGE_1)
			user.host.adjustBruteLoss(60)
			M = new /mob/living/simple_animal/hostile/flesh_biomorph/lesser/small(user.host.loc)
		if(EVOLUTION_STAGE_2)
			user.host.adjustBruteLoss(120)
			M = new /mob/living/simple_animal/hostile/flesh_biomorph/lesser/medium(user.host.loc)
		if(EVOLUTION_STAGE_3 to EVOLUTION_STAGE_4)
			user.host.adjustBruteLoss(200)
			M = new /mob/living/simple_animal/hostile/flesh_biomorph/lesser/large(user.host.loc)
	M.client = user.client
	user.disinfest()

// Take Control
/datum/action/treacherous_flesh/take_control
	name = "Захватить контроль"
	desc = "Мы перехватываем контроль переферией нервной системы носителя, получая возможность управлять всеми его действиями, включая речь и жесты. К сожалению, во время такого контроля мы не способны использовать наши особые силы. Мы сможем вернуть контроль над телом носителю в любой момент."
	button_overlay_icon_state = "take_control"
	var/in_use = FALSE

/datum/action/treacherous_flesh/take_control/activate()
	if(in_use)
		return FALSE
	if(!isnull(user.trapped_mind))
		return FALSE
	in_use = TRUE
	var/confirm = alert(usr, "Мы уверены что хотим захватить контроль над телом носителя?","Захватить тело?","Да","Нет")
	if(confirm != "Да")
		in_use = FALSE
		return FALSE

	// HOST TO TRAPPED MIND
	// Spawning trapped mind
	var/mob/living/trapped_mind/temp_mind = new /mob/living/trapped_mind(user.host)
	user.trapped_mind = temp_mind

	// Moving host to trapped mind
	user.trapped_mind.name = user.host.real_name
	user.trapped_mind.ckey = user.host.ckey

	// FLESH TO HOST BODY
	user.host.ckey = user.ckey

	// Granting return action
	var/datum/action/return_control/A = new()
	A.Grant(user.host)
	in_use = FALSE

	return TRUE

// Return Control
/datum/action/return_control
	name = "Вернуть контроль"
	desc = "Мы возвращаем контроль над телом носителю."
	button_overlay_icon_state = "return_control"
	button_background_icon_state = "bg_flesh"
	button_overlay_icon = 'modular_ss220/lazarus/icons/lazarus_actions.dmi'
	button_background_icon = 'modular_ss220/lazarus/icons/lazarus_actions.dmi'
	var/in_use = FALSE

/datum/action/return_control/Trigger(left_click)
	if(!..())
		return FALSE
	if(in_use)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/host = owner
	if(isnull(host.treacherous_flesh.trapped_mind))
		return FALSE
	in_use = TRUE
	var/confirm = alert(usr, "Мы уверены что хотим вернуть контроль над телом носителю?","Вернуть контроль?","Да","Нет")
	if(confirm != "Да")
		in_use = FALSE
		return FALSE

	host.treacherous_flesh.ckey = host.ckey

	host.ckey = host.treacherous_flesh.trapped_mind.ckey

	// Clearing
	qdel(host.treacherous_flesh.trapped_mind)
	host.treacherous_flesh.trapped_mind = null // Sometimes garbage collector left it there for some time, but we need this being null for checks
	qdel(src)
	return TRUE

// Emit Pheromones

/datum/action/treacherous_flesh/passive/emit_pheromones
	name = "Выделять феромоны"
	desc = "Переключает режим выделения феромонов. Пока мы выделяем феромоны, мутанты и порождения Матери не будут атаковать нашего носителя, принимая его за своего."
	button_overlay_icon_state = "pheromones_off"
	var/is_active = FALSE

/datum/action/treacherous_flesh/passive/emit_pheromones/activate()
	if(is_active)
		to_chat(user, "<span class='notice'>Мы прекратили выделять феромоны.</span>")
		user.host.faction.Remove("treacherous_flesh")
		is_active = FALSE
		button_overlay_icon_state = "pheromones_off"
	else
		to_chat(user, "<span class='notice'>Мы начинаем выделять феромоны.</span>")
		user.host.faction.Add("treacherous_flesh")
		is_active = TRUE
		button_overlay_icon_state = "pheromones_on"
	UpdateButtons()
	return TRUE

#undef EVOLUTION_BONUS
#undef EVOLUTION_STAGE_0
#undef EVOLUTION_STAGE_1
#undef EVOLUTION_STAGE_2
#undef EVOLUTION_STAGE_3
#undef EVOLUTION_STAGE_4
