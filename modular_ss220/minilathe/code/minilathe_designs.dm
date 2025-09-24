// MARK: SHARED DESIGNS
/datum/design/beaker/New()
	. = ..()
	category += list("Containers", "Glassware")
	return ..()

/datum/design/large_beaker/New()
	. = ..()
	category += list("Containers", "Glassware")
	return ..()

/datum/design/bucket/New()
	. = ..()
	category += list("Hydroponical", "Janitorial")
	return ..()

/datum/design/syringe/New()
	. = ..()
	category += list("Containers", "Hydroponical")
	return ..()

/datum/design/eftpos/New()
	. = ..()
	category += list("Service Misc.", "Security Misc.")
	return ..()

/datum/design/recorder/New()
	. = ..()
	category += list("Service Misc.", "Security Misc.")
	return ..()

/datum/design/tape/New()
	. = ..()
	category += list("Service Misc.", "Security Misc.")
	return ..()

/datum/design/dropper
	name = "Dropper"
	id = "dropper"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 10, MAT_GLASS = 20)
	build_path = /obj/item/reagent_containers/dropper
	category = list("initial", "Medical", "Containers", "Hydroponical")

/datum/design/spraybottle/New()
	. = ..()
	category += list("Containers", "Janitorial")
	return ..()

//MARK: MATERIALS
/datum/design/metal/New()
	. = ..()
	category += list("Materials")
	return ..()

/datum/design/glass/New()
	. = ..()
	category += list("Materials")
	return ..()

/datum/design/rglass/New()
	. = ..()
	category += list("Materials")
	return ..()

/datum/design/rods/New()
	. = ..()
	category += list("Materials")
	return ..()

// MARK: SURGICAL TOOLS
/datum/design/scalpel/New()
	. = ..()
	category += list("Surgical Tools")
	return ..()

/datum/design/circular_saw/New()
	. = ..()
	category += list("Surgical Tools")
	return ..()

/datum/design/surgicaldrill/New()
	. = ..()
	category += list("Surgical Tools")
	return ..()

/datum/design/retractor/New()
	. = ..()
	category += list("Surgical Tools")
	return ..()

/datum/design/cautery/New()
	. = ..()
	category += list("Surgical Tools")
	return ..()

/datum/design/hemostat/New()
	. = ..()
	category += list("Surgical Tools")
	return ..()

/datum/design/bonesetter/New()
	. = ..()
	category += list("Surgical Tools")
	return ..()

/datum/design/fixovein/New()
	. = ..()
	category += list("Surgical Tools")
	return ..()

/datum/design/bonegel/New()
	. = ..()
	category += list("Surgical Tools")
	return ..()

// MARK: CONTAINERS
/datum/design/pillbottle/New()
	. = ..()
	category += list("Containers")
	return ..()

/datum/design/lockbox_vial/New()
	. = ..()
	category += list("Containers")
	return ..()

/datum/design/pipette
	name = "Pipette"
	id = "pipette"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 10, MAT_GLASS = 20)
	build_path = /obj/item/reagent_containers/dropper/precision
	category = list("initial", "Medical", "Containers")

// MARK: MISC MEDICAL
/datum/design/stethoscope/New()
	. = ..()
	category += list("Medical Misc.")
	return ..()

/datum/design/health_sensor/New()
	. = ..()
	category += list("Medical Misc.")
	return ..()

/datum/design/safety_hypo/New()
	. = ..()
	category += list("Medical Misc.")
	return ..()

/datum/design/roller_bed/New()
	. = ..()
	category += list("Medical Misc.")
	return ..()

/datum/design/healthanalyzer/New()
	. = ..()
	category += list("Medical Misc.")
	return ..()

/datum/design/prescription_glasses
	name = "Prescription Glasses"
	id = "prescription_glasses"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 100, MAT_GLASS = 250)
	build_path = /obj/item/clothing/glasses/regular
	category = list("initial", "Medical", "Medical Misc.")

