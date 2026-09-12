/obj/item/hand_valuer
	name = "ручной оценщик"
	desc = "Приспособление воксов для оценки стоимости объекта."
	icon = 'modular_ss220/antagonists/icons/trader_machine.dmi'
	icon_state = "valuer"
	inhand_icon_state = "camera_bug"
	var/obj/machinery/vox_trader/connected_trader

/obj/item/hand_valuer/examine(mob/user)
	. = ..()
	if(!isvox(user))
		. += SPAN_NOTICE("Выглядит непонятно. Как воксы этим пользуются?")

/obj/item/hand_valuer/afterattack__legacy__attackchain(atom/target, mob/user, proximity, params)
	if(!proximity)
		return

	if(!isvox(user))
		to_chat(user, SPAN_WARNING("Кажется вы тыкаете не той стороной... Или [name] не работает? Да как воксы этим пользуются?!"))
		return

	if(!connected_trader)
		to_chat(user, SPAN_WARNING("Невозможно получить сведения с оценочной базы данных. Подключите устройство."))
		return

	if(!isobj(target))
		to_chat(user, SPAN_NOTICE("Данный объект не поддается оценке."))
		return

	if(!connected_trader.check_usable(user))
		return

	var/value = connected_trader.get_value(user, list(target), TRUE)
	to_chat(user, chat_box_notice(SPAN_GREEN("Ценность [target.name]: [value]")))

/obj/item/hand_valuer/proc/connect(mob/living/user, obj/machinery/vox_trader/input_trader)
	to_chat(user, SPAN_GREEN("Устройство [connected_trader ? "пере" : ""]инициализировано в системе."))
	playsound(src, 'modular_ss220/antagonists/sound/guns/m79_unload.ogg', 50, 1)
	icon_state = "[initial(icon_state)]-on"
	connected_trader = input_trader
