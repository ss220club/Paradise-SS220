/obj/item/gun/syringe/dart_gun
	name = "dart gun"
	desc = "Компактный метатель дротиков для доставки химических коктейлей."
	icon = 'modular_ss220/antagonists/icons/guns/projectile.dmi'
	icon_state = "dartgun"
	item_state = "bluetag"
	var/cartridge_overlay = "dartgun_cartridge_overlay"
	max_syringes = 5
	var/list/valid_cartridge_types = list(/obj/item/storage/dart_cartridge)
	var/valid_dart_type = /obj/item/reagent_containers/syringe/dart
	var/obj/item/storage/dart_cartridge/cartridge_loaded
	var/pixel_y_overlay_div = 5	// сколько у нас делений для спрайта оверлея ("Позиций")
	var/pixel_y_overlay_offset = 2 // на сколько пикселей смещаем оверлей

/obj/item/gun/syringe/dart_gun/update_overlays()
	. = ..()
	if(cartridge_loaded)
		var/pixel_y_offset = 0
		var/num = length(syringes)
		if(num)
			pixel_y_offset = -(pixel_y_overlay_div - pixel_y_overlay_div * num / max_syringes) * pixel_y_overlay_offset
		. += image(icon = icon, icon_state = cartridge_overlay,  pixel_y = pixel_y_offset)
		if(cartridge_loaded.overlay_state_color)
			. += image(icon = icon, icon_state = "[cartridge_overlay]_[cartridge_loaded.overlay_state_color]",  pixel_y = pixel_y_offset)
		. += icon_state

/obj/item/gun/syringe/dart_gun/attackby(obj/item/A, mob/user, params, show_msg)
	if(cartridge_loaded)
		for(var/hold_type in cartridge_loaded.can_hold)
			if(!istype(A, hold_type))
				continue
			if(insert_syringe_to_cartridge(A) && user && user.unEquip(A))
				to_chat(user, span_notice("Вы загрузили [A] в [cartridge_loaded] в [src]!"))
				return ..()
		to_chat(user, "Картридж [src] полон!")
		return FALSE
	else
		for(var/cartridge_type in valid_cartridge_types)
			if(istype(A, cartridge_type))
				if(user && !user.unEquip(A))
					return TRUE
				to_chat(user, span_notice("Вы вставили [A] в [src]!"))
				cartridge_load(A)
				return ..()
	if(!chambered.BB && istype(A, valid_dart_type) && length(syringes) < max_syringes)
		return ..()
	if(user)
		to_chat(user, "[A] не вмещается в [src]!")
	return TRUE

/obj/item/gun/syringe/dart_gun/proc/insert_syringe_to_cartridge(obj/item/syringe)
	if(length(syringes) >= max_syringes)
		return FALSE
	syringe.forceMove(cartridge_loaded)
	syringes.Add(syringe)
	process_chamber()
	return TRUE

/obj/item/gun/syringe/dart_gun/proc/cartridge_load(obj/item/A, mob/user)
	A.forceMove(src)
	cartridge_loaded = A
	for(var/obj/item/I in A.contents)
		syringes.Add(I)
	process_chamber()

/obj/item/gun/syringe/dart_gun/proc/cartridge_unload(mob/user)
	if(!cartridge_loaded)
		return FALSE
	user.unEquip(cartridge_loaded)
	cartridge_loaded.update_icon()
	cartridge_loaded = null
	update_icon()

/obj/item/gun/syringe/dart_gun/attack_self(mob/living/user)
	if(cartridge_loaded)
		user.put_in_hands(cartridge_loaded)
		playsound(src, 'modular_ss220/antagonists/sound/guns/m79_unload.ogg', 50, 1)
		to_chat(user, span_notice("Вы выгрузили [cartridge_loaded] с [src]."))
		cartridge_loaded = null
		process_chamber()
		return TRUE
	return ..()

