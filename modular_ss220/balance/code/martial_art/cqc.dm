/datum/martial_art/cqc
	var/break_neck_cd = FALSE

/datum/martial_combo/cqc/restrain/perform_combo(mob/living/carbon/human/user, mob/living/target, datum/martial_art/MA)
	var/datum/martial_art/cqc/CQC = MA
	if(!istype(CQC))
		return MARTIAL_COMBO_FAIL
	if(CQC.restraining)
		return MARTIAL_COMBO_FAIL
	if(!target.stat)
		target.visible_message("<span class='warning'>[user] locks [target] into a restraining position!</span>", \
							"<span class='userdanger'>[user] locks you into a restraining position!</span>")

		ADD_TRAIT(target, TRAIT_MUTE, name)
		ADD_TRAIT(target, TRAIT_EMOTE_MUTE, name)
		ADD_TRAIT(target, TRAIT_PACIFISM, name)
		CQC.restraining = TRUE
		addtimer(CALLBACK(CQC, TYPE_PROC_REF(/datum/martial_art/cqc, drop_restraining), target), 5 SECONDS, TIMER_UNIQUE)
		add_attack_logs(user, target, "Melee attacked with martial-art [src] : Restrain", ATKLOG_ALL)
		return MARTIAL_COMBO_DONE
	return MARTIAL_COMBO_FAIL

/datum/martial_art/cqc/proc/break_neck(mob/living/carbon/human/defender, mob/living/carbon/human/attacker)
	defender.visible_message("<span class='warning'>[attacker] breaks [defender]'s neck!</span>", \
							"<span class='userdanger'>[attacker] breaks your neck!</span>")
	defender.apply_damage(50, BRUTE)
	var/obj/item/organ/external/head = defender.bodyparts_by_name["head"]
	head.fracture()
	break_neck_cd = TRUE
	addtimer(VARSET_CALLBACK(src, break_neck_cd, FALSE), 3 MINUTES, TIMER_UNIQUE)

/datum/martial_art/cqc/proc/artery_smash(mob/living/carbon/human/defender, mob/living/carbon/human/attacker)
	defender.visible_message("<span class='danger'>[attacker] hits [defender]'s carotid artery!</span>", \
						"<span class='userdanger'>[attacker] hits your carotid artery!</span>")
	add_attack_logs(attacker, defender, "Hit carotid artery with martial-art [src]", ATKLOG_ALL)
	defender.SetSleeping(40 SECONDS)

/datum/martial_art/cqc/drop_restraining(mob/living/carbon/human/target)
	restraining = FALSE
	REMOVE_TRAIT(target, TRAIT_MUTE, name)
	REMOVE_TRAIT(target, TRAIT_EMOTE_MUTE, name)
	REMOVE_TRAIT(target, TRAIT_PACIFISM, name)

/datum/martial_combo/cqc/punch
	name = "Punch CQC"
	steps = list(MARTIAL_COMBO_STEP_HARM, MARTIAL_COMBO_STEP_HARM)
	explaination_text = "Обычный удар CQC до тех пор пока в руках противника не появляются щит или нож. Выбивает их из рук врага а также наносит урон стамине."

/datum/martial_combo/cqc/punch/perform_combo(mob/living/carbon/human/user, mob/living/target, datum/martial_art/MA)
	. = MARTIAL_COMBO_DONE_BASIC_HIT
	for(var/obj/item/hand_item in list(target.l_hand, target.r_hand))
		if(istype(hand_item, /obj/item/kitchen/knife))
			target.drop_item_to_ground(hand_item)
			target.apply_damage(25, STAMINA)
			user.put_in_hands(hand_item)
			. = MARTIAL_COMBO_DONE
		if(istype(hand_item, /obj/item/shield))
			target.apply_damage(50, STAMINA)
			target.apply_damage(25, BRUTE)
			target.drop_item_to_ground(hand_item)
			target.throw_at(get_step(target, user.dir), 2, 3, user)
			. = MARTIAL_COMBO_DONE
