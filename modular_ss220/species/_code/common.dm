#define SERPENTID_CHEM_REAGENT_ID "msg"

#define SERPENTID_CARAPACE_NOARMOR_STATE 30
#define SERPENTID_CARAPACE_NOCHAMELION_STATE 60
#define SERPENTID_CARAPACE_NOPRESSURE_STATE 90

#define SERPENTID_GENE_DEGRADATION_DAMAGE 0.5
#define SERPENTID_GENE_DEGRADATION_CD 60

#define SERPENTID_ORGAN_CHEMISTRY_LUNGS 1
#define SERPENTID_ORGAN_CHEMISTRY_KIDNEYS 0.5
#define SERPENTID_ORGAN_CHEMISTRY_EYES 0.05
#define SERPENTID_ORGAN_CHEMISTRY_EARS 0.1

#define SERPENTID_CHEM_MULT_CONSUPTION 0.75
#define SERPENTID_CHEM_MULT_PRODUCTION 0.6

#define SERPENTID_EYES_LOW_VISIBLE_VALUE 0.7
#define SERPENTID_EYES_MAX_VISIBLE_VALUE 1

#define SERPENTID_ORGAN_CHEMISTRY_MAX 100

/datum/species
	var/can_buckle = FALSE
	var/buckle_lying = TRUE
	var/eyes_icon = 'icons/mob/human_face.dmi'
	var/face_icon = 'icons/mob/human_face.dmi'
	var/face_icon_state = "bald_s"
	var/action_mult = 1
	var/equipment_black_list = list()
	var/butt_sprite_icon = 'icons/obj/butts.dmi'
