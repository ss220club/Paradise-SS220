// CC loot pool
/datum/spawn_pool/centcommloot
	id = "central_command_spawn_pool"
	available_points = INFINITY

/obj/effect/spawner/random/pool/centcommloot
	icon = 'icons/effects/random_spawners.dmi'
	icon_state = "giftbox"
	spawn_pool_id = "central_command_spawn_pool"

/obj/effect/spawner/random/pool/spaceloot/syndicate/common/depot/centcomm
	spawn_inside = null
	spawn_pool_id = "central_command_spawn_pool"

/obj/effect/spawner/random/pool/spaceloot/syndicate/rare/depot/centcomm
	spawn_inside = null
	spawn_pool_id = "central_command_spawn_pool"

/obj/effect/spawner/random/pool/spaceloot/syndicate/officer/depot/centcomm
	spawn_inside = null
	spawn_pool_id = "central_command_spawn_pool"

/obj/effect/spawner/random/pool/spaceloot/syndicate/armory/depot/centcomm
	spawn_inside = null
	spawn_pool_id = "central_command_spawn_pool"

/obj/effect/spawner/random/pool/centcommloot/syndicate/mixed
	loot = list(
		/obj/effect/spawner/random/pool/spaceloot/syndicate/common/depot/centcomm = 30,
		/obj/effect/spawner/random/pool/spaceloot/syndicate/rare/depot/centcomm = 20,
		/obj/effect/spawner/random/pool/spaceloot/syndicate/officer/depot/centcomm = 5,
		/obj/effect/spawner/random/pool/spaceloot/syndicate/armory/depot/centcomm = 1,
	)

// space loot pool
/obj/effect/spawner/random/pool/spaceloot/mechtransport_new/mecha
	icon_state = "durand_old"
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

/obj/effect/spawner/random/pool/spaceloot/modsuit_syndie
	icon = 'modular_ss220/maps220/icons/spawner_icons.dmi'
	icon_state = "mod"

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
	icon_state = "stetchkin"
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
		/obj/item/gun/energy/kinetic_accelerator/experimental = 1,
	)

/obj/effect/spawner/random/pool/spaceloot/security/modsuit
	icon = 'modular_ss220/maps220/icons/spawner_icons.dmi'
	icon_state = "mod"
	point_value = 75
	spawn_loot_chance = 45
	loot = list(
		/obj/machinery/suit_storage_unit/security/space = 9,
		/obj/machinery/suit_storage_unit/security/space/safeguard = 1,
	)

// gateways pool
/datum/spawn_pool/gatewayloot
	id = "gateway_spawn_pool"
	available_points = 850

/obj/effect/spawner/random/pool/gatewayloot
	icon = 'icons/effects/random_spawners.dmi'
	icon_state = "giftbox"
	spawn_pool_id = "gateway_spawn_pool"

/obj/effect/spawner/random/pool/spaceloot/mining_tool/gateway
	spawn_pool_id = "gateway_spawn_pool"
	spawn_loot_chance = 50

/obj/effect/spawner/random/pool/gatewayloot/spellbook
	icon = 'icons/obj/library.dmi'
	icon_state = "random_book"
	point_value = 100
	loot = list(/obj/item/spellbook/oneuse/random/necropolis)

/obj/effect/spawner/random/pool/gatewayloot/wisp
	point_value = 100
	loot = list(/obj/item/wisp_lantern)

/obj/effect/spawner/random/pool/gatewayloot/wizard
	point_value = 150
	loot = list(/mob/living/simple_animal/hostile/deadwizard)

/obj/effect/spawner/random/pool/gatewayloot/credits
	point_value = 20
	loot = list(
		/obj/item/stack/spacecash/c200,
		/obj/item/stack/spacecash/c500,
		/obj/item/stack/spacecash/c1000,
	)

/obj/effect/spawner/random/pool/gatewayloot/tsf/lieutenant
	spawn_all_loot = TRUE
	point_value = 125
	loot = list(
		/obj/item/clothing/head/beret/solgov,
		/obj/item/clothing/under/solgov/command,
		/obj/item/clothing/gloves/combat,
		/obj/item/clothing/shoes/combat,
		/obj/item/gun/projectile/automatic/pistol/deagle,
	)

