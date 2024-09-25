// ============ Органы внутренние ============
///почки - базовые c добавлением дикея, вырабатывают энзимы, которые позволяют ГБС скрываться
/obj/item/organ/internal/kidneys/serpentid
	name = "serpentid kidneys"
	icon = 'icons/obj/species_organs/unathi.dmi'
	decayable = TRUE
	recoverable = TRUE
	decay_rate = 4
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/internal/kidneys/serpentid/ui_action_click()
	switch_mode()

/obj/item/organ/internal/kidneys/serpentid/switch_mode(var/force_off = FALSE)
	.=..()
	var/datum/species/serpentid/spiece = owner.dna.species
	if (istype(spiece, /datum/species/serpentid))
		if(!force_off && owner.get_chemical_value(SERPENTID_CHEM_REAGENT_ID) >= GAS_ORGAN_CHEMISTRY_KIDNEYS && !spiece.cloak_engaged)
			spiece.cloak_engaged = TRUE
			chemical_consuption = GAS_ORGAN_CHEMISTRY_KIDNEYS
		else
			spiece.cloak_engaged = FALSE
			chemical_consuption = 0


///печень - вырабатывает глутамат натрия из нутриентов
/obj/item/organ/internal/liver/serpentid
	name = "serpentid liver"
	icon = 'icons/obj/species_organs/unathi.dmi'
	desc = "A large looking liver."
	alcohol_intensity = 2
	decayable = TRUE
	recoverable = TRUE
	max_value = GAS_ORGAN_CHEMISTRY_MAX
	decay_rate = 4

/obj/item/organ/internal/liver/serpentid/on_life()
	. = ..()
	max_value = clamp((((max_damage - damage)/max_damage)*100),0,GAS_ORGAN_CHEMISTRY_MAX)
	if (owner.get_chemical_value(SERPENTID_CHEM_REAGENT_ID) < max_value)
		for(var/datum/reagent/consumable/chemical in owner.reagents.reagent_list)
			if(!isnull(chemical))
				chemical.holder.remove_reagent(chemical.id, SERPENTID_CHEM_MULT_CONSUPTION*chemical.nutriment_factor)
				owner.reagents.add_reagent(SERPENTID_CHEM_REAGENT_ID, SERPENTID_CHEM_MULT_PRODUCTION*chemical.nutriment_factor)
	else
		var/excess_value = owner.get_chemical_value(SERPENTID_CHEM_REAGENT_ID) - max_value
		var/datum/reagent/chem = owner.get_chemical_path(SERPENTID_CHEM_REAGENT_ID)
		chem.holder.remove_reagent(SERPENTID_CHEM_REAGENT_ID, excess_value)

///Легкие - вырабатывают сальбутамол при наличии глутамата натрия
/obj/item/organ/internal/lungs/serpentid
	name = "serpentid lungs"
	icon = 'icons/obj/species_organs/unathi.dmi'
	organ_datums = list(/datum/organ/lungs/serpentid)
	decayable = TRUE
	recoverable = TRUE
	decay_rate = 3
	var/salb_secretion = FALSE
	actions_types = list(/datum/action/item_action/organ_action/use)

/datum/organ/lungs/serpentid
	safe_oxygen_min = 21
	safe_toxins_max = 5

	cold_level_1_threshold = SERPENTID_COLD_THRESHOLD_LEVEL_BASE
	cold_level_2_threshold = SERPENTID_COLD_THRESHOLD_LEVEL_BASE - SERPENTID_COLD_THRESHOLD_LEVEL_DOWN
	cold_level_3_threshold = SERPENTID_COLD_THRESHOLD_LEVEL_BASE - 2*SERPENTID_COLD_THRESHOLD_LEVEL_DOWN

	heat_level_1_threshold = SERPENTID_HEAT_THRESHOLD_LEVEL_BASE
	heat_level_2_threshold = SERPENTID_HEAT_THRESHOLD_LEVEL_BASE + SERPENTID_HEAT_THRESHOLD_LEVEL_UP
	heat_level_3_threshold = SERPENTID_HEAT_THRESHOLD_LEVEL_BASE + 2*SERPENTID_HEAT_THRESHOLD_LEVEL_UP

/obj/item/organ/internal/lungs/serpentid/ui_action_click()
	switch_mode()

/obj/item/organ/internal/lungs/serpentid/switch_mode(var/force_off = FALSE)
	.=..()
	if(!salb_secretion && !force_off && owner.get_chemical_value(SERPENTID_CHEM_REAGENT_ID) >= GAS_ORGAN_CHEMISTRY_LUNGS)
		salb_secretion = TRUE
		chemical_consuption = GAS_ORGAN_CHEMISTRY_LUNGS
	else
		salb_secretion = FALSE
		chemical_consuption = 0

/obj/item/organ/internal/lungs/serpentid/on_life()
	.=..()
	if(salb_secretion)
		var/mob/living/carbon/human/human_owner = owner
		human_owner.reagents.add_reagent("salbutamol", GAS_ORGAN_CHEMISTRY_LUNGS * SERPENTID_CHEM_MULT_CONSUPTION)

///Сердце - вырабатывают мефедрон при активации, но за каждый тик сжирает стамину ГБС, получает урон при ударе электричеством
/obj/item/organ/internal/heart/serpentid
	name = "serpentid heart"
	decayable = TRUE
	recoverable = TRUE
	decay_rate = 5
	actions_types = list(/datum/action/item_action/organ_action/use)

