/datum/vox_pack/goods
	name = "DEBUG Goods Vox Pack"
	category = VOX_PACK_GOODS
	is_need_trader_cost = FALSE

/datum/vox_pack/goods/figure
	name = "Фигурка"
	desc = "Случайный товар для продажи."
	reference = "G_FIG"
	cost = 25
	contains = list(/obj/random/figure)

/datum/vox_pack/goods/mech
	name = "Механоид"
	desc = "Случайный товар для продажи."
	reference = "G_MECH"
	cost = 25
	contains = list(/obj/random/mech)

/datum/vox_pack/goods/plushie
	name = "Плюшка"
	desc = "Случайный товар для продажи."
	reference = "G_PLUSH"
	cost = 25
	contains = list(/obj/random/plushie)

/datum/vox_pack/goods/therapy
	name = "Плюшка-Обнимашка"
	desc = "Случайный товар для продажи."
	reference = "G_THER"
	cost = 25
	contains = list(/obj/random/therapy)

/datum/vox_pack/goods/carp_plushie
	name = "Плюшка-Карпушка"
	desc = "Случайный товар для продажи."
	reference = "G_CARP"
	cost = 25
	contains = list(/obj/random/carp_plushie)

/datum/vox_pack/goods/food
	name = "Еда"
	desc = "Случайный товар для продажи."
	reference = "G_CARP"
	cost = 50
	contains = list(/obj/effect/spawner/lootdrop/three_course_meal)

/datum/vox_pack/goods/random
	var/random_subtype

/datum/vox_pack/goods/random/New()
	. = ..()
	if(!random_subtype)
		return
	var/list/possible_types = subtypesof(random_subtype) + list(random_subtype)
	var/choosen_type = pick(possible_types)
	contains.Add(choosen_type)

/datum/vox_pack/goods/random/toy
	name = "Игрушка"
	desc = "Случайный товар для продажи."
	reference = "G_TOY"
	cost = 100
	random_subtype = /obj/item/toy

/datum/vox_pack/goods/random/bikehorn
	name = "Гудок"
	desc = "Случайный товар для продажи."
	reference = "G_HORN"
	cost = 100
	random_subtype = /obj/item/bikehorn

/datum/vox_pack/goods/random/beach_ball
	name = "Мяч"
	desc = "Случайный товар для продажи."
	reference = "G_BALL"
	cost = 100
	random_subtype = /obj/item/beach_ball

/datum/vox_pack/goods/random/instrument
	name = "Музыкальный Инструмент"
	desc = "Случайный товар для продажи."
	reference = "G_MINS"
	cost = 100
	random_subtype = /obj/item/instrument

/datum/vox_pack/goods/random/soap
	name = "Мыло"
	desc = "Случайный товар для продажи."
	reference = "G_SOAP"
	cost = 25
	random_subtype = /obj/item/soap

/datum/vox_pack/goods/random/lighter
	name = "Зажигалка"
	desc = "Случайный товар для продажи."
	reference = "G_LIGH"
	cost = 75
	random_subtype = /obj/item/lighter
