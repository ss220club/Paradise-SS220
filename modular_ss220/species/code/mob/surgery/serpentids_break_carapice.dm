//Procedures in this file: Carapice break surgery
//////////////////////////////////////////////////////////////////
//						CARAPICE SURGERY							//
//////////////////////////////////////////////////////////////////
///Surgery Datums
/datum/surgery/carapice_break
	name = "Break Carapice"
	steps = list(
		/datum/surgery_step/open_encased/saw,
		/datum/surgery_step/open_encased/retract
	)

	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_GROIN)

/datum/surgery/carapice_break/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if(affected.carapice_limb && !(affected.status & ORGAN_BROKEN))
		return TRUE
	return FALSE

/datum/surgery_step/open_encased/saw/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if(affected.carapice_limb && !(affected.status & ORGAN_BROKEN))
		carapice_state = 0
	. = .. ()

/datum/surgery_step/finish_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if(affected.carapice_limb && !(affected.status & ORGAN_BROKEN))
		carapice_state = SERPENTID_CARAPICE_MAX_STATE
	. = .. ()
