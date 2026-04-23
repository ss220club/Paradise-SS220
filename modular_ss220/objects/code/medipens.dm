#define SAFE_MIN_TEMPERATURE T0C+7	// Safe minimum temperature for chemicals before they would start to damage slimepeople.
#define SAFE_MAX_TEMPERATURE T0C+36 // Safe maximum temperature for chemicals before they would start to damage drask.

/obj/item/reagent_containers/hypospray/autoinjector/custom/apply(mob/living/carbon/C, mob/user)
	if(user != C)
		if(!instant_application)
			C.visible_message(span_warning("[user] пытается вколоть [src] в [C]."))
			if(!do_after(user, 3 SECONDS, needhand = TRUE, target = C, progress = TRUE))
				return

		C.visible_message(span_warning("[user] вкалывает [src] в [C]."))
	return ..()

// MARK: Кастом медипены
/obj/item/reagent_containers/hypospray/autoinjector/custom
	var/instant_application = TRUE
	icon = 'modular_ss220/objects/icons/medipens.dmi'
	icon_state = "medipen"
	desc = "Быстрый и безопасный способ вводить химические вещества гуманоидным существам. Этот имеет увеличенную ёмкость."
	amount_per_transfer_from_this = 30
	volume = 30
	instant_application = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/custom/update_icon_state()
	icon_state = replacetext(icon_state, regex(@"\d+$"), "")
	if(reagents.total_volume <= 0)
		icon_state = "[icon_state]0"

/obj/item/reagent_containers/hypospray/autoinjector/custom/brute
	name = "Медипен для физического урона"
	icon_state = "medipen_red"
	desc = "Быстрый и безопасный способ лечить раны и справляться с незначительной болью даже через скафандры. Содержит бикаридин и салициловую кислоту."
	list_reagents = list("bicaridine" = 10, "sal_acid" = 3)
	instant_application = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/custom/burn
	name = "Медипен от ожогов"
	icon_state = "medipen_org"
	desc = "Быстрый и безопасный способ лечить ожоги и регулировать температуру тела даже через скафандры. Содержит келотан и ментол."
	list_reagents = list("kelotane" = 10, "menthol" = 3)
	instant_application = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/custom/critical
	name = "Медипен стабилизации"
	icon_state = "medipen_blu"
	desc = "Быстрый и безопасный способ стабилизировать пациента и предотвратить потерю сознания даже через скафандры. Содержит эпинефрин и сальбутамол."
	list_reagents = list("epinephrine" = 10, "salbutamol" = 5)
	instant_application = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/custom/radiation
	name = "Противорадиационный медипен"
	icon_state = "medipen_rad"
	desc = "Быстрый и безопасный способ противодействовать эффектам облучения даже через скафандры. Содержит йодид калия."
	list_reagents = list("potass_iodide" = 15)
	instant_application = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/custom/toxin
	name = "Противотоксинный медипен"
	icon_state = "medipen_grn"
	desc = "Быстрый и безопасный способ противодействовать эффектам отравления даже через скафандры. Содержит уголь."
	list_reagents = list("charcoal" = 20)
	instant_application = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/custom/elite/brute
	name = "Элитный медипен"
	icon_state = "medipen_red"
	desc = "Специальный медипен содержащий высокачественную медицину способную лечить раны и справляться с колосальными физическими повреждениями даже через скафандры не рекомендуется вкалывать больше трех за раз."
	list_reagents = list("bruzin_plus" = 10)
	instant_application = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/custom/elite/burn
	name = "Элитный медипен"
	icon_state = "medipen_org"
	desc = "Специальный медипен содержащий высокачественную медицину способную лечить раны и справляться с колосальными ожоговыми повреждениями даже через скафандры не рекомендуется вкалывать больше трех за раз."
	list_reagents = list("dermalin_plus" = 10)
	instant_application = FALSE

// MARK: Космическая аптечка
/obj/item/storage/firstaid/spacer
	name = "Космическая аптечка"
	desc = "Медицинский набор, предназначенный для использования в вакууме при ношении EVA и MOD скафандров. Содержит медипены для лечения физического урона и ожогов. Также включает медипены стабилизации с противотоксиным для экстренных случаев и анализатор здоровья."
	icon_state = "firstaid_spacer"
	icon = 'modular_ss220/aesthetics/boxes/icons/boxes.dmi'
	lefthand_file = 'modular_ss220/aesthetics/boxes/icons/boxes_lefthand.dmi'
	righthand_file = 'modular_ss220/aesthetics/boxes/icons/boxes_righthand.dmi'

