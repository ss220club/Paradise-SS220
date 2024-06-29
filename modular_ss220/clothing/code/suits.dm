/obj/item/clothing/suit/v_jacket
	name = "куртка V"
	desc = "Куртка так называемого V."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "v_jacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/takemura_jacket
	name = "куртка Такэмуры"
	desc = "Куртка так называемого Такэмуры."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "takemura_jacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/katarina_jacket
	name = "куртка Катарины"
	desc = "Куртка так называемой Катарины."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "katarina_jacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/katarina_cyberjacket
	name = "киберкуртка Катарины"
	desc = "Кибер-куртка так называемой Катарины."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "katarina_cyberjacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/hooded/shark_costume
	name = "костюм акулы"
	desc = "Костюм из 'синтетической' кожи акулы, пахнет."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "shark_casual"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	allowed = list(/obj/item/tank/internals/emergency_oxygen)
	hoodtype = /obj/item/clothing/head/hooded/shark_hood

/obj/item/clothing/head/hooded/shark_hood
	name = "акулий капюшон"
	desc = "Капюшон, прикрепленный к костюму акулы."
	icon = 'modular_ss220/clothing/icons/object/hats.dmi'
	icon_state = "shark_casual"
	icon_override = 'modular_ss220/clothing/icons/mob/hats.dmi'
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags = BLOCKHAIR
	flags_inv = HIDEEARS

/obj/item/clothing/suit/hooded/shark_costume/light
	name = "светло-голубой костюм акулы"
	icon_state = "shark_casual_light"
	hoodtype = /obj/item/clothing/head/hooded/shark_hood/light

/obj/item/clothing/head/hooded/shark_hood/light
	name = "светло-голубой акулий капюшон"
	icon_state = "shark_casual_light"

/obj/item/clothing/suit/space/deathsquad/officer/syndie
	name = "куртка офицера синдиката"
	desc = "Длинная куртка из высокопрочного волокна."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "jacket_syndie"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'

/obj/item/clothing/suit/space/deathsquad/officer/field
	name = "полевая форма офицера флота Нанотрейзен"
	desc = "Парадный плащ, разработанный в качестве массового варианта формы Верховного Главнокомандующего. У этой униформы нет тех же защитных свойств, что и у оригинала, но она все ещё является довольно удобным и стильным предметом гардероба."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "ntsc_uniform"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'

/obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt
	name = "армированная мантия офицера флота Нанотрейзен"
	desc = "Один из вариантов торжественного одеяния сотрудников Верховного Командования Нанотрейзен, подойдет для официальной встречи или важного вылета. Сшита из лёгкой и сверхпрочной ткани."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "ntsc_cloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	species_restricted = list("Human")

/obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt/coat_nt
	name = "полевой плащ офицера флота Нанотрейзен"
	desc = "Парадный плащ нового образца, внедряемый на объектах компании в последнее время. Отличительной чертой является стоячий воротник и резаный подол. Невысокие показатели защиты нивелируются пафосом, источаемым этим плащом."
	icon_state = "ntsc_coat"

/obj/item/clothing/suit/hooded/vi_arcane
	name = "куртка Вай"
	desc = "Слегка потрёпанный жакет боевой девчушки Вай."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "vi_arcane"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	flags_inv = HIDEJUMPSUIT
	hoodtype = /obj/item/clothing/head/hooded/vi_arcane

/obj/item/clothing/head/hooded/vi_arcane
	name = "капюшон Вай"
	desc = "Капюшон, прикреплённый к жакету Вай."
	icon = 'modular_ss220/clothing/icons/object/hats.dmi'
	icon_state = "vi_arcane"
	icon_override = 'modular_ss220/clothing/icons/mob/hats.dmi'
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags = BLOCKHAIR
	flags_inv = HIDEEARS

/obj/item/clothing/suit/hooded/vi_arcane
	name = "жакет Вай"
	icon_state = "vi_arcane"
	hoodtype = /obj/item/clothing/head/hooded/vi_arcane