/obj/effect/spawner/random/pool/gatewayloot/tsf/marine
	spawn_all_loot = TRUE
	point_value = 150
	loot = list(
		/obj/item/clothing/head/soft/solgov/marines,
		/obj/item/clothing/under/solgov,
		/obj/item/clothing/gloves/combat,
		/obj/item/clothing/shoes/combat,
		/obj/item/gun/projectile/automatic/pistol/m1911,
	)

/obj/effect/spawner/random/pool/gatewayloot/tsf/mixed
	loot = list(
		/obj/effect/spawner/random/pool/gatewayloot/tsf/marine = 99,
		/obj/effect/spawner/random/pool/gatewayloot/tsf/lieutenant = 1,
	)

/obj/effect/spawner/random/pool/gatewayloot/cult
	point_value = 30
	spawn_loot_chance = 60
	loot = list(
		/obj/item/shield/mirror,
		/obj/item/melee/cultblade,
		/obj/item/whetstone/cult,
		/obj/item/clothing/suit/hooded/cultrobes,
	)

/obj/effect/spawner/random/pool/gatewayloot/laser
	icon_state = "stetchkin"
	point_value = 30
	spawn_loot_chance = 50
	loot = list(/obj/item/gun/energy/laser)

/obj/effect/spawner/random/pool/gatewayloot/laser/retro
	loot = list(/obj/item/gun/energy/laser/retro)

/obj/effect/spawner/random/pool/gatewayloot/laser/advanced
	point_value = 55
	loot = list(
		/obj/item/gun/energy/laser,
		/obj/item/gun/energy/laser/retro,
		/obj/item/gun/energy/lasercannon,
		/obj/item/gun/energy/lwap,
		/obj/item/gun/energy/xray,
	)


/obj/effect/spawner/random/pool/gatewayloot/rsg
	icon_state = "stetchkin"
	point_value = 80
	spawn_loot_chance = 50
	loot = list(
		/obj/item/gun/syringe/rapidsyringe
	)

/obj/effect/spawner/random/pool/gatewayloot/immortality_ring
	point_value = 250
	loot = list(
		/obj/item/clothing/gloves/ring/immortality_ring
	)

/obj/effect/spawner/random/pool/spaceloot/modsuit_syndie/nuclear/gateway
	spawn_pool_id = "gateway_spawn_pool"

/obj/effect/spawner/random/pool/spaceloot/syndicate/common/gateway
	spawn_pool_id = "gateway_spawn_pool"

/obj/effect/spawner/random/pool/spaceloot/syndicate/rare/gateway
	spawn_pool_id = "gateway_spawn_pool"

/obj/effect/spawner/random/pool/spaceloot/syndicate/officer/gateway
	spawn_pool_id = "gateway_spawn_pool"

/obj/effect/spawner/random/pool/spaceloot/syndicate/armory/gateway
	spawn_pool_id = "gateway_spawn_pool"

/obj/effect/spawner/random/pool/gatewayloot/syndicate/mixed
	loot = list(
		/obj/effect/spawner/random/pool/spaceloot/syndicate/common/gateway = 30,
		/obj/effect/spawner/random/pool/spaceloot/syndicate/rare/gateway = 20,
		/obj/effect/spawner/random/pool/spaceloot/syndicate/officer/gateway = 5,
		/obj/effect/spawner/random/pool/spaceloot/syndicate/armory/gateway = 1,
	)

/obj/effect/spawner/random/pool/gatewayloot/syndicate/common_rare
	loot = list(
		/obj/effect/spawner/random/pool/spaceloot/syndicate/common/gateway = 3,
		/obj/effect/spawner/random/pool/spaceloot/syndicate/rare/gateway = 2,
	)

/obj/effect/spawner/random/pool/gatewayloot/lockbox
	guaranteed = TRUE
	point_value = 200
	loot = list(/obj/item/storage/lockbox/experimental_weapon/gateway)

/obj/effect/spawner/random/pool/gatewayloot/speedloader
	point_value = 25
	loot = list(
		/obj/item/ammo_box/shotgun/buck = 3,
		/obj/item/ammo_box/shotgun = 1,
		/obj/item/ammo_box/shotgun/confetti = 1,
	)

/obj/effect/spawner/random/pool/gatewayloot/proto_egun
	point_value = 100
	loot = list(/obj/item/gun/energy/e_gun/old)

/obj/effect/spawner/random/pool/gatewayloot/claymore
	guaranteed = TRUE
	point_value = 60
	loot = list(
		/obj/item/claymore/ceremonial = 6,
		/obj/item/nullrod/claymore = 3,
		/obj/item/claymore = 1,
	)

