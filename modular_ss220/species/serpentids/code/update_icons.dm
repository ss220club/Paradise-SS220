//Обновление иконок для кастомных рас
/datum/character_save/update_preview_icon(for_observer=0)
	. = .. ()
	var/datum/species/selected_specie = GLOB.all_species[species]

	//Это ужасно,но так можно кастомным расам выдавать кастомные глаза (я хз, почему сработало так, нужны разьяснения)
	var/icon/face_s = new/icon("icon" = selected_specie.eyes_icon, "icon_state" = selected_specie.eyes)
	if(!(selected_specie.bodyflags & NO_EYES))
		var/icon/eyes_s = new/icon("icon" = selected_specie.eyes_icon, "icon_state" = selected_specie ? selected_specie.eyes : "eyes_s")
		eyes_s.Blend(e_colour, ICON_ADD)
		face_s.Blend(eyes_s, ICON_OVERLAY)

	preview_icon.Blend(face_s, ICON_OVERLAY)
	preview_icon_front = new(preview_icon, dir = SOUTH)
	preview_icon_side = new(preview_icon, dir = WEST)

//Прок на получение иконки глаз кастомных рас (перезапись, возможно стоит расширить?)
/mob/living/carbon/human/get_eyecon()
	var/obj/item/organ/internal/eyes/eyes = get_int_organ(/obj/item/organ/internal/eyes)
	if(istype(dna.species) && dna.species.eyes)
		var/icon/eyes_icon
		if(eyes)
			eyes_icon = eyes.generate_icon()
		else //Error 404: Eyes not found!
			eyes_icon = new(dna.species.eyes_icon, dna.species.eyes)//eyes_icon = new('modular_ss220/species/serpentids/icons/mob/r_serpentid_eyes.dmi', "serp_eyes_s")//
			eyes_icon.Blend("#800000", ICON_ADD)

		return eyes_icon
