/datum/vox_pack/dart
	name = "DEBUG Dart Vox Pack"
	category = VOX_PACK_DART

// ============== GUNS ==============

/datum/vox_pack/dart/gun
	name = "Дротикомет"
	desc = "Компактный метатель дротиков для доставки химических коктейлей. Вмещает 5(+1) дротиков."
	reference = "D_G"
	cost = 0
	contains = list(/obj/item/gun/syringe/dart_gun)

/datum/vox_pack/dart/gun/ext
	name = "Расширенный Дротикомет"
	desc = "Расширенный метатель дротиков и шприцов для доставки химических коктейлей. Вмещает 5(+1) дротиков и шприцов."
	reference = "D_GE"
	cost = 0
	contains = list(/obj/item/gun/syringe/dart_gun/extended)

/datum/vox_pack/dart/gun/big
	name = "Вместительный Дротикомет"
	desc = "Вместительный метатель дротиков для доставки химических коктейлей. Вмещает 10(+1) дротиков."
	reference = "D_GB"
	cost = 0
	contains = list(/obj/item/gun/syringe/dart_gun/big)


// ============== AMMO ==============

/datum/vox_pack/dart/cartridge
	name = "Картридж (5+1)"
	desc = "Подставка для дротиков."
	reference = "D_C"
	cost = 0
	contains = list(/obj/item/storage/dart_cartridge)

/datum/vox_pack/dart/cartridge/extended
	name = "Картридж (5+1)"
	desc = "Расширенная подставка для дротиков и шприцов."
	reference = "D_C_EXT"
	cost = 0
	contains = list(/obj/item/storage/dart_cartridge/extended)

/datum/vox_pack/dart/cartridge/big
	name = "Картридж (10+1)"
	desc = "Увеличенная подставка для дротиков."
	reference = "D_C_BIG"
	cost = 0
	contains = list(/obj/item/storage/dart_cartridge/big)

/datum/vox_pack/dart/cartridge/combat
	name = "Картридж (5+1)"
	desc = "Подставка для боевых дротиков для нанесения повреждений."
	reference = "D_C_COM"
	cost = 0
	contains = list(/obj/item/storage/dart_cartridge/combat)

/datum/vox_pack/dart/cartridge/medical
	name = "Картридж (5+1)"
	desc = "Подставка для полезных дротиков для восстановления."
	reference = "D_C_MED"
	cost = 0
	contains = list(/obj/item/storage/dart_cartridge/medical)

/datum/vox_pack/dart/cartridge/pain
	name = "Картридж (5+1)"
	desc = "Подставка для вредных дротиков, приносящих боль и страдания."
	reference = "D_C_PAIN"
	cost = 0
	contains = list(/obj/item/storage/dart_cartridge/pain)

/datum/vox_pack/dart/cartridge/drugs
	name = "Картридж (5+1)"
	desc = "Подставка для вредных дротиков-наркотиков."
	reference = "D_C_DRUG"
	cost = 0
	contains = list(/obj/item/storage/dart_cartridge/drugs)

/datum/vox_pack/dart/cartridge/random
	name = "Картридж с ???  (10+1)"
	desc = "Случайный набор дротиков с химикатами."
	reference = "D_C_RAND"
	cost = 0
	contains = list(/obj/item/storage/dart_cartridge/big/random)
