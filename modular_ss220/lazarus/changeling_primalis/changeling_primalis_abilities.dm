/*
TODO:

Скилл на общение с хостом. ГОТОВ
Скилл на ремонт органов. ГОТОВ
Скилл на крик.
Скилл на заражение. ГОТОВ
Скилл на перехват контроля.
Скилл на вознесение.
*/

#define EVOLUTION_BONUS 150

// Basic

/datum/action/changeling_primalis
	/// Amount of chemicals required to use
	var/chemical_cost = 0
	/// Reference to user
	var/mob/living/simple_animal/changeling_primalis/user = null
	button_background_icon_state = "bg_flesh"
	button_overlay_icon = 'modular_ss220/lazarus/icons/lazarus_actions.dmi'
	button_background_icon = 'modular_ss220/lazarus/icons/lazarus_actions.dmi'

/datum/action/changeling_primalis/New(var/mob/living/simple_animal/changeling_primalis/new_user)
	user = new_user

/datum/action/changeling_primalis/proc/activate()
	return TRUE

/datum/action/changeling_primalis/Trigger(left_click)
	if(..() != FALSE)
		if(!user.host)
			to_chat(user, span_warning("У вас отсутствует носитель. Этого быть не должно. Обратитесь к эвент-мастеру, чтобы вам помогли."))
			return FALSE
		return activate()
	return FALSE

/datum/action/changeling_primalis/proc/take_chems()
	if(user.chemicals < chemical_cost)
		to_chat(usr, span_warning("Для этого вам нужно [chemical_cost] химикатов."))
		return FALSE
	user.chemicals -= chemical_cost
	return TRUE

/datum/action/changeling_primalis/toggle
	var/is_active = FALSE

// Message host

/datum/action/changeling_primalis/message_host
	name = "Сообщить носителю"
	desc = "Мы подключаемся к мозгу носителя, и посылаем ему некоторое сообщение. Носитель будет воспринимать наши слова как странный голос в голове. Носитель не может ответить нам, пока мы не установим с ним контакт, но может использовать шёпот, чтобы скрыть разговор с нами."
	button_overlay_icon_state = "message"
	chemical_cost = 0

/datum/action/changeling_primalis/message_host/activate()
	var/msg = clean_input("Сообщение:", "Сообщение для носителя")
	if(!msg)
		return
	if(user.host.client)
		if(user.host.client.holder)
			to_chat(user.host, "<b>Вы слышите голос в своей голове... <i>[msg]</i></b>")
	return TRUE

// Contact host

/datum/action/changeling_primalis/contact_host
	name = "Установить контакт"
	desc = "Мы закрепляемся в сознании нашего носителя, раскрывая своё существование и устанавливая постоянный контакт. После этого носитель будет знать, что мы находимся в нём и сможет коммуницировать с нами посредством телепатии. Однако наша истинная природа будет ему неизвестна."
	button_overlay_icon_state = "contact_host"
	chemical_cost = 0
	var/in_use = FALSE

/datum/action/changeling_primalis/contact_host/activate()
	if(!in_use)
		in_use = TRUE
		var/confirm = alert(usr, "Вы уверены, что хотите установить контакт с носителем? Он моментально узнает о нашем присутствии и сможет телепатически общаться с нами.","Установить контакт?","Да","Нет")
		if(confirm == "Да")
			Remove(user)
			for(var/datum/action/changeling_primalis/message_host/mes_host in user.actions)
				mes_host.Remove(user)
			var/datum/action/com_host = new /datum/action/changeling_primalis/communicate_host(user)
			var/datum/action/com_parasite = new /datum/action/communicate_parasite(user)
			com_host.Grant(user)
			com_parasite.Grant(user.host)
			return TRUE
		in_use = FALSE
	return FALSE


// Communicate host

/datum/action/changeling_primalis/communicate_host
	name = "Разговаривать с носителем"
	desc = "Мы транслируем сообщение в разум носителя. Носитель поймёт, что оно исходит от нас."
	button_overlay_icon_state = "message"
	chemical_cost = 0

/datum/action/changeling_primalis/communicate_host/activate()
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
		if(host.changeling_primalis)
			var/msg = clean_input("Сообщение:", "Сообщение для гостя")
			if(!msg)
				return
			to_chat(host, "<b>[host.name]: <i>[msg]</i></b>")
			to_chat(host.changeling_primalis, "<b>[host.name]: <i>[msg]</i></b>")

// Speed Up Evolution

/datum/action/changeling_primalis/speed_up_evolution
	name = "Ускорить эволюцию"
	desc = "Ускоряет процесс нашего развития за счёт химикатов. Даёт намёк на заражение носителю и окружающим людям. Может нанести вред носителю. Используйте тогда, когда ваш носитель и окружающие его люди заняты. Стоит 100 химикатов"
	button_overlay_icon_state = "speed_up_evolution"
	chemical_cost = 100

/datum/action/changeling_primalis/speed_up_evolution/activate()
	if(!take_chems())
		return FALSE
	to_chat(user, span_notice("Мы бросаем все наши силы на то, чтобы углубиться в тело носителя, сливаясь с его организмом в единое целое."))
	switch(rand(0, 5))
		if(0 to 5)
			to_chat(user.host, span_attack("Голову пронзает невероятноя боль. Вы едва не теряете сознание от этого. Будто что-то скребёт внутри..."))
			user.host.adjustBrainLoss(10)
			user.host.adjustStaminaLoss(50)
			user.host.pain("head", 90)
	user.evolution_points += EVOLUTION_BONUS
	return TRUE

