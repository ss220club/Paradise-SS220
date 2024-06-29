/datum/vox_pack/equipment
	name = "DEBUG Equipment Vox Pack"
	category = VOX_PACK_EQUIPMENT


// ============== BACKPACK ==============

/datum/vox_pack/equipment/backpack
	name = "Рюкзак"
	desc = "Рюкзак из плотно переплетенного синтетического волокна. Хорошо защищает спину носителя при побегах и вмещает достаточно добра."
	reference = "E_B"
	cost = 200
	contains = list(/obj/item/storage/backpack/vox)

/datum/vox_pack/equipment/backpack/duffel
	name = "Сумка"
	desc = "Сумка из синтетического волокна. Емкий, вмещает много добра."
	reference = "E_BD"
	cost = 300
	contains = list(/obj/item/storage/backpack/duffel/vox)

/datum/vox_pack/equipment/backpack/satchel
	name = "Ранец"
	desc = "Ранец из синтетического волокна. Компактный, из-за чего его можно отлично прятать."
	reference = "E_BS"
	cost = 150
	contains = list(/obj/item/storage/backpack/satchel_flat/vox)


// ============== GLOVES ==============
/datum/vox_pack/equipment/gloves
	name = "Рукавицы"
	desc = "Плотные рукавицы с когтями с защитой кистей."
	reference = "E_G"
	cost = 400
	contains = list(/obj/item/clothing/gloves/vox)

/datum/vox_pack/equipment/gloves/insulated
	name = "Изоляционные Рукавицы"
	desc = "Плотные изоляционные рукавицы с когтями."
	reference = "E_GI"
	cost = 2000
	contains = list(/obj/item/clothing/gloves/color/yellow/vox)


// ============== MAGBOOTS ==============
/datum/vox_pack/equipment/magboots
	name = "Магнитные Налапочники"
	desc = "Когтистые плотные налапочники с небольшой защитой для лап."
	reference = "E_M"
	cost = 200
	contains = list(/obj/item/clothing/shoes/magboots/vox)

/datum/vox_pack/equipment/magboots/scout
	name = "Магнитные Налапочники Разведки"
	desc = "Легкие когтистые налапочники с продвинутым сцеплением с поверхностью для ускорение передвижения."
	reference = "E_MS"
	cost = 1000
	contains = list(/obj/item/clothing/shoes/magboots/vox/scout)

/datum/vox_pack/equipment/magboots/combat
	name = "Боевые Магнитные Налапочники"
	desc = "Боевые бронированные когтистые налапочники с улучшенным сцеплением с поверхностью."
	reference = "E_MC"
	cost = 2000
	time_until_available = 45
	contains = list(/obj/item/clothing/shoes/magboots/vox/combat)

/datum/vox_pack/equipment/magboots/heavy
	name = "Тяжелые Магнитные Налапочники"
	desc = "Тяжелые бронированные когтистые налапочники для ведения боевых действий и защит нижних конечностей от всевозможных угроз."
	reference = "E_MH"
	cost = 4000
	time_until_available = 60
	contains = list(/obj/item/clothing/shoes/magboots/vox/heavy)


// ============== Space Suits ==============
/datum/vox_pack/equipment/pressure
	name = "Скафандр"
	desc = "Защитный костюм для работы во враждебной атмосфере с приемлимыми защитными свойствами и полной защитой от давления."
	reference = "E_PR"
	cost = 100
	contains = list(
		/obj/item/clothing/suit/space/vox,
		/obj/item/clothing/head/helmet/space/vox
		)


// ============== Misc ==============
/datum/vox_pack/equipment/flag
	name = "Флаг"
	desc = "С ним ценности еще ценнее."
	reference = "E_FLAG"
	cost = 100
	contains = list(/obj/item/flag/vox_raider)

/datum/vox_pack/equipment/radio
	name = "Наушники"
	desc = "Наушник дальней связи для поддержания связи со стаей."
	reference = "E_RAD"
	cost = 100
	contains = list(/obj/item/radio/headset/vox)

/datum/vox_pack/equipment/radio/alt
	name = "Защитные наушники"
	desc = "Наушник дальней связи для поддержания связи со стаей. Защищает ушные раковины от громких звуков"
	reference = "E_RAD_ALT"
	cost = 500
	time_until_available = 60
	contains = list(/obj/item/radio/headset/vox/alt)

/datum/vox_pack/equipment/card
	name = "Идентификационная Карта"
	desc = "Карта для идентификации, смены образов и воровства доступов."
	reference = "E_CARD"
	cost = 150
	contains = list(/obj/item/card/id/syndicate/vox)

/datum/vox_pack/equipment/food
	name = "Варево"
	desc = "Лучше чем ничего."
	reference = "E_FOOD"
	cost = 5
	contains = list(/obj/item/food/snacks/soup/stew)

/datum/vox_pack/equipment/hand_valuer
	name = "Оценщик"
	desc = "Позволяет узнать ценность товаров. Не забудьте его активировать о Расчичетчикик."
	reference = "E_VALUER"
	cost = 100
	contains = list(/obj/item/hand_valuer)

/datum/vox_pack/equipment/nitrogen
	name = "Дыхательный Балон"
	desc = "Сдвоенный дыхательный балон наполненный нитрогеном."
	reference = "E_NITR"
	cost = 50
	contains = list(/obj/item/tank/internals/emergency_oxygen/double/vox)

/datum/vox_pack/equipment/nitrogen
	name = "Дыхательная Маска"
	desc = "С встроенной трубкой для дыхания"
	reference = "E_NITR"
	cost = 25
	contains = list(/obj/item/clothing/mask/breath/vox)

/datum/vox_pack/equipment/jammer
	name = "Глушилка"
	desc = "Глушитель связи."
	reference = "E_JAM"
	cost = 500
	contains = list(/obj/item/jammer)

/datum/vox_pack/equipment/jammer
	name = "Глушилка"
	desc = "Глушитель связи."
	reference = "E_JAM"
	cost = 500
	contains = list(/obj/item/jammer)

/datum/vox_pack/equipment/ai_detector
	name = "Детектор"
	desc = "Детектор искусственного интеллекта замаскированного под мультиметр."
	reference = "E_AI"
	cost = 250
	contains = list(/obj/item/multitool/ai_detect)

/datum/vox_pack/equipment/stealth
	name = "Имплантер Маскировки"
	desc = "Имплантер для скрытых операций и краж."
	reference = "E_BCI_S"
	cost = 2000
	contains = list(/obj/item/bio_chip_implanter/stealth)

/datum/vox_pack/equipment/freedom
	name = "Имплантер Свободы"
	desc = "Имплантер скоротечно изменяющий структуру костей для освобождения от сдерживающих факторов."
	reference = "E_BCI_F"
	cost = 1500
	contains = list(/obj/item/bio_chip_implanter/freedom)
