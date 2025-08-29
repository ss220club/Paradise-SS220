/datum/research/autolathe/mini/service/DesignHasReqs(datum/design/D)
	. = ..()
	return D && (D.build_type & AUTOLATHE) && ("Dinnerware" in D.category)
	return ..()
