/datum/spell/horsemask
	name = "Curse of the Horseman"
	desc = "Накладывает проклятие на цель, заставляя ее носить несъемную маску лошади и говорить как лошадь. Все маски на цели будут уничтожены. Для этого заклинания не требуется роба волшебника."
	base_cooldown = 150
	clothes_req = FALSE
	invocation = "KN'A FTAGHU, PUCK 'BTHNK!"
	invocation_type = "shout"
	cooldown_min = 30 //30 deciseconds reduction per rank

	selection_activated_message = SPAN_NOTICE("Вы начинаете тихо произносить заклинание. Нажмите на цель или рядом с ней, чтобы применить его.")
	selection_deactivated_message = SPAN_NOTICE("Вы перестаёте тихо ржать.")

	action_icon_state = "barn"
	sound = 'sound/magic/HorseHead_curse.ogg'

/datum/spell/horsemask/create_new_targeting()
	var/datum/spell_targeting/click/T = new()
	T.selection_type = SPELL_SELECTION_RANGE
	return T


/datum/spell/horsemask/cast(list/targets, mob/user = usr)
	if(!length(targets))
		to_chat(user, SPAN_NOTICE("Нет целей поблизости."))
		return

	var/mob/living/carbon/human/target = targets[1]

	if(target.can_block_magic(antimagic_flags))
		target.visible_message(SPAN_DANGER("Лицо [target.declent_ru(GENITIVE)] охватывает пламя, которое мгновенно вырывается наружу, не причинив [target.declent_ru(DATIVE)] вреда!"),
			SPAN_DANGER("Ваше лицо начинает гореть, но пламя отражается вашей антимагической защитой!"),
		)
		to_chat(user, SPAN_WARNING("Заклинание не дало эффекта!"))
		return FALSE

	var/obj/item/clothing/mask/horsehead/magichead = new /obj/item/clothing/mask/horsehead
	magichead.flags |= DROPDEL	//curses!
	magichead.set_nodrop(TRUE)
	magichead.flags_inv = null	//so you can still see their face
	magichead.voicechange = TRUE	//NEEEEIIGHH
	target.visible_message(	SPAN_DANGER("Лицо [target.declent_ru(GENITIVE)] озаряется пламенем, а после на его месте появляется голова лошади!"), \
							SPAN_DANGER("Ваше лицо горит, и вскоре вы понимаете, что у вас лошадиная морда!"))
	if(!target.drop_item_to_ground(target.wear_mask))
		qdel(target.wear_mask)
	target.equip_to_slot_if_possible(magichead, ITEM_SLOT_MASK, TRUE, TRUE)

	target.flash_eyes()