/obj/effect/spawner/random/pool/gatewayloot/enforcer
	icon_state = "stetchkin"
	point_value = 95
	spawn_loot_chance = 75
	loot = list(/obj/item/gun/projectile/automatic/pistol/enforcer)

/obj/effect/spawner/random/pool/gatewayloot/syndie_mob
	point_value = 20
	loot = list(
		/mob/living/simple_animal/hostile/syndicate/ranged/autogib/spacebattle = 25,
		/mob/living/simple_animal/hostile/syndicate/melee/autogib/spacebattle = 25,
		/mob/living/simple_animal/hostile/syndicate/ranged/space/autogib/spacebattle = 25,
		/mob/living/simple_animal/hostile/syndicate/melee/space/autogib/spacebattle = 25,

		// let the massacre begin, always least chance
		/mob/living/simple_animal/hostile/syndicate/melee/autogib/depot/armory/spacebattle/gateway = 1,
	)

/obj/effect/spawner/random/pool/gatewayloot/syndie_mob/space
	loot = list(
		/mob/living/simple_animal/hostile/syndicate/ranged/space/autogib/spacebattle,
		/mob/living/simple_animal/hostile/syndicate/melee/space/autogib/spacebattle,
	)

// syndie mob loot
/obj/effect/spawner/random/pool/gatewayloot/syndie_mob_loot
	loot = list(
		/obj/item/ammo_casing/c10mm = 62,
		/obj/item/food/syndicake = 5,
		/obj/item/poster/random_contraband = 5,
		/obj/item/tank/internals/emergency_oxygen/engi/syndi = 5,
		/obj/item/clothing/glasses/night = 5,
		/obj/item/reagent_containers/patch/styptic = 4,
		/obj/item/reagent_containers/patch/silver_sulf = 4,
		/obj/item/food/donkpocket = 4,
		/obj/effect/spawner/random/pool/gatewayloot/syndicate/mixed = 3,
		/obj/item/storage/box/syndidonkpockets = 2,

		// always least chance
		/obj/item/card/id/syndicate = 1,
	)

/obj/effect/spawner/random/pool/gatewayloot/syndie_mob_loot/space
	loot = list(
		/obj/item/ammo_casing/c10mm = 99,
		/obj/effect/spawner/random/pool/gatewayloot/syndie_mob_loot/space/modsuit = 1,
	)

/obj/effect/spawner/random/pool/gatewayloot/syndie_mob_loot/space/modsuit
	icon = 'modular_ss220/maps220/icons/spawner_icons.dmi'
	icon_state = "mod"
	loot = list(
		/obj/item/mod/control/pre_equipped/traitor = 3,
		/obj/item/mod/control/pre_equipped/nuclear = 1,
	)

/obj/effect/spawner/random/pool/gatewayloot/syndie_mob_loot/ranged
	loot = list(
		/obj/item/ammo_casing/c10mm = 75,
		/obj/item/clothing/accessory/holster = 15,
		/obj/item/ammo_box/magazine/m10mm = 9,

		// always least chance
		/obj/effect/spawner/random/pool/gatewayloot/syndie_mob_loot/ranged/handgun = 1,
	)

/obj/effect/spawner/random/pool/gatewayloot/syndie_mob_loot/ranged/handgun
	icon_state = "stetchkin"
	loot = list(
		/obj/item/gun/projectile/automatic/pistol = 98,

		// always least chance
		/obj/item/gun/projectile/revolver = 1,
		/obj/item/gun/projectile/revolver/fake = 1,
	)

/obj/effect/spawner/random/pool/gatewayloot/syndie_mob_loot/melee
	icon_state = "stetchkin"
	loot = list(
		/obj/item/ammo_casing/c10mm = 98,

		// always least chance
		/obj/item/shield/energy = 1,
		/obj/item/melee/energy/sword/saber = 1,
	)

/obj/effect/spawner/random/pool/gatewayloot/griefsky
	point_value = 100
	loot = list(/mob/living/simple_animal/bot/secbot/griefsky/syndie/spacebattle)

/obj/effect/spawner/random/pool/gatewayloot/mauler
	icon_state = "durand_old"
	point_value = 200
	loot = list(/obj/mecha/combat/marauder/mauler/spacebattle)
