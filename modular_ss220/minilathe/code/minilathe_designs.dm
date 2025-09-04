/datum/research/minilathe

/datum/research/minilathe/CanAddDesign2Known(datum/design/design)
	// Specifically excludes circuit imprinter and mechfab
	if(design.locked || !(design.build_type & (AUTOLATHE|PROTOLATHE|CRAFTLATHE)))
		return FALSE

	for(var/mat in design.materials)
		if(mat != MAT_METAL && mat != MAT_GLASS)
			return FALSE

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

//MARK: SERVICE TOOLS
/datum/research/minilathe/service/DesignHasReqs(datum/design/D)
	return D && (D.build_type & AUTOLATHE) && (("initial" in D.category) && (("Dinnerware" in D.category) || ("Service Tools" in D.category) || ("Materials" in D.category)))

/datum/design/bucket/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/eftpos/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/cultivator/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/spade/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/shovel/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/plant_analyzer/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/hatchet/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/light_tube/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/light_bulb/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/handlabeler/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/desttagger/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/spraycan/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/painter/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/mousetrap/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/desk_bell/New()
	. = ..()
	category += list("Service Tools")
	return ..()

/datum/design/spraybottle/New()
	. = ..()
	category += list("Service Tools")
	return ..()
