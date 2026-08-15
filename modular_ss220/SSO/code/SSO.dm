//////////////////////////////
// MARK: SSO suit
//////////////////////////////
/obj/item/clothing/head/helmet/space/deathsquad/beret/sso
	name = "Special Operation Force officer beret"
	icon_state = "beret_trainergreen"
	color = "#999999"

/obj/item/clothing/suit/space/deathsquad/officer/sso
	name = "Пальто ССО"
	desc = "Бронированное пальто офицера ССО"
	icon = 'modular_ss220/SSO/icons/suit/sso_icon.dmi'
	icon_state = "sso_open"
	worn_icon = 'modular_ss220/SSO/icons/suit/sso_worn.dmi'
	flags_inv = 0
	ignore_suitadjust = 0
	suit_adjusted = 1
	actions_types = list(/datum/action/item_action/openclose)
	adjust_flavour = "unzipped"

/obj/item/clothing/suit/space/deathsquad/officer/sso/ricardo
	name = "Пальто Р.Милошевича"
	desc = "Бронированное пальто офицера ССО, полковника а также офицера специальный операций Рикардоса Милошевича."
	icon_state = "sso_ric_open"
	flags_inv = 0
	ignore_suitadjust = 0
	suit_adjusted = 1
	actions_types = list(/datum/action/item_action/openclose)
	adjust_flavour = "unbutton"

/obj/item/clothing/suit/space/deathsquad/officer/sso/armor_1
	name = "Комплект брони СCО"
	desc = "Модульная броня Сил Специальных Операций."
	icon_state = "armor_1"
	inhand_icon_state = "armor"
	actions_types = list()


/obj/item/clothing/suit/space/deathsquad/officer/sso/armor_2
	name = "Комплект брони СCО"
	desc = "Модульная броня Сил Специальных Операций. Боевой модуль"
	icon_state = "armor_2"
	inhand_icon_state = "armor"
	actions_types = list()

/obj/item/clothing/suit/space/deathsquad/officer/sso/armor_3
	name = "Комплект брони СCО"
	desc = "Модульная броня Сил Специальных Операций. Боевой модуль"
	icon_state = "armor_3"
	inhand_icon_state = "armor"
	actions_types = list()

/obj/item/clothing/suit/space/deathsquad/officer/sso/coat
	name = "Пальто ССО"
	desc = "Бронированное пальто офицера ССО"
	icon_state = "coat_1"
	actions_types = list()

/obj/item/clothing/head/helmet/space/deathsquad/beret/sso/helmet
	name = "Каска ССО"
	desc = "Шлем Офицера Сил Специальных Операций"
	icon = 'modular_ss220/SSO/icons/suit/sso_icon.dmi'
	icon_state = "helmet"
	worn_icon = 'modular_ss220/SSO/icons/suit/sso_worn.dmi'
	actions_types = list(/datum/action/item_action/toggle_nvg)
	var/nvg_enabled = FALSE

// for Night vision Start
/obj/item/clothing/head/helmet/space/deathsquad/beret/sso/helmet/ui_action_click(mob/user, actiontype)
	if(actiontype == /datum/action/item_action/toggle_nvg)
		toggle_nvg(user)

/obj/item/clothing/head/helmet/space/deathsquad/beret/sso/helmet/item_action_slot_check(slot)
	if(slot == ITEM_SLOT_HEAD)
		return TRUE

/obj/item/clothing/head/helmet/space/deathsquad/beret/sso/helmet/equipped(mob/user, slot, initial)
	. = ..()
	if(nvg_enabled && slot == ITEM_SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_NIGHT_VISION, "helmet[UID()]")

/obj/item/clothing/head/helmet/space/deathsquad/beret/sso/helmet/dropped(mob/user)
	. = ..()
	if(user)
		REMOVE_TRAIT(user, TRAIT_NIGHT_VISION, "helmet[UID()]")

/obj/item/clothing/head/helmet/space/deathsquad/beret/sso/helmet/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][nvg_enabled ? "_nvg" : ""]"

/obj/item/clothing/head/helmet/space/deathsquad/beret/sso/helmet/proc/toggle_nvg(mob/user)
	var/msg
	if(!HAS_TRAIT_FROM(user, TRAIT_NIGHT_VISION, "helmet[UID()]"))
		ADD_TRAIT(user, TRAIT_NIGHT_VISION, "helmet[UID()]")
		msg = "You lowered your night-vision goggles over your eyes."
		nvg_enabled = TRUE
	else
		REMOVE_TRAIT(user, TRAIT_NIGHT_VISION, "helmet[UID()]")
		msg = "You raised your night-vision goggles."
		nvg_enabled = FALSE

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.head == src)
			H.update_sight()

	update_icon(UPDATE_ICON_STATE)
	user.update_inv_head()
	to_chat(user, SPAN_NOTICE("[msg]"))

