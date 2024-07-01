/datum/outfit/miner
	name = "Труп шахтёра"
	uniform = /obj/item/clothing/under/rank/cargo/miner/lavaland
	shoes = /obj/item/clothing/shoes/workboots/mining
	mask = /obj/item/clothing/mask/gas
	back = /obj/item/storage/backpack/explorer

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
		/obj/item/bio_chip/mindshield,
		/obj/item/bio_chip/dust
	)
	cybernetic_implants = list(
		/obj/item/organ/internal/cyberimp/chest/nutriment/plus/hardened,
		/obj/item/organ/internal/cyberimp/arm/combat/centcom,
		/obj/item/organ/internal/cyberimp/brain/anti_stam/hardened,
		/obj/item/organ/internal/eyes/cybernetic/xray/hardened
	)

/datum/outfit/admin/tanya/tanya2
	name = "Таня фон Нормандия - АРГ - в броне"
	back = /obj/item/mod/control/pre_equipped/responsory/commander

/datum/outfit/admin/tanya/tanya3
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

/datum/outfit/admin/tanya/tanya4
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

/datum/outfit/redneck
	name = "деревенщина 1"
	uniform = /obj/item/clothing/under/dune/heatprotect
	suit = /obj/item/clothing/suit/poncho
	belt = /obj/item/storage/belt/fannypack
	shoes = /obj/item/clothing/shoes/cowboy
	head = /obj/item/clothing/head/cowboyhat
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/breath/shemag_desert
	l_pocket = /obj/item/tank/internals/emergency_oxygen/double
	r_pocket = /obj/item/clothing/mask/cigarette/pipe/cobpipe
	back = /obj/item/storage/backpack/satchel/explorer
	backpack_contents = list(
		/obj/item/storage/box/survival/redneck,
		/obj/item/flashlight,
		/obj/item/lighter/zippo/engraved,
		/obj/item/storage/wallet/random,
		/obj/item/clothing/accessory/cowboyshirt,
		/obj/item/stack/spacecash/c100,
		/obj/item/storage/fancy/cigarettes/cigpack_robust,
	)

/datum/outfit/redneck/redneck2
	name = "деревенщина 2"
	suit = /obj/item/clothing/suit/poncho/red
	belt = /obj/item/storage/belt/military
	shoes = /obj/item/clothing/shoes/cowboy/black
	head = /obj/item/clothing/head/cowboyhat/black
	gloves = /obj/item/clothing/gloves/fingerless
	backpack_contents = list(
		/obj/item/storage/box/survival/redneck,
		/obj/item/flashlight,
		/obj/item/storage/fancy/matches,
		/obj/item/storage/wallet/random,
		/obj/item/clothing/accessory/cowboyshirt/navy,
		/obj/item/stack/spacecash/c100,
		/obj/item/storage/fancy/cigarettes/cigpack_robust,
	)

/datum/outfit/redneck/redneck3
	name = "деревенщина 3"
	suit = /obj/item/clothing/suit/hooded/desert_cape/desert_cape2
	belt = /obj/item/storage/belt/fannypack/black
	shoes = /obj/item/clothing/shoes/cowboy/fancy
	head = /obj/item/clothing/head/cowboyhat/tan
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list(
		/obj/item/storage/box/survival/redneck,
		/obj/item/flashlight,
		/obj/item/clothing/accessory/cowboyshirt/white,
		/obj/item/lighter/random,
		/obj/item/storage/wallet/random,
		/obj/item/stack/spacecash/c100,
		/obj/item/storage/fancy/cigarettes/cigpack_robust,
	)

/datum/outfit/redneck/redneck4
	name = "деревенщина 4"
	suit = /obj/item/clothing/suit/fluff/dusty_jacket
	belt = /obj/item/storage/belt/fannypack
	r_pocket = /obj/item/clothing/mask/cigarette/pipe

/datum/outfit/redneck/redneck_shame
	name = "позорный деревенщина"
	uniform = /obj/item/clothing/under/dune/heatprotect
	suit = /obj/item/clothing/suit/poncho/ponchoshame
	belt = /obj/item/storage/belt/fannypack/pink
	glasses = /obj/item/clothing/glasses/fluff/kamina
	shoes = /obj/item/clothing/shoes/cowboy/pink
	head = /obj/item/clothing/head/cowboyhat/pink
	gloves = /obj/item/clothing/gloves/color/purple
	backpack_contents = list(
		/obj/item/storage/box/survival/redneck,
		/obj/item/clothing/accessory/cowboyshirt/pink,
		/obj/item/flashlight,
		/obj/item/lighter/zippo/fluff/warriorstar,
		/obj/item/storage/wallet/random,
		/obj/item/stack/spacecash/c100,
		/obj/item/storage/fancy/cigarettes/cigpack_robust,
	)

/datum/outfit/redneck_women
	name = "деревенщина-женщина"
	uniform = /obj/item/clothing/under/dune/heatprotect
	suit = /obj/item/clothing/suit/hooded/abaya
	shoes = /obj/item/clothing/shoes/sandal
	mask = /obj/item/clothing/mask/breath/shemag_desert
	l_pocket = /obj/item/tank/internals/emergency_oxygen/double
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/box/survival/redneck,
		/obj/item/lighter/zippo/engraved,
		/obj/item/storage/wallet/random,
		/obj/item/stack/spacecash/c100,
	)

/datum/outfit/redneck_women/woman2
	name = "деревенщина-женщина 2"
	suit = /obj/item/clothing/suit/hooded/abaya/orange

/datum/outfit/job/ntspecops/normandy
	name = "Мунивёрс Нормандия"
	suit = /obj/item/clothing/suit/space/deathsquad/officer/soo_brown
	l_pocket = /obj/item/dualsaber/legendary_saber/normandy_saber
	cybernetic_implants = list(
		/obj/item/organ/internal/eyes/cybernetic/xray/hardened,
		/obj/item/organ/internal/cyberimp/brain/anti_stam/hardened,
		/obj/item/organ/internal/cyberimp/chest/nutriment/plus/hardened,
		/obj/item/organ/internal/cyberimp/arm/combat/centcom,
		/obj/item/organ/internal/cyberimp/chest/hydration/hardened
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
		/obj/item/organ/internal/cyberimp/chest/hydration/hardened
	)
