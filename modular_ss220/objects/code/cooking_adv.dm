/obj/item/reagent_containers/cooking/board/advanced
	icon = 'modular_ss220/objects/icons/cooking_adv.dmi'
	name = "Улучшенная разделочная доска"
	desc = "Усиленная разделочная доска."
	icon_state = "cutting_board_adv"

	product_multiplier = 2

/obj/item/reagent_containers/cooking/board/bluespace
	icon = 'modular_ss220/objects/icons/cooking_adv.dmi'
	name = "Блюспейс разделочная доска"
	desc = "Разделочная доска с блюспейс дублирующим эффектом."
	icon_state = "cutting_board_bs"

	product_multiplier = 4

/obj/item/reagent_containers/cooking/bowl/advanced
	icon = 'modular_ss220/objects/icons/cooking_adv.dmi'
	name = "Улучшенная миска"
	desc = "Усиленная миска для готовки большего обьема пищи."
	icon_state = "bowl_adv"

	product_multiplier = 2

/obj/item/reagent_containers/cooking/bowl/bluespace
	icon = 'modular_ss220/objects/icons/cooking_adv.dmi'
	name = "Блюспейс миска"
	desc = "Миска с блюспейс дублирующим эффектом."
	icon_state = "bowl_bs"

	product_multiplier = 4

/datum/design/board/advanced
	name = "Улучшенная разделочная доска"
	desc = "Усиленная разделочная доска, предназначенная для более эффективной готовки большего количества пищи."
	id = "board/advanced"
	req_tech = list("materials" = 5, "bluespace" = 5)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 300, MAT_GLASS = 100, MAT_TITANIUM = 100)
	build_path = /obj/item/reagent_containers/cooking/board/advanced
	category = list("Miscellaneous")

/datum/design/board/bluespace
	name = "Блюспейс разделочная доска"
	desc = "Разделочная доска, усиленная блюспейс-технологией, позволяющей дублировать приготовленные блюда."
	id = "board/bluespace"
	req_tech = list("materials" = 7, "bluespace" = 7, "powerstorage" = 6)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 300, MAT_GLASS = 100, MAT_TITANIUM = 100, MAT_DIAMOND = 100, MAT_BLUESPACE = 100)
	build_path = /obj/item/reagent_containers/cooking/board/bluespace
	category = list("Miscellaneous")

/datum/design/bowl/advanced
	name = "Улучшенная миска"
	desc = "Усиленная миска для смешивания салатов, с высокой эффективностью позволяющей готовить больше пищи."
	id = "bowl/advanced"
	req_tech = list("materials" = 5, "bluespace" = 5)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 300, MAT_GLASS = 100, MAT_TITANIUM = 100)
	build_path = /obj/item/reagent_containers/cooking/bowl/advanced
	category = list("Miscellaneous")

/datum/design/bowl/bluespace
	name = "Блюспейс миска"
	desc = "Миска, усиленная блюспейс технологиями, способная дублировать готовые блюда."
	id = "bowl/bluespace"
	req_tech = list("materials" = 7, "bluespace" = 7, "powerstorage" = 6)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 300, MAT_GLASS = 100, MAT_TITANIUM = 100, MAT_DIAMOND = 100, MAT_BLUESPACE = 100)
	build_path = /obj/item/reagent_containers/cooking/bowl/bluespace
	category = list("Miscellaneous")
