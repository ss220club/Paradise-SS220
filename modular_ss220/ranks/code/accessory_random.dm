// =================================
// Выбор рандомных званий для точечного спавна
// Например для педалей
// =================================
/obj/item/clothing/accessory/rank/random
	icon_state = "holobadge_rank"
	item_state = "gold_id"
	item_color = "holobadge_rank"
	var/list/possible_ranks_list = list("Специалист")

// ============= Initial Name =============
/obj/item/clothing/accessory/rank/random/get_rank_name(mob/user)
	if(length(possible_ranks_list))
		return user.real_name
	var/new_rank_name = pick(possible_ranks_list)
	return "[new_rank_name] [user.real_name]"

// ========================================
/obj/item/clothing/accessory/rank/random/enlisted
	name = "голографические погоны офицера"
	possible_ranks_list = list(
		"Рядовой",
		"Ефрейтор",
		"Мл. Сержант",
		"Сержант",
		"Ст. Сержант",
		"Старшина",
	)

/obj/item/clothing/accessory/rank/random/officer
	name = "голографические погоны старшего офицера"
	icon_state = "holobadge_rank_officer"
	item_color = "holobadge_rank_officer"
	possible_ranks_list = list(
		"Прапорщик",
		"Ст. Прапорщик",
		"Мл. Лейтенант",
		"Лейтенант",
		"Ст. Лейтенант",
		"Капитан",
		"Майор",
	)

/obj/item/clothing/accessory/rank/random/command
	name = "голографические погоны командования"
	icon_state = "holobadge_rank_officer"
	item_color = "holobadge_rank_officer"
	possible_ranks_list = list(
		"Подполковник",
		"Полковник",
		"Генерал-Майор",
		"Генерал-Лейтенант",
		"Генерал-Полковник",
		"Верховный Генерал",
	)

/obj/item/clothing/accessory/rank/random/warden
	name = "голографические погоны смотрителя"
	icon_state = "holobadge_rank_officer"
	item_color = "holobadge_rank_officer"
	possible_ranks_list = list(
		"Смотритель",
		"Надзиратель" ,
		"Координатор",
		"Верховный Надзиратель",
	)

/obj/item/clothing/accessory/rank/random/detective
	name = "голографические погоны детектива"
	possible_ranks_list = list(
		"Сыщик",
		"Следователь",
		"Ст. Следователь",
		"Специалист Бюро",
		"Инспектор",
	)