/obj/item/clothing/head/hooded/vi_arcane
	name = "капюшон Вай"
	icon_state = "vi_arcane"

/obj/item/clothing/suit/storage/soundhand_black_jacket
	name = "фанатская черная куртка группы Саундхэнд."
	desc = "Фанатская черная куртка группы Саундхэнд."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_black_jacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_black_jacket/soundhand_black_jacket_tag
	name = "черная куртка с тэгом группы Саундхэнд."
	desc = "Легендарная черная куртка с тэгом группы Саундхэнд."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_black_jacket_teg"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "soundhand_black_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_olive_jacket
	name = "фанатская оливковая куртка группы Саундхэнд."
	desc = "Фанатская оливковая куртка группы Саундхэнд."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_olive_jacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_olive_jacket/soundhand_olive_jacket_tag
	name = "оливковая куртка с тэгом группы Саундхэнд."
	desc = "Легендарная оливковая куртка с тэгом группы Саундхэнд."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_olive_jacket_teg"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "soundhand_olive_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_brown_jacket
	name = "фанатская коричневая куртка группы Саундхэнд."
	desc = "Фанатская коричневая куртка группы Саундхэнд."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_brown_jacket"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_brown_jacket/soundhand_brown_jacket_tag
	name = "коричневая куртка с тэгом группы Саундхэнд."
	desc = "Легендарная коричневая куртка с тэгом группы Саундхэнд."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_brown_jacket_teg"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'
	item_state = "soundhand_brown_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/chef/red
	name = "chef's red apron"
	desc = "Хорошо скроенный поварской китель."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "chef_red"
	sprite_sheets = list(
		"Abductor" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Ancient Skeleton" 	= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Diona" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Drask" 			= 	'modular_ss220/clothing/icons/mob/species/drask/suits.dmi',
		"Golem" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Grey" 				= 	'modular_ss220/clothing/icons/mob/species/grey/suits.dmi',
		"Human" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Kidan" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Machine"			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Monkey" 			= 	'modular_ss220/clothing/icons/mob/species/monkey/suits.dmi',
		"Nian" 				= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Plasmaman" 		= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Shadow" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Skrell" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Slime People" 		= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Tajaran" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Unathi" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Vox" 				= 	'modular_ss220/clothing/icons/mob/species/vox/suits.dmi',
		"Vulpkanin" 		= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Nucleation"		=	'modular_ss220/clothing/icons/mob/suits.dmi',
		)

/datum/supply_packs/misc/soundhand
	name = "Soundhand Fan Crate"
	contains = list(/obj/item/clothing/suit/storage/soundhand_black_jacket,
					/obj/item/clothing/suit/storage/soundhand_olive_jacket,
					/obj/item/clothing/suit/storage/soundhand_brown_jacket)
	cost = 600
	containername = "soundhand fan crate"

/* Space Battle */
/obj/item/clothing/suit/space/hardsuit/security
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "hardsuit-sec-old"
	icon_override = 'modular_ss220/clothing/icons/mob/suits.dmi'

/obj/item/clothing/head/helmet/space/hardsuit/security
	icon = 'modular_ss220/clothing/icons/object/helmet.dmi'
	icon_state = "hardsuit0-sec"
	icon_override = 'modular_ss220/clothing/icons/mob/helmet.dmi'

/* SOO jacket */
/obj/item/clothing/suit/space/deathsquad/officer/soo_brown
	icon_state = "brtrenchcoat_open"











//desert

