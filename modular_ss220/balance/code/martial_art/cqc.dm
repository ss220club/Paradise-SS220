/datum/martial_art/cqc
	///variable for 3 minutes break neck CD
	var/break_neck_cd = FALSE

/// returns ability to use hands to victim after harm act in hands
/datum/martial_art/cqc/proc/off_hand_pain(mob/defender)
	if(!defender)
		return
	REMOVE_TRAIT(defender, TRAIT_BLOCKED_HANDS, "cqc_harm_act")

/// attack for combo with same name and attack from horizontal position
/datum/martial_art/cqc/proc/takedown(mob/living/carbon/human/attacker, mob/living/carbon/human/defender)
	defender.visible_message("<span class='warning'>[attacker] leg sweeps [defender]!", \
						"<span class='userdanger'>[attacker] leg sweeps you!</span>")
	playsound(get_turf(attacker), 'sound/effects/hit_kick.ogg', 10, TRUE, -1)
	defender.KnockDown(5 SECONDS)
	attacker.SetKnockDown(0 SECONDS)
	defender.Paralyse(1 SECONDS)
	attacker.resting = FALSE
	attacker.stand_up() //Quickly get up like the cool dude you are.
	add_attack_logs(attacker, defender, "Melee attacked with martial-art [src] : takedown", ATKLOG_ALL)

/datum/martial_combo/cqc/restrain/perform_combo(mob/living/carbon/human/user, mob/living/target, datum/martial_art/MA)
	var/datum/martial_art/cqc/CQC = MA
	if(!istype(CQC))
		return MARTIAL_COMBO_FAIL
	if(CQC.restraining)
		return MARTIAL_COMBO_FAIL
	if(!target.stat)
		target.visible_message("<span class='warning'>[user] locks [target] into a restraining position!</span>", \
							"<span class='userdanger'>[user] locks you into a restraining position!</span>")
		for(var/obj/item/grab/G in target.grabbed_by)
			if(G.assailant != user)
				continue
			//target unable to do something while in grab
			ADD_TRAIT(target, TRAIT_MUTE, name)
			ADD_TRAIT(target, TRAIT_EMOTE_MUTE, name)
			ADD_TRAIT(target, TRAIT_HANDS_BLOCKED, name)
			RegisterSignal(target, COMSIG_GRAB_RELEASE, PROC_REF(drop_mute))
			break
		CQC.restraining = TRUE
		addtimer(VARSET_CALLBACK(CQC, restraining, FALSE), 5 SECONDS, TIMER_UNIQUE) // end of period for neck break and sleep combos
		add_attack_logs(user, target, "Melee attacked with martial-art [src] : Restrain", ATKLOG_ALL)
		return MARTIAL_COMBO_DONE
	return MARTIAL_COMBO_FAIL

/// return ability do something to victim after release from grab
/datum/martial_combo/cqc/restrain/proc/drop_mute(mob/living/carbon/human/affecting, mob/living/carbon/human/assailant)
	SIGNAL_HANDLER
	UnregisterSignal(affecting, COMSIG_GRAB_RELEASE)
	REMOVE_TRAIT(affecting, TRAIT_MUTE, name)
	REMOVE_TRAIT(affecting, TRAIT_EMOTE_MUTE, name)
	REMOVE_TRAIT(affecting, TRAIT_HANDS_BLOCKED, name)

/// finish of break neck combo
/datum/martial_art/cqc/proc/break_neck(mob/living/carbon/human/defender, mob/living/carbon/human/attacker)
	defender.visible_message("<span class='warning'>[attacker] breaks [defender]'s neck!</span>", \
							"<span class='userdanger'>[attacker] breaks your neck!</span>")
	defender.apply_damage(50, BRUTE)
	var/obj/item/organ/external/head = defender.bodyparts_by_name["head"]
	head.fracture()
	break_neck_cd = TRUE
	addtimer(VARSET_CALLBACK(src, break_neck_cd, FALSE), 3 MINUTES) // cooldown

/// finish of artery smash combo(hrrrrr mimimimi)
/datum/martial_art/cqc/proc/artery_smash(mob/living/carbon/human/defender, mob/living/carbon/human/attacker)
	defender.visible_message("<span class='danger'>[attacker] hits [defender]'s carotid artery!</span>", \
						"<span class='userdanger'>[attacker] hits your carotid artery!</span>")
	add_attack_logs(attacker, defender, "Hit carotid artery with martial-art [src]", ATKLOG_ALL)
	defender.SetSleeping(40 SECONDS)

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

/datum/martial_combo/cqc/advanced
	name = "Advanced CQC"
	steps = list(MARTIAL_COMBO_STEP_HARM, MARTIAL_COMBO_STEP_HELP, MARTIAL_COMBO_STEP_GRAB, MARTIAL_COMBO_STEP_HARM, MARTIAL_COMBO_STEP_DISARM)
	explaination_text = "Заставляет цель выранить предмет в руке вне зависимости от того, насколько коепкая хватка."

/datum/martial_combo/cqc/advanced/perform_combo(mob/living/carbon/human/user, mob/living/target, datum/martial_art/MA)
	var/mob/living/carbon/human/human_target = target
	if(!istype(human_target) || istype(human_target.get_active_hand(), /obj/item/kitchen/knife))
		return MARTIAL_COMBO_DONE_BASIC_HIT
	if(target.drop_item_to_ground(human_target.get_active_hand(), TRUE))
		target.apply_damage(25, STAMINA)
	return MARTIAL_COMBO_DONE

/datum/martial_combo/cqc/adaptive
	name = "Adaptive reception"
	steps = list(MARTIAL_COMBO_STEP_DISARM, MARTIAL_COMBO_STEP_HARM, MARTIAL_COMBO_STEP_HARM, MARTIAL_COMBO_STEP_HARM, MARTIAL_COMBO_STEP_HARM, MARTIAL_COMBO_STEP_HARM, MARTIAL_COMBO_STEP_HARM)
	explaination_text = "Заставляет цель выранить предмет в руке вне зависимости от того, насколько коепкая хватка."

/datum/martial_combo/cqc/adaptive/perform_combo(mob/living/carbon/human/user, mob/living/target, datum/martial_art/MA)
	var/mob/living/carbon/human/human_target = target
	if(!istype(human_target))
		return MARTIAL_COMBO_DONE_BASIC_HIT
	human_target.Paralyse(10 SECONDS, TRUE)
	return MARTIAL_COMBO_DONE

/datum/martial_combo/cqc/takedown
	name = "Takedown"
	steps = list(MARTIAL_COMBO_STEP_HARM, MARTIAL_COMBO_STEP_DISARM, MARTIAL_COMBO_STEP_HARM, MARTIAL_COMBO_STEP_DISARM)
	explaination_text = "Позволяет уронить противника, так будто удар наносится из положения лежа"

/datum/martial_combo/cqc/takedown/perform_combo(mob/living/carbon/human/user, mob/living/target, datum/martial_art/MA)
	if(!istype(target, /mob/living/carbon/human))
		return MARTIAL_COMBO_DONE_BASIC_HIT
	var/datum/martial_art/cqc/CQC = MA
	CQC.takedown(user, target)
	return MARTIAL_COMBO_DONE
