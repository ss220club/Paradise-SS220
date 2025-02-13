/obj/item/borg/upgrade/modkit/random
	name = "random modkit"

/obj/item/borg/upgrade/modkit/random/Initialize(mapload)
	. = ..()
	var/spawntype = pick(
		/obj/item/borg/upgrade/modkit/range,
		/obj/item/borg/upgrade/modkit/damage,
		/obj/item/borg/upgrade/modkit/tracer,
		/obj/item/borg/upgrade/modkit/tracer/adjustable,
		/obj/item/borg/upgrade/modkit/lifesteal,
		/obj/item/borg/upgrade/modkit/cooldown,
		/obj/item/borg/upgrade/modkit/chassis_mod,
		/obj/item/borg/upgrade/modkit/chassis_mod/orange,
		/obj/item/borg/upgrade/modkit/aoe/turfs,
	)
	new spawntype(loc)
	qdel(src)
