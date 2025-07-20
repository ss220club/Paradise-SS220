/obj/structure/event_console
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	var/icon_keyboard = "tech_key"
	var/icon_screen = "comm"
	var/light_range_on = 2
	var/light_power_on = 0.9

/obj/structure/event_console/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/event_console/update_overlays()
	. = ..()
	if(icon_keyboard)
		. += "[icon_keyboard]"
		underlays += emissive_appearance(icon, "[icon_keyboard]_lightmask")
	var/icon/emissive_avg_screen_color = new(icon, icon_screen)
	emissive_avg_screen_color.Scale(1, 1)
	var/screen_emissive_color = copytext(emissive_avg_screen_color.GetPixel(1, 1), 1, 8) // remove opacity
	set_light(light_range_on, light_power_on, screen_emissive_color)
	. += "[icon_screen]"

/obj/structure/event_console/shuttle_console
	name = "консоль коммуникации"
	desc = "Консоль, способная отправить сигнал бедствия."

/obj/structure/event_console/shuttle_console/attack_hand(mob/living/user)
	if(!ishuman(user))
		return ..()
	if(SSticker.quarantine)
		to_chat(user, span_boldwarning("Объект находится на карантине. Вызов помощи невозможен. Обратитесь к администрации колонии за помощью."))
		return
	if(!SSticker.shuttle_called)
		var/confirm = alert(user, "Вы уверены что хотите отправить сигнал бедствия? Это действие нельзя отменить.","Отправить сигналл бедствия?","Да","Нет")
		if(confirm != "Да")
			return
		SSticker.shuttle_called = TRUE
		to_chat(user, span_notice("Сигнал бедствия был отправлен."))
		message_admins("(ИВЕНТ) ИГРОКИ ОТПРАВИЛИ СИГНАЛ БЕДСТВИЯ.")
	return

/obj/structure/event_console/quarantine
	name = "консоль управления карантином"
	desc = "Консоль, благодаря которой можно отключить процедуры карантина на объекте."

/obj/structure/event_console/quarantine/attack_hand(mob/living/user)
	if(!ishuman(user))
		return ..()
	if(!SSticker.quarantine)
		to_chat(user, span_notice("Объект уже снят с карантина"))
		return
	var/confirm = alert(user, "Вы уверены что хотите отправить снять карантин? Это действие нельзя отменить.","Снять карантин?","Да","Нет")
	if(confirm != "Да")
		return
	SSticker.quarantine = FALSE
	to_chat(user, span_notice("Карантин был снят."))
	message_admins("(ИВЕНТ) ИГРОКИ СНЯЛИ КАРАНТИН.")
	return
