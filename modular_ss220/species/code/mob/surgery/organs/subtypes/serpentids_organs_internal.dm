// ============ Органы внутренние ============
///почки - базовые c добавлением дикея
/obj/item/organ/internal/kidneys/serpentid
	name = "serpentid kidneys"
	icon = 'icons/obj/species_organs/unathi.dmi'
	decayable = TRUE
	recoverable = TRUE
	decay_rate = 4

///печень - вырабатывает глутамат натрия из нутриентов
/obj/item/organ/internal/liver/serpentid
	name = "serpentid liver"
	icon = 'icons/obj/species_organs/unathi.dmi'
	desc = "A large looking liver."
	alcohol_intensity = 2
	decayable = TRUE
	recoverable = TRUE
	decay_rate = 4

/obj/item/organ/internal/liver/serpentid/on_life()
	. = ..()
	for(var/datum/reagent/consumable/chemical in owner.reagents.reagent_list)
		if(!isnull(chemical))
			chemical.holder.remove_reagent(chemical.id, SERPENTID_CHEM_MULT_CONSUPTION*chemical.nutriment_factor)
			owner.reagents.add_reagent(SERPENTID_CHEM_REAGENT_ID, SERPENTID_CHEM_MULT_PRODUCTION*chemical.nutriment_factor)

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
	heat_level_1_threshold = 350
	heat_level_2_threshold = 400
	heat_level_3_threshold = 450

	cold_level_1_threshold = 250
	cold_level_2_threshold = 180
	cold_level_3_threshold = 100

/obj/item/organ/internal/lungs/serpentid/ui_action_click()
	switch_mode()

/obj/item/organ/internal/lungs/serpentid/switch_mode(var/force_off = FALSE)
	.=..()
	if(!salb_secretion && !force_off && get_chemical_value(SERPENTID_CHEM_REAGENT_ID) > 0)
		salb_secretion = TRUE
		chemical_consuption += GAS_ORGAN_CHEMISTRY_LUNGS
	else
		salb_secretion = FALSE
		chemical_consuption -= 0

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
	if(!get_chemical_value(SERPENTID_CHEM_REAGENT_ID) > GAS_ORGAN_CHEMISTRY_HEART && heart_owner.get_damage_amount(STAMINA) < STAMINA_DAMAGE_ON_MEPH)
		var/mob/living/carbon/human/human_owner = owner
		var/datum/reagent/chem = get_chemical_path(SERPENTID_CHEM_REAGENT_ID)
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
	if(!sonar_active && !force_off && get_chemical_value(SERPENTID_CHEM_REAGENT_ID) > 0)
		sonar_active = TRUE
		chemical_consuption += GAS_ORGAN_CHEMISTRY_EARS
	else
		sonar_active = FALSE
		chemical_consuption -= 0

/obj/item/organ/internal/ears/serpentid/on_life()
	.=..()
	if(sonar_active && prob(max_damage - damage))
		sense_creatures()

/obj/item/organ/internal/ears/serpentid/proc/sense_creatures()
	playsound(owner, 'sound/mecha/skyfall_power_up.ogg', vol = 20, vary = TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
	for(var/mob/living/creature in range(9, owner))
		if(creature == owner || creature.stat == DEAD)
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

/obj/item/organ/internal/eyes/serpentid/generate_icon(mob/living/carbon/human/HA)
	var/mob/living/carbon/human/H = HA
	if(!istype(H))
		H = owner
	var/icon/eyes_icon = new /icon('modular_ss220/species/icons/mob/human_races/serpentid_eyes.dmi', H.dna.species.eyes)
	eyes_icon.Blend(eye_color, ICON_ADD)

	return eyes_icon

/obj/item/organ/internal/eyes/serpentid/ui_action_click()
	switch_mode()
	owner.update_sight()

/obj/item/organ/internal/eyes/serpentid/switch_mode(var/force_off = FALSE)
	.=..()
	vision_flags = initial(vision_flags)
	if(lighting_alpha == LIGHTING_PLANE_ALPHA_VISIBLE && !force_off && get_chemical_value(SERPENTID_CHEM_REAGENT_ID) > 0)
		lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		see_in_dark = 8
		chemical_consuption += GAS_ORGAN_CHEMISTRY_EYES
	else
		lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
		see_in_dark = 1
		vision_flags &= ~SEE_BLACKNESS
		chemical_consuption -= 0

/obj/item/organ/internal/eyes/serpentid/insert(mob/living/carbon/M, special = 0, dont_remove_slot = 0)
	. = ..()
	ADD_TRAIT(M, TRAIT_COLORBLIND, ROUNDSTART_TRAIT)

/obj/item/organ/internal/eyes/serpentid/remove(mob/living/carbon/M, special = 0)
	. = ..()
	REMOVE_TRAIT(M, TRAIT_COLORBLIND, ROUNDSTART_TRAIT)

/obj/item/organ/internal/brain/serpentid
	name = "serpentid brain"
	icon = 'modular_ss220/species/icons/obj/surgery.dmi'
	icon_state = "crystal-brain"
