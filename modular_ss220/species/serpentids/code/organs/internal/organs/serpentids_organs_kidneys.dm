/// почки - базовые c добавлением дикея, вырабатывают энзимы, которые позволяют ГБС скрываться
/obj/item/organ/internal/kidneys/serpentid
	name = "secreting organ"
	icon = 'modular_ss220/species/serpentids/icons/organs.dmi'
	icon_state = "kidneys"
	desc = "A large looking organ, that can inject chemicals."
	actions_types = 		list(/datum/action/item_action/organ_action/toggle/serpentid)
	var/chemical_consuption = SERPENTID_ORGAN_HUNGER_KIDNEYS
	var/cloak_engaged = FALSE
	radial_action_state = "serpentid_stealth"
	radial_action_icon = 'modular_ss220/species/serpentids/icons/organs.dmi'

/obj/item/organ/internal/kidneys/serpentid/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/organ_decay, 0.12, BASIC_RECOVER_VALUE)
	AddComponent(/datum/component/organ_toxin_damage, 0.15)
	AddComponent(/datum/component/hunger_organ)
	AddComponent(/datum/component/organ_action, radial_action_state, radial_action_icon)

/mob/living/carbon/human/serpentid/handle_kidneys()
	. = ..()

	var/obj/item/organ/internal/kidneys/serpentid/kidneys = get_int_organ(/obj/item/organ/internal/kidneys/serpentid)

	if((src.m_intent != MOVE_INTENT_RUN || src.body_position == LYING_DOWN || (world.time - src.last_movement) >= 5) && (!src.stat && (src.mobility_flags & MOBILITY_STAND) && !src.restrained() && kidneys.cloak_engaged))
		if(src.invisibility != INVISIBILITY_LEVEL_TWO)
			src.alpha -= 51
	else
		if(src.invisibility != INVISIBILITY_OBSERVER)
			src.reset_visibility()
			src.alpha = 255
	if(src.alpha == 0)
		src.make_invisible()

/obj/item/organ/internal/kidneys/serpentid/switch_mode(force_off = FALSE)
	. = ..()
	if(!(HAS_TRAIT(owner, TRAIT_CLOAKBLOCKED)))
		if(!force_off && owner?.nutrition >= NUTRITION_LEVEL_HYPOGLYCEMIA && !cloak_engaged && !(status & ORGAN_DEAD))
			cloak_engaged = TRUE
			chemical_consuption = initial(chemical_consuption)
			owner.visible_message(SPAN_WARNING("Тело [owner] начинает покрываться пятнами и преломлять свет!"))
		else
			cloak_engaged = FALSE
			chemical_consuption = 0
			owner.visible_message(SPAN_NOTICE("Тело [owner] перестает преломлять свет."))
	SEND_SIGNAL(src, COMSIG_ORGAN_CHANGE_CHEM_CONSUPTION, chemical_consuption)

/obj/item/organ/internal/kidneys/serpentid/get_active_state()
	return cloak_engaged
