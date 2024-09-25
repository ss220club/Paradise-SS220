/datum/surgery_step/generic/cut_open/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/limb = target.get_organ(target_zone)
	if(limb.carapice_limb && limb.carapice_state > 0)
		user.visible_message("<span class='notice'>Эта конечность [target] покрыта крепким хитином. Сломайте его, прежде чем начать операцию .</span>")
		return SURGERY_BEGINSTEP_ABORT
	. = .. ()
