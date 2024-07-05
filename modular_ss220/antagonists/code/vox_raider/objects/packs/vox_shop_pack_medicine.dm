/datum/vox_pack/medicine
	name = "DEBUG Medicine Vox Pack"
	category = VOX_PACK_MEDICINE

/datum/vox_pack/medicine/blood
	name = "Кровь"
	desc = "Кровь предназначенная для переливания Воксам."
	reference = "MED_BLOOD"
	cost = 200
	contains = list(/obj/item/reagent_containers/iv_bag/blood/vox)

/datum/vox_pack/medicine/dart
	name = "Медицинский дротик"
	desc = "Дротик наполненный медикаментами от слабых повреждений."
	reference = "MED_BLOOD"
	cost = 25
	contains = list(/obj/item/reagent_containers/syringe/dart/medical)