// MARK: COOKWARE
/datum/design/bowl/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/icecream_bowl/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/pot/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/pan/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/ovendish/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/grill_grate/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/deep_basket/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/cleaver/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/kitchen_knife/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/cheese_knife/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/pizza_cutter/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/fork/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/spoon/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/spork/New()
	. = ..()
	category += list("Cookware")
	return ..()

/datum/design/tray/New()
	. = ..()
	category += list("Cookware")
	return ..()

// MARK: GLASSWARE
/datum/design/drinking_glass/New()
	. = ..()
	category += list("Glassware")
	return ..()

/datum/design/shot_glass/New()
	. = ..()
	category += list("Glassware")
	return ..()

/datum/design/shaker/New()
	. = ..()
	category += list("Glassware")
	return ..()

// MARK: HYDROPONICAL
/datum/design/cultivator/New()
	. = ..()
	category += list("Hydroponical")
	return ..()

/datum/design/spade/New()
	. = ..()
	category += list("Hydroponical")
	return ..()

/datum/design/shovel/New()
	. = ..()
	category += list("Hydroponical")
	return ..()

/datum/design/plant_analyzer/New()
	. = ..()
	category += list("Hydroponical")
	return ..()

/datum/design/hatchet/New()
	. = ..()
	category += list("Hydroponical")
	return ..()

// MARK: JANITORIAL
/datum/design/mousetrap/New()
	. = ..()
	category += list("Janitorial")
	return ..()

/datum/design/light_tube/New()
	. = ..()
	category += list("Janitorial")
	return ..()

/datum/design/light_bulb/New()
	. = ..()
	category += list("Janitorial")
	return ..()

/datum/design/push_broom
	name = "Push Broom"
	id = "push_broom"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 3500, MAT_GLASS = 500)
	build_path = /obj/item/push_broom
	category = list("initial", "Miscellaneous", "Janitorial")

/datum/design/mop
	name = "Mop"
	id = "mop"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 3500, MAT_GLASS = 500)
	build_path = /obj/item/mop
	category = list("initial", "Miscellaneous", "Janitorial")

/datum/design/flyswatter
	name = "Flyswatter"
	id = "flyswatter"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 3000, MAT_GLASS = 1000)
	build_path = /obj/item/melee/flyswatter
	category = list("initial", "Miscellaneous", "Janitorial")

/datum/design/wetfloor_sign
	name = "Wet Floor Sign"
	id = "wetfloor_sign"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 500, MAT_GLASS = 500)
	build_path = /obj/item/caution
	category = list("initial", "Miscellaneous", "Janitorial")

// MARK: MISC SERVICE
/datum/design/handlabeler/New()
	. = ..()
	category += list("Service Misc.")
	return ..()

/datum/design/desttagger/New()
	. = ..()
	category += list("Service Misc.")
	return ..()

/datum/design/spraycan/New()
	. = ..()
	category += list("Service Misc.")
	return ..()

/datum/design/painter/New()
	. = ..()
	category += list("Service Misc.")
	return ..()

/datum/design/desk_bell/New()
	. = ..()
	category += list("Service Misc.")
	return ..()

// MARK: AMMUNITION
/datum/design/beanbag_slug/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/rubbershot/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/e_charger/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/shotgun_dart/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/incendiary_slug/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/laser_slug/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/riot_dart/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/riot_dart_sniper/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/riot_darts/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/riot_darts_sniper/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/b357/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/c10mm/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/c45/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/c9mm/New()
	. = ..()
	category += list("Ammunition")
	return ..()

/datum/design/c_foam_ammo/New()
	. = ..()
	category += list("Ammunition")
	return ..()

// MARK: MISC SECURITY
/datum/design/handcuffs_mini
	name = "Handcuffs"
	id = "handcuffs"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 500)
	build_path = /obj/item/restraints/handcuffs
	category = list("Security Misc.")

/datum/design/receiver/New()
	. = ..()
	category += list("Security Misc.")
	return ..()

/datum/design/flamethrower/New()
	. = ..()
	category += list("Security Misc.")
	return ..()

/datum/design/sample_kit/New()
	. = ..()
	category += list("Security Misc.")
	return ..()

/datum/design/knuckleduster/New()
	. = ..()
	category += list("Security Misc.")
	return ..()
