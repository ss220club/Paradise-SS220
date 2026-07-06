/mob/living/carbon/human/examine_visible_clothing(skip_gloves = FALSE, skip_suit_storage = FALSE, skip_jumpsuit = FALSE, skip_shoes = FALSE, skip_mask = FALSE, skip_ears = FALSE, skip_eyes = FALSE, skip_face = FALSE)
	var/list/message_parts = list(
// SS220 EDIT START - FULL RU TRANSLATE TO MOB EXAMINE (ПОЛНЫЙ ПЕРЕВОД ОСМОТРА СУЩЕСТВ)
		list("[ru_p_hold()]", l_hand, " в", "левой руке"),
		list("[ru_p_hold()]", r_hand, " в", "правой руке"),
		list("[ru_p_wear()]", head, " на", "голове"),
		list("[ru_p_wear()]", neck, " на", "шее"),
		list("[ru_p_wear()]", !skip_jumpsuit && w_uniform, null, null, length(w_uniform?.accessories) && "[russian_accessory_list(w_uniform)]"),
		list("[ru_p_wear()]", wear_suit, null, null),
		list("[ru_p_equip()]", !skip_suit_storage && s_store, " на", wear_suit && wear_suit.name),
		list("[ru_p_carry()]", back, " на", "своей спине"),
		list("[ru_p_wear()]", !skip_gloves && gloves, " на", "руках"),
		list("[ru_p_wear()]", belt, " на", "поясе"),
		list("[ru_p_wear()]", !skip_shoes && shoes, " на", "ногах"),
		list("[ru_p_wear()]", !skip_mask && wear_mask, " на", "лице"),
		list("[ru_p_wear()]", glasses,", скрывая свои", "глаза"),
		list("[ru_p_equip()]", !skip_ears && l_ear, " на", "левом ухе"),
		list("[ru_p_equip()]", !skip_ears && r_ear, " на", "правом ухе"),
		list("[ru_p_wear()]", wear_id, "", ""),
	// SS220 EDIT END
	)

	return message_parts

/mob/living/carbon/human/examine_show_ssd()
	if(dna?.species.show_ssd)
		return ..()

/mob/living/carbon/human/examine_handle_individual_limb(limb_name)
	var/msg = ""
	// SS220 EDIT START - Translated to RU
	switch(limb_name)
		if("руках")
			if(blood_DNA)
				msg += "[SPAN_WARNING("[ru_p_them(TRUE)] руки [hand_blood_color != "#030303" ? "покрыты чьей-то кровью!" : "испачканы маслом."]")]\n"

		if("глаза")
			if(HAS_TRAIT(src, SCRYING))
				if(IS_CULTIST(src) && HAS_TRAIT(src, CULT_EYES))
					msg += "[SPAN_BOLDWARNING("[ru_p_them(TRUE)] светящиеся красные глаза будто затуманены!")]\n"
				else
					msg += "[SPAN_BOLDWARNING("[ru_p_them(TRUE)] глаза затуманены.")]\n"
			else if(IS_CULTIST(src) && HAS_TRAIT(src, CULT_EYES))
				msg += "[SPAN_BOLDWARNING("[ru_p_them(TRUE)] глаза сияют неестественным красным светом!")]\n"

	return msg
	// SS220 EDIT END

/mob/living/carbon/human/examine_what_am_i(skip_gloves = FALSE, skip_suit_storage = FALSE, skip_jumpsuit = FALSE, skip_shoes = FALSE, skip_mask = FALSE, skip_ears = FALSE, skip_eyes = FALSE, skip_face = FALSE)
	if(!dna)
		return

	var/msg = ""

	var/displayed_species = dna?.species.name
	var/examine_color = dna.species.flesh_color
	for(var/obj/item/clothing/C in src)			//Disguise checks
		if(C == head || C == wear_suit || C == wear_mask || C == w_uniform || C == belt || C == back)
			if(C.species_disguise)
				displayed_species = C.species_disguise
				break

	// If an IPC's covered in synthetic skin, they can appear human.
	if(calculate_ipc_masquerade_status())
		displayed_species = "human" // SS220 EDIT - Lowercased "human" for translation
		examine_color = "#d1aa2e"

	if(skip_jumpsuit && skip_face || HAS_TRAIT(src, TRAIT_NOEXAMINE)) //either obscured or on the nospecies list
		msg += "!"    //omit the species when examining
	else
// SS220 EDIT START - Перевод названия расы в осмотре персонажа
		var/species_key = lowertext(displayed_species)
		var/species_name = declent_ru_initial(species_key, NOMINATIVE, lowertext(displayed_species))
