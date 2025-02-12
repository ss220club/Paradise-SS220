// CC loot pool
/datum/spawn_pool/centcommloot
	id = "central_command_spawn_pool"
	available_points = INFINITY

/obj/effect/spawner/random/pool/centcommloot
	icon = 'icons/effects/random_spawners.dmi'
	icon_state = "giftbox"
	spawn_pool_id = "central_command_spawn_pool"

/obj/effect/spawner/random/pool/centcommloot/syndicate/tier1
	spawn_loot_chance = 40
	loot = list(
		// Loot schema: costumes, toys, useless gimmick items
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/clothing/shoes/magboots/syndie,
		/obj/item/clothing/suit/jacket/bomber/syndicate,
		/obj/item/clothing/suit/storage/iaa/blackjacket/armored,
		/obj/item/clothing/under/syndicate/combat,
		/obj/item/clothing/under/syndicate/sniper,
		/obj/item/coin/antagtoken/syndicate,
		/obj/item/deck/cards/syndicate,
		/obj/item/lighter/zippo/gonzofist,
		/obj/item/soap/syndie,
		/obj/item/stamp/chameleon,
		/obj/item/storage/fancy/cigarettes/cigpack_syndicate,
		/obj/item/storage/toolbox/syndicate,
		/obj/item/suppressor,
		/obj/item/toy/syndicateballoon,
		/obj/item/storage/secure/briefcase/syndie,
	)

/obj/effect/spawner/random/pool/centcommloot/syndicate/tier2
	spawn_loot_chance = 40
	loot = list(
		/obj/item/ammo_box/magazine/m10mm,
		/obj/item/clothing/gloves/color/black/thief,
		/obj/item/clothing/shoes/chameleon/noslip,
		/obj/item/clothing/under/syndicate/silicon_cham,
		/obj/item/clothing/mask/chameleon/voice_change,
		/obj/item/flash/cameraflash,
		/obj/item/gun/projectile/automatic/toy/pistol/riot,
		/obj/item/lighter/zippo/gonzofist,
		/obj/item/mod/module/chameleon,
		/obj/item/mod/module/holster/hidden,
		/obj/item/mod/module/noslip,
		/obj/item/mod/module/visor/night,
		/obj/item/mod/module/plate_compression,
		/obj/item/reagent_containers/hypospray/autoinjector/hyper_medipen,
		/obj/item/reagent_containers/hypospray/autoinjector/nanocalcium,
		/obj/item/stack/sheet/mineral/gold{amount = 20},
		/obj/item/stack/sheet/mineral/plasma{amount = 20},
		/obj/item/stack/sheet/mineral/silver{amount = 20},
		/obj/item/stack/sheet/mineral/uranium{amount = 20},
		/obj/item/stamp/chameleon,
		/obj/item/storage/backpack/duffel/syndie/med/surgery,
		/obj/item/storage/backpack/satchel_flat,
		/obj/item/storage/belt/military,
		/obj/item/storage/box/syndie_kit/camera_bug,
		/obj/item/storage/box/syndie_kit/chameleon,
		/obj/item/storage/box/syndie_kit/space,
	)

/obj/effect/spawner/random/pool/centcommloot/syndicate/tier3
	spawn_loot_chance = 40
	loot = list(
		/obj/item/borg/upgrade/syndicate,
		/obj/item/clothing/glasses/hud/security/chameleon,
		/obj/item/clothing/glasses/thermal,
		/obj/item/clothing/shoes/magboots/elite,
		/obj/item/door_remote/omni/access_tuner,
		/obj/item/encryptionkey/binary,
		/obj/item/jammer,
		/obj/item/mod/module/power_kick,
		/obj/item/mod/module/visor/thermal,
		/obj/item/pen/edagger,
		/obj/item/pinpointer/advpinpointer,
		/obj/item/stack/sheet/mineral/diamond{amount = 10},
		/obj/item/storage/belt/sheath/snakesfang,
		/obj/item/storage/box/syndidonkpockets,
		/obj/item/storage/box/syndie_kit/stechkin,
		/obj/item/mod/control/pre_equipped/traitor,
		/obj/item/mod/module/stealth,
	)

