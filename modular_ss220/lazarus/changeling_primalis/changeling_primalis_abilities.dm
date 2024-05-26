// Basic

/datum/action/changeling_primalis
	/// Amount of chemicals required to use
	var/chemical_cost = 0
	/// Reference to user
	var/mob/living/simple_animal/changeling_primalis/user = null
	background_icon_state = "bg_changeling"

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

// Fleshmend

/datum/action/changeling_primalis/fleshmend
	name = "Быстрое исцеление"
	desc = "Быстро исцеляет нашего носителя. Не лечит переломы, внутреннее кровотечение и органы. При частом использовании эффективность снижается. Стоит 30 химикатов."
	button_icon_state = "fleshmend"
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

// Epinephrine

/datum/action/changeling_primalis/epinephrine
	name = "Передозировка адреналином"
	desc = "Вводит в носителя ударную дозу адреналина, снимая оглушение и ускоряя его. При частом использовании может навредить носителю. Стоит 50 химикатов"
	button_icon_state = "adrenaline"
	chemical_cost = 50

/datum/action/changeling_primalis/epinephrine/activate()
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

// Heat Up

/datum/action/changeling_primalis/heat_up
	name = "Органическая грелка"
	desc = "Повышает температуру тела носителя на 1500 единиц, помогая тому согреться или дольше продержаться на улице. Стоит 20 химикатов"
	button_icon_state = "heat_up"
	chemical_cost = 20

/datum/action/changeling_primalis/heat_up/activate()
	if(!take_chems())
		return FALSE
	to_chat(user, "<span class='notice'>Вы тратите часть химикатов на повышения температуры тела носителя</span>")
	to_chat(user.host, "<span class='warning'>По телу пробегает странная волна тепла. Вам становится очень комфортно.</span>")
	user.host.frostbite = clamp(user.host.frostbite + 1500, 0, FROSTBITE_WARM)
	return TRUE

// Armblade

/datum/action/changeling_primalis/toggle/armblade
	name = "Рука-лезвие"
	desc = "Мы преобразуем руку носителя в смертельное лезвие. Стоит 25 химикатов. Поддержание не стоит химикатов."
	button_icon_state = "armblade"
	chemical_cost = 25

/datum/action/changeling_primalis/toggle/armblade/activate()
	if(is_active)
		to_chat(user, "<span class='notice'>Мы преобразуем руку-клинок обратно в нормальную конечность.</span>")
		to_chat(user.host, "<span class='warning'>Вы вновь чувствуете невероятную боль в руке. Похоже, странная рука-лезвие вновь превратилось в вашу обычную конечность.</span>")
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
	button_icon_state = "chitinous_armor"
	chemical_cost = 40

/datum/action/changeling_primalis/toggle/chitin_armor/activate()
	if(is_active)
		to_chat(user, "<span class='notice'>Мы разрушаем панцирь, вновь обнажая уязвимую плоть носителя миру.</span>")
		to_chat(user.host, "<span class='warning'>Вы вновь чувствуете невероятную боль по всему телу. Панцирь начинает раскалываться и вскоре полностью спадает.</span>")
		user.host.unEquip(user.host.head)
		user.host.unEquip(user.host.wear_suit)
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

		to_chat(user, "<span class='notice'>Используя податливые ткани носителя, мы формируете прочный панцирь из его эпидермиса.</span>")
		to_chat(user.host, "<span class='warning'>Вы чувствуете невероятную боль по всему телу. Плоть пузырится и рвётся, покрывая вас неким подобием хитинового панциря.</span>")
		user.host.unEquip(user.host.head)
		user.host.unEquip(user.host.wear_suit)
		user.host.equip_to_slot_if_possible(new /obj/item/clothing/suit/armor/changeling(user), SLOT_HUD_OUTER_SUIT, TRUE, TRUE)
		user.host.equip_to_slot_if_possible(new /obj/item/clothing/head/helmet/changeling(user), SLOT_HUD_HEAD, TRUE, TRUE)
		is_active = TRUE
		return TRUE
