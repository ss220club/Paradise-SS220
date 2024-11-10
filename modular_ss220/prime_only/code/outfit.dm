// MARK: Prime outfits

/datum/outfit/job/explorer
	uniform = /obj/item/clothing/under/rank/cargo/expedition_prime
	head = /obj/item/clothing/head/soft/black
	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel_norm

/datum/outfit/admin/tanya
	name = "Дельта 817 - экипировка АРГ"
	uniform = /obj/item/clothing/under/solgov/srt
	belt = /obj/item/storage/belt/military/assault/srt
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/beret/solgov/command
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/gas/sechailer
	glasses = /obj/item/clothing/glasses/hud/security/night
	l_pocket = /obj/item/tank/internals/emergency_oxygen/double
	l_ear = /obj/item/radio/headset/centcom
	r_pocket = /obj/item/reagent_containers/hypospray/combat/nanites
	back = /obj/item/storage/backpack/security
	pda = /obj/item/pda/centcom
	backpack_contents = list(
		/obj/item/storage/box/responseteam,
		/obj/item/storage/box/flashbangs,
		/obj/item/ammo_box/magazine/m556/arg = 5,
		/obj/item/flashlight/seclite,
		/obj/item/grenade/plastic/c4/x4,
		/obj/item/melee/energy/sword/saber,
		/obj/item/shield/energy,
		/obj/item/gun/projectile/automatic/ar
	)
	bio_chips = list(
		/obj/item/bio_chip/mindshield
	)
	cybernetic_implants = list(
		/obj/item/organ/internal/cyberimp/chest/nutriment/plus/hardened,
		/obj/item/organ/internal/cyberimp/arm/combat/centcom,
		/obj/item/organ/internal/cyberimp/brain/anti_stam/hardened,
		/obj/item/organ/internal/eyes/cybernetic/xray/hardened,
	)

/datum/outfit/admin/tanya/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/I = H.wear_id
	if(istype(I))
		apply_to_card(I, H, get_centcom_access("Nanotrasen Navy Officer"), "Normandy Special Forces")
	I.rank = "Nanotrasen Navy Officer"
	I.assignment = "Normandy Special Forces"
	H.sec_hud_set_ID()

/datum/outfit/admin/tanya/tanya2
	name = "Дельта 817 - экипировка АРГ в броне"
	back = /obj/item/mod/control/pre_equipped/responsory/commander

/datum/outfit/admin/tanya/tanya3
	name = "Дельта 817 - экипировка NF10 в броне"
	back = /obj/item/mod/control/pre_equipped/responsory/commander
	backpack_contents = list(
		/obj/item/storage/box/responseteam,
		/obj/item/storage/box/flashbangs,
		/obj/item/ammo_box/magazine/smgm9mm/ap = 5,
		/obj/item/flashlight/seclite,
		/obj/item/grenade/plastic/c4/x4,
		/obj/item/melee/energy/sword/saber,
		/obj/item/shield/energy,
		/obj/item/gun/projectile/automatic/proto
	)

/datum/outfit/admin/tanya/tanya4
	name = "Дельта 817 - экипировка пулемет в броне"
	back = /obj/item/mod/control/pre_equipped/apocryphal
	r_hand = /obj/item/gun/projectile/automatic/l6_saw
	backpack_contents = list(
		/obj/item/storage/box/responseteam,
		/obj/item/storage/box/flashbangs,
		/obj/item/ammo_box/magazine/mm556x45 = 5,
		/obj/item/flashlight/seclite,
		/obj/item/grenade/plastic/c4/x4,
		/obj/item/melee/energy/sword/saber,
		/obj/item/shield/energy,
	)

/datum/outfit/admin/tanya/tanya5
	name = "Дельта 817 - экипировка IK в броне"
	back = /obj/item/mod/control/pre_equipped/responsory/security
	r_hand = /obj/item/gun/projectile/automatic/lasercarbine
	backpack_contents = list(
		/obj/item/storage/box/responseteam,
		/obj/item/storage/box/flashbangs,
		/obj/item/ammo_box/magazine/laser/ert = 5,
		/obj/item/flashlight/seclite,
		/obj/item/grenade/plastic/c4/x4,
		/obj/item/melee/energy/sword/saber,
		/obj/item/shield/energy,
	)

/datum/outfit/admin/tanya/tanya6
	name = "Дельта 817 - экипировка пульсовая в броне"
	back = /obj/item/mod/control/pre_equipped/apocryphal
	r_hand = /obj/item/shield/energy
	backpack_contents = list(
		/obj/item/storage/box/responseteam,
		/obj/item/storage/box/flashbangs,
		/obj/item/flashlight/seclite,
		/obj/item/grenade/plastic/c4/x4,
		/obj/item/melee/energy/sword/saber,
		/obj/item/gun/energy/pulse
	)