/// END

/obj/item/clothing/suit/space/deathsquad/officer/rep
	name = "Пальто НТ"
	desc = "Пальто Офицера Флота Нанотройзен"
	icon = 'modular_ss220/SSO/icons/suit/sso_icon.dmi'
	icon_state = "rep_1"
	worn_icon = 'modular_ss220/SSO/icons/suit/sso_worn.dmi'

/obj/item/clothing/suit/space/deathsquad/officer/rep/alt1
	icon_state = "rep_2"

/obj/item/clothing/suit/space/deathsquad/officer/rep/alt2
	icon_state = "rep_3"

/obj/item/clothing/suit/space/deathsquad/officer/rep/alt3
	icon_state = "rep_4"

/obj/item/clothing/suit/space/deathsquad/officer/rep/alt4
	icon_state = "rep_5"

/obj/item/clothing/suit/space/deathsquad/officer/rep/alt5
	icon_state = "rep_6"

/obj/item/clothing/suit/space/deathsquad/officer/rep/alvion
	name = "Пальто Адмирала НТ"
	desc = "Пальто Адмирала флота Нанотрейзен."
	icon_state = "alvion"

/obj/item/clothing/mask/gas/swat/sso
	name = "Противогаз ССО"
	desc = "Противогаз, специально созданный для сил специальных операций."
	icon = 'modular_ss220/SSO/icons/suit/sso_icon.dmi'
	icon_state = "mask"
	worn_icon = 'modular_ss220/SSO/icons/suit/sso_worn.dmi'

/obj/item/storage/belt/federation_webbing/sso
	name = "Разгрузка ССО"
	desc = "Разгрузка ТСФ, в расцветке ССО."
	icon = 'modular_ss220/SSO/icons/suit/sso_icon.dmi'
	icon_state = "wedding"
	worn_icon = 'modular_ss220/SSO/icons/suit/sso_worn.dmi'

/obj/item/clothing/under/rank/centcom/captain/vkr
	name = "NT Representative officer's jumpsuit"
	desc = "It's a jumpsuit worn by CentComm Officers."
	icon = 'modular_ss220/SSO/icons/suit/sso_icon.dmi'
	icon_state = "under_vkr"
	worn_icon = 'modular_ss220/SSO/icons/suit/sso_worn.dmi'

/obj/item/clothing/under/rank/centcom/captain/admiral
	name = "NT Admiral jumpsuit"
	desc = "Адмиральский костюм! Я ТУТ ГЛАВНЫЙ В СЕКТОРЕ! РАЗОЙДИСЬ!."
	icon = 'modular_ss220/SSO/icons/suit/sso_icon.dmi'
	icon_state = "under_admiral"
	worn_icon = 'modular_ss220/SSO/icons/suit/sso_worn.dmi'

/obj/item/clothing/under/rank/centcom/captain/sso
	name = "Special Operation Force jumpsuit"
	desc = "ССО... Много слагается легенд. Кто они вообще такие? Да кто бы знал. Одно можно знать точно - с ними шутки плохи."
	icon = 'modular_ss220/SSO/icons/suit/sso_icon.dmi'
	icon_state = "under_sso"
	worn_icon = 'modular_ss220/SSO/icons/suit/sso_worn.dmi'

/obj/item/storage/backpack/ert/sso
	name = "Special Operation Force rucksack"
	desc = "Штурмовой рюкзак ССО, вмещает достаточно"
	icon = 'modular_ss220/SSO/icons/suit/sso_icon.dmi'
	icon_state = "backpack_1"
	worn_icon = 'modular_ss220/SSO/icons/suit/sso_worn.dmi'

/obj/item/storage/backpack/duffel/sso
	name = "Special Operation Force Raid rucksack"
	desc = "Огромный рейдовый рюкзак ССО"
	icon = 'modular_ss220/SSO/icons/suit/sso_icon.dmi'
	icon_state = "backpack_2"
	worn_icon = 'modular_ss220/SSO/icons/suit/sso_worn.dmi'
	max_combined_w_class = 60
	zip_time = 1
	resistance_flags = FIRE_PROOF
	silent = TRUE

