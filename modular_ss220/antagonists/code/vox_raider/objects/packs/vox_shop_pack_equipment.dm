/datum/vox_pack/equipment
	name = "DEBUG Equipment Vox Pack"
	category = VOX_PACK_EQUIPMENT


// ============== BACKPACK ==============
/datum/vox_pack/equipment/backpack
	name = "Рюкзак"
	desc = "Рюкзак из плотно переплетенного синтетического волокна. Хорошо защищает спину носителя при побегах и вмещает достаточно добра."
	cost = 50
	contains = list(/obj/item/storage/backpack/vox)

/datum/vox_pack/equipment/backpack/duffel
	name = "Сумка"
	desc = "Сумка из синтетического волокна. Емкий, вмещает много добра."
	cost = 50
	contains = list(/obj/item/storage/backpack/duffel/vox)

/datum/vox_pack/equipment/backpack/satchel
	name = "Ранец"
	desc = "Ранец из синтетического волокна. Компактный, из-за чего его можно отлично прятать."
	cost = 50
	contains = list(/obj/item/storage/backpack/satchel_flat/vox)


// ============== GLOVES ==============
/datum/vox_pack/equipment/gloves
	name = "Рукавицы"
	desc = "Плотные рукавицы с когтями."
	cost = 50
	contains = list(/obj/item/clothing/gloves/vox)

/datum/vox_pack/equipment/gloves/insulated
	name = "Изоляционные Рукавицы"
	desc = "Плотные изоляционные рукавицы с когтями."
	cost = 50
	contains = list(/obj/item/clothing/gloves/color/yellow/vox)


// ============== MAGBOOTS ==============
/datum/vox_pack/equipment/magboots
	name = "Магнитные Налапочники"
	desc = "Тяжелые бронированные когтистые налапочники."
	cost = 50
	contains = list(/obj/item/clothing/shoes/magboots/vox)

/datum/vox_pack/equipment/magboots/scout
	name = "Магнитные Налапочники Разведки"
	desc = "Легкие когтистые налапочники с продвинутым сцеплением с поверхностью для ускорение передвижения."
	cost = 50
	contains = list(/obj/item/clothing/shoes/magboots/vox/scout)

/datum/vox_pack/equipment/magboots/combat
	name = "Боевые Магнитные Налапочники"
	desc = "Боевые бронированные когтистые налапочники с улучшенным сцеплением с поверхностью."
	cost = 50
	contains = list(/obj/item/clothing/shoes/magboots/vox/combat)

/datum/vox_pack/equipment/magboots/heavy
	name = "Тяжелые Магнитные Налапочники"
	desc = "Тяжелые бронированные когтистые налапочники для ведения боевых действий и защит нижних конечностей от всевозможных угроз."
	cost = 50
	contains = list(/obj/item/clothing/shoes/magboots/vox/heavy)


// ============== Space Suits ==============
/datum/vox_pack/equipment/pressure
	name = "Скафандр"
	desc = "Защитный костюм для работы во враждебной атмосфере с приемлимыми защитными свойствами и полной защитой от давления."
	cost = 50
	contains = list(/obj/item/clothing/suit/space/vox, /obj/item/clothing/head/helmet/space/vox)
