//Procedures in this file: carapace break surgery
//////////////////////////////////////////////////////////////////
//						carapace SURGERY							//
//////////////////////////////////////////////////////////////////
///Surgery Datums
/datum/surgery/carapace_break
	name = "Break carapace"
	steps = list(
		/datum/surgery_step/saw_carapace/serpentid,
		/datum/surgery_step/cut_carapace,
		/datum/surgery_step/retract_carapace
	)

	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_GROIN)
	requires_organic_bodypart = TRUE

/datum/surgery/organ_manipulation/carapace
	name = "Organ manipulation"
	steps = list(
		/datum/surgery_step/open_encased/retract,
		/datum/surgery_step/proxy/manipulate_organs,
		/datum/surgery_step/internal/manipulate_organs/finish,
	)
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_GROIN)
	requires_organic_bodypart = TRUE

/datum/surgery/bone_repair/carapace
	name = "Carapace Repair"
	steps = list(
		/datum/surgery_step/glue_bone,
		/datum/surgery_step/set_bone,
		/datum/surgery_step/finish_bone,
		/datum/surgery_step/generic/cauterize
	)
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_GROIN)
	requires_organic_bodypart = TRUE