/obj/item/gun/syringe/dart_gun/process_chamber()
	. = ..()
	if(!cartridge_loaded)
		update_icon()
		return

	// Вышвыриваем картридж
	if(!length(syringes))
		var/turf/current_turf = get_turf(src)
		cartridge_loaded.forceMove(current_turf)
		cartridge_loaded.throw_at(target = current_turf, range = 3, speed = 1)
		cartridge_loaded.pixel_x = rand(-10, 10)
		cartridge_loaded.pixel_y = rand(-4, 16)
		cartridge_loaded.update_icon()
		cartridge_loaded = null
		update_icon()
		playsound(src, 'modular_ss220/antagonists/sound/guns/m79_break_open.ogg', 50, 1)
		return

	playsound(src, 'modular_ss220/antagonists/sound/guns/m79_reload.ogg', 50, 1)
	update_icon()


/obj/item/storage/dart_cartridge
	name = "dart cartridge"
	desc = "Подставка для дротиков."
	icon = 'modular_ss220/antagonists/icons/guns/ammo.dmi'
	icon_state = "darts-0"
	var/icon_state_base = "darts"
	var/overlay_state = "darts_overlay"
	var/overlay_state_color
	item_state = "rcdammo"
	origin_tech = "materials=2"
	storage_slots = 5
	can_hold = list(
		/obj/item/reagent_containers/syringe/dart
	)
	var/dart_fill_type	// Каким дротиком заполним?
	var/dart_fill_num = 5	// Сколько дротиков заполним

/obj/item/storage/dart_cartridge/update_icon()
	. = ..()
	var/num = length(contents)
	if(!num)
		icon_state = "[icon_state_base]-0"
	else if(num > storage_slots)
		icon_state = "[icon_state_base]-[storage_slots]"
	else
		icon_state = "[icon_state_base]-[num]"
	return TRUE

/obj/item/storage/dart_cartridge/update_overlays()
	. = ..()
	if(overlay_state_color)
		. += "[overlay_state]_[overlay_state_color]"

/obj/item/storage/dart_cartridge/populate_contents()
	if(dart_fill_type)
		for(var/i in 1 to dart_fill_num+1) //На один больше чтобы фулл заряжался + 1 внутрь
			new dart_fill_type(src)
		update_icon()


/obj/item/reagent_containers/syringe/dart
	name = "dart"
	desc = "Дротик содержащий химические коктейли."
	icon = 'modular_ss220/antagonists/icons/objects/dart.dmi'
	amount_per_transfer_from_this = 15
	volume = 15


// ============== Шприцеметы ==============

/obj/item/gun/syringe/dart_gun/extended
	name = "extended dart gun"
	desc = "Расширенный метатель дротиков и шприцов для доставки химических коктейлей."
	icon_state = "dartgun_ext"
	valid_cartridge_types = list(
		/obj/item/storage/dart_cartridge,
		/obj/item/storage/dart_cartridge/extended
		)

/obj/item/gun/syringe/dart_gun/big
	name = "capacious dart gun"
	desc = "Вместительный метатель дротиков для доставки химических коктейлей."
	icon_state = "dartgun_big"
	max_syringes = 10
	pixel_y_overlay_offset = 1
	valid_cartridge_types = list(
		/obj/item/storage/dart_cartridge,
		/obj/item/storage/dart_cartridge/big,
		)


// ============= Картриджи =============

/obj/item/storage/dart_cartridge/extended
	name = "extended dart cartridge"
	desc = "Подставка для дротиков и шприцов."
	overlay_state_color = "ext"
	can_hold = list(
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/syringe/dart
	)

/obj/item/storage/dart_cartridge/big
	name = "capacious dart cartridge"
	desc = "Расширенная подставка для дротиков."
	overlay_state_color = "big"
	storage_slots = 10
	dart_fill_num = 10

/obj/item/storage/dart_cartridge/combat
	name = "combat dart cartridge"
	desc = "Подставка для боевых дротиков для нанесения повреждений."
	overlay_state_color = "red"
	dart_fill_type = /obj/item/reagent_containers/syringe/dart/combat

