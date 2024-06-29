/datum/vox_pack/goods
	name = "DEBUG Goods Vox Pack"
	category = VOX_PACK_GOODS
	is_need_trader_cost = FALSE
	var/obj/random_subtype

/datum/vox_pack/goods/New()
	. = ..()
	if(!random_subtype)
		return
	var/list/possible_types = list(random_subtype) + subtypesof(random_subtype)
	var/choosen_type = pick(possible_types)
	contains.Add(choosen_type)

/datum/vox_pack/goods/figure
	name = "Фигурка"
	desc = "Случайный товар для продажи."
	reference = "G_FIG"
	cost = 25
	random_subtype = /obj/item/toy/figure

/datum/vox_pack/goods/mech
	name = "Механоид"
	desc = "Случайный товар для продажи."
	reference = "G_MECH"
	cost = 25
	random_subtype = /obj/item/toy/figure/mech

/datum/vox_pack/goods/plushie
	name = "Плюшка"
	desc = "Случайный товар для продажи."
	reference = "G_PLUSH"
	cost = 25
	random_subtype = /obj/item/toy/plushie

/datum/vox_pack/goods/therapy
	name = "Плюшка-Обнимашка"
	desc = "Случайный товар для продажи."
	reference = "G_THER"
	cost = 25
	random_subtype = /obj/item/toy/therapy

/datum/vox_pack/goods/carp_plushie
	name = "Плюшка-Карпушка"
	desc = "Случайный товар для продажи."
	reference = "G_CARP"
	cost = 25
	random_subtype = /obj/item/toy/plushie/carpplushie

/datum/vox_pack/goods/food
	name = "Еда"
	desc = "Случайный товар для продажи."
	reference = "G_CARP"
	cost = 50
	random_subtype = /obj/item/food/snacks

/datum/vox_pack/goods/toy
	name = "Игрушка"
	desc = "Случайный товар для продажи."
	reference = "G_TOY"
	cost = 100
	random_subtype = /obj/item/toy

/datum/vox_pack/goods/bikehorn
	name = "Гудок"
	desc = "Случайный товар для продажи."
	reference = "G_HORN"
	cost = 100
	random_subtype = /obj/item/bikehorn

/datum/vox_pack/goods/beach_ball
	name = "Мяч"
	desc = "Случайный товар для продажи."
	reference = "G_BALL"
	cost = 100
	random_subtype = /obj/item/beach_ball

/datum/vox_pack/goods/instrument
	name = "Музыкальный Инструмент"
	desc = "Случайный товар для продажи."
	reference = "G_MINS"
	cost = 100
	random_subtype = /obj/item/instrument

/datum/vox_pack/goods/soap
	name = "Мыло"
	desc = "Случайный товар для продажи."
	reference = "G_SOAP"
	cost = 25
	random_subtype = /obj/item/soap

/datum/vox_pack/goods/lighter
	name = "Зажигалка"
	desc = "Случайный товар для продажи."
	reference = "G_LIGH"
	cost = 75
	random_subtype = /obj/item/lighter

/datum/vox_pack/goods/drugs
	name = "Наркотики"
	desc = "Мясу понравится этот товар."
	reference = "G_DRUG"
	cost = 200
	contains = list(/obj/item/storage/pill_bottle/random_drug_bottle)
