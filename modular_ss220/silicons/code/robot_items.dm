/* Engineer */
// Небольшой багфикс "непрозрачного открытого шлюза"
/obj/structure/inflatable/door/operate()
	. = ..()
	opacity = FALSE

// Голопроектор и улучшенные варианты //
/obj/item/holosign_creator/atmos/basic
	name = "ATMOS holofan projector"
	desc = "Стандартный модуль ATMOS голопроектора, предназначенный для использования инженерными киборгами. Создаваемые голопроекции полностью блокируют перемещение газов.\
		<br>Количество создаваемых голопроекций снижено до одной относительно немодульного аналога в целях снижения энергопотребления."
	icon = 'modular_ss220/silicons/icons/robot_tools.dmi'
	icon_state = "atmos_holofan"
	max_signs = 1

/obj/item/holosign_creator/atmos/better
	name = "upgraded ATMOS holofan projector"
	desc = "Улучшенный модуль ATMOS голопроектора, предназначенный для использования инженерными киборгами.\
		<br>Количество создаваемых голопроекций увеличено до 3 за счёт применения улучшенных материалов."
	icon = 'modular_ss220/silicons/icons/robot_tools.dmi'
	icon_state = "atmos_holofan_better"
	max_signs = 3

/obj/item/holosign_creator/atmos/best
	name = "advanced ATMOS holofan projector"
	desc = "Продвинутый модуль ATMOS голопроектора, предназначенный для использования инженерными киборгами.\
		<br>Количество создаваемых голопроекций увеличено до 5 за счёт точечной оптимизации микросхем и применения редких материалов."
	icon = 'modular_ss220/silicons/icons/robot_tools.dmi'
	icon_state = "atmos_holofan_best"
	max_signs = 5

/* Medical */
/obj/item/reagent_containers/borghypo
	name = "hypospray"
	desc = "Простейший гипоспрей для киборгов, позволяющий оказывать медицинскую помощь в чрезвычайных ситуациях."
	reagent_ids = list("salglu_solution", "epinephrine", "charcoal", "sal_acid", "salbutamol")
	volume = 30


/obj/item/reagent_containers/borghypo/upgraded
	name = "upgraded hypospray"
	desc = "Усовершенствованный гипоспрей для киборгов, позволяющий оказывать качественную медицинскую помощь."
	reagent_ids = list("salglu_solution", "epinephrine", "charcoal", "sal_acid", "salbutamol", "spaceacillin", "hydrocodone", "mannitol")
	volume = 60

/* Service */
/obj/item/eftpos/cyborg
	name = "Silicon EFTPOS"
	desc = "Проведите ID картой для оплаты налогов."
	transaction_purpose = "Оплата счета от робота."

/obj/item/eftpos/cyborg/Initialize(mapload)
	. = ..()
	transaction_purpose = "Оплата счета от [usr.name]."

/obj/item/eftpos/ui_act(action, list/params, datum/tgui/ui)
	var/mob/living/user = ui.user

	switch(action)
		if("toggle_lock")
			if(transaction_locked)
				if(!check_user_position(user))
					return
				transaction_locked = FALSE
				transaction_paid = FALSE
			else if(linked_account)
				transaction_locked = TRUE
			else
				to_chat(user, SPAN_WARNING("[bicon(src)]No account connected to send transactions to.<"))
			return TRUE
	. = ..()
