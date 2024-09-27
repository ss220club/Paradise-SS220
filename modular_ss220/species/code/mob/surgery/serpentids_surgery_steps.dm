#define CARAPACE_BLOCK_OPERATION list(/datum/surgery/bone_repair,/datum/surgery/bone_repair/skull,/datum/surgery/organ_manipulation)

/datum/surgery/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if(affected.carapace_limb && !(affected.status & ORGAN_BROKEN))
		return FALSE
	if (src.type in CARAPACE_BLOCK_OPERATION)//отключить стандартные операции класса "манипуляция органов", восстановить кость.
		return FALSE
	. = .. ()

/datum/surgery/bone_repair/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if(affected.carapace_limb && !(affected.status & ORGAN_BROKEN))
		return FALSE

/datum/surgery/bone_repair/carapace/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if(affected.carapace_limb && (affected.status & ORGAN_BROKEN))
		return TRUE
	return FALSE

/datum/surgery/carapace_break/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if(affected.carapace_limb && !(affected.status & ORGAN_BROKEN))
		return TRUE
	return FALSE

/datum/surgery_step/generic/cut_open/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/limb = target.get_organ(target_zone)
	if(limb.carapace_limb && !(limb.status & ORGAN_BROKEN))
		user.visible_message("<span class='notice'>Эта конечность [target] покрыта крепким хитином. Сломайте его, прежде чем начать операцию .</span>")
		return SURGERY_BEGINSTEP_ABORT
	. = .. ()

/datum/surgery_step/retract_carapace/end_step(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if(affected.carapace_limb && !(affected.status & ORGAN_BROKEN))
		affected.fracture()
	. = .. ()


/datum/surgery_step/set_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if(affected.carapace_limb && !(affected.status & ORGAN_BROKEN))
		affected.mend_fracture()
	. = .. ()