// Fleshmend

/datum/action/changeling_primalis/fleshmend
	name = "Быстрое исцеление"
	desc = "Мы быстро исцеляем нашего носителя. Не лечит переломы, внутреннее кровотечение и органы. При частом использовании эффективность снижается. Стоит 30 химикатов."
	button_overlay_icon_state = "fleshmend"
	chemical_cost = 30

/datum/action/changeling_primalis/fleshmend/activate()
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

/datum/action/changeling_primalis/adrenaline
	name = "Передозировка адреналином"
	desc = "Мы вводим в носителя ударную дозу адреналина, снимая оглушение и ускоряя передвижение. При частом использовании может навредить носителю. Стоит 50 химикатов"
	button_overlay_icon_state = "adrenaline"
	chemical_cost = 50

/datum/action/changeling_primalis/adrenaline/activate()
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

/datum/action/changeling_primalis/panacea
	name = "Анатомическая панацея"
	desc = "Мы вводим в тело носителя ряд биоактивных элементов, вычищая из него токсины, радиацию и мутировавшие трани, а также восстанавливая нервную систему. Стоит 50 химикатов"
	button_overlay_icon_state = "panacea"
	chemical_cost = 50

/datum/action/changeling_primalis/panacea/activate()
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

/datum/action/changeling_primalis/regrow_organs
	name = "Отрастить органы"
	desc = "Мы вводим в организм большое колличество вещества, стимулярующего производство стволовых клеток. Носитель отращивает все потерянные конечности, а также восстанавлиет и отращивает все органы. Стоит 150 химикатов."
	button_overlay_icon_state = "regrow_organs"
	chemical_cost = 150

/datum/action/changeling_primalis/regrow_organs/activate()
	if(!take_chems())
		return FALSE
	to_chat(user, "<span class='notice'>Химикаты растекаются по телу, за секунды формируя новые ткани, а затем и сложные структуры.</span>")
	to_chat(user.host, "<span class='warning'>Вы чувствуете невероятную боль. Кожа пузырится и на месте отсутствующих культей формируются новый, здоровые конечности. Вас тошнит.</span>")
	user.host.emote("scream")

	user.host.check_and_regenerate_organs(src)

	return TRUE

// Heat Up

/datum/action/changeling_primalis/heat_up
	name = "Органическая грелка"
	desc = "Повышает температуру тела носителя на 1500 единиц, помогая тому согреться или дольше продержаться на улице. Стоит 20 химикатов."
	button_overlay_icon_state = "heat_up"
	chemical_cost = 20

/datum/action/changeling_primalis/heat_up/activate()
	if(!take_chems())
		return FALSE
	to_chat(user, "<span class='notice'>Вы тратите часть химикатов на повышения температуры тела носителя</span>")
	to_chat(user.host, "<span class='notice'>По телу пробегает странная волна тепла. Вам становится очень комфортно.</span>")
	user.host.frostbite = clamp(user.host.frostbite + 1500, 0, FROSTBITE_WARM)
	return TRUE

// Armblade

/datum/action/changeling_primalis/toggle/armblade
	name = "Рука-лезвие"
	desc = "Мы преобразуем руку носителя в смертельное лезвие. Стоит 25 химикатов. Поддержание не стоит химикатов."
	button_overlay_icon_state = "armblade"
	chemical_cost = 25

/datum/action/changeling_primalis/toggle/armblade/activate()
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

/datum/action/changeling_primalis/toggle/chitin_armor
	name = "Хитиновый панцирь"
	desc = "Мы покрываем тело носителя прочным хитиновым панцирем. Стоит 40 химикатов. Поддержание не стоит химикатов."
	button_overlay_icon_state = "chitin_armor"
	chemical_cost = 40

/datum/action/changeling_primalis/toggle/chitin_armor/activate()
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

/datum/action/changeling_primalis/passive/proc/disable()
	return

/datum/action/changeling_primalis/passive/passive_infest
	name = "Пассивное заражение"
	desc = "Переключается режим пассивного заражения. Если включено, то вся пища, медикаменты, жидкости и оперируемые пациенты, которых трогал наш носитель, будут заражаться образцами наших тканей. Потребляет много химикатов пока активно."
	button_overlay_icon_state = "passive_infest_off"

/datum/action/changeling_primalis/passive/passive_infest/activate()
	if(user.infecting)
		to_chat(user, "<span class='notice'>Мы прекратили выделять заражающие ткани.</span>")
		user.infecting = FALSE
		button_overlay_icon_state = "passive_infest_off"
	else
		to_chat(user, "<span class='notice'>Мы начинаем выделять заражающие ткани.</span>")
		user.infecting = TRUE
		button_overlay_icon_state = "passive_infest_on"
	UpdateButtons()
	return TRUE

/datum/action/changeling_primalis/passive/passive_infest/disable()
	if(user.infecting)
		to_chat(user, "<span class='notice'>Мы больше не можем поддерживать выделение заражающих тканей</span>")
		user.infecting = FALSE
		button_overlay_icon_state = "passive_infest_off"
		UpdateButtons()

