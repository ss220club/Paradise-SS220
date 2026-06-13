/obj/item/clothing/neck/necklace/collarspike
	name = "шипованый ошейник"
	desc = "Стильный кожаный ошейник с стальными шипами. На внутренней стороне ошейника выжженно слово Rerro."
	icon = 'modular_ss220/clothing/icons/object/neck.dmi'
	icon_state = "collarspike_s"
	worn_icon = 'modular_ss220/clothing/icons/mob/neck.dmi'
	sprite_sheets = list(
		"Kidan" = 'modular_ss220/clothing/icons/mob/species/kidan/neck.dmi',
		"Grey" = 'modular_ss220/clothing/icons/mob/species/grey/neck.dmi',
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/neck.dmi',
	)

/obj/item/clothing/neck/necklace/holocollar
	name = "ошейник с кварцевым камнем"
	desc = "Ошейник ручной работы с огранённым кварцем нежно-голубого оттенка. Чёрная кожаная привязь с магнитным замком обеспечивает удобную фиксацию. Справа выгравированы три слова: BODY. MIND. SOUL., а слева — тёмно-фиолетовой каллиграфией нанесено LiteCore."
	icon = 'modular_ss220/clothing/icons/object/neck.dmi'
	icon_state = "collarholo_s"
	worn_icon = 'modular_ss220/clothing/icons/mob/neck.dmi'
	sprite_sheets = list(
		"Kidan" = 'modular_ss220/clothing/icons/mob/species/kidan/neck.dmi',
		"Grey" = 'modular_ss220/clothing/icons/mob/species/grey/neck.dmi',
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/neck.dmi',
		"Drask" = 'modular_ss220/clothing/icons/mob/species/drask/neck.dmi',
	)

/datum/action/item_action/cloak
	name = "Activate Cloak"


/obj/item/clothing/neck/cloak/chameleon
	name = "Grey cloak"
	desc = "A simple grey cloak, a little worn."
	icon_state = "cloak"

	actions_types = list(/datum/action/item_action/cloak)

	var/cloak_active = FALSE
	var/next_use = 0

	var/cloak_duration = 20 SECONDS
	var/cloak_cooldown = 10 SECONDS
	var/stealth_alpha = 10


/obj/item/clothing/neck/cloak/chameleon/activate_self(mob/user)
	if(cloak_active)
		return ITEM_INTERACT_COMPLETE

	if(world.time < next_use)
		to_chat(user, SPAN_WARNING("The cloaking field is still recharging!"))
		return ITEM_INTERACT_COMPLETE

	if(user.get_item_by_slot(ITEM_SLOT_NECK) != src)
		to_chat(user, SPAN_WARNING("You must wear the cloak first!"))
		return ITEM_INTERACT_COMPLETE

	if(!ishuman(user))
		return ITEM_INTERACT_COMPLETE

	var/mob/living/carbon/human/H = user

	activate_cloak(H)

	return ITEM_INTERACT_COMPLETE


/obj/item/clothing/neck/cloak/chameleon/proc/activate_cloak(mob/living/carbon/human/user)
	if(cloak_active)
		return

	cloak_active = TRUE

	RegisterSignal(user, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(break_cloak))
	RegisterSignal(user, COMSIG_ATOM_BULLET_ACT, PROC_REF(break_cloak))

	RegisterSignals(user, list(
		COMSIG_MOB_ITEM_ATTACK,
		COMSIG_ATTACK_BY,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_HITBY,
		COMSIG_ATOM_HULK_ATTACK,
		COMSIG_ATOM_ATTACK_PAW
	), PROC_REF(break_cloak))

	user.set_alpha_tracking(stealth_alpha, src, update_alpha = FALSE)
	animate(user, alpha = user.get_alpha(), time = 1.5 SECONDS)

	to_chat(user, SPAN_NOTICE("The cloaking field activates."))

	addtimer(CALLBACK(src, PROC_REF(disable_cloak), user), cloak_duration)


/obj/item/clothing/neck/cloak/chameleon/proc/break_cloak(datum/source)
	SIGNAL_HANDLER

	if(!cloak_active)
		return

	var/mob/living/carbon/human/H = loc

	if(!istype(H))
		return

	disable_cloak(H)


/obj/item/clothing/neck/cloak/chameleon/proc/disable_cloak(mob/living/carbon/human/user)
	if(QDELETED(user))
		return

	UnregisterSignal(user, COMSIG_HUMAN_MELEE_UNARMED_ATTACK)
	UnregisterSignal(user, COMSIG_ATOM_BULLET_ACT)

	UnregisterSignal(user, list(
		COMSIG_MOB_ITEM_ATTACK,
		COMSIG_ATTACK_BY,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_HITBY,
		COMSIG_ATOM_HULK_ATTACK,
		COMSIG_ATOM_ATTACK_PAW
	))

	user.set_alpha_tracking(ALPHA_VISIBLE, src, update_alpha = FALSE)
	animate(user, alpha = user.get_alpha(), time = 1.5 SECONDS)

	cloak_active = FALSE
	next_use = world.time + cloak_cooldown

	to_chat(user, SPAN_NOTICE("The cloaking field deactivates."))


/obj/item/clothing/neck/cloak/chameleon/dropped(mob/user)
	. = ..()

	if(cloak_active && ishuman(user))
		var/mob/living/carbon/human/H = user
		disable_cloak(H)
