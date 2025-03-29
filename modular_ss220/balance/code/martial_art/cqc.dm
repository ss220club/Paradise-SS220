/datum/martial_art/cqc
	///variable for 3 minutes break neck CD
	combos = list(/datum/martial_combo/cqc/restrain, /datum/martial_combo/cqc/punch, /datum/martial_combo/cqc/takedown, /datum/martial_combo/cqc/adaptive, /datum/martial_combo/cqc/advanced) //SS220 EDIT
	var/break_neck_delay = 3 MINUTES;
	COOLDOWN_DECLARE(break_neck_cd)

/datum/martial_art/cqc/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(act(MARTIAL_COMBO_STEP_GRAB, A, D))
		return
	var/obj/item/grab/G = D.grabbedby(A, 1)
	if(!G)
		return FALSE
	if(A.dir == D.dir)
		G.last_upgrade = world.time
		G.state = GRAB_AGGRESSIVE
		G.icon_state = "grabbed1"
		G.hud.icon_state = "reinforce1"
		G.adjust_position()
		add_attack_logs(D, A, "Aggressively grabbed", ATKLOG_ALL)
	D.Immobilize(1 SECONDS) //Catch them off guard, but not long enough to do too much nonsense
	add_attack_logs(A, D, "Melee attacked with martial-art [src] : grabbed", ATKLOG_ALL)

	return TRUE

/datum/martial_art/cqc/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(act(MARTIAL_COMBO_STEP_HARM, A, D))
		return
	add_attack_logs(A, D, "Melee attacked with martial-art [src]", ATKLOG_ALL)
	A.do_attack_animation(D)
	//finish of grab, grab, harm combo
	if(restraining && COOLDOWN_FINISHED(break_neck_cd))
		break_neck(D, A)
		return TRUE
	var/picked_hit_type = pick("CQC'd", "neck chopped", "gut punched", "Big Bossed")
	if(IS_HORIZONTAL(D))
		picked_hit_type = "stomps on"
	// cant use hands for 2 seconds
	if(A.zone_selected == "r_hand" || A.zone_selected == "l_hand")
		ADD_TRAIT(D, TRAIT_HANDS_BLOCKED, CQC_HARM_ACT_TRAIT)
		addtimer(CALLBACK(src, PROC_REF(off_hand_pain), D), 2 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
	// extra damage if has knife
	if(istype(A.get_inactive_hand(), /obj/item/kitchen/knife))
		D.apply_damage(25, BRUTE, A.zone_selected)
		D.apply_damage(10, STAMINA)
	else
		D.apply_damage(1, BRUTE, A.zone_selected)
		D.apply_damage(15, STAMINA)
	playsound(get_turf(D), 'sound/weapons/cqchit1.ogg', 10, TRUE, -1)
	D.visible_message(span_danger("[A] [picked_hit_type] [D]!"), \
						span_userdanger("[A] [picked_hit_type] you!"))
	add_attack_logs(A, D, "Melee attacked with martial-art [src] : [picked_hit_type]", ATKLOG_ALL)
	if(IS_HORIZONTAL(A) && !IS_HORIZONTAL(D))
		takedown(A, D)
	return TRUE

/datum/martial_art/cqc/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(act(MARTIAL_COMBO_STEP_DISARM, A, D))
		return
	var/obj/item/grab/G = A.get_inactive_hand()
	//finish of grab, grab, harm combo
	if(restraining && istype(G) && G.affecting == D)
		artery_smash(D, A)

	var/obj/item/shield = D.get_best_shield()

	if(!IS_HORIZONTAL(D) || !restraining)
		playsound(get_turf(D), 'sound/weapons/cqchit1.ogg', 5, TRUE, -1)
		if(shield && shield.hit_reaction(D, A, "strike", 100))
			return TRUE // blocked by shield
		D.visible_message(span_warning("[A] strikes [D]'s jaw with their hand!"), \
							span_userdanger("[A] strikes your jaw, disorienting you!"))
		D.drop_item()
		D.apply_damage(5, STAMINA)
	else
		D.visible_message(span_danger("[A] attempted to disarm [D]!"), span_userdanger("[A] attempted to disarm [D]!"))
		playsound(D, 'sound/weapons/punchmiss.ogg', 5, TRUE, -1)

	add_attack_logs(A, D, "Disarmed with martial-art [src]", ATKLOG_ALL)
	return TRUE

/// returns ability to use hands to victim after harm act in hands
/datum/martial_art/cqc/proc/off_hand_pain(mob/defender)
	if(!defender)
		return
	REMOVE_TRAIT(defender, TRAIT_HANDS_BLOCKED, CQC_HARM_ACT_TRAIT)

/// attack for combo with same name and attack from horizontal position
/datum/martial_art/cqc/proc/takedown(mob/living/carbon/human/attacker, mob/living/carbon/human/defender)
	defender.visible_message(span_warning("[attacker] leg sweeps [defender]!", \
						span_userdanger("[attacker] leg sweeps you!"))
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
		target.visible_message(span_warning("[user] locks [target] into a restraining position!"), \
							span_userdanger("[user] locks you into a restraining position!"))
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
	defender.visible_message(span_warning("[attacker] breaks [defender]'s neck!"), \
							span_userdanger("[attacker] breaks your neck!"))
	defender.apply_damage(50, BRUTE)
	var/obj/item/organ/external/head = defender.bodyparts_by_name["head"]
	head.fracture()
	COOLDOWN_START(src, break_neck_cd, break_neck_delay)

/// finish of artery smash combo(hrrrrr mimimimi)
/datum/martial_art/cqc/proc/artery_smash(mob/living/carbon/human/defender, mob/living/carbon/human/attacker)
	defender.visible_message(span_danger("[attacker] hits [defender]'s carotid artery!"), \
						span_userdanger("[attacker] hits your carotid artery!"))
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
