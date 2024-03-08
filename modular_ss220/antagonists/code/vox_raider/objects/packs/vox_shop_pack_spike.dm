/datum/vox_pack/spike
	name = "DEBUG Spike Vox Pack"
	category = VOX_PACK_SPIKE


// ============== GUNS ==============

/datum/vox_pack/spike/gun
	name = "Шипомет"
	desc = "Стандартный универсальный шипомет, перезаряжаемый через съемные батареи. Выстреливает энергетическими кристаллами."
	reference = "S_G"
	cost = 1000
	contains = list(/obj/item/gun/energy/spike)

/datum/vox_pack/spike/gun/long
	name = "Длинный Шипомет"
	desc = "Точное оружие с самовосстанавливающимися снарядами способное пронизить шипами сразу несколько стоящих друг за другом целей. Выстреливает длинными энергетическими кристаллами с увеличенной проникающей способностью, за счет снижения смертоносности. Подходит для толп противников."
	reference = "S_GL"
	cost = 1500
	contains = list(/obj/item/gun/energy/spike/long)

/datum/vox_pack/spike/gun/bio
	name = "Био Шипомет"
	desc = "Оружие восстанавливающее снаряды за счет нутриентов носителя-Вокса, но пожирает другие виды при попытке его использования. Выстреливает большими энергетическими заостренными кристаллами, выматывающие цель. Подходит для сражения с одиночной целью."
	reference = "S_GB"
	cost = 1500
	contains = list(/obj/item/gun/energy/spike/bio)

// ============== AMMO ==============

/datum/vox_pack/spike/cell
	name = "Зарядная Ячейка"
	desc = "Стандартная зарядная ячейка подходящая под большинство шипометов."
	reference = "S_C"
	cost = 200
	contains = list(/obj/item/stock_parts/cell/vox_spike)
