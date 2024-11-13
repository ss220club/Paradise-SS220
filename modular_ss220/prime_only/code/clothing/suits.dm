// MARK: Coats

/obj/item/clothing/suit/midnight_coat
	name = "потрёпанное пальто"
	desc = "Чёрное пальто с меховым воротником, подкладка которого подшита плотным слоем дюраткани. На внутренней стороне имеется нашивка в виде букв ''M.B.'', вплетенных в символ звезды."
	icon = 'modular_ss220/prime_only/icons/object/suits.dmi'
	icon_state = "midnight_coat"
	icon_override = 'modular_ss220/prime_only/icons/mob/suits.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(MELEE = 15, BULLET = 5, LASER = 5, ENERGY = 5, BOMB = 0, RAD = 0, FIRE = 10, ACID = 5)
	allowed = list(/obj/item/gun, /obj/item/flashlight, /obj/item/tank/internals, /obj/item/melee/baton, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/restraints/handcuffs, /obj/item/dualsaber)
	sprite_sheets = list(
		"Kidan" = 'modular_ss220/prime_only/icons/mob/species/kidan/suits/suits.dmi',
		"Vox" = 'modular_ss220/prime_only/icons/mob/species/vox/suits/suits.dmi',
		"Drask" = 'modular_ss220/prime_only/icons/mob/species/drask/suits/suits.dmi',
	)
	var/datum/action/item_action/chameleon/stealth/stealth_action

/datum/action/item_action/chameleon/stealth
	name = "стелс-режим"
	button_overlay_icon_state = "mech_lights_off"
	var/stealth_alpha = 75
	var/equiped = 0

/datum/action/item_action/chameleon/stealth/Grant(mob/M)
	..()

/datum/action/item_action/chameleon/change/Remove(mob/M)
	if(M && (M == owner))
		M.alpha = initial(M.alpha)
		LAZYREMOVE(M.actions, src)
	..()

/datum/action/item_action/chameleon/stealth/Trigger(left_click)
	. = ..()
	set_stealth(owner)

/datum/action/item_action/chameleon/stealth/proc/set_stealth(mob/user)
	if(user.alpha != stealth_alpha)
		user.alpha = stealth_alpha
	else
		user.alpha = initial(user.alpha)

/obj/item/clothing/suit/midnight_coat/Initialize(mapload)
	. = ..()
	stealth_action = new(src)

/obj/item/clothing/suit/midnight_coat/Destroy()
	QDEL_NULL(stealth_action)
	return ..()

/obj/item/clothing/suit/midnight_coat/item_action_slot_check(slot, mob/user)
	. = ..()
	if(slot == SLOT_HUD_OUTER_SUIT)
		return TRUE
	else
		user.alpha = initial(user.alpha)

/obj/item/clothing/suit/browntrenchcoat/blueshield_chef
	name = "одеяния начальника подразделения \"Синий Щит\""
	desc = "Мундир командиров локальных подразделений ''Синий Щит'' контролирующих работу сотрудников как с Административных Объектов Нанотрейзен, так и непосредственно на местах. \
	Как правило, его носители имеют старшее офицерское звание как в организации ''Щитов'', так и во флоте компании."
	icon = 'modular_ss220/prime_only/icons/object/suits.dmi'
	icon_state = "blueshield_chef_coat_open"
	icon_override = 'modular_ss220/prime_only/icons/mob/suits.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(MELEE = 200, BULLET = 200, LASER = 50, ENERGY = 50, BOMB = INFINITY, RAD = INFINITY, FIRE = INFINITY, ACID = INFINITY)
	allowed = list(/obj/item/gun, /obj/item/flashlight, /obj/item/tank/internals, /obj/item/melee/baton, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/restraints/handcuffs, /obj/item/dualsaber)
	sprite_sheets = list(
		"Kidan" = 'modular_ss220/prime_only/icons/mob/species/kidan/suits/suits.dmi',
		"Vox" = 'modular_ss220/prime_only/icons/mob/species/vox/suits/suits.dmi',
		"Drask" = 'modular_ss220/prime_only/icons/mob/species/drask/suits/suits.dmi',
	)

// MARK: Hardsuit
/obj/item/clothing/suit/space/hardsuit/midnight_suit
	name = "\improper модернизированный элитный экзоскелет"
	desc = "Экзоскелет ударной группы синдиката, модернизированный по спецзаказу Миднайта Блэка."
	icon = 'modular_ss220/prime_only/icons/object/suits.dmi'
	icon_override = 'modular_ss220/prime_only/icons/mob/suits.dmi'
	icon_state = "hardsuit-midnightsuit"
	item_state = "hardsuit-midnightsuit"
	armor = list(MELEE = 115, BULLET = 115, LASER = 65, ENERGY = 40, BOMB = 200, RAD = INFINITY, FIRE = INFINITY, ACID = INFINITY)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/midnight_suit
	species_restricted = list("Human") // Уточню на счет лока на расу
