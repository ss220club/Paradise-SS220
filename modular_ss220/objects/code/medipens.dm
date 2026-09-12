#define SAFE_MIN_TEMPERATURE T0C+7	// Safe minimum temperature for chemicals before they would start to damage slimepeople.
#define SAFE_MAX_TEMPERATURE T0C+36 // Safe maximum temperature for chemicals before they would start to damage drask.

// MARK: Custom Medipen
/obj/item/reagent_containers/hypospray/autoinjector/custom
	icon = 'modular_ss220/objects/icons/medipens.dmi'
	icon_state = "base"
	desc = "Быстрый и безопасный способ вводить химические вещества гуманоидным существам. Этот имеет увеличенную ёмкость."
	amount_per_transfer_from_this = 30
	volume = 30

	/// The color of the wrapper overlay.
	var/tag_color = null
	/// The icon state of the wrapper overlay.
	var/color_tag_state = "color_tag_wrapper"

	var/instant_application = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/custom/proc/apply_wrap()
	if(tag_color)
		var/image/I = image(icon, color_tag_state)
		I.color = tag_color
		overlays = list(I)

/obj/item/reagent_containers/hypospray/autoinjector/custom/Initialize(mapload)
	. = ..()
	apply_wrap()

/obj/item/reagent_containers/hypospray/autoinjector/custom/apply(mob/living/carbon/C, mob/user)
	if(user != C)
		if(!instant_application)
			C.visible_message(SPAN_WARNING("[user] пытается вколоть [src] в [C]."))
			if(!do_after(user, 3 SECONDS, needhand = TRUE, target = C, progress = TRUE))
				return

		C.visible_message(SPAN_WARNING("[user] вкалывает [src] в [C]."))
	return ..()

/obj/item/reagent_containers/hypospray/autoinjector/custom/brute
	name = "Медипен против травм"
	tag_color = COLOR_RED
	desc = "Быстрый и безопасный способ лечить раны и справляться с незначительной болью даже через скафандры. Содержит бикаридин и салициловую кислоту."
	list_reagents = list("bicaridine" = 10, "sal_acid" = 3)
	instant_application = TRUE

/obj/item/reagent_containers/hypospray/autoinjector/custom/burn
	name = "Медипен против ожогов"
	tag_color = COLOR_ORANGE
	desc = "Быстрый и безопасный способ лечить ожоги и регулировать температуру тела даже через скафандры. Содержит келотан и ментол."
	list_reagents = list("kelotane" = 10, "menthol" = 3)
	instant_application = TRUE

/obj/item/reagent_containers/hypospray/autoinjector/custom/critical
	name = "Стабилизирующий медипен"
	tag_color = COLOR_BLUE
	desc = "Быстрый и безопасный способ стабилизировать пациента и предотвратить потерю сознания даже через скафандры. Содержит эпинефрин и сальбутамол."
	list_reagents = list("epinephrine" = 10, "salbutamol" = 5)
	instant_application = TRUE

/obj/item/reagent_containers/hypospray/autoinjector/custom/radiation
	name = "Противорадиационный медипен"
	icon_state = "indastrial"
	tag_color = COLOR_BLACK
	desc = "Быстрый и безопасный способ противодействовать эффектам облучения даже через скафандры. Содержит йодид калия и уголь."
	list_reagents = list("potass_iodide" = 15, "charcoal" =5 )
	instant_application = TRUE

/obj/item/reagent_containers/hypospray/autoinjector/custom/toxin
	name = "Противотоксинный медипен"
	tag_color = COLOR_GREEN
	desc = "Быстрый и безопасный способ противодействовать эффектам отравления даже через скафандры. Содержит уголь."
	list_reagents = list("charcoal" = 20)
	instant_application = TRUE

// MARK: Medipen Case
/obj/item/storage/pill_bottle/medipen_case
	name = "Кейс для автоинжекторов"
	desc = "Это контейнер для хранения медицинских автоинжекторов."
	icon = 'modular_ss220/aesthetics/boxes/icons/boxes.dmi'
	icon_state = "medipen_case"
	belt_icon = "patch_pack" // PLACEHOLDER. TEPMPORARY NO REALY, IT IS JUST A PLACEHOLDER, I SWEAR
	use_sound = 'modular_ss220/aesthetics_sounds/sound/handling/plasticbox_open.ogg'
	can_hold = list(/obj/item/reagent_containers/hypospray/autoinjector)
	materials = list(MAT_METAL = 160, MAT_GLASS = 40)
	storage_slots = 7
	max_combined_w_class = 7
	display_contents_with_number = FALSE
	wrapper_state = "medipen_case_wrap"

