/obj/item/hand_valuer
	name = "ручной оценщик"
	desc = "Приспособление воксов для оценки стоимости объекта."
	icon = 'modular_ss220/antagonists/icons/trader_machine.dmi'
	icon_state = "gps-s"
	item_state = "camera_bug"
	var/obj/machinery/vox_trader/connected_trader

/obj/item/hand_valuer/examine(mob/user)
	. = ..()
	if(!isvox(user))
		. += span_notice("Выглядит непонятно. Как воксы этим пользуются?")

/obj/item/hand_valuer/afterattack(atom/target, mob/user, proximity, params)
	if(!proximity)
		return

	if(!isvox(user))
		to_chat(span_warning("Кажется вы тыкаете не той стороной... Или [name] не работает? Да как воксы этим пользуются?!"))
		return

	if(!connected_trader)
		to_chat(span_warning("Невозможно получить сведения с оценочной базы данных. Подключите устройство."))
		return

	if(!isobj(target))
		to_chat(span_notice("Данный объект не поддается оценке."))
		return

	if(!connected_trader.check_usable(user))
		return

	var/value = connected_trader.get_value(list(target))
	to_chat(span_green("Ценность [target.name]: [value]"))