/datum/outfit/job/ntspecops/normandy
	name = "Мунивёрс Нормандия"
	suit = /obj/item/clothing/suit/space/deathsquad/officer/soo_brown
	l_pocket = /obj/item/dualsaber/legendary_saber/sister
	cybernetic_implants = list(
		/obj/item/organ/internal/eyes/cybernetic/xray/hardened,
		/obj/item/organ/internal/cyberimp/brain/anti_stam/hardened,
		/obj/item/organ/internal/cyberimp/chest/nutriment/plus/hardened,
		/obj/item/organ/internal/cyberimp/arm/combat/centcom,
	)
	bio_chips = list(
		/obj/item/bio_chip/mindshield
	)

/datum/outfit/job/ntnavyofficer/traisen
	name = "Генрих Трейзен"
	r_hand = /obj/item/storage/belt/sheath/saber/cane_rapier
	head = /obj/item/clothing/head/ntrep
	mask = /obj/item/clothing/mask/gas/navy_officer
	suit = /obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt
	back = /obj/item/storage/backpack/satchel

/datum/outfit/job/ntnavyofficer/traisen/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/I = H.wear_id
	if(istype(I))
		apply_to_card(I, H, get_centcom_access("Nanotrasen Navy Officer"), "Nanotrasen Chief Executive Officer")
	I.rank = "Nanotrasen Navy Officer"
	I.assignment = "Nanotrasen Chief Executive Officer"
	H.sec_hud_set_ID()

/datum/outfit/job/ntnavyofficer/field/sharlotta
	name = "Дитерхис"
	suit = /obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt
	l_pocket = /obj/item/dualsaber/legendary_saber/flame
	gloves = /obj/item/clothing/gloves/color/white
	uniform = /obj/item/clothing/under/rank/procedure/representative

/datum/outfit/job/ntnavyofficer/field/gromov
	name = "Громов"
	l_pocket = /obj/item/dualsaber/legendary_saber/sorrow_catcher
	head = /obj/item/clothing/head/helmet/space/deathsquad/beret
	mask = /obj/item/clothing/mask/breath/breathscarf
	suit = /obj/item/clothing/suit/space/deathsquad/officer/field

/datum/outfit/job/ntnavyofficer/field/gromov/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/I = H.wear_id
	if(istype(I))
		apply_to_card(I, H, get_centcom_access("Nanotrasen Navy Officer"), "Special Operations Secretary")
	I.rank = "Nanotrasen Navy Officer"
	I.assignment = "Special Operations Secretary"
	H.sec_hud_set_ID()

/datum/outfit/job/ntnavyofficer/field/fane
	name = "Фейн"
	suit = /obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt/gold
	mask = /obj/item/clothing/mask/breath/breathscarf

/datum/outfit/job/ntnavyofficer/field/candros
	name = "Кандрос"
	suit = /obj/item/clothing/suit/browntrenchcoat/blueshield_chef
	mask = /obj/item/clothing/mask/gas/navy_officer
	head = /obj/item/clothing/head/beret/centcom/officer/blueshield_chef

/datum/outfit/job/ntnavyofficer/field/candros/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/I = H.wear_id
	if(istype(I))
		apply_to_card(I, H, get_centcom_access("Nanotrasen Navy Officer"), "Operational Group Commander")
	I.rank = "Nanotrasen Navy Officer"
	I.assignment = "Operational Group Commander"
	H.sec_hud_set_ID()

/datum/outfit/job/ntnavyofficer/field/rizu
	name = "Рицу"
	suit = /obj/item/clothing/suit/space/deathsquad/officer
	uniform = /obj/item/clothing/under/pants/classicjeans
	head = /obj/item/clothing/head/cowboyhat
	glasses = /obj/item/clothing/glasses/eyepatch
	gloves = /obj/item/clothing/gloves/ring/silver
	belt = /obj/item/storage/belt/military/assault/m1911
	shoes = /obj/item/clothing/shoes/combat
	r_pocket = /obj/item/reagent_containers/hypospray/combat/nanites
	l_pocket = /obj/item/dualsaber/legendary_saber/flee_catcher
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/gun/projectile/automatic/pistol/m1911,
		/obj/item/cane,
		/obj/item/clothing/accessory/holster,
		/obj/item/flashlight/seclite
	)

/obj/item/storage/belt/military/assault/m1911/populate_contents()
	new /obj/item/ammo_box/magazine/m45 (src)
	new /obj/item/ammo_box/magazine/m45 (src)
	new /obj/item/ammo_box/magazine/m45 (src)
	new /obj/item/ammo_box/magazine/m45 (src)
	new /obj/item/ammo_box/magazine/m45 (src)
	new /obj/item/ammo_box/magazine/m45 (src)