/obj/item/storage/firstaid/spacer/populate_contents()
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/brute(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/brute(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/burn(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/burn(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/critical(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/toxin(src)
	new /obj/item/healthanalyzer(src)

/datum/supply_packs/medical/spacerkits
	name = "Ящик космических аптечек"
	contains = list(/obj/item/storage/firstaid/spacer,
					/obj/item/storage/firstaid/spacer,
					/obj/item/storage/firstaid/spacer,
					/obj/item/storage/firstaid/spacer
					)
	cost = 400
	containername = "Ящик космических аптечек"

/obj/machinery/suit_storage_unit/expedition
	storage_type = /obj/item/storage/firstaid/spacer

/obj/machinery/suit_storage_unit/security
	storage_type = /obj/item/storage/firstaid/spacer

// MARK: Медипен кейсы
/obj/item/storage/pill_bottle/medipen_case
	name = "Кейс для автоинжекторов"
	desc = "Это контейнер для хранения медицинских автоинжекторов.."
	icon = 'modular_ss220/aesthetics/boxes/icons/boxes.dmi'
	icon_state = "medipen_case"
	belt_icon = "patch_pack"
	use_sound = 'modular_ss220/aesthetics_sounds/sound/handling/plasticbox_open.ogg'
	can_hold = list(/obj/item/reagent_containers/hypospray/autoinjector)
	storage_slots = 10
	max_combined_w_class = 5
	display_contents_with_number = FALSE
	wrapper_state = "medipen_case_wrap"

/datum/design/medipencase
	name = "Кейс для автоинжекторов"
	id = "medipencase"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 160, MAT_GLASS = 40)
	build_path = /obj/item/storage/pill_bottle/medipen_case
	category = list("initial", "Medical")

/obj/item/storage/box/medipen_cases
	name = "Коробка кейсов для автоинжекторов"
	desc = "На передней стороне изображены кейсы для автоинжекторов."
	icon = 'modular_ss220/aesthetics/boxes/icons/boxes.dmi'
	icon_state = "medipen_box"

/obj/item/storage/box/medipen_cases/populate_contents()
	for(var/I in 1 to 7)
		var/obj/item/storage/pill_bottle/P = new /obj/item/storage/pill_bottle/medipen_case(src)
		P.apply_wrapper_color(I)

/obj/item/storage/pill_bottle/medipen_case/radiation
	name = "Кейс содержащий противорадиационные и токсинные автоинжекторы"
	wrapper_color = COLOR_ORANGE

/obj/item/storage/pill_bottle/medipen_case/radiation/populate_contents()
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/radiation(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/toxin(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/radiation(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/toxin(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/radiation(src)

/obj/machinery/smartfridge/medbay/Initialize(mapload)
	. = ..()
	accepted_items_typecache |= typecacheof(list(
		/obj/item/reagent_containers/hypospray/autoinjector,
	))

/obj/machinery/economy/vending/medical/Initialize(mapload)
	products += list(/obj/item/storage/pill_bottle/medipen_case = 1,)
	return ..()

/datum/chemical_production_mode/autoinjectors
	mode_id = "medipens"
	production_name = "Medipens"
	production_icon = "syringe"
	item_type = /obj/item/reagent_containers/hypospray/autoinjector/custom
	sprites = list("medipen", "medipen_red", "medipen_org", "medipen_blu", "medipen_grn", "medipen_prp", "medipen_rad")
	max_items_amount = 20
	max_units_per_item = 30
	name_suffix = " medipen"
	var/static/list/safe_chem_list = list("antihol", "charcoal", "epinephrine", "insulin", "teporone", "salbutamol", "omnizine",
									"weak_omnizine", "stimulants", "synaptizine", "potass_iodide", "oculine", "mannitol",
									"spaceacillin", "salglu_solution", "sal_acid", "cryoxadone", "synthflesh",
									"hydrocodone", "mitocholide", "rezadone", "menthol", "diphenhydramine", "ephedrine",
									"iron", "sanguine_reagent", "kelotane", "bicaridine", "pen_acid")

/datum/chemical_production_mode/autoinjectors/get_base_placeholder_name(datum/reagents/reagents)
	return reagents.get_master_reagent_name()

/datum/chemical_production_mode/autoinjectors/proc/safety_check(datum/reagents/R)
	for(var/datum/reagent/A in R.reagent_list)
		if(!safe_chem_list.Find(A.id))
			return FALSE
	if(R.chem_temp < SAFE_MIN_TEMPERATURE || R.chem_temp > SAFE_MAX_TEMPERATURE)
		return FALSE
	return TRUE

/datum/chemical_production_mode/autoinjectors/configure_item(data, datum/reagents/R, obj/item/reagent_containers/hypospray/autoinjector/custom/P)
	. = ..()
	var/chemicals_is_safe = data["chemicals_is_safe"]

	if(isnull(chemicals_is_safe))
		chemicals_is_safe = safety_check(R)
		data["chemicals_is_safe"] = chemicals_is_safe

	if(chemicals_is_safe)
		P.instant_application = TRUE

#undef SAFE_MIN_TEMPERATURE
#undef SAFE_MAX_TEMPERATURE
