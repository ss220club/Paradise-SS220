// MARK: Miscellaneous
/obj/item/clothing/suit/v_jacket
	name = "куртка V"
	desc = "Куртка так называемого V."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "v_jacket"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/takemura_jacket
	name = "куртка Такэмуры"
	desc = "Куртка так называемого Такэмуры."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "takemura_jacket"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/katarina_jacket
	name = "куртка Катарины"
	desc = "Куртка так называемой Катарины."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "katarina_jacket"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/katarina_cyberjacket
	name = "киберкуртка Катарины"
	desc = "Кибер-куртка так называемой Катарины."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "katarina_cyberjacket"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/hooded/shark_costume
	name = "костюм акулы"
	desc = "Костюм из 'синтетической' кожи акулы, пахнет."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "shark_casual"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
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
	worn_icon = 'modular_ss220/clothing/icons/mob/hats.dmi'
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

/obj/item/clothing/suit/hooded/vi_arcane
	name = "куртка Вай"
	desc = "Слегка потрёпанный жакет боевой девчушки Вай."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "vi_arcane"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	hoodtype = /obj/item/clothing/head/hooded/vi_arcane

/obj/item/clothing/head/hooded/vi_arcane
	name = "капюшон Вай"
	desc = "Капюшон, прикреплённый к жакету Вай."
	icon = 'modular_ss220/clothing/icons/object/hats.dmi'
	icon_state = "vi_arcane"
	worn_icon = 'modular_ss220/clothing/icons/mob/hats.dmi'
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

/obj/item/clothing/suit/storage/soundhand_white_jacket
	name = "серебристая куртка группы Саундхэнд"
	desc = "Редкая серебристая куртка Саундхэнд. Ограниченная серия."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_white_jacket"
	worn_icon_state = "soundhand_white_jacket"
	inhand_icon_state = "soundhand_white_jacket"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_white_jacket/tag
	name = "куртка Арии"
	desc = "Редкая серебристая куртка Арии Вильвен, основательницы Саундхэнд."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_white_jacket_teg"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_black_jacket
	name = "фанатская черная куртка Саундхэнд"
	desc = "Черная куртка группы Саундхэнд, исполненая в духе оригинала, но без логотипа на спине. С любовью для фанатов."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_black_jacket"
	worn_icon_state = "soundhand_black_jacket"
	inhand_icon_state = "soundhand_black_jacket"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_black_jacket/tag
	name = "черная куртка Саундхэнд"
	desc = "Черная куртка с тэгом группы Саундхэнд, которую носят исполнители группы."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_black_jacket_teg"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_olive_jacket
	name = "фанатская оливковая куртка Саундхэнд"
	desc = "Оливковая куртка гурппы Саундхэнд, исполненая в духе оригинала, но без логотипа на спине. С любовью для фанатов."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_olive_jacket"
	worn_icon_state = "soundhand_olive_jacket"
	inhand_icon_state = "soundhand_olive_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_olive_jacket/tag
	name = "оливковая куртка с тэгом группы Саундхэнд"
	desc = "Оливковая куртка с тэгом группы Саундхэнд, которую носят исполнители группы."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_olive_jacket_teg"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_brown_jacket
	name = "фанатская коричневая куртка Саундхэнд"
	desc = "Коричневая куртка Саундхэнд, исполненая в духе оригинала, но без логотипа на спине. С любовью для фанатов."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_brown_jacket"
	worn_icon_state = "soundhand_brown_jacket"
	inhand_icon_state = "soundhand_brown_jacket"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/obj/item/clothing/suit/storage/soundhand_brown_jacket/tag
	name = "коричневая куртка с тэгом Саундхэнд"
	desc = "Коричневая куртка с тэгом группы Саундхэнд, которую носят исполнители группы."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "soundhand_brown_jacket_teg"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'

/datum/supply_packs/misc/soundhand_fan
	name = "Soundhand Fan Crate"
	contains = list(/obj/item/clothing/suit/storage/soundhand_black_jacket,
					/obj/item/clothing/suit/storage/soundhand_black_jacket,
					/obj/item/clothing/suit/storage/soundhand_olive_jacket,
					/obj/item/clothing/suit/storage/soundhand_olive_jacket,
					/obj/item/clothing/suit/storage/soundhand_brown_jacket,
					/obj/item/clothing/suit/storage/soundhand_brown_jacket,
					/obj/item/clothing/suit/storage/soundhand_white_jacket)
	cost = 1500
	containername = "soundhand Fan crate"

