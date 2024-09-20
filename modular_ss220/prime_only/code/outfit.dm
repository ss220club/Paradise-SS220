// Explorer's outfits
/datum/outfit/job/explorer
	uniform = /obj/item/clothing/under/rank/cargo/expedition_prime
	head = /obj/item/clothing/head/soft/black
	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel_norm


//Event outfits
/datum/outfit/admin/tanya
	name = "Таня фон Нормандия - АРГ - без брони"
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
	id = /obj/item/card/id/centcom/tanya
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

/datum/outfit/admin/tanya/tanya2
	name = "Таня фон Нормандия - АРГ - в броне"
	back = /obj/item/mod/control/pre_equipped/responsory/commander

/datum/outfit/admin/tanya/tanya3
	name = "Таня фон Нормандия - NF10 - в броне - основной вариант"
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
	name = "Таня фон Нормандия - Пулемет - в броне"
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
	name = "Таня фон Нормандия - IK - в броне - основной вариант"
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
	name = "Таня фон Нормандия - Пульсовая - в броне"
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

/datum/outfit/admin/syndicate/midnight
	name = "Миднайт Блэк"
	uniform = /obj/item/clothing/under/suit/really_black
	shoes = /obj/item/clothing/shoes/chameleon/noslip
	uplink_uses = 200
	id = /obj/item/card/id/midnight
	cybernetic_implants = list(
		/obj/item/organ/internal/eyes/cybernetic/thermals/hardened,
		/obj/item/organ/internal/cyberimp/brain/anti_stam/hardened,
		/obj/item/organ/internal/cyberimp/chest/nutriment/plus/hardened,
	)

/datum/outfit/job/ntnavyofficer/traisen
	name = "Генрих Трейзен"
	r_hand = /obj/item/storage/belt/rapier/cane_rapier
	head = /obj/item/clothing/head/ntrep
	mask = /obj/item/clothing/mask/gas/navy_officer
	suit = /obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt

/datum/outfit/job/ntnavyofficer/field/sharlotta
	name = "Дитерхис"
	suit = /obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt
	l_pocket = /obj/item/dualsaber/legendary_saber/flame

/datum/outfit/job/ntnavyofficer/field/gromov
	name = "Громов"
	l_pocket = /obj/item/dualsaber/legendary_saber/sorrow_catcher
	head = /obj/item/clothing/head/helmet/space/deathsquad/beret
	mask = /obj/item/clothing/mask/breath/breathscarf

/datum/outfit/job/ntnavyofficer/field/fane
	name = "Фейн"
	suit = /obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt/gold
	mask = /obj/item/clothing/mask/breath/breathscarf
