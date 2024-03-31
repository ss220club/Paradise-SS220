/datum/species/grey
	name = "Grey"
	name_plural = "Greys"
	icobase = 'icons/mob/human_races/r_grey.dmi'
	language = "Psionic Communication"

	blurb = "Серые, известны своими псионическими способностями и уникальной внешностью, родом из пределов Млечного Пути, с неизвестным происхождением. \
	Они в значительной степени полагаются на технологию клонирования и управляются технократическим советом ученых.<br/><br/> \
	Сосредоточившись на технологическом прогрессе и изучении вселенной, Серые не имеют религиозных или духовных убеждений. \
	Их объективный взгляд и обширные знания часто позволяют им сосредоточиться на собственных проектах, а не на разногласиях с другими видами."

	eyes = "grey_eyes_s"
	butt_sprite = "grey"

	has_organ = list(
		"heart" =    /obj/item/organ/internal/heart/grey,
		"lungs" =    /obj/item/organ/internal/lungs/grey,
		"liver" =    /obj/item/organ/internal/liver/grey,
		"kidneys" =  /obj/item/organ/internal/kidneys/grey,
		"brain" =    /obj/item/organ/internal/brain/grey,
		"appendix" = /obj/item/organ/internal/appendix,
		"eyes" =     /obj/item/organ/internal/eyes/grey //5 darksight.
		)

	species_traits = list(LIPS, CAN_WINGDINGS, NO_HAIR)
	clothing_flags = HAS_UNDERWEAR | HAS_UNDERSHIRT | HAS_SOCKS
	bodyflags =  HAS_BODY_MARKINGS | HAS_BODYACC_COLOR | SHAVED | BALD
	dietflags = DIET_HERB
	has_gender = FALSE
	reagent_tag = PROCESS_ORG
	flesh_color = "#a598ad"
	blood_color = "#A200FF"

/datum/species/grey/handle_dna(mob/living/carbon/human/H, remove)
	..()
	H.dna.SetSEState(GLOB.remotetalkblock, !remove, TRUE)
	singlemutcheck(H, GLOB.remotetalkblock, MUTCHK_FORCED)
	if(!remove)
		H.dna.default_blocks.Add(GLOB.remotetalkblock)
	else
		H.dna.default_blocks.Remove(GLOB.remotetalkblock)

/datum/species/grey/water_act(mob/living/carbon/human/H, volume, temperature, source, method = REAGENT_TOUCH)
	return

/datum/species/grey/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	var/translator_pref = H.client.prefs.active_character.speciesprefs
	if(translator_pref || ((ismindshielded(H) || J?.job_department_flags & DEP_FLAG_COMMAND) && HAS_TRAIT(H, TRAIT_WINGDINGS)))
		if(istype(J))
			if(J.title == "Mime")
				return
			if(J.title == "Clown")
				var/obj/item/organ/internal/cyberimp/brain/speech_translator/clown/implant = new
				implant.insert(H)
				return
		var/obj/item/organ/internal/cyberimp/brain/speech_translator/implant = new
		implant.insert(H)
		if(!translator_pref && istype(J))
			to_chat(H, "<span class='notice'>A speech translator implant has been installed due to your role on the station.</span>")

/datum/species/grey/get_species_runechat_color(mob/living/carbon/human/H)
	var/obj/item/organ/internal/eyes/E = H.get_int_organ(/obj/item/organ/internal/eyes)
	if(E)
		return E.eye_color
	return flesh_color
