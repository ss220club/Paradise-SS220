/obj/item/melee/vibroblade
	name = "\improper vibroblade"
	desc = "Виброклинок воинов Раскинта. Микрогенератор ультразвука в рукояти позволяет лезвию вибрировать \
		с огромной частотой, что позволяет при его достаточной зарядке наносить глубокие раны даже ударами по касательной."
	icon = 'modular_ss220/objects/icons/melee.dmi'
	icon_state = "vibroblade"
	item_state = "vibroblade"
	lefthand_file = 'modular_ss220/objects/icons/inhands/melee_lefthand.dmi'
	righthand_file = 'modular_ss220/objects/icons/inhands/melee_righthand.dmi'
	hitsound = 'modular_ss220/objects/sound/weapons/melee/sardaukar/knifehit1.ogg'
	drop_sound = 'modular_ss220/aesthetics_sounds/sound/handling/drop/knife.ogg'
	pickup_sound = 'modular_ss220/objects/sound/weapons/melee/sardaukar/equip.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	force = 20
	throwforce = 15
	throw_speed = 2
	throw_range = 5
	armour_penetration_percentage = 75
	slot_flags = SLOT_FLAG_BELT
	w_class = WEIGHT_CLASS_NORMAL
	sharp = TRUE
	flags = CONDUCT
	var/energy = 0
	var/max_energy = 20
	var/charge_time = 10 SECONDS
	var/new_icon_state

/obj/item/melee/vibroblade/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/parry, _stamina_constant = 2, _stamina_coefficient = 0.5, _parryable_attack_types = ALL_ATTACK_TYPES)

/obj/item/melee/vibroblade/attack_self(mob/living/user)
	var/msg_for_all = span_warning("[user.name] пытается зарядить [src], но кнопка на рукояти не поддается!")
	var/msg_for_user = span_notice("Вы пытаетесь нажать на кнопку зарядки [src], но она заблокирована.")
	var/msg_recharge_all = span_notice("[user.name] нажимает на кнопку зарядки [src]...")
	var/msg_recharge_user = span_notice("Вы нажимаете на кнопку зарядки [src], пытаясь зарядить микрогенератор...")

	if(energy >= max_energy)
		user.visible_message(msg_for_all, msg_for_user)
		return FALSE

	playsound(loc, 'sound/effects/sparks3.ogg', 10, 1)
	do_sparks(1, 1, src)
	user.visible_message(msg_recharge_all, msg_recharge_user)

	if(!do_after_once(user, charge_time, target = src))
		return
	energy += 5
	update_icon_state()
	. = ..()

/obj/item/melee/vibroblade/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
	var/list/obj/item/organ/external/cutoff = list ("l_arm", "r_arm", "l_hand", "r_hand", "l_leg", "r_leg", "r_foot", "l_foot")
	if(energy == 5)
		target.adjustBruteLoss (5)
		energy -= 5
	if(energy == 10)
		target.adjustBruteLoss (10)
		energy -= 10
	if(energy == 15)
		target.adjustBruteLoss (10)
		target.Weaken(1 SECONDS)
		energy -= 15
	if(energy == 20)
		target.adjustBruteLoss (10)
		var/obj/item/organ/external/pick_organ = pick(cutoff)
		var/obj/item/organ/external/lucky_organ = target.get_organ(pick_organ)
		if(!lucky_organ)
			energy -= 20
		else
			lucky_organ.droplimb(1, DROPLIMB_SHARP, 0, 1)
			energy -= 20
	update_icon_state()
	..()

/obj/item/melee/vibroblade/update_icon_state()
	icon_state = initial(icon_state)
	new_icon_state = "[icon_state]_[energy]"
	if(energy>=0)
		icon_state = new_icon_state

/obj/item/melee/vibroblade/sardaukar
	name = "\improper виброклинок гвардейца"
	desc = "Виброклинок гвардейцев Императора. Микрогенератор ультразвука в рукояти позволяет лезвию вибрировать \
	с огромной частотой, что позволяет при его достаточной зарядке наносить глубокие раны даже ударами по касательной. \
	Воины Куи'кверр-Кэтиш обучаются мастерству ближнего боя с детства, поэтому в их руках он особо опасен и жесток. \
	Каждый будущий гвардеец добывает свой клинок в ритуальном бою и его сохранность есть вопрос жизни и смерти владельца."
	icon_state = "vibroblade_elite"
	item_state = "vibroblade_elite"
	force = 25
	charge_time = 3 SECONDS