//////////////////////////////
// MARK: Outfit
//////////////////////////////
/datum/outfit/job/admin/nt_navy_captain/vkr
	name = "NT Navy Representative"

	uniform = /obj/item/clothing/under/rank/centcom/captain/vkr
	suit = /obj/item/clothing/suit/space/deathsquad/officer/rep/alt1
	allow_backbag_choice = FALSE
	back = /obj/item/storage/backpack/satcheldeluxe
	belt = /obj/item/gun/energy/pulse/pistol
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/centcom
	head = /obj/item/clothing/head/beret/centcom/captain
	l_ear = /obj/item/radio/headset/centcom
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	id = /obj/item/card/id/centcom
	pda = /obj/item/pda/centcom
	box = /obj/item/storage/box/centcomofficer
	backpack_contents = list(
		/obj/item/stamp/centcom,
		/obj/item/stamp/navcom,
	)
	bio_chips = list(
		/obj/item/bio_chip/mindshield,
		/obj/item/bio_chip/dust
	)
	cybernetic_implants = list(
		/obj/item/organ/internal/cyberimp/chest/nutriment/plus/hardened,
		/obj/item/organ/internal/cyberimp/arm/combat/centcom
	)

/datum/outfit/job/admin/ntnavyofficer/vkr/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/I = H.wear_id
	if(istype(I))
		apply_to_card(I, H, get_centcom_access("Nanotrasen Navy Representative"), "Nanotrasen Navy Representative")
	I.rank = "Nanotrasen Navy Representative"
	I.assignment = "Nanotrasen Navy Representative"
	H.sec_hud_set_ID()


/datum/outfit/job/admin/nt_navy_captain/admiral
	name = "NT Navy Admiral"

	uniform = /obj/item/clothing/under/rank/centcom/captain/admiral
	suit = /obj/item/clothing/suit/space/deathsquad/officer/rep/alvion
	allow_backbag_choice = FALSE
	back = /obj/item/storage/backpack/satcheldeluxe
	box = /obj/item/storage/box/centcomofficer
	backpack_contents = list(
		/obj/item/bio_chip_implanter/death_alarm,
		/obj/item/stamp/centcom,
		/obj/item/stamp/navcom,
		/obj/item/gun/projectile/revolver/reclinable/rsh12,
		/obj/item/ammo_box/speed_loader_mm127,
		/obj/item/ammo_box/speed_loader_mm127
	)
/datum/outfit/job/admin/ntspecops/sso
	name = "Special Operations Force (SSO)"

	jobtype = /datum/job/ntspecops
	allow_backbag_choice = FALSE
	uniform = /obj/item/clothing/under/rank/centcom/captain/sso
	suit = /obj/item/clothing/suit/space/deathsquad/officer/sso
	belt = /obj/item/storage/belt/federation_webbing/sso
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/combat/swat
	mask = /obj/item/clothing/mask/holo_cigar
	head = /obj/item/clothing/head/helmet/space/deathsquad/beret/sso
	l_ear = /obj/item/radio/headset/centcom
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/fluff/eyepro
	id = /obj/item/card/id/ert/deathsquad
	pda = /obj/item/pda/centcom
	r_pocket = /obj/item/flashlight/seclite
	l_pocket = /obj/item/pinpointer/advpinpointer
	suit_store = /obj/item/gun/projectile/automatic/pistol/sso
	back = /obj/item/storage/backpack/ert/sso
	box = /obj/item/storage/box/centcomofficer
	backpack_contents = list(
		/obj/item/storage/box/handcuffs,
		/obj/item/clothing/mask/gas/swat/sso,
		/obj/item/clothing/head/helmet/space/deathsquad/beret/sso/helmet,
		/obj/item/suppressor,
		/obj/item/clothing/accessory/holster,

	)
	bio_chips = list(
		/obj/item/bio_chip/mindshield,
		/obj/item/bio_chip/dust
	)
	cybernetic_implants = list(
		/obj/item/organ/internal/eyes/cybernetic/thermals/hardened,
		/obj/item/organ/internal/cyberimp/brain/anti_stam/hardened,
		/obj/item/organ/internal/cyberimp/chest/nutriment/plus/hardened,
		/obj/item/organ/internal/cyberimp/arm/combat
	)

/datum/outfit/job/admin/ntspecops/sso/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/I = H.wear_id
	if(istype(I))
		apply_to_card(I, H, get_all_centcom_access(), name, "deathsquad")
	I.rank = "Special Operations Force"
	I.assignment = "Deathsquad"
	H.sec_hud_set_ID()