// SS220 EDIT END
		msg += " - <b><font color='[examine_color]'>[species_name]</font></b> [height] роста с [physique] телосложением!"
	return msg

/mob/living/carbon/human/examine_start_damage_block(skip_gloves = FALSE, skip_suit_storage = FALSE, skip_jumpsuit = FALSE, skip_shoes = FALSE, skip_mask = FALSE, skip_ears = FALSE, skip_eyes = FALSE, skip_face = FALSE)
	var/msg = ""
	var/list/wound_flavor_text = list()
	var/list/is_destroyed = list()
	var/skip_bodyparts = 0
	for(var/organ_tag in dna.species.has_limbs)

		var/list/organ_data = dna.species.has_limbs[organ_tag]
		//var/organ_descriptor = organ_data["descriptor"] // SS220 EDIT - Отключено из-за ненадобности в процессе перевода
		is_destroyed["[organ_data["descriptor"]]"] = 1

		var/obj/item/organ/external/E = bodyparts_by_name[organ_tag]
		var/bodypart_clothing_bitflag = bodypart_name_to_clothing_bitflag(organ_tag)
		if(!E)
			if(bodypart_clothing_bitflag & skip_bodyparts)
				continue
			wound_flavor_text["[organ_tag]"] = "<b>У [ru_p_theirs()] отсутствует [declent_ru_initial(organ_data["descriptor"], NOMINATIVE, organ_data["descriptor"])].</b>\n"
			if(bodypart_clothing_bitflag & ARM_LEFT)
				skip_bodyparts |= HAND_LEFT
				wound_flavor_text["l_hand"] = null
			if(bodypart_clothing_bitflag & ARM_RIGHT)
				skip_bodyparts |= HAND_RIGHT
				wound_flavor_text["r_hand"] = null
			if(bodypart_clothing_bitflag & LEG_LEFT)
				skip_bodyparts |= FOOT_LEFT
				wound_flavor_text["l_foot"] = null
			if(bodypart_clothing_bitflag & LEG_RIGHT)
				skip_bodyparts |= FOOT_RIGHT
				wound_flavor_text["r_foot"] = null
			continue

		if(bodypart_clothing_bitflag & HEAD)
			if(skip_mask)
				continue
			var/obj/item/clothing/mask/current_mask = wear_mask
			if(istype(current_mask) && (current_mask.body_parts_covered & bodypart_clothing_bitflag))
				continue

		var/chest_groin_arms_legs_bitflag = ARMS | LEGS | UPPER_TORSO | LOWER_TORSO //is what covered by jumpsuit
		if(bodypart_clothing_bitflag & chest_groin_arms_legs_bitflag)
			if(skip_jumpsuit)
				continue
			if(!isnull(w_uniform) && (w_uniform.body_parts_covered & bodypart_clothing_bitflag))
				continue

		if(bodypart_clothing_bitflag & HANDS)
			if(skip_gloves)
				continue
			var/obj/item/clothing/gloves/current_gloves = gloves
			if(istype(current_gloves) && (current_gloves.body_parts_covered & bodypart_clothing_bitflag))
				continue

		if(bodypart_clothing_bitflag & FEET)
			if(skip_shoes)
				continue
			var/obj/item/clothing/shoes/current_shoes = shoes
			if(istype(current_shoes) && (current_shoes.body_parts_covered & bodypart_clothing_bitflag))
				continue

		if(!ismachineperson(src))
			if(E.is_robotic() && !E.has_synthetic_skin)
				wound_flavor_text["[E.limb_name]"] = "У [ru_p_theirs()] протез [E.declent_ru(GENITIVE)]!\n"

			else if(E.status & ORGAN_SPLINTED)
				wound_flavor_text["[E.limb_name]"] = "У [ru_p_theirs()] наложен гипс на [E.declent_ru(ACCUSATIVE)]!\n"

			else if(!E.properly_attached)
				wound_flavor_text["[E.limb_name]"] = "[ru_p_them(TRUE)] [E.declent_ru(NOMINATIVE)] едва закреплена!\n"

			else if(E.status & ORGAN_BURNT)
				wound_flavor_text["[E.limb_name]"] = "[ru_p_them(TRUE)] [E.declent_ru(NOMINATIVE)] сильно обгорела" + (E.status & ORGAN_SALVED ? ", но была обработана" : "") + "!\n"

		if(E.open)
			if(E.is_robotic())
				msg += "<b>Панель техобслуживания на [ru_p_them()] [ignore_limb_branding(E.declent_ru(PREPOSITIONAL))] открыта!</b>\n"
			else
				msg += "<b>У [ru_p_theirs()] на [ignore_limb_branding(E.declent_ru(PREPOSITIONAL))] [E.open != ORGAN_ORGANIC_VIOLENT_OPEN ? "открытая операционная рана" : "насильственный разрыв тканей"]!</b>\n"

		for(var/obj/item/I in E.embedded_objects)
			// we cant just use \a here, as we want it to appear before the bicon
			msg += "<b>В [ru_p_them()] [E.declent_ru(PREPOSITIONAL)] застряло что-то похожее на [bicon(I)] [I.declent_ru(NOMINATIVE)]!</b>\n"

	//Handles the text strings being added to the actual description.
	//If they have something that covers the limb, and it is not missing, put flavortext.  If it is covered but bleeding, add other flavortext.

	msg += wound_flavor_text["head"]
	msg += wound_flavor_text["chest"]
	msg += wound_flavor_text["groin"]
	msg += wound_flavor_text["l_arm"]
	msg += wound_flavor_text["l_hand"]
	msg += wound_flavor_text["r_arm"]
	msg += wound_flavor_text["r_hand"]
	msg += wound_flavor_text["l_leg"]
	msg += wound_flavor_text["l_foot"]
	msg += wound_flavor_text["r_leg"]
	msg += wound_flavor_text["r_foot"]
	return msg

