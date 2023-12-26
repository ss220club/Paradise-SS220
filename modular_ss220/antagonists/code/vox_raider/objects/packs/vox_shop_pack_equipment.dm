/datum/vox_pack/equipment
	name = "DEBUG Equipment Vox Pack"

// ============== BACKPACK ==============
/datum/vox_pack/equipment/backpack
	name = "Рюкзак"
	desc = "Рюкзак воксов из плотно переплетенного синтетического волокна. Хорошо защищает спину носителя при побегах и вмещает достаточно добра."
	cost = 50
	contains = list(/obj/item/storage/backpack/vox)

/datum/vox_pack/equipment/backpack/duffel
	name = "Сумка"
	desc = "Сумка воксов из синтетического волокна. Емкий, вмещает много добра."
	cost = 50
	contains = list(/obj/item/storage/backpack/duffel/vox)

/datum/vox_pack/equipment/backpack/satchel
	name = "Ранец"
	desc = "Ранец воксов из синтетического волокна. Компактный, из-за чего его можно отлично прятать."
	cost = 50
	contains = list(/obj/item/storage/backpack/satchel_flat/vox)

// ============== GLOVES ==============
/datum/vox_pack/equipment/gloves
	name = "Рукавицы"
	desc = "Плотные рукавицы причудливой формы с когтями."
	cost = 50
	contains = list(/obj/item/clothing/gloves/vox)

/datum/vox_pack/equipment/gloves/insulated
	name = "Изоляционные Рукавицы"
	desc = "Плотные изоляционные рукавицы причудливой формы с когтями."
	cost = 50
	contains = list(/obj/item/clothing/gloves/color/yellow/vox)

// ============== MAGBOOTS ==============
/datum/vox_pack/equipment/magboots
	name = "Магнитные Налапочники"
	desc = "Тяжелые бронированные налапочники для когтистых лап причудливой формы."
	cost = 50
	contains = list(/obj/item/clothing/shoes/magboots/vox)

/datum/vox_pack/equipment/magboots/combat
	name = "Боевые Магнитные Налапочники"
	desc = "Боевые бронированные налапочники для когтистых лап причудливой формы с улучшенным сцеплением с поверхностью."
	cost = 50
	contains = list(/obj/item/clothing/shoes/magboots/vox/combat)

/datum/vox_pack/equipment/magboots/scout
	name = "Магнитные Налапочники Разведки"
	desc = "Легкие налапочники для когтистых лап причудливой формы с продвинутым сцеплением с поверхностью для ускорение передвижения."
	cost = 50
	contains = list(/obj/item/clothing/shoes/magboots/vox/scout)