/obj/item/clothing/suit/hooded/desert_cape
	name = "пустынная накидка"
	desc = "Пустынная накидка из особой крепкой ткани. Капюшон поможет не свалиться под палящим солнцем"
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "desertcape"
	sprite_sheets = list(
		"Human"				= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Diona" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Drask" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Grey" 				= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Human" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Machine"			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Nian" 				= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Plasmaman" 		= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Skrell" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Slime People" 		= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Unathi" 			= 	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Vox" 				= 	'modular_ss220/clothing/icons/mob/species/vox/suits.dmi',
		"Nucleation"		=	'modular_ss220/clothing/icons/mob/suits.dmi',
		"Kidan" 			= 	'modular_ss220/clothing/icons/mob/species/kidan/suits.dmi',
		"Tajaran" 			=	'modular_ss220/clothing/icons/mob/species/tajaran/suits.dmi',
		"Vulpkanin" 		= 	'modular_ss220/clothing/icons/mob/suits.dmi',
	)
	flags_inv = HIDETAIL
	armor = list(MELEE = 20, BULLET = 20, LASER = 20, ENERGY = 5, BOMB = 15, RAD = 0, FIRE = 50, ACID = 50)
	allowed = list(/obj/item/reagent_containers/drinks/flask, /obj/item/melee, /obj/item/flash, /obj/item/lighter, /obj/item/storage/fancy/cigarettes, /obj/item/tank/internals, /obj/item/gun/energy, /obj/item/gun/projectile, /obj/item/kitchen/knife, /obj/item/dualsaber)
	hoodtype = /obj/item/clothing/head/hooded/desert_cape

/obj/item/clothing/head/hooded/desert_cape
	name = "капюшон пустынной накидки"
	desc = "Капюшон, прикреплённый к пустынной накидке."
	icon = 'modular_ss220/clothing/icons/object/hats.dmi'
	icon_state = "desertcape_hood"
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	flags = BLOCKHAIR
	flags_inv = HIDEEARS
	sprite_sheets = list(
		"Human"				= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Diona" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Drask" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Grey" 				= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Human" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Machine"			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Nian" 				= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Plasmaman" 		= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Skrell" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Slime People" 		= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Unathi" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Vox" 				= 	'modular_ss220/clothing/icons/mob/species/vox/hats.dmi',
		"Nucleation"		=	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Kidan" 			= 	'modular_ss220/clothing/icons/mob/species/kidan/hats.dmi',
		"Tajaran" 			=	'modular_ss220/clothing/icons/mob/species/tajaran/hats.dmi',
		"Vulpkanin" 		= 	'modular_ss220/clothing/icons/mob/species/vulpkanin/hats.dmi',
	)

/obj/item/clothing/suit/hooded/desert_cape/desert_cape2
	name = "лёгкая пустынная накидка"
	desc = "Лёгкая пустынная накидка из особой крепкой ткани. Капюшон поможет не свалиться под палящим солнцем."
	icon_state = "desertlightcape"
	armor = list(MELEE = 20, BULLET = 10, LASER = 10, ENERGY = 5, BOMB = 15, RAD = 0, FIRE = 50, ACID = 50)
	hoodtype = /obj/item/clothing/head/hooded/desert_cape/desert_cape2

/obj/item/clothing/head/hooded/desert_cape/desert_cape2
	name = "капюшон лёгкой пустынной накидки"
	desc = "Капюшон, прикреплённый к лёгкой пустынной накидке."
	icon_state = "desertlightcape_hood"

/obj/item/clothing/suit/hooded/desert_cape/desert_kidan
	name = "киданская накидка"
	desc = "Мешковатая и лёгкая накидка из особой ткани, позволяет защититься от солнца и недоброжелателей."
	icon_state = "desertkidancape"
	hoodtype = /obj/item/clothing/head/hooded/desert_cape/desert_kidan
	species_restricted = list("Kidan")

/obj/item/clothing/head/hooded/desert_cape/desert_kidan
	name = "капюшон киданской накидки"
	desc = "Капюшон, прикреплённый к киданской накидке."
	icon_state = "desertkidancape_hood"