/mob/living/carbon/human/examine_extra_damage_flavor()
	var/msg = ""
	if(bleedsuppress)
		msg += "[ru_p_them(TRUE)] тело чем-то перебинтовано.\n"
	else if(bleed_rate)
		msg += "<b>У [ru_p_theirs()] открытое кровотечение!</b>\n"

	return msg

/mob/living/carbon/human/examine_extra_general_flavor(mob/user)
	var/msg = ""
	switch(decaylevel)
		if(1)
			msg += "[ru_p_them(TRUE)] тело начинает едко пахнуть.\n"
		if(2)
			msg += "[ru_p_them(TRUE)] тело раздулось и пахнет крайне отвратно.\n"
		if(3)
			msg += "[ru_p_them(TRUE)] тело заметно гниёт и темнеет, кожа начинает отслаиваться. Запах неописуемо отвратительный.\n"
		if(4)
			msg += "[ru_p_them(TRUE)] тело по большей части разложилось, оставляя за собой лишь [isslimeperson(src) ? "массу застывшей слизи" : "груду костей"], что когда-то была полна жизнью.\n"

	// only humans get employment records
	if(hasHUD(user, EXAMINE_HUD_SKILLS))
		var/perpname = get_visible_name(TRUE)
		var/skills

		if(perpname)
			for(var/datum/data/record/E in GLOB.data_core.general)
				if(E.fields["name"] == perpname)
					skills = E.fields["notes"]
			if(skills)
				var/char_limit = 40
				if(length(skills) <= char_limit)
					msg += "[SPAN_DEPTRADIO("Сведения о работе:")] [skills]\n"
				else
					msg += "[SPAN_DEPTRADIO("Сведения о работе: [copytext_preserve_html(skills, 1, char_limit-3)]...")]<a href='byond://?src=[UID()];employment_more=1'>More...</a>\n"


	if(hasHUD(user, EXAMINE_HUD_MEDICAL_READ))
		var/perpname = get_visible_name(TRUE)
		var/medical = "Отсутствует"
		var/mental = "Отсутствует"

		for(var/datum/data/record/E in GLOB.data_core.general)
			if(E.fields["name"] == perpname)
				for(var/datum/data/record/R in GLOB.data_core.general)
					if(R.fields["id"] == E.fields["id"])
						medical = R.fields["p_stat"]
						mental = R.fields["m_stat"]

		var/medical_status = hasHUD(user, EXAMINE_HUD_MEDICAL_WRITE) ? "<a href='byond://?src=[UID()];medical=1'>\[[medical]\]</a>" : "\[[medical]\]"
		var/mental_status = hasHUD(user, EXAMINE_HUD_MEDICAL_WRITE) ? "<a href='byond://?src=[UID()];mental=1'>\[[mental]\]</a>" : "\[[mental]\]"
		msg += "[SPAN_DEPTRADIO("Физическое состояние: ")][medical_status]\n"
		msg += "[SPAN_DEPTRADIO("Психическое состояние: ")][mental_status]\n"
		msg += "[SPAN_DEPTRADIO("Медицинские сведения:")] <a href='byond://?src=[UID()];medrecord=`'>\[Просмотреть\]</a> <a href='byond://?src=[UID()];medrecordComment=`'>\[Недавние заметки\]</a> <a href='byond://?src=[UID()];medrecordadd=`'>\[Добавить\]</a>\n"

	if(hasHUD(user, EXAMINE_HUD_SECURITY_READ))
		var/perpname = get_visible_name(TRUE)
		var/criminal = "Отсутствует"
		var/commentLatest = "ОШИБКА: Не удалось найти запись в базе данных для этой персоны." //If there is no datacore present, give this

		if(perpname)
			for(var/datum/data/record/E in GLOB.data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in GLOB.data_core.security)
						if(R.fields["id"] == E.fields["id"])
							criminal = R.fields["criminal"]
							if(LAZYLEN(R.fields["comments"])) //if the commentlist is present
								var/list/comments = R.fields["comments"]
								commentLatest = LAZYACCESS(comments, length(comments)) //get the latest entry from the comment log
								if(islist(commentLatest))
									commentLatest = "[commentLatest["header"]]: [commentLatest["text"]]"
							else
								commentLatest = "Нет записей." //If present but without entries (=target is recognized crew)

			var/criminal_status = hasHUD(user, EXAMINE_HUD_SECURITY_WRITE) ? "<a href='byond://?src=[UID()];criminal=1'>\[[criminal]\]</a>" : "\[[criminal]\]"
			msg += "[SPAN_DEPTRADIO("Криминальный статус:")] [criminal_status]\n"
			msg += "[SPAN_DEPTRADIO("Досье СБ:")] <a href='byond://?src=[UID()];secrecord=`'>\[Просмотреть\]</a> <a href='byond://?src=[UID()];secrecordComment=`'>\[Недавние заметки\]</a> <a href='byond://?src=[UID()];secrecordadd=`'>\[Добавить\]</a>\n"
			msg += "[SPAN_DEPTRADIO("Недавние правки:")] [commentLatest]\n"

	if(hasHUD(user, EXAMINE_HUD_MALF_READ))
		var/perpname = get_visible_name(TRUE)
		var/malf = "Отсутствует"

		if(perpname)
			for(var/datum/data/record/E in GLOB.data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in GLOB.data_core.security)
						if(R.fields["id"] == E.fields["id"])
							malf = E.fields["ai_target"]

			var/malf_status = hasHUD(user, EXAMINE_HUD_MALF_WRITE) ? "<a href='byond://?src=[UID()];ai=`'>\[[malf]\]</a>" : "\[[malf]\]"
			msg += "[SPAN_DEPTRADIO("Статус цели:")] [malf_status]\n"

	return msg

