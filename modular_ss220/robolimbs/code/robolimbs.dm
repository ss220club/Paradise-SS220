//EI_Start
/datum/robolimb/etaminindustry
	company = "Etamin Industry Gold On Black"
	desc = "Модель протезированной конечности от Этамин Индастрис."
	icon = 'modular_ss220/robolimbs/icons/etaminindustry_main.dmi'
	has_subtypes = 1

/datum/robolimb/etaminindustry/etaminindustry_alt1
	company = "Etamin Industry Elite Series"
	icon = 'modular_ss220/robolimbs/icons/etaminindustry_alt1.dmi'
	parts = list("head")
	has_subtypes = null

/datum/robolimb/etaminindustry/etaminindustry_alt2
	company = "Etamin Industry SharpShooter Series"
	icon = 'modular_ss220/robolimbs/icons/etaminindustry_alt2.dmi'
	parts = list("head")
	has_subtypes = null

/datum/robolimb/etaminindustry/etaminindustry_alt3
	company = "Etamin Industry King Series"
	icon = 'modular_ss220/robolimbs/icons/etaminindustry_alt3.dmi'
	parts = list("head")
	has_subtypes = null

/datum/sprite_accessory/body_markings/head/optics/etamin
	icon = 'modular_ss220/robolimbs/icons/ei_optic.dmi'
	name = "EI Optics"
	species_allowed = list("Machine")
	icon_state = "ei_standart"
	models_allowed = list("Etamin Industry King Series")

/datum/sprite_accessory/body_markings/head/optics/etamin/alt1
	name = "EI Optics Alt"
	icon_state = "ei_alt1"

/datum/sprite_accessory/body_markings/head/optics/etamin/alt2
	name = "EI Optics Alt 2"
	icon_state = "ei_alt2"
//EI_End

//Cybersun_Start
/datum/robolimb/cybersun
	company = "Cybersun Industries"
	desc = "Модель протеза от Киберсан Индастрис."
	icon = 'modular_ss220/robolimbs/icons/cybersun_main.dmi'
	has_subtypes = 1

/datum/robolimb/cybersun/cybersun_redheavy
	company = "Cybersun Industries Heavy"
	icon = 'modular_ss220/robolimbs/icons/cybersun_redheavy.dmi'
	parts = list("chest", "groin", "r_leg", "l_leg", "r_arm", "l_arm")
	has_subtypes = null

/datum/robolimb/cybersun/cybersun_blacklight
	company = "Cybersun Industries Black"
	icon = 'modular_ss220/robolimbs/icons/cybersun_black.dmi'
	parts = list("head", "chest", "groin", "r_leg", "l_leg", "r_arm", "l_arm", "r_hand", "l_hand")
	has_subtypes = null

/datum/robolimb/cybersun/cybersun_blackheavy
	company = "Cybersun Industries Black Heavy"
	icon = 'modular_ss220/robolimbs/icons/cybersun_blackheavy.dmi'
	parts = list("chest", "groin", "r_leg", "l_leg", "r_arm", "l_arm")
	has_subtypes = null

/datum/sprite_accessory/body_markings/head/optics/cybersun
	icon = 'modular_ss220/robolimbs/icons/cs_optics.dmi'
	name = "Two Central Optics"
	species_allowed = list("Machine")
	icon_state = "two_cen"
	models_allowed = list("Cybersun Industries", "Cybersun Industries Black")

/datum/sprite_accessory/body_markings/head/optics/cybersun/tworight
	name = "Two Right Optics"
	icon_state = "two_right"

/datum/sprite_accessory/body_markings/head/optics/cybersun/twoleft
	name = "Two Left Optics"
	icon_state = "two_left"

/datum/sprite_accessory/body_markings/head/optics/cybersun/cyclop
	name = "Cyclops Optics"
	icon_state = "cyclops"

/datum/sprite_accessory/body_markings/head/optics/cybersun/sniper
	name = "Sniper Optics"
	icon_state = "sniper"

/datum/sprite_accessory/body_markings/head/optics/cybersun/tear
	name = "Tear Optics"
	icon_state = "tear"

/datum/sprite_accessory/body_markings/head/optics/cybersun/veil
	name = "Veil Optics"
	icon_state = "veil"
//Cybersun_End
