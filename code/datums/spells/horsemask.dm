/datum/spell/horsemask
	name = "Curse of the Horseman"
	desc = "Это заклинание накладывает проклятие на цель, заставляя ее носить несъемную маску лошадиной головы и говорить как лошадь. Все маски, которые надеты на цель, будут уничтожены. Для этого заклинания не требуется роба волшебника."
	base_cooldown = 150
	clothes_req = FALSE
	invocation = "KN'A FTAGHU, PUCK 'BTHNK!"
	invocation_type = "shout"
	cooldown_min = 30 //30 deciseconds reduction per rank

	selection_activated_message = "<span class='notice'>Вы начинаете тихо произносить заклинание. Нажмите на цель или рядом с ней, чтобы произнести заклинание.</span>"
	selection_deactivated_message = "<span class='notice'>Вы перестаёте тихо ржать.</span>"

	action_icon_state = "barn"
	sound = 'sound/magic/HorseHead_curse.ogg'

/datum/spell/horsemask/create_new_targeting()
	var/datum/spell_targeting/click/T = new()
	T.selection_type = SPELL_SELECTION_RANGE
	return T


/datum/spell/horsemask/cast(list/targets, mob/user = usr)
	if(!length(targets))
		to_chat(user, "<span class='notice'>Нет целей поблизости.</span>")
		return

	var/mob/living/carbon/human/target = targets[1]

	if(target.can_block_magic(antimagic_flags))
		target.visible_message("<span class='danger'>Лицо [target.declent_ru(GENITIVE)] охватывает пламя, которое мгновенно вырывается наружу, оставляя [target.declent_ru(GENITIVE)] невредимым!</span>",
			"<span class='danger'>Твое лицо начинает гореть, но пламя отражается твоей антимагической защитой!</span>",
		)
		to_chat(user, "<span class='warning'>Заклинание не дало эффекта!</span>")
		return FALSE

	var/obj/item/clothing/mask/horsehead/magichead = new /obj/item/clothing/mask/horsehead
	magichead.flags |= DROPDEL	//curses!
	magichead.set_nodrop(TRUE)
	magichead.flags_inv = null	//so you can still see their face
	magichead.voicechange = TRUE	//NEEEEIIGHH
	target.visible_message(	"<span class='danger'>Лицо [target.declent_ru(GENITIVE)] озаряется пламенем, а после на его месте появляется голова лошади!</span>", \
							"<span class='danger'>Твое лицо горит, и вскоре ты понимаешь, что у тебя лошадиная морда!</span>")
	if(!target.drop_item_to_ground(target.wear_mask))
		qdel(target.wear_mask)
	target.equip_to_slot_if_possible(magichead, ITEM_SLOT_MASK, TRUE, TRUE)

	target.flash_eyes()
