/obj/item/reagent_containers/glass/beaker/variety/white
	name = "x-large beaker"
	desc = "Мензурка, созданная с применением пластика."
	icon = 'modular_ss220/objects/icons/beakers.dmi'
	icon_state = "beakerwhite"
	volume = 150
	amount_per_transfer_from_this = 10
	container_type = OPENCONTAINER

/obj/item/reagent_containers/glass/beaker/variety/gold
	name = "metamaterial beaker"
	desc = "Мензурка, созданная с применением золота"
	icon = 'modular_ss220/objects/icons/beakers.dmi'
	icon_state = "beakergold"
	volume = 180
	amount_per_transfer_from_this = 10
	container_type = OPENCONTAINER

/obj/item/reagent_containers/glass/beaker/variety/white/Initialize(mapload)
	. = ..()
	possible_transfer_amounts += list(55,80,110,130,150)

/obj/item/reagent_containers/glass/beaker/variety/gold/Initialize(mapload)
	. = ..()
	possible_transfer_amounts += list(55,80,110,130,150,160,180)

/obj/item/reagent_containers/glass/beaker/variety/on_reagent_change()
	. = ..()
	update_icon(UPDATE_OVERLAYS)

/obj/item/reagent_containers/glass/beaker/variety/update_overlays()
	. = ..()
	if(reagents.total_volume)
		var/image/internal_reagents = image('modular_ss220/objects/icons/beaker_fillings.dmi', src, "[icon_state]10")

		var/icon_choose = round((reagents.total_volume / volume) * 100)
		switch(icon_choose)
			if(0 to 9)
				internal_reagents.icon_state = "[icon_state]-10"
			if(10 to 24)
				internal_reagents.icon_state = "[icon_state]10"
			if(25 to 49)
				internal_reagents.icon_state = "[icon_state]25"
			if(50 to 74)
				internal_reagents.icon_state = "[icon_state]50"
			if(75 to 79)
				internal_reagents.icon_state = "[icon_state]75"
			if(80 to 90)
				internal_reagents.icon_state = "[icon_state]80"
			if(91 to INFINITY)
				internal_reagents.icon_state = "[icon_state]100"

		internal_reagents.icon += mix_color_from_reagents(reagents.reagent_list)
		. += internal_reagents

	if(!is_open_container())
		. += "lid_[initial(icon_state)]"
		if(!blocks_emissive)
			. += emissive_blocker(icon, "lid_[initial(icon_state)]")
	if(assembly)
		. += "assembly"

/datum/design/beaker_white
	name = "X-large beaker"
	id = "xlarge_beaker"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 500, MAT_PLASTIC = 500, MAT_GLASS = 2500,)
	req_tech = list("materials" = 2, "plasmatech" = 2,)
	build_path = /obj/item/reagent_containers/glass/beaker/variety/white
	category = list("Medical")

/datum/design/beaker_gold
	name = "Metamaterial beaker"
	id = "metamaterial_beaker"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1500, MAT_GOLD = 1500, MAT_GLASS = 2500,)
	req_tech = list("materials" = 4, "plasmatech" = 3)
	build_path = /obj/item/reagent_containers/glass/beaker/variety/gold
	category = list("Medical")