/obj/item/organ/internal/heart/serpentid/ui_action_click()
	var/mob/living/heart_owner = owner
	if(!owner.get_chemical_value(SERPENTID_CHEM_REAGENT_ID) >= GAS_ORGAN_CHEMISTRY_HEART && heart_owner.get_damage_amount(STAMINA) <= STAMINA_DAMAGE_ON_MEPH)
		var/mob/living/carbon/human/human_owner = owner
		var/datum/reagent/chem = owner.get_chemical_path(SERPENTID_CHEM_REAGENT_ID)
		chem.holder.remove_reagent(SERPENTID_CHEM_REAGENT_ID, GAS_ORGAN_CHEMISTRY_HEART)
		human_owner.reagents.add_reagent("mephedrone", GAS_ORGAN_CHEMISTRY_HEART * SERPENTID_CHEM_MULT_PRODUCTION)
		heart_owner.apply_damage(STAMINA_DAMAGE_ON_MEPH, STAMINA)

/obj/item/organ/internal/ears/serpentid
	name = "serpentid ears"
	decayable = TRUE
	recoverable = TRUE
	decay_rate = 2
	actions_types = list(/datum/action/item_action/organ_action/use)
	var/sonar_active = FALSE

/obj/item/organ/internal/ears/serpentid/ui_action_click()
	switch_mode()

/obj/item/organ/internal/ears/serpentid/switch_mode(var/force_off = FALSE)
	.=..()
	if(!sonar_active && !force_off && owner.get_chemical_value(SERPENTID_CHEM_REAGENT_ID) >= GAS_ORGAN_CHEMISTRY_EARS)
		sonar_active = TRUE
		chemical_consuption = GAS_ORGAN_CHEMISTRY_EARS
	else
		sonar_active = FALSE
		chemical_consuption = 0

/obj/item/organ/internal/ears/serpentid/on_life()
	.=..()
	if(sonar_active && prob(max_damage - damage))
		sense_creatures()

/obj/item/organ/internal/ears/serpentid/proc/sense_creatures()
	for(var/mob/living/creature in range(9, owner))
		if(creature == owner || creature.stat == DEAD || (world.time - creature.l_move_time) < 50)
			continue
		new /obj/effect/temp_visual/sonar_ping(owner.loc, owner, creature)

/obj/item/organ/internal/eyes/serpentid
	name = "serpentid eyes"
	icon = 'modular_ss220/species/icons/obj/surgery.dmi'
	icon_state = "crystal-eyes"
	light_color = "#1C1C00"
	decayable = TRUE
	recoverable = TRUE
	decay_rate = 1
	see_in_dark = 1
	flash_protect = FLASH_PROTECTION_VERYVUNERABLE
	lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	actions_types = list(/datum/action/item_action/organ_action/use)
	see_invisible = 20

/obj/item/organ/internal/eyes/serpentid/generate_icon(mob/living/carbon/human/HA)
	var/mob/living/carbon/human/H = HA
	if(!istype(H))
		H = owner
	var/icon/eyes_icon = new /icon('modular_ss220/species/icons/mob/human_races/serpentid_eyes.dmi', H.dna.species.eyes)
	eyes_icon.Blend(eye_color, ICON_ADD)

	return eyes_icon

/obj/item/organ/internal/eyes/serpentid/ui_action_click()
	switch_mode()

/obj/item/organ/internal/eyes/serpentid/switch_mode(var/force_off = FALSE)
	.=..()
	vision_flags = initial(vision_flags)
	if(lighting_alpha == LIGHTING_PLANE_ALPHA_VISIBLE && !force_off && owner.get_chemical_value(SERPENTID_CHEM_REAGENT_ID) >= GAS_ORGAN_CHEMISTRY_EYES)
		lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		see_in_dark = 8
		chemical_consuption = GAS_ORGAN_CHEMISTRY_EYES
		owner.update_sight()
	else
		lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
		see_in_dark = 1
		vision_flags &= ~SEE_BLACKNESS
		chemical_consuption = 0
		owner.update_sight()

/obj/item/organ/internal/eyes/serpentid/on_life()
	. = ..()
	if(!isnull(owner))
		var/mob/mob = owner
		mob.update_client_colour(time = 10)

/obj/item/organ/internal/eyes/serpentid/get_colourmatrix() //Returns a special colour matrix
	var/chem_value = owner.get_chemical_value(SERPENTID_CHEM_REAGENT_ID)/GAS_ORGAN_CHEMISTRY_MAX
	var/vision_chem = clamp(chem_value, SERPENTID_EYES_LOW_VISIBLE_VALUE, SERPENTID_EYES_MAX_VISIBLE_VALUE)
	var/vision_concentration = (1 - vision_chem/SERPENTID_EYES_MAX_VISIBLE_VALUE)*SERPENTID_EYES_LOW_VISIBLE_VALUE
	var/vision_adjust = clamp(vision_concentration, 0, SERPENTID_EYES_LOW_VISIBLE_VALUE)
	var/vision_matrix = list(vision_chem, vision_adjust, vision_adjust,\
		vision_adjust, vision_chem, vision_adjust,\
		vision_adjust, vision_adjust, vision_chem)
	return vision_matrix

/obj/item/organ/internal/brain/serpentid
	name = "serpentid brain"
	icon = 'modular_ss220/species/icons/obj/surgery.dmi'
	icon_state = "crystal-brain"
