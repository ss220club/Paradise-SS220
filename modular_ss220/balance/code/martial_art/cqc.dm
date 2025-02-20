/datum/martial_art/cqc/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	MARTIAL_ARTS_ACT_CHECK
	var/obj/item/grab/G = A.get_inactive_hand()
	if(restraining && istype(G) && G.affecting == D && !chokehold_active)
		start_chokehold(A, D)
		return TRUE
	else
		drop_restraining()

	var/obj/item/shield = D.get_best_shield()

	if(!IS_HORIZONTAL(D) || !restraining)
		if(shield && shield.hit_reaction(D, A, "strike", 100))
			return TRUE
		D.visible_message("<span class='warning'>[A] strikes [D]'s jaw with their hand!</span>", \
							"<span class='userdanger'>[A] strikes your jaw, disorienting you!</span>")
		playsound(get_turf(D), 'sound/weapons/cqchit1.ogg', 5, TRUE, -1)
		D.drop_item()
		D.apply_damage(5, STAMINA)
	else
		D.visible_message("<span class='danger'>[A] attempted to disarm [D]!</span>", "<span class='userdanger'>[A] attempted to disarm [D]!</span>")
		playsound(D, 'sound/weapons/punchmiss.ogg', 5, TRUE, -1)

	add_attack_logs(A, D, "Disarmed with martial-art [src]", ATKLOG_ALL)
	return TRUE

/datum/martial_art/cqc/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	MARTIAL_ARTS_ACT_CHECK
	var/obj/item/grab/G = D.grabbedby(A, 1)
	if(abs(A.dir - D.dir) in list(abs(NORTH-SOUTH), abs(WEST-EAST)))
		G.last_upgrade = world.time
		G.state = GRAB_AGGRESSIVE
		G.icon_state = "grabbed1"
		G.hud.icon_state = "reinforce1"
		G.adjust_position()
		add_attack_logs(assailant, affecting, "Aggressively grabbed", ATKLOG_ALL)
	if(G)
		D.Immobilize(1 SECONDS) //Catch them off guard, but not long enough to do too much nonsense
		add_attack_logs(A, D, "Melee attacked with martial-art [src] : grabbed", ATKLOG_ALL)

	return TRUE

/datum/martial_art/cqc/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	MARTIAL_ARTS_ACT_CHECK
	add_attack_logs(A, D, "Melee attacked with martial-art [src]", ATKLOG_ALL)
	A.do_attack_animation(D)
	var/picked_hit_type = pick("CQC'd", "neck chopped", "gut punched", "Big Bossed")
	var/bonus_damage = 15
	if(IS_HORIZONTAL(D))
		bonus_damage += 10 //Being stomped on doesn't feel good.
		picked_hit_type = "stomps on"
	if(is_type_in_list(A.get_inactive_hand(), /obj/item/kitchen/knife))
		D.apply_damage(25, BRUTE)
		D.apply_damage(10, STAMINA)
	else
		D.apply_damage(1, BRUTE)
		D.apply_damage(bonus_damage, STAMINA)
	if(picked_hit_type == "kicks" || picked_hit_type == "stomps on")
		playsound(get_turf(D), 'sound/weapons/cqchit2.ogg', 10, TRUE, -1)
	else
		playsound(get_turf(D), 'sound/weapons/cqchit1.ogg', 10, TRUE, -1)
	D.visible_message("<span class='danger'>[A] [picked_hit_type] [D]!</span>", \
						"<span class='userdanger'>[A] [picked_hit_type] you!</span>")
	add_attack_logs(A, D, "Melee attacked with martial-art [src] : [picked_hit_type]", ATKLOG_ALL)
	if(IS_HORIZONTAL(A) && !IS_HORIZONTAL(D))
		D.visible_message("<span class='warning'>[A] leg sweeps [D]!", \
							"<span class='userdanger'>[A] leg sweeps you!</span>")
		playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 10, TRUE, -1)
		D.KnockDown(5 SECONDS)
		A.SetKnockDown(0 SECONDS)
		A.resting = FALSE
		A.stand_up() //Quickly get up like the cool dude you are.
		add_attack_logs(A, D, "Melee attacked with martial-art [src] : Leg sweep", ATKLOG_ALL)
	return TRUE
