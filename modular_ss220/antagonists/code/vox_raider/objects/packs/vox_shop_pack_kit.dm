// Цельные наборы
/datum/vox_pack/kit
	name = "DEBUG Kit Vox Pack"
	category = VOX_PACK_KIT
	is_need_trader_cost = FALSE
	var/discount_div = 0.05	// Процент скидки на паки за покупку набора
	var/list/packs_list = list() // Паки которые мы используем для инициализации текущего пака и его цены

/datum/vox_pack/kit/New()
	. = ..()
	var/temp_cost = 0
	for(var/datum/vox_pack/pack in packs_list)
		temp_cost += pack.cost
		contains += pack.contains
		if(pack.limited_stock >= 0)
			limited_stock = min(limited_stock, pack.limited_stock)
	cost += temp_cost / discount_div

// ============== Дешевые Наборы ==============

/datum/vox_pack/kit/lamilar
	name = "Лёгкий Набор"
	desc = "Дешевый и лёгкий набор снаряжения, производящийся в промышленных масштабах и рекомендуемый каждому начинающему и опытному воксу при отсутствии средств."
	reference = "K_LAM"
	packs_list = list(
		/datum/vox_pack/mercenary/lamilar,
		/datum/vox_pack/equipment/magboots,
		/datum/vox_pack/equipment/gloves,
		)
	discount_div = 0.35

/datum/vox_pack/kit/pressure
	name = "Космический Набор"
	desc = "Дешевый набор для перемещения в космосе. Отличное дополнение к полевым наборам."
	reference = "K_PRES"
	packs_list = list(
		/datum/vox_pack/equipment/pressure,
		)
	discount_div = 0.35
	contains = list(
		/obj/item/tank/internals/emergency_oxygen/double/vox,
		/obj/item/clothing/mask/breath/vox,
	)

// ============== Наборы Наемников ==============

/datum/vox_pack/kit/stormtrooper
	name = "Штурмовой Набор"
	desc = "Набор штурмовика для сражения при нормальной атмосфере."
	reference = "K_STR"
	packs_list = list(
		/datum/vox_pack/mercenary/stormtrooper,
		/datum/vox_pack/equipment/magboots/combat,
		/datum/vox_pack/equipment/gloves,
		)

/datum/vox_pack/kit/fieldmedic
	name = "Набор Полевого Медика"
	desc = "Всё для оказания первой помощи и защиты самого медика."
	reference = "K_FM"
	packs_list = list(
		/datum/vox_pack/mercenary/fieldmedic,
		/datum/vox_pack/equipment/magboots,
		/datum/vox_pack/equipment/gloves,
		)
	discount_div = 0.15

/datum/vox_pack/kit/field_scout
	name = "Набор Полевого Разведчика"
	desc = "Набор для быстрых действий в благоприятных условиях."
	reference = "K_FSCT"
	packs_list = list(
		/datum/vox_pack/mercenary/lamilar/scout,
		/datum/vox_pack/equipment/magboots/scout,
		/datum/vox_pack/equipment/gloves/insulated,
		)

/datum/vox_pack/kit/bomber
	name = "Набор Подрывника"
	desc = "Набор медвежатника для собственной защиты и вскрытия защищенного."
	reference = "K_"
	packs_list = list(
		/datum/vox_pack/mercenary/bomber,
		/datum/vox_pack/equipment/magboots/heavy,
		/datum/vox_pack/equipment/gloves/insulated,
		)


// ============== Наборы Рейдеров ==============

/datum/vox_pack/kit/trooper
	name = "Набор Космического Штурмовика"
	desc = "Набор для штурма космических кораблей и станций."
	time_until_available = 60
	reference = "K_"
	packs_list = list(
		/datum/vox_pack/raider/trooper,
		/datum/vox_pack/equipment/magboots/combat,
		/datum/vox_pack/equipment/gloves,
		)
	contains = list(
		/obj/item/clothing/mask/breath/vox/respirator,
		/obj/item/tank/internals/emergency_oxygen/double/vox,
	)

/datum/vox_pack/kit/scout
	name = "Набор Космического Разведчика"
	desc = "Набор для проведения разведки в неблагоприятных условиях."
	time_until_available = 60
	reference = "K_SSCT"
	packs_list = list(
		/datum/vox_pack/raider/scout,
		/datum/vox_pack/equipment/magboots/scout,
		/datum/vox_pack/equipment/gloves/insulated,
		)
	contains = list(
		/obj/item/clothing/mask/breath/vox/respirator,
		/obj/item/tank/internals/emergency_oxygen/double/vox,
	)

/datum/vox_pack/kit/medic
	name = "Набор Космического Медика"
	desc = "Набор для скорого оказания помощи в неблагоприятных условиях и защиты носителя."
	time_until_available = 60
	reference = "K_"
	packs_list = list(
		/datum/vox_pack/raider/medic,
		/datum/vox_pack/equipment/magboots,
		/datum/vox_pack/equipment/gloves,
		)
	discount_div = 0.15
	contains = list(
		/obj/item/clothing/mask/breath/vox,
		/obj/item/tank/internals/emergency_oxygen/double/vox,
	)

/datum/vox_pack/kit/mechanic
	name = "Набор Механика"
	desc = "Набор первичного необходимого для ремонта вышедшего из строя оборудования в условиях боя."
	time_until_available = 60
	reference = "K_"
	packs_list = list(
		/datum/vox_pack/raider/mechanic,
		/datum/vox_pack/equipment/magboots/heavy,
		/datum/vox_pack/equipment/gloves/insulated,
		)
	contains = list(
		/obj/item/clothing/mask/breath/vox,
		/obj/item/tank/internals/emergency_oxygen/double/vox,
	)

/datum/vox_pack/kit/heavy
	name = "Тяжелый Набор"
	desc = "Полный набор тяжелого костюма для работы в условиях переизбыточной опасности."
	time_until_available = 90
	reference = "K_HEAVY"
	packs_list = list(
		/datum/vox_pack/raider/heavy,
		/datum/vox_pack/equipment/magboots/heavy,
		/datum/vox_pack/equipment/gloves/insulated,
		)
	contains = list(
		/obj/item/clothing/mask/breath/vox/respirator,
		/obj/item/tank/internals/emergency_oxygen/double/vox,
	)
