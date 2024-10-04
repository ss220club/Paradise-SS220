#define SERPENTID_CHEM_REAGENT_ID "msg"

#define SERPENTID_CARAPACE_NOARMOR_STATE 60
#define SERPENTID_CARAPACE_NOCHAMELION_STATE 30
#define SERPENTID_CARAPACE_NOPRESSURE_STATE 90

#define SERPENTID_GENE_DEGRADATION_DAMAGE 0.5
#define SERPENTID_GENE_DEGRADATION_CD 60

#define SERPENTID_HEAT_THRESHOLD_LEVEL_BASE 350
#define SERPENTID_HEAT_THRESHOLD_LEVEL_UP 50
#define SERPENTID_ARMORED_HEAT_THRESHOLD 380

#define SERPENTID_COLD_THRESHOLD_LEVEL_BASE 250
#define SERPENTID_COLD_THRESHOLD_LEVEL_DOWN 80
#define SERPENTID_ARMORED_COLD_THRESHOLD 0

#define GAS_ORGAN_CHEMISTRY_EYES 0.75
#define GAS_ORGAN_CHEMISTRY_EARS 0.25
#define GAS_ORGAN_CHEMISTRY_HEART 25
#define GAS_ORGAN_CHEMISTRY_LUNGS 1
#define GAS_ORGAN_CHEMISTRY_KIDNEYS 0.6

#define SERPENTID_CHEM_MULT_CONSUPTION 0.75
#define SERPENTID_CHEM_MULT_PRODUCTION 0.6

#define SERPENTID_EYES_LOW_VISIBLE_VALUE 0.7
#define SERPENTID_EYES_MAX_VISIBLE_VALUE 1

#define GAS_ORGAN_CHEMISTRY_MAX 100

#define SPIECES_BAN_HEADS_JOB (1<<12)

//Добавление новых алертов
/atom/movable/screen/alert/carapace_break_armor
	name = "Слабые повреждения панциря."
	desc = "Ваш панцирь поврежден. Нарушение целостности снизило сопротивление урону."
	icon_state = "carapace_break_armor"
	icon = 'modular_ss220/species/serpentids/icons/screen_alert.dmi'

/atom/movable/screen/alert/carapace_break_cloak
	name = "Средние повреждения панциря"
	desc = "Ваш панцирь поврежден. Нарушения целостности лишило вас возможность скрывать себя."
	icon_state = "carapace_break_cloak"
	icon = 'modular_ss220/species/serpentids/icons/screen_alert.dmi'

/atom/movable/screen/alert/carapace_break_rig
	name = "Сильные повреждения панциря"
	desc = "Ваш панцирь поврежден. Нарушения целостности лишило вас сопротивлению окружающей среде."
	icon_state = "carapace_break_rig"
	icon = 'modular_ss220/species/serpentids/icons/screen_alert.dmi'

//Обновление иконок для кастомных рас
/datum/character_save/update_preview_icon(for_observer=0)
	. = .. ()
	var/datum/species/selected_specie = GLOB.all_species[species]

	var/icon/face_s = new/icon("icon" = selected_specie.eyes_faces, "icon_state" = selected_specie.default_face)
	if(!(selected_specie.bodyflags & NO_EYES))
		var/icon/eyes_s = new/icon("icon" = selected_specie.eyes_icon, "icon_state" = selected_specie ? selected_specie.eyes : "eyes_s")
		eyes_s.Blend(e_colour, ICON_ADD)
		face_s.Blend(eyes_s, ICON_OVERLAY)

	preview_icon.Blend(face_s, ICON_OVERLAY)
	preview_icon_front = new(preview_icon, dir = SOUTH)
	preview_icon_side = new(preview_icon, dir = WEST)

/mob/living/carbon/human/serpentid/get_eyecon()
	var/obj/item/organ/internal/eyes/eyes = get_int_organ(/obj/item/organ/internal/eyes)
	if(istype(dna.species) && dna.species.eyes)
		var/icon/eyes_icon
		if(eyes)
			eyes_icon = eyes.generate_icon()
		else //Error 404: Eyes not found!
			eyes_icon = new(dna.species.eyes_icon, dna.species.eyes)
			eyes_icon.Blend("#800000", ICON_ADD)

		return eyes_icon