/obj/item/clothing/suit/chef/red
	name = "chef's red coat"
	desc = "Хорошо скроенный поварской китель."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "chef_red"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	sprite_sheets = list(
		"Monkey" = 'modular_ss220/clothing/icons/mob/species/monkey/suits.dmi',
		"Grey" = 'modular_ss220/clothing/icons/mob/species/grey/suits.dmi',
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/suits.dmi',
		"Drask" = 'modular_ss220/clothing/icons/mob/species/drask/suits.dmi',
	)

/obj/item/clothing/suit/storage/paramedic/pmed_jacket_new
	name = "Светоотражающая куртка парамедика"
	desc = "Ярко-жёлтая куртка парамедика со светоотражающими элементами, нарукавной мигалкой и множеством карманов. Изготовлена из плотного материала и хорошо заметна с большого расстояния. "
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "pmed_new_jacket_open"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	ignore_suitadjust = FALSE
	suit_adjusted = TRUE
	actions_types = list(/datum/action/item_action/toggle)
	adjust_flavour = "unpin нарукавная мигалка"
	sprite_sheets = list(
		"Drask" 			= 	'modular_ss220/clothing/icons/mob/species/drask/suits.dmi',
		"Vox" 				= 	'modular_ss220/clothing/icons/mob/species/vox/suits.dmi',
		)

// MARK: Space Battle
/obj/item/clothing/suit/space/hardsuit/security
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "hardsuit-sec-old"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'

/obj/item/clothing/head/helmet/space/hardsuit/security
	icon = 'modular_ss220/clothing/icons/object/helmet.dmi'
	icon_state = "hardsuit0-sec"
	worn_icon = 'modular_ss220/clothing/icons/mob/helmet.dmi'

// MARK: NT & Syndie
/* NANOTRASEN */
/obj/item/clothing/suit/space/deathsquad/officer/soo_brown
	icon_state = "brtrenchcoat_open"

/obj/item/clothing/suit/space/deathsquad/officer/field
	name = "полевая форма офицера флота Нанотрейзен"
	desc = "Парадный плащ, разработанный в качестве массового варианта формы Верховного Главнокомандующего. У этой униформы нет тех же защитных свойств, что и у оригинала, но она все ещё является довольно удобным и стильным предметом гардероба."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "ntsc_uniform"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'

/obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt
	name = "армированная мантия офицера флота Нанотрейзен"
	desc = "Один из вариантов торжественного одеяния сотрудников Верховного Командования Нанотрейзен, подойдет для официальной встречи или важного вылета. Сшита из лёгкой и сверхпрочной ткани."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "ntsc_cloak"
	worn_icon = 'modular_ss220/clothing/icons/mob/cloaks.dmi'

/obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt/gold
	name = "накидка офицера флота Нанотрейзен"
	desc = "Изящный плащ для высокопоставленного офицера Нанотрейзен, выполненный из уникального материала, который сочетает в себе лёгкость и прочность. Идеально подходит для торжественных и рабочих мероприятий."
	icon_state = "nt_cloak_gold"

/obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt/coat_nt
	name = "полевой плащ офицера флота Нанотрейзен"
	desc = "Парадный плащ нового образца, внедряемый на объектах компании в последнее время. Отличительной чертой является стоячий воротник и резаный подол. Невысокие показатели защиты нивелируются пафосом, источаемым этим плащом."
	icon_state = "ntsc_coat"

/obj/item/clothing/under/rank/centcom/intern
	name = "nanotrasen intern uniform"
	desc = "Стандартная униформа стажера НТ. Обладает не самым хорошим качеством, однако вполне сгодится для удовлетворения амбиций стажера. В комплекте идёт зеленый галстук. Слава НТ!"
	icon = 'icons/obj/clothing/under/procedure.dmi'
	icon_state = "iaa"
	worn_icon = 'icons/mob/clothing/under/procedure.dmi'
	item_color = "iaa"
	sprite_sheets = list(
		"Vox" = 'icons/mob/clothing/species/vox/under/procedure.dmi',
		"Drask" = 'icons/mob/clothing/species/drask/under/procedure.dmi',
		"Grey" = 'icons/mob/clothing/species/grey/under/procedure.dmi',
		"Kidan" = 'icons/mob/clothing/species/kidan/under/procedure.dmi',
	)

/* SYNDICATE */
/obj/item/clothing/suit/space/deathsquad/officer/syndie
	name = "куртка офицера синдиката"
	desc = "Длинная куртка из высокопрочного волокна."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "jacket_syndie"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'

