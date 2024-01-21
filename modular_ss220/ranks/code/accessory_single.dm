// =================================
// Одиночные звания для точечного спавна
// Например для педалей
// =================================
/obj/item/clothing/accessory/rank/single
	icon_state = "holobadge_rank"
	item_state = "gold_id"
	item_color = "holobadge_rank"
	var/rank_name = "Специалист"

// ============= Initial Name =============
/obj/item/clothing/accessory/rank/single/get_rank_name(mob/user)
	var/new_rank_name = "[rank_name] [user.real_name]"
	return new_rank_name

// ========================================
/obj/item/clothing/accessory/rank/single/enlisted
	name = "голографические погоны офицера"
	rank_name = "Кадет"
/obj/item/clothing/accessory/rank/single/enlisted/private
	rank_name = "Рядовой"
/obj/item/clothing/accessory/rank/single/enlisted/corporal
	rank_name = "Ефрейтор"
/obj/item/clothing/accessory/rank/single/enlisted/sergeant/lance
	rank_name = "Мл.Сержант"
/obj/item/clothing/accessory/rank/single/enlisted/sergeant
	rank_name = "Сержант"
/obj/item/clothing/accessory/rank/single/enlisted/sergeant/senior
	rank_name = "Ст.Сержант"
/obj/item/clothing/accessory/rank/single/enlisted/sergeant/major
	rank_name = "Старшина"

/obj/item/clothing/accessory/rank/single/officer
	name = "голографические погоны старшего офицера"
	icon_state = "holobadge_rank_officer"
	item_color = "holobadge_rank_officer"
	rank_name = "Офицер"
/obj/item/clothing/accessory/rank/single/officer/prapor
	rank_name = "Прапорщик"
/obj/item/clothing/accessory/rank/single/officer/prapor/senior
	rank_name = "Ст.Прапорщик"
/obj/item/clothing/accessory/rank/single/officer/lieutenant/sub
	rank_name = "Мл.Лейтенант"
/obj/item/clothing/accessory/rank/single/officer/lieutenant
	rank_name = "Лейтенант"
/obj/item/clothing/accessory/rank/single/officer/lieutenant/senior
	rank_name = "Ст.Лейтенант"
/obj/item/clothing/accessory/rank/single/officer/captain
	rank_name = "Капитан"
/obj/item/clothing/accessory/rank/single/officer/major
	rank_name = "Майор"

/obj/item/clothing/accessory/rank/single/command
	name = "голографические погоны командования"
	icon_state = "holobadge_rank_officer"
	item_color = "holobadge_rank_officer"
	rank_name = "Командир"
/obj/item/clothing/accessory/rank/single/command/podpolk
	rank_name = "Подполковник"
/obj/item/clothing/accessory/rank/single/command/polk
	rank_name = "Полковник"
/obj/item/clothing/accessory/rank/single/command/gen
	rank_name = "Генерал"
/obj/item/clothing/accessory/rank/single/command/gen/maj
	rank_name = "Генерал-Майор"
/obj/item/clothing/accessory/rank/single/command/gen/lieut
	rank_name = "Генерал-Лейтенант"
/obj/item/clothing/accessory/rank/single/command/gen/polk
	rank_name = "Генерал-Полковник"
/obj/item/clothing/accessory/rank/single/command/gen/supreme
	rank_name = "Верховный Генерал"

/obj/item/clothing/accessory/rank/single/warden
	name = "голографические погоны смотрителя"
	icon_state = "holobadge_rank_officer"
	item_color = "holobadge_rank_officer"
	rank_name = "Надзиратель"
/obj/item/clothing/accessory/rank/single/warden/keeper
	rank_name = "Смотритель"
/obj/item/clothing/accessory/rank/single/warden/coord
	rank_name = "Координатор"
/obj/item/clothing/accessory/rank/single/warden/overseer
	rank_name = "Верховный Надзиратель"

/obj/item/clothing/accessory/rank/single/detective
	name = "голографические погоны детектива"
	rank_name = "Детектив"
/obj/item/clothing/accessory/rank/single/detective/sleuth
	rank_name = "Сыщик"
/obj/item/clothing/accessory/rank/single/detective/investigator
	rank_name = "Следователь"
/obj/item/clothing/accessory/rank/single/detective/investigator/senior
	rank_name = "Ст. Следователь"
/obj/item/clothing/accessory/rank/single/detective/specialist
	rank_name = "Специалист Бюро"
/obj/item/clothing/accessory/rank/single/detective/inspector
	rank_name = "Инспектор"

/obj/item/clothing/accessory/rank/single/specialist
	rank_name = "Специалист"