/obj/item/storage/dart_cartridge/medical
	name = "medical dart cartridge"
	overlay_state_color = "teal"
	desc = "Подставка для полезных дротиков для восстановления."
	dart_fill_type = /obj/item/reagent_containers/syringe/dart/medical

/obj/item/storage/dart_cartridge/pain
	name = "pain dart cartridge"
	overlay_state_color = "yellow"
	desc = "Подставка для вредных дротиков, приносящих боль и страдания."
	dart_fill_type = /obj/item/reagent_containers/syringe/dart/pain

/obj/item/storage/dart_cartridge/drugs
	name = "drugs dart cartridge"
	overlay_state_color = "purple"
	desc = "Подставка для дротиков-наркотиков."
	dart_fill_type = /obj/item/reagent_containers/syringe/dart/drugs


// ============= Шприцы =============

/obj/item/reagent_containers/syringe/dart/combat
	name = "combat dart"
	desc = "Боевой дротик, заставляющий цель потерять равновесие и впоследствии обездвижиться."
	list_reagents = list("space_drugs" = 5, "ether" = 5, "haloperidol" = 5)

/obj/item/reagent_containers/syringe/dart/medical
	name = "medical dart"
	desc = "Медицинский дротик для восстановления большинства повреждений."
	list_reagents = list("silver_sulfadiazine" = 5, "styptic_powder" = 5, "charcoal" = 5)

/obj/item/reagent_containers/syringe/dart/pain
	name = "pain dart"
	desc = "Зудящий порошок с примесью гистамина для страданий."
	list_reagents = list("itching_powder" = 10, "histamine" = 5)

/obj/item/reagent_containers/syringe/dart/drugs
	name = "pain dart"
	desc = "Отвратительная смесь наркотиков, вызывающая галлюцинации, потерю координации и рассудка."
	list_reagents = list(
		"space_drugs" = 5, "lsd" = 5, "fliptonium" = 2, "jenkem" = 2, "happiness" = 1)

/obj/item/reagent_containers/syringe/dart/antiviral
	name = "dart (spaceacillin)"
	desc = "Содержит противовирусные вещества."
	list_reagents = list("spaceacillin" = 10)

/obj/item/reagent_containers/syringe/dart/charcoal
	name = "dart (charcoal)"
	desc = "Содержит древесный уголь для лечения токсинов и повреждений от них."
	list_reagents = list("charcoal" = 10)

/obj/item/reagent_containers/syringe/dart/epinephrine
	name = "dart (Epinephrine)"
	desc = "Содержит адреналин для стабилизации пациентов."
	list_reagents = list("epinephrine" = 10)

/obj/item/reagent_containers/syringe/dart/insulin
	name = "dart (insulin)"
	desc = "Содержит инсулин для лечения диабета."
	list_reagents = list("insulin" = 10)

/obj/item/reagent_containers/syringe/dart/calomel
	name = "dart (calomel)"
	desc = "Содержит токсичный каломель для очистки от других веществ в организме."
	list_reagents = list("calomel" = 10)

/obj/item/reagent_containers/syringe/dart/heparin
	name = "dart (heparin)"
	desc = "Содержит гепарин, антикоагулянт крови."
	list_reagents = list("heparin" = 10)

/obj/item/reagent_containers/syringe/dart/bioterror
	name = "bioterror dart"
	desc = "Содержит несколько парализующих реагентов."
	list_reagents = list("neurotoxin" = 5, "capulettium" = 5, "sodium_thiopental" = 5)

/obj/item/reagent_containers/syringe/dart/capulettium
	name = "capulettium dart"
	desc = "Для упокоения целей."
	list_reagents = list("capulettium" = 10)

/obj/item/reagent_containers/syringe/dart/sarin
	name = "toxin dart"
	desc = "Смертельный нейротоксин в малых дозах."
	list_reagents = list("sarin" = 5)

/obj/item/reagent_containers/syringe/dart/pancuronium
	name = "pancuronium dart"
	desc = "Мощный парализующий яд"
	list_reagents = list("pancuronium" = 5)