// MARK: ERT
/obj/item/clothing/suit/armor/vest/ert
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "ember_sec"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	sprite_sheets = list(
		"Kidan" = 'modular_ss220/clothing/icons/mob/species/kidan/suits.dmi',
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/suits.dmi',
		"Drask" = 'modular_ss220/clothing/icons/mob/species/drask/suits.dmi',
	)

/obj/item/clothing/suit/armor/vest/ert/command
	icon_state = "ember_com"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/suit/armor/vest/ert/security
	icon_state = "ember_sec"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/armor/vest/ert/medical
	icon_state = "ember_med"

// Actualy not used - ERT engineer uses /obj/item/clothing/suit/space/ert_engineer instead
/obj/item/clothing/suit/armor/vest/ert/engineer
	icon = 'icons/obj/clothing/suits.dmi'

/obj/item/clothing/suit/armor/vest/ert/janitor
	icon_state = "ember_jan"

/obj/item/clothing/suit/armor/vest/ert/security/paranormal
	icon_state = "knight_templar"
	sprite_sheets = list("Vox" = 'icons/mob/clothing/species/vox/suit.dmi')

/obj/item/clothing/suit/space/ert_engineer
	name = "emergency response team engineer space suit"
	desc = "Space suit worn by engineering members of the Nanotrasen Emergency Response Team. Has orange highlights."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "ember_eng"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	armor = list(MELEE = 20, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 10, RAD = 50, FIRE = 200, ACID = 115)
	slowdown = 0.5
	sprite_sheets = list(
		"Kidan" = 'modular_ss220/clothing/icons/mob/species/kidan/suits.dmi',
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/suits.dmi',
		"Drask" = 'modular_ss220/clothing/icons/mob/species/drask/suits.dmi',
	)

/obj/item/clothing/suit/storage/browntrenchcoat
	name = "старое коричневое пальто"
	desc = "Поношенное пальто старого фасона."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "brtrenchcoat"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	sprite_sheets = list(
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/suits.dmi',
		"Monkey" = 'modular_ss220/clothing/icons/mob/species/monkey/suits.dmi',
	)

/* EI suits */
/obj/item/clothing/suit/storage/ei_jacket
	name = "кожаная куртка Rock on Black"
	desc = "Сочетание настоящего рокерского духа и современного стиля. При взгляде на вас, у каждого возникнет лишь одна мысль: «Это настоящий рок спирит!»."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "ei_jacket_open"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	ignore_suitadjust = FALSE
	suit_adjusted = TRUE
	actions_types = list(/datum/action/item_action/openclose)
	adjust_flavour = "unzip"
	sprite_sheets = list(
		"Grey" = 'modular_ss220/clothing/icons/mob/species/grey/suits.dmi',
		"Kidan" = 'modular_ss220/clothing/icons/mob/species/kidan/suits.dmi',
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/suits.dmi',
		"Drask" = 'modular_ss220/clothing/icons/mob/species/drask/suits.dmi',
	)

/obj/item/clothing/suit/storage/ei_coat
	name = "офицерский плащ EI"
	desc = "Этот плащ был создан специально для офицеров корпорации Etamin Industry. Если вы видите его на ком-то, то либо перед вами офицер корпорации, либо тот, кто отдал бешеные бабки за этот плащ."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "ei_coat"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	species_restricted = list("Human", "Tajaran", "Vulpkanin", "Skrell", "Nucleation", "Skeleton", "Slime People", "Unathi", "Abductor", "Golem", "Machine", "Shadow")

/* Security */
/obj/item/clothing/suit/armor/cop
	name = "grey overcoat"
	desc = "Не забудьте про шлем любителя свежего воздуха."
	icon = 'modular_ss220/clothing/icons/object/suits.dmi'
	icon_state = "armored_coat"
	worn_icon = 'modular_ss220/clothing/icons/mob/suits.dmi'
	armor = list(MELEE = 25, BULLET = 25, LASER = 15, ENERGY = 5, BOMB = 1, RAD = 0, FIRE = 50, ACID = 50)
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS
	cold_protection = UPPER_TORSO | LOWER_TORSO | ARMS
	heat_protection = UPPER_TORSO | LOWER_TORSO | ARMS
	sprite_sheets = list(
		"Kidan" = 'modular_ss220/clothing/icons/mob/species/kidan/suits.dmi',
		"Grey" = 'modular_ss220/clothing/icons/mob/species/grey/suits.dmi',
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/suits.dmi',
		"Drask" = 'modular_ss220/clothing/icons/mob/species/drask/suits.dmi',
	)
