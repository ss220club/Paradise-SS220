/obj/item/rlf
	name = "rapid lollipop fabricator"
	desc = "A device used to rapidly deploy lollipop."
	icon = 'modular_ss220/silicons/icons/robot_tools.dmi'
	icon_state = "rlf"
	new_attack_chain = TRUE

/obj/item/rlf/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(!isrobot(user) || !iscarbon(target))
		return NONE

	user.changeNext_move(CLICK_CD_MELEE)
	var/mob/living/carbon/receiver = target
	if(receiver.stat != CONSCIOUS)
		to_chat(user, SPAN_WARNING("[receiver] can't accept any items because they're not conscious!"))
		return ITEM_INTERACT_COMPLETE
	if(!user.Adjacent(receiver))
		to_chat(user, SPAN_WARNING("You need to be closer to [receiver] to offer them lollipop."))
		return ITEM_INTERACT_COMPLETE
	if(!receiver.client)
		to_chat(user, SPAN_WARNING("You offer lollipop to [receiver], but they don't seem to respond..."))
		return ITEM_INTERACT_COMPLETE
	var/obj/item/I = new /obj/item/food/candy/sucker/lollipop
	receiver.throw_alert("take item [I.UID()]", /atom/movable/screen/alert/take_item/RLF, alert_args = list(user, receiver, I))
	to_chat(user, SPAN_INFO("You offer lollipop to [receiver]."))
	return ITEM_INTERACT_COMPLETE

/atom/movable/screen/alert/take_item/RLF/Click(location, control, params)
	var/mob/living/receiver = locateUID(receiver_UID)
	if(receiver.stat != CONSCIOUS)
		return
	var/obj/item/food/candy/sucker/I = locateUID(item_UID)
	if(receiver.r_hand && receiver.l_hand)
		to_chat(receiver, SPAN_WARNING("You need to have your hands free to accept [I]!"))
		return
	var/mob/living/giver = locateUID(giver_UID)
	if(!isrobot(giver))
		return
	if(!giver.Adjacent(receiver))
		to_chat(receiver, SPAN_WARNING("You need to stay in reaching distance of [giver] to take [I]!"))
		return
	UnregisterSignal(I, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))
	var/mob/living/silicon/robot/borg = giver
	borg.cell.charge -= 500
	I.forceMove(get_turf(giver))
	receiver.put_in_hands(I)
	I.add_fingerprint(receiver)
	I.on_give(giver, receiver)
	receiver.visible_message(SPAN_NOTICE("[giver] handed [I] to [receiver]."))
	receiver.clear_alert("take item [item_UID]")

/obj/item/food/candy/sucker/lollipop
	name = "lollipop"
	desc = "For being such a courage patient!"
	icon_state = "sucker"
	filling_color = "#60A584"
	list_reagents = list("sugar" = 4)

/obj/item/food/candy/sucker/lollipop/New()
	. = ..()
	icon_state = pick("sucker_blue", "sucker_green", "sucker_orange", "sucker_purple", "sucker_red", "sucker_yellow")
