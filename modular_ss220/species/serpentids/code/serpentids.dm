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

/datum/species
	var/can_buckle = FALSE
	var/buckle_lying = TRUE
	var/eyes_icon = 'icons/mob/human_face.dmi'
	var/eyes_faces = 'icons/mob/human_face.dmi'
	var/default_face = "bald_s"
	var/action_mult = 1

/datum/species/serpentid
	name = "Serpentid"
	name_plural = "Serpentids"
	icobase = 'modular_ss220/species/serpentids/icons/mob/r_serpentid.dmi'
	eyes_icon = 'modular_ss220/species/serpentids/icons/mob/serpentid_eyes.dmi'
	blurb = "TODO"
	language = "Stok"
	siemens_coeff = 2.0
	coldmod = 0.9
	heatmod = 1.2
	hunger_drain = 0.3
	action_mult = 1
	tox_mod = 1.5


	species_traits = list(LIPS, NO_HAIR)
	inherent_traits = list(TRAIT_CHUNKYFINGERS, TRAIT_RESISTHEAT, TRAIT_RESISTHIGHPRESSURE, TRAIT_RESISTLOWPRESSURE, TRAIT_NOPAIN)
	inherent_biotypes = MOB_ORGANIC | MOB_HUMANOID | MOB_REPTILE
	dies_at_threshold = TRUE

	dietflags = DIET_CARN
	taste_sensitivity = TASTE_SENSITIVITY_SHARP
	allowed_consumed_mobs = list(/mob/living/simple_animal/mouse, /mob/living/simple_animal/lizard, /mob/living/simple_animal/chick, /mob/living/simple_animal/chicken,
								/mob/living/simple_animal/crab, /mob/living/simple_animal/butterfly, /mob/living/simple_animal/parrot, /mob/living/simple_animal/hostile/poison/bees)

	bodyflags = HAS_SKIN_COLOR | BALD | SHAVED
	skinned_type = /obj/item/stack/sheet/animalhide/lizard
	flesh_color = "#34AF10"
	base_color = "#066000"
	eyes = "serpentid_eyes_s"

	exotic_blood = "facid"
	blood_color = "#b0fc22"

	reagent_tag = PROCESS_ORG

	has_organ = list(
		"heart" =    /obj/item/organ/internal/heart/serpentid,
		"lungs" =    /obj/item/organ/internal/lungs/serpentid,
		"liver" =    /obj/item/organ/internal/liver/serpentid,
		"kidneys" =  /obj/item/organ/internal/kidneys/serpentid,
		"brain" =    /obj/item/organ/internal/brain/serpentid,
		"eyes" =     /obj/item/organ/internal/eyes/serpentid,
		"ears" =     /obj/item/organ/internal/ears/serpentid,
		//"l_hand" =  /obj/item/organ/internal/cyberimp/arm/toolset/mantisblade/l,
		//"r_hand" =  /obj/item/organ/internal/cyberimp/arm/toolset/mantisblade,
		"chest" =  /obj/item/organ/internal/cyberimp/chest/serpentid_blades,
		)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/carapace, "descriptor" = "chest"),
		"groin" =  list("path" = /obj/item/organ/external/groin/carapace, "descriptor" = "groin"),
		"head" =   list("path" = /obj/item/organ/external/head/carapace, "descriptor" = "head"),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/carapace, "descriptor" = "left arm"),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/carapace, "descriptor" = "right arm"),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/carapace, "descriptor" = "left leg"),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/carapace, "descriptor" = "right leg"),
		"l_hand" = list("path" = /obj/item/organ/external/hand/carapace, "descriptor" = "left hand"),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/carapace, "descriptor" = "right hand"),
		"l_foot" = list("path" = /obj/item/organ/external/foot/carapace, "descriptor" = "left foot"),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/carapace, "descriptor" = "right foot"))


	suicide_messages = list(
		"is attempting to bite their tongue off!",
		"is jamming their claws into their eye sockets!",
		"is twisting their own neck!",
		"is holding their breath!")

	autohiss_basic_map = list(
			"s" = list("ss", "sss", "ssss")
		)
	autohiss_extra_map = list(
			"x" = list("ks", "kss", "ksss")
		)

	can_buckle = TRUE
	buckle_lying = FALSE

	var/can_stealth = TRUE
	var/list/valid_limbs = list()
	var/gene_lastcall = 0

/datum/species/serpentid/handle_reagents(mob/living/carbon/human/H, datum/reagent/R)
	if (R.id == SERPENTID_CHEM_REAGENT_ID)
		return FALSE
	else
		return TRUE