/mob/living/carbon/human/proc/calculate_ipc_masquerade_status()
	if(!ismachineperson(src))
		return FALSE

	var/all_visible_parts_have_skin = TRUE

	for(var/obj/item/organ/external/limb as anything in bodyparts)
		if(!limb || !limb.is_robotic())
			continue

		// If it's covered by clothing then it doesn't need to have skin for the masquerade
		if(is_bodypart_covered_by_clothing(limb.limb_name))
			continue

		if(!limb.has_synthetic_skin)
			return FALSE

	return all_visible_parts_have_skin

/mob/living/carbon/human/examine_get_brute_message()
	return get_ru_brute_word(src) // SS220 EDIT - Translated to RU

/// Checks if a body part is covered by clothing
/mob/living/carbon/human/proc/is_bodypart_covered_by_clothing(part_name)
	var/bodypart_clothing_bitflag = bodypart_name_to_clothing_bitflag(part_name)
	if(!bodypart_clothing_bitflag)
		return FALSE

	// Masks
	if(bodypart_clothing_bitflag & HEAD)
		var/obj/item/clothing/mask/current_mask = wear_mask
		if(istype(current_mask) && (current_mask.body_parts_covered & bodypart_clothing_bitflag))
			return TRUE

	// Jumpsuit/uniform
	var/chest_groin_arms_legs_bitflag = ARMS | LEGS | UPPER_TORSO | LOWER_TORSO
	if(bodypart_clothing_bitflag & chest_groin_arms_legs_bitflag)
		if(w_uniform && (w_uniform.body_parts_covered & bodypart_clothing_bitflag))
			return TRUE
		if(wear_suit && (wear_suit.body_parts_covered & bodypart_clothing_bitflag))
			return TRUE

	// Gloves
	if(bodypart_clothing_bitflag & HANDS)
		var/obj/item/clothing/gloves/current_gloves = gloves
		if(istype(current_gloves) && (current_gloves.body_parts_covered & bodypart_clothing_bitflag))
			return TRUE

	// Shoes
	if(bodypart_clothing_bitflag & FEET)
		var/obj/item/clothing/shoes/current_shoes = shoes
		if(istype(current_shoes) && (current_shoes.body_parts_covered & bodypart_clothing_bitflag))
			return TRUE

	return FALSE