/datum/design/medipen_case
	name = "Кейс для автоинжекторов"
	id = "medipencase"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 160, MAT_GLASS = 40)
	build_path = /obj/item/storage/pill_bottle/medipen_case
	category = list("initial", "Medical")

// TODO CURRENTLY NOT USED, ADD TO MAPS
/obj/item/storage/box/medipens
	name = "Коробка кейсов для автоинжекторов"
	desc = "На передней стороне изображены кейсы для автоинжекторов."
	icon = 'modular_ss220/aesthetics/boxes/icons/boxes.dmi'
	icon_state = "medipen_box"

/obj/item/storage/box/medipens/populate_contents()
	for(var/I in 1 to 7)
		var/obj/item/storage/pill_bottle/P = new /obj/item/storage/pill_bottle/medipen_case(src)
		P.apply_wrapper_color(I)

/obj/item/storage/pill_bottle/medipen_case/spacer
	name = "Космический кейс для автоинжекторов"
	wrapper_color = COLOR_BROWN_ORANGE

/obj/item/storage/pill_bottle/medipen_case/spacer/populate_contents()
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/brute(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/brute(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/burn(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/burn(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/toxin(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/critical(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/critical(src)

/obj/item/storage/pill_bottle/medipen_case/blueshield
	name = "набор инжекторов Blue Shield"
	wrapper_color = COLOR_CYAN_BLUE

/obj/item/storage/pill_bottle/medipen_case/blueshield/populate_contents()
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/brute(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/brute(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/burn(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/burn(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/toxin(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/radiation(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/critical(src)

/obj/item/storage/pill_bottle/medipen_case/radiation
	name = "Кейс содержащий противорадиационные автоинжекторы"
	wrapper_color = COLOR_ORANGE

/obj/item/storage/pill_bottle/medipen_case/radiation/populate_contents()
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/radiation(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/radiation(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/radiation(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/radiation(src)

/obj/structure/closet/secure_closet/blueshield/populate_contents()
	. = ..()
	new /obj/item/storage/pill_bottle/medipen_case/blueshield(src)

/obj/structure/closet/radiation/populate_contents()
	. = ..()
	new /obj/item/storage/pill_bottle/medipen_case/radiation(src)

/obj/machinery/smartfridge/medbay/Initialize(mapload)
	. = ..()
	accepted_items_typecache |= typecacheof(list(
		/obj/item/reagent_containers/hypospray/autoinjector,
	))

/obj/machinery/economy/vending/medical/Initialize(mapload)
	products += list(/obj/item/storage/pill_bottle/medipen_case = 2,)
	return ..()

/obj/machinery/economy/vending/nta/medical/Initialize(mapload)
	products += list(/obj/item/storage/pill_bottle/medipen_case = 5,
	/obj/item/reagent_containers/hypospray/autoinjector/custom/brute = 10,
	/obj/item/reagent_containers/hypospray/autoinjector/custom/burn = 10,)
	return ..()

/obj/machinery/suit_storage_unit/expedition
	storage_type = /obj/item/storage/pill_bottle/medipen_case/spacer

/obj/machinery/suit_storage_unit/security
	storage_type = /obj/item/storage/pill_bottle/medipen_case/spacer

/datum/chemical_production_mode/autoinjectors
	mode_id = "medipens"
	production_name = "Medipens"
	production_icon = "syringe"
	item_type = /obj/item/reagent_containers/hypospray/autoinjector/custom
	sprites = list("medipen_red", "medipen_orange", "medipen_blue", "medipen_green", "medipen_purple", "medipen_black")
	max_items_amount = 20
	max_units_per_item = 30
	name_suffix = " medipen"
	var/static/list/safe_chem_list = /datum/chemical_production_mode/patches::safe_chem_list

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

	for(var/color_name in /datum/asset/spritesheet/chem_master::medipen_colors)
		if(P.icon_state == "medipen_[color_name]")
			P.tag_color = /datum/asset/spritesheet/chem_master::medipen_colors[color_name]
			break

	P.apply_wrap()

#undef SAFE_MIN_TEMPERATURE
#undef SAFE_MAX_TEMPERATURE