/datum/species/serpentid/handle_life(mob/living/carbon/human/H)

	var/armor_count = 0
	var/gene_degradation = 0
	for(var/obj/item/organ/external/limb in H.bodyparts)
		if (!(limb.type in valid_limbs))
			gene_degradation += SERPENTID_GENE_DEGRADATION_DAMAGE
		var/limb_armor = limb.brute_dam + limb.burn_dam
		armor_count += limb_armor

	if (gene_lastcall >= SERPENTID_GENE_DEGRADATION_CD)
		H.adjustCloneLoss(gene_degradation)
		gene_lastcall = 0
	else
		gene_lastcall += 1

	//Потеря брони при первом трешхолде
	if (armor_count <= SERPENTID_CARAPACE_NOARMOR_STATE)
		brute_mod = 0.6
		burn_mod = 0.8
		ADD_TRAIT(H, TRAIT_PIERCEIMMUNE, "carapace_state")
		H.clear_alert("carapace_break_armor")
	else
		brute_mod = 1.3
		burn_mod = 1.5
		REMOVE_TRAIT(H, TRAIT_PIERCEIMMUNE, "carapace_state")
		H.throw_alert("carapace_break_armor", /atom/movable/screen/alert/carapace_break_armor)

	//Потеря стелса при втором трешхолде
	if (armor_count <= SERPENTID_CARAPACE_NOCHAMELION_STATE)
		can_stealth = TRUE
		H.clear_alert("carapace_break_cloak")
	else
		H.throw_alert("carapace_break_cloak", /atom/movable/screen/alert/carapace_break_cloak)
		can_stealth = FALSE

	//Потеря рига при третьем трешхолде
	var/cold = SERPENTID_COLD_THRESHOLD_LEVEL_BASE
	var/heat = SERPENTID_HEAT_THRESHOLD_LEVEL_BASE
	hazard_high_pressure = HAZARD_HIGH_PRESSURE
	warning_high_pressure = WARNING_HIGH_PRESSURE
	warning_low_pressure = WARNING_LOW_PRESSURE
	hazard_low_pressure = HAZARD_LOW_PRESSURE
	cold = SERPENTID_ARMORED_COLD_THRESHOLD
	heat = SERPENTID_ARMORED_HEAT_THRESHOLD
	if (armor_count <= SERPENTID_CARAPACE_NOPRESSURE_STATE)
		hazard_high_pressure = 1000
		warning_high_pressure = 1000
		warning_low_pressure = -1
		hazard_low_pressure = -1
		cold = SERPENTID_ARMORED_COLD_THRESHOLD
		heat = SERPENTID_ARMORED_HEAT_THRESHOLD
		H.clear_alert("carapace_break_rig")
	else
		H.throw_alert("carapace_break_rig", /atom/movable/screen/alert/carapace_break_rig)
	var/up = SERPENTID_COLD_THRESHOLD_LEVEL_DOWN
	var/down = SERPENTID_COLD_THRESHOLD_LEVEL_DOWN
	cold_level_1 = cold
	cold_level_2 = cold_level_1 - down
	cold_level_3 = cold_level_2 - down
	heat_level_1 = heat
	heat_level_2 = heat_level_1 + up
	heat_level_3 = heat_level_2 + up

	. = ..()

//Модификация граба для хвата из стелса
/datum/species/grab(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	. = .. ()
	var/datum/species/serpentid/active_spieces =  user.dna.species
	if (istype(active_spieces, /datum/species/serpentid))
		if (user.invisibility == INVISIBILITY_LEVEL_TWO)
			for(var/X in target.grabbed_by)
				var/obj/item/grab/G = X
				G.state = GRAB_AGGRESSIVE
				G.icon_state = "grabbed1"
				user.reset_visibility()


/datum/species/serpentid/on_species_gain(mob/living/carbon/human/H)
	..()
	H.resize = 1
	H.can_buckle = can_buckle
	H.buckle_lying = buckle_lying
	H.update_transform()
	H.AddComponent(/datum/component/footstep, FOOTSTEP_MOB_SLIME, 1, -6)
	H.AddComponent(/datum/component/gadom_living)
	H.AddComponent(/datum/component/gadom_cargo)
	for (var/limb_name in has_limbs)
		valid_limbs += has_limbs[limb_name]["path"]

//Блокировка ботинок
/datum/species/serpentid/can_equip(obj/item/I, slot, disable_warning = FALSE, mob/living/carbon/human/H)
	switch(slot)
		if(SLOT_HUD_SHOES)
			return FALSE
	. = .. ()

//Ограничение на роли антагов (генокрад онли)
/datum/antag_scenario/vampire/New()
	restricted_species += list("Serpentid")
	. = .. ()

/datum/antag_scenario/traitor/New()
	restricted_species += list("Serpentid")
	. = .. ()

/datum/antag_scenario/team/blood_brothers/New()
	restricted_species += list("Serpentid")
	. = .. ()

//Добавление новых алертов
/atom/movable/screen/alert/carapace_break_armor
	name = "Слабые повреждения панциря."
	desc = "Ваш панцирь поврежден. Нарушение целостности снизило сопротивление урону."
	icon_state = "carapace_break_armor"
	icon = 'modular_ss220/species/icons/mob/screen_alert.dmi'

/atom/movable/screen/alert/carapace_break_cloak
	name = "Средние повреждения панциря"
	desc = "Ваш панцирь поврежден. Нарушения целостности лишило вас возможность скрывать себя."
	icon_state = "carapace_break_cloak"
	icon = 'modular_ss220/species/icons/mob/screen_alert.dmi'

/atom/movable/screen/alert/carapace_break_rig
	name = "Сильные повреждения панциря"
	desc = "Ваш панцирь поврежден. Нарушения целостности лишило вас сопротивлению окружающей среде."
	icon_state = "carapace_break_rig"
	icon = 'modular_ss220/species/icons/mob/screen_alert.dmi'

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
