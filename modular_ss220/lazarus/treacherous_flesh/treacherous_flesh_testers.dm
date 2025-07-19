/obj/item/treacherous_flesh_tester
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	new_attack_chain = TRUE

	var/positive_message = ""
	var/negative_message = ""

/obj/item/treacherous_flesh_tester/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(!ishuman(target))
		return ..()
	var/mob/living/carbon/human/human_target = target
	if(human_target.treacherous_flesh)
		user.visible_message(
			"<span class='boldwarning'>[positive_message]</span>",
			"<span class='boldwarning'>[positive_message]</span>",
			chat_message_type = MESSAGE_TYPE_INFO
		)
	else
		user.visible_message(
			"<span class='notice'>[negative_message]</span>",
			"<span class='notice'>[negative_message]</span>",
			chat_message_type = MESSAGE_TYPE_INFO
		)

/obj/item/treacherous_flesh_tester/covid
	name = "одноразовый тестер на космо-ковид"
	desc = "По описанию на этикетке, это устройство может проверить человека на заражение 'космо-ковидом'. Информация как о производителе, так и о том, что такое 'космо-ковид' отсутствует."
	icon = 'icons/obj/hypo.dmi'
	icon_state = "lazarus_hypo"
	item_state = "hypo"

	positive_message = "Тестер показывает красную лампочку, а также издаёт неприятный звук. Похоже, тест положительный."
	negative_message = "Тестер показывает зелёную лампочку, а также издаёт тихий пиликающий звук. Похоже, тест отрицательный."

	var/used = FALSE

/obj/item/treacherous_flesh_tester/covid/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(used)
		to_chat(user, span_notice("Тестер уже был использован."))
		return
	playsound(src,'sound/effects/refill.ogg',50,1)
	icon_state = "lazarus_empty"
	used = TRUE
	return ..()

/obj/item/treacherous_flesh_tester/artifact
	name = "странный кристалл"
	desc = "Странный синеватый кристалл, похоже, реагирует на заражённые ткани. Быть может, у вас получится найти ему применение?"
	icon_state = "purified_soulstone"
	icon = 'icons/obj/wizard.dmi'
	item_state = "electronic"

	positive_message = "Кристалл выпускает синеватое свечение, когда его подносят к цели."
	negative_message = "Кристалл никак не реагирует."
