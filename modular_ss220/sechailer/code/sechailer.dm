GLOBAL_LIST_EMPTY(sechailers)

/datum/action/item_action/dispatch
	name = "Signal Dispatch"
	desc = "Открывает колесо быстрого выбора для сообщения о преступлениях, включая ваше текущее местоположение."
	button_icon_state = "dispatch"
	icon_icon = 'modular_ss220/sechailer/icons/sechailer.dmi'
	use_itemicon = FALSE

/obj/item/clothing/mask/gas/sechailer
	var/obj/item/radio/radio // For engineering alerts.
	var/dispatch_cooldown = 25 SECONDS
	var/is_on_cooldown = FALSE
	var/is_emped = FALSE
	actions_types = list(/datum/action/item_action/dispatch, /datum/action/item_action/halt, /datum/action/item_action/adjust, /datum/action/item_action/selectphrase)

/obj/item/clothing/mask/gas/sechailer/hos
	actions_types = list(/datum/action/item_action/dispatch, /datum/action/item_action/halt, /datum/action/item_action/selectphrase)

/obj/item/clothing/mask/gas/sechailer/warden
	actions_types = list(/datum/action/item_action/dispatch, /datum/action/item_action/halt, /datum/action/item_action/selectphrase)

/obj/item/clothing/mask/gas/sechailer/swat
	actions_types = list(/datum/action/item_action/dispatch, /datum/action/item_action/halt, /datum/action/item_action/selectphrase)

/obj/item/clothing/mask/gas/sechailer/blue
	actions_types = list(/datum/action/item_action/dispatch, /datum/action/item_action/halt, /datum/action/item_action/selectphrase)

/obj/item/clothing/mask/gas/sechailer/Destroy()
	qdel(radio)
	GLOB.sechailers -= src
	. = ..()

/obj/item/clothing/mask/gas/sechailer/Initialize()
	. = ..()
	GLOB.sechailers += src
	radio = new /obj/item/radio(src)
	radio.listening = FALSE
	radio.config(list("Security" = 0))
	radio.follow_target = src

/obj/item/clothing/mask/gas/sechailer/proc/dispatch(mob/user)
	var/area/A = get_location_name(src, TRUE) // get_location_name works better as affected says
	var/list/options = list()
	// Just hardcoded for now!
	for(var/option in list(
		"502 (Убийство)",
		"101 (Сопротивление Аресту)",
		"308 (Вторжение)",
		"305 (Мятеж)",
		"402 (Нападение на Офицера)"
		))
		options[option] = image(icon = 'modular_ss220/sechailer/icons/menu.dmi', icon_state = option)
	var/message = show_radial_menu(user, src, options)

	if(!message)
		return
	if(is_on_cooldown == TRUE && is_emped == FALSE) // If on cooldown
		to_chat(user, span_notice("Ожидайте. Система оповещения перезаряжается, примерное время восстановления: [dispatch_cooldown / 10] секунд."))
		return
	if(is_on_cooldown == TRUE && is_emped == TRUE) // If emped
		to_chat(user, span_notice("Ожидайте. Система оповещения в защитном режиме, примерное время восстановления: [dispatch_cooldown / 10] секунд."))
		return

	radio.autosay("Центр, Код [message], офицер [user] запрашивает помощь в [A].", "Система Оповещения", "Security", list(z))
	is_on_cooldown = TRUE
	addtimer(CALLBACK(src, PROC_REF(reboot)), dispatch_cooldown)
	for(var/atom/movable/hailer in GLOB.sechailers)
		if(hailer.loc && ismob(hailer.loc))
			playsound(hailer.loc, 'modular_ss220/sechailer/sound/dispatch_please_respond.ogg', 55, FALSE)

/obj/item/clothing/mask/gas/sechailer/proc/reboot()
	is_on_cooldown = FALSE
	is_emped = FALSE

/obj/item/clothing/mask/gas/sechailer/ui_action_click(mob/user, actiontype)
	. = ..()
	if(actiontype == /datum/action/item_action/dispatch)
		dispatch(user)

/obj/item/clothing/mask/gas/sechailer/emp_act(severity)
	if(is_on_cooldown)
		return
	is_on_cooldown = TRUE
	is_emped = TRUE
	addtimer(CALLBACK(src, PROC_REF(reboot)), dispatch_cooldown)
	if(ishuman(loc))
		var/mob/living/carbon/human/user = loc
		to_chat(user, span_userdanger("Обнаружен электромагнитный импульс, система оповещения отключена для сохранения работоспособности..."))