/obj/item/clothing/suit/space/kidan_powerarmor
	name = "силовая броня жука-рейдера"
	desc = "Силовая броня СССП старого образца. Некоторые партии, по всей видимости, были специально созданы для киданских борцов за независимость. Во всяком случае теперь эта броня пренадлежит рейдерам."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "kidan_power_armor"
	item_state = "kidan_power_armor"
	allowed = list(/obj/item/gun, /obj/item/flashlight, /obj/item/tank/internals, /obj/item/melee/baton, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/restraints/handcuffs, /obj/item/dualsaber)
	slowdown = 0.3
	armor = list(MELEE = 30, BULLET = 25, LASER = 35, ENERGY = 5, BOMB = 30, RAD = 25, FIRE = 50, ACID = 50)
	sprite_sheets = list(
		"Kidan" 			= 	'modular_ss220/clothing/icons/mob/species/kidan/suits.dmi',
	)
	species_restricted = list("Kidan")
	var/footstep = 1

/obj/item/clothing/suit/space/kidan_powerarmor/on_mob_move(dir, mob/mob)
	var/mob/living/carbon/human/H = mob
	if(!istype(H) || H.wear_suit != src || !isturf(H.loc))
		return
	if(footstep > 1)
		playsound(src, 'sound/effects/servostep.ogg', 100, 1)
		footstep = 0
	else
		footstep++
	..()

// village clothes temp

/obj/item/clothing/suit/hooded/abaya
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/head/hooded/screened_niqab
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/suit/poncho
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/accessory/cowboyshirt
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/head/cowboyhat
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/shoes/cowboy
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/suit/fluff/dusty_jacket
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT


//dune hardsuit

/obj/item/clothing/suit/space/hardsuit/dune
	name = "\improper защитный костюм офицера"
	desc = "Специальный костюм офицера Центрального Командования Нанотрейзен предназначенный для защиты от агрессивной окружающей среды."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "hardsuit-CCdesert"
	item_state = "hardsuit-CCdesert"
	slowdown = 0.25
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	flags_inv = HIDEJUMPSUIT
	armor = list(MELEE = 35, BULLET = 15, LASER = 30, ENERGY = 10, BOMB = 30, RAD = 50, FIRE = 75, ACID = 75)
	allowed = list(/obj/item/gun, /obj/item/flashlight, /obj/item/tank/internals, /obj/item/melee/baton, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/restraints/handcuffs, /obj/item/dualsaber)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/dune
	sprite_sheets = list(
		"Human" = 'modular_ss220/clothing/icons/mob/suits.dmi',
	)
	species_restricted = list("Human")

/obj/item/clothing/head/helmet/space/hardsuit/dune
	name = "\improper шлем"
	desc = "Щлем защитного костюма офицера ЦК."
	icon = 'modular_ss220/clothing/icons/object/helmet.dmi'
	icon_state = "hardsuit0-CCdesert"
	item_state = "hardsuit0-CCdesert"
	item_color = "CCdesert"
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	sprite_sheets = list(
		"Human" = 'modular_ss220/clothing/icons/mob/helmet.dmi',
	)
	species_restricted = list("Human")

/obj/item/clothing/suit/space/hardsuit/dune/midnight_suit
	name = "\improper костюм Миднайта"
	desc = "Экзоскелет ударной группы синдиката, модернизированный по спецзаказу Миднайта Блэка."
	icon_state = "hardsuit-midnightsuit"
	item_state = "hardsuit-midnightsuit"
	armor = list(MELEE = 115, BULLET = 115, LASER = 65, ENERGY = 40, BOMB = 200, RAD = INFINITY, FIRE = INFINITY, ACID = INFINITY)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/dune/midnight_suit

/obj/item/clothing/head/helmet/space/hardsuit/dune/midnight_suit
	name = "\improper шлем"
	desc = "Шлем костюма Миднайта."
	icon_state = "hardsuit0-midnightsuit"
	item_state = "hardsuit0-midnightsuit"
	item_color = "midnightsuit"
	armor = list(MELEE = 115, BULLET = 115, LASER = 65, ENERGY = 40, BOMB = 200, RAD = INFINITY, FIRE = INFINITY, ACID = INFINITY)
