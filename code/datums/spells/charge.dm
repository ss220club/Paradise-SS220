/datum/spell/charge
	name = "Charge"
	desc = "Заклинание может заряжать самые разные предметы в ваших руках. Творческий волшебник может даже использовать его для наделения магической силой своего товарища по магии."
	base_cooldown = 1 MINUTES
	clothes_req = FALSE
	invocation = "DIRI CEL"
	invocation_type = "whisper"
	cooldown_min = 400 //50 deciseconds reduction per rank
	action_icon_state = "charge"

/datum/spell/charge/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/charge/cast(list/targets, mob/user = usr)
	for(var/mob/living/L in targets)
		var/list/hand_items = list(L.get_active_hand(),L.get_inactive_hand())
		var/charged_item = null
		var/burnt_out = FALSE

		if(L.pulling && (isliving(L.pulling)))
			var/mob/living/M =	L.pulling
			if(length(M.mob_spell_list) != 0 || (M.mind && length(M.mind.spell_list) != 0))
				for(var/datum/spell/S in M.mob_spell_list)
					S.cooldown_handler.revert_cast()
				if(M.mind)
					for(var/datum/spell/S in M.mind.spell_list)
						S.cooldown_handler.revert_cast()
				to_chat(M, SPAN_NOTICE("Вы чувствуете необузданную энергию внутри себя, как же это приятно!"))
			else
				to_chat(M, SPAN_NOTICE("На мгновение вы чувствуете себя очень странно, но потом чувство проходит."))
				burnt_out = TRUE
			charged_item = M
			break
		for(var/obj/item in hand_items)
			if(istype(item, /obj/item/spellbook))
				if(istype(item, /obj/item/spellbook/oneuse))
					var/obj/item/spellbook/oneuse/I = item
					if(prob(80))
						L.visible_message(SPAN_WARNING("[I] загорается!"))
						qdel(I)
					else
						I.used = FALSE
						charged_item = I
						break
				else
					to_chat(L, SPAN_CAUTION("На обложке книги появляются светящиеся красные символы..."))
					to_chat(L, SPAN_WARNING("[pick("ХОРОШАЯ ПОПЫТКА, НО НЕ СЕГОДНЯ!", "УМНО, НО НЕДОСТАТОЧНО!", "КАКОЙ ГЕНИАЛЬНЫЙ ЖУЛИК, БУДЕШЬ РАБОТАТЬ У НАС!", "МИЛО!", "ВЫ ЖЕ НЕ ДУМАЛИ, ЧТО ЭТО БУДЕТ ТАК ПРОСТО, НЕ ТАК ЛИ?")]"))
					burnt_out = TRUE
			else if(istype(item, /obj/item/book/granter))
				var/obj/item/book/granter/I = item
				if(prob(80))
					L.visible_message(SPAN_WARNING("[I] загорается!"))
					qdel(I)
				else
					I.uses += 1
					charged_item = I
					break

			else if(istype(item, /obj/item/gun/magic))
				var/obj/item/gun/magic/I = item
				if(prob(80) && !I.can_charge)
					I.max_charges--
				if(I.max_charges <= 0)
					I.max_charges = 0
					burnt_out = TRUE
				I.charges = I.max_charges
				if(istype(item,/obj/item/gun/magic/wand) && I.max_charges != 0)
					var/obj/item/gun/magic/W = item
					W.icon_state = initial(W.icon_state)
				charged_item = I
				break
			else if(istype(item, /obj/item/stock_parts/cell/))
				var/obj/item/stock_parts/cell/C = item
				C.charge = C.maxcharge
				charged_item = C
				break
			else if(item.contents)
				var/obj/I = null
				for(I in item.contents)
					if(istype(I, /obj/item/stock_parts/cell/))
						var/obj/item/stock_parts/cell/C = I
						C.charge = C.maxcharge
						item.update_icon()
						charged_item = item
						break
		if(!charged_item)
			to_chat(L, SPAN_NOTICE("Вы чувствуете, как к вашим рукам приливает сила, но это ощущение быстро исчезает..."))
		else if(burnt_out)
			to_chat(L, SPAN_CAUTION("[charged_item] похоже, не реагирует на заклинание..."))
		else
			to_chat(L, SPAN_NOTICE("[charged_item] внезапно становится очень горячим!"))
