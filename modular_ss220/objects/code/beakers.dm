/obj/item/reagent_containers/glass/beaker/white
	name = "x-large beaker"
	desc = "Мензурка, созданная с применением пластика."
	icon_state = "beakerwhite"
	volume = 150

/obj/item/reagent_containers/glass/beaker/gold
	name = "metamaterial beaker"
	desc = "Мензурка, созданная с применением золота."
	icon_state = "beakergold"
	volume = 180

/obj/item/reagent_containers/glass/beaker/white/Initialize(mapload)
	. = ..()
	possible_transfer_amounts += list(100, 150)

/obj/item/reagent_containers/glass/beaker/gold/Initialize(mapload)
	. = ..()
	possible_transfer_amounts += list(90, 180)

/datum/design/beaker_white
	name = "X-large Beaker"
	desc = "Мензурка с нанесением покрытия из укреплённого стекла и пластика. Вмещает до 150 юнитов."
	id = "xlarge_beaker"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 500, MAT_PLASTIC = 500, MAT_GLASS = 2500)
	req_tech = list("materials" = 2, "plasmatech" = 2,)
	build_path = /obj/item/reagent_containers/glass/beaker/white
	category = list("Medical")

/datum/design/beaker_gold
	name = "Metamaterial Beaker"
	desc = "Мензурка с нанесением покрытия из золота. Вмещает до 180 юнитов."
	id = "metamaterial_beaker"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1500, MAT_GOLD = 1500, MAT_GLASS = 2500)
	req_tech = list("materials" = 4, "plasmatech" = 3)
	build_path = /obj/item/reagent_containers/glass/beaker/gold
	category = list("Medical")