/obj/effect/spawner/random/pool/centcommloot/syndicate/tier4
	loot = list(
		/obj/item/bio_chip_implanter/proto_adrenalin,
		/obj/item/chameleon,
		/obj/item/gun/medbeam,
		/obj/item/gun/projectile/automatic/sniper_rifle/toy,
		/obj/item/melee/energy/sword/saber,
		/obj/item/mod/control/pre_equipped/traitor_elite,
		/obj/item/organ/internal/cyberimp/arm/razorwire,
		/obj/item/organ/internal/cyberimp/brain/sensory_enhancer,
		/obj/item/reagent_containers/hypospray/autoinjector/stimulants,
		/obj/item/shield/energy,
		/obj/item/weaponcrafting/gunkit/universal_gun_kit,
		/obj/item/storage/box/syndie_kit/teleporter,
		/obj/item/cqc_manual,
	)

/obj/effect/spawner/random/pool/centcommloot/syndicate/mixed
	loot = list(
		/obj/effect/spawner/random/pool/centcommloot/syndicate/tier1 = 30,
		/obj/effect/spawner/random/pool/centcommloot/syndicate/tier2 = 20,
		/obj/effect/spawner/random/pool/centcommloot/syndicate/tier3 = 5,
		/obj/effect/spawner/random/pool/centcommloot/syndicate/tier4 = 1,
	)

// space loot pool
/datum/spawn_pool/spaceloot
	available_points = 2200 // tweak available points considering centcomm and away mission

/obj/effect/spawner/random/pool/spaceloot/mechtransport_new/mecha
	point_value = 100
	loot = list(/obj/mecha/combat/durand/old/mechtransport_new)

/obj/effect/spawner/random/pool/spaceloot/mechtransport_new/mecha_equipment
	point_value = 40
	spawn_all_loot = TRUE
	loot = list(
		/obj/item/mecha_parts/mecha_equipment/weapon/honker,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser,
		)

/obj/effect/spawner/random/pool/spaceloot/modsuit_syndie/nuclear
	point_value = 110
	spawn_loot_chance = 30
	loot = list(/obj/machinery/suit_storage_unit/syndicate)

/obj/effect/spawner/random/pool/spaceloot/modsuit_syndie/corpse
	loot = list(/obj/effect/mob_spawn/human/corpse/syndicatecommando)

/obj/effect/spawner/random/pool/spaceloot/syndicate/common_rare
	loot = list(
		/obj/effect/spawner/random/pool/spaceloot/syndicate/common = 3,
		/obj/effect/spawner/random/pool/spaceloot/syndicate/rare = 2,
	)

/obj/effect/spawner/random/pool/spaceloot/laser
	point_value = 30
	spawn_loot_chance = 40
	loot = list(
		/obj/item/gun/energy/laser,
		/obj/item/gun/energy/laser/retro,
	)

/obj/effect/spawner/random/pool/spaceloot/mining_tool
	point_value = 15
	loot = list(
		/obj/item/pickaxe = 50,
		/obj/item/pickaxe/safety = 30,
		/obj/item/pickaxe/mini = 20,
		/obj/item/pickaxe/silver = 10,
		/obj/item/pickaxe/gold = 9,
		/obj/item/pickaxe/diamond = 7,
		/obj/item/pickaxe/drill = 15,
		/obj/item/pickaxe/drill/diamonddrill = 5,
		/obj/item/pickaxe/drill/jackhammer = 3,
		/obj/item/gun/energy/plasmacutter = 5,
		/obj/item/gun/energy/plasmacutter/adv = 3,
		/obj/item/kinetic_crusher = 3,
		/obj/item/gun/energy/kinetic_accelerator = 3,
		/obj/item/gun/energy/kinetic_accelerator/pistol = 3,
		/obj/item/gun/energy/kinetic_accelerator/experimental,
	)

/obj/effect/spawner/random/pool/spaceloot/security/modsuit
	point_value = 75
	spawn_loot_chance = 45
	loot = list(
		/obj/machinery/suit_storage_unit/security/space = 9,
		/obj/machinery/suit_storage_unit/security/space/safeguard,
	)
