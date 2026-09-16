#define BLUESPACE_UTENSIL_ICON 'modular_ss220/objects/icons/bluespace_utensils.dmi'

/obj/item/reagent_containers/cooking

	// mutliplies the amount of product produced by a recipe when using this container
	var/product_multiplier = 1

/obj/item/reagent_containers/cooking/board/advanced
	icon = BLUESPACE_UTENSIL_ICON
	name = "Улучшенная разделочная доска"
	desc = "Усиленная разделочная доска для готовки большего объема пищи."
	icon_state = "cutting_board_adv"

	product_multiplier = 2

/obj/item/reagent_containers/cooking/board/bluespace
	icon = BLUESPACE_UTENSIL_ICON
	name = "Блюспейс разделочная доска"
	desc = "Разделочная доска с блюспейс дублирующим эффектом."
	icon_state = "cutting_board_bs"

	product_multiplier = 3

/obj/item/reagent_containers/cooking/bowl/advanced
	icon = BLUESPACE_UTENSIL_ICON
	name = "Улучшенная миска"
	desc = "Усиленная миска для готовки большего объема пищи."
	icon_state = "bowl_adv"

	product_multiplier = 2

/obj/item/reagent_containers/cooking/bowl/bluespace
	icon = BLUESPACE_UTENSIL_ICON
	name = "Блюспейс миска"
	desc = "Миска с блюспейс дублирующим эффектом."
	icon_state = "bowl_bs"

	product_multiplier = 3

/datum/design/board/advanced
	name = "Улучшенная разделочная доска"
	desc = "Усиленная разделочная доска, предназначенная для более эффективной готовки большего количества пищи."
	id = "board/advanced"
	req_tech = list("materials" = 5, "bluespace" = 5)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 4000, MAT_GLASS = 2000, MAT_TITANIUM = 1000)
	build_path = /obj/item/reagent_containers/cooking/board/advanced
	category = list("Miscellaneous")

/datum/design/board/bluespace
	name = "Блюспейс разделочная доска"
	desc = "Разделочная доска, усиленная блюспейс-технологией, позволяющей дублировать приготовленные блюда."
	id = "board/bluespace"
	req_tech = list("materials" = 7, "bluespace" = 7, "powerstorage" = 6)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 5000, MAT_GLASS = 3000, MAT_TITANIUM = 2500, MAT_DIAMOND = 2000, MAT_BLUESPACE = 1500)
	build_path = /obj/item/reagent_containers/cooking/board/bluespace
	category = list("Miscellaneous")

/datum/design/bowl/advanced
	name = "Улучшенная миска"
	desc = "Усиленная миска для смешивания салатов, повышающая эффективность приготовления и увеличивающая объём готовой пищи."
	id = "bowl/advanced"
	req_tech = list("materials" = 5, "bluespace" = 5)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 4000, MAT_GLASS = 2000, MAT_TITANIUM = 1000)
	build_path = /obj/item/reagent_containers/cooking/bowl/advanced
	category = list("Miscellaneous")

/datum/design/bowl/bluespace
	name = "Блюспейс миска"
	desc = "Миска, усиленная блюспейс-технологиями, способная дублировать готовые блюда."
	id = "bowl/bluespace"
	req_tech = list("materials" = 7, "bluespace" = 7, "powerstorage" = 6)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 5000, MAT_GLASS = 3000, MAT_TITANIUM = 2500, MAT_DIAMOND = 2000, MAT_BLUESPACE = 1500)
	build_path = /obj/item/reagent_containers/cooking/bowl/bluespace
	category = list("Miscellaneous")

#undef BLUESPACE_UTENSIL_ICON
