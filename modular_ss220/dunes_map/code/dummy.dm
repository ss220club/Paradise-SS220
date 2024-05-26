//DUMMIES

/obj/item/projectile/beam/depredator/dummy
	damage = 0

/obj/item/projectile/beam/laser/heavylaser/dummy
	damage = 0

/obj/item/projectile/beam/depredator/dummy/hitscan
	color = LIGHT_COLOR_PURPLE
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/depredator
	tracer_type = /obj/effect/projectile/tracer/depredator
	impact_type = /obj/effect/projectile/impact/depredator
	impact_effect_type = null
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = LIGHT_COLOR_PURPLE
	muzzle_flash_intensity = 6
	muzzle_flash_range = 2
	muzzle_flash_color_override = LIGHT_COLOR_PURPLE
	impact_light_intensity = 7
	impact_light_range = 2.5
	impact_light_color_override = LIGHT_COLOR_PURPLE

/obj/machinery/power/emitter/dummy_depred
	name = "стреляло"
	desc = "скрытный депредатор незаметно стрелять трурль спецэффекты 220"
	projectile_type = /obj/item/projectile/beam/depredator/dummy/hitscan
	projectile_sound = 'modular_ss220/aesthetics_sounds/sound/mobs/vortigaunt/attack_shoot4.ogg'

/obj/machinery/power/emitter/dummy_depred/Initialize(mapload)
	. = ..()
	invisibility = 101
	active = 1
	powered = TRUE
	active_power_consumption = 0
	state = 2
	fire_delay = 150
	maximum_fire_delay = 700
	minimum_fire_delay = 20

/obj/machinery/power/emitter/dummy_laser
	name = "стреляло"
	desc = "незаметный стрелять лазер эффекты взрыв кино сс220"
	projectile_type = /obj/item/projectile/beam/laser/heavylaser/dummy
	projectile_sound = 'sound/weapons/lasercannonfire.ogg'
	invisibility = 101
	powered = TRUE
	active = 1
	active_power_consumption = 0
	state = 2
	fire_delay = 150
	maximum_fire_delay = 500
	minimum_fire_delay = 40

/obj/machinery/power/emitter/dummy_laser/Initialize(mapload)
	. = ..()
	invisibility = 101
	active = 1
	powered = TRUE
	active_power_consumption = 0
	state = 2
	fire_delay = 150
	maximum_fire_delay = 100
	minimum_fire_delay = 50

/obj/machinery/porta_turret/syndicate/dummy
	name = "система защиты АКН"
	icon_state = "target_prism"
	icon_state_initial = "target_prism"
	icon_state_active = "target_prism"
	icon_state_destroyed = "destroyed_target_prism"
	faction = "neutral"
	lethal = TRUE
	name = "Heavy Defence Turret"
	max_integrity = 120
	projectile = /obj/item/projectile/beam/laser/heavylaser
	eprojectile = /obj/item/projectile/beam/laser/heavylaser
	shot_sound = 'sound/weapons/lasercannonfire.ogg'
	eshot_sound = 'sound/weapons/lasercannonfire.ogg'
	reqpower = FALSE

/mob/living/carbon/human/dummy/target
	name = ""
	desc = ""
	alpha = 0
	opacity = TRUE
	density = TRUE
	faction = "syndicate"

/datum/outfit/admin/tanya
	name = "Таня фон Нормандия"
	uniform = /obj/item/clothing/under/solgov/srt
	belt = /obj/item/storage/belt/military/assault/srt
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/beret/solgov/command
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/gas/sechailer
	r_hand = /obj/item/gun/projectile/automatic/ar
	l_pocket = /obj/item/tank/internals/emergency_oxygen/double
	r_pocket = /obj/item/reagent_containers/hypospray/combat/nanites
	back = /obj/item/mod/control/pre_equipped/apocryphal
	id = /obj/item/card/id/centcom
	pda = /obj/item/pda/centcom
	backpack_contents = list(
		/obj/item/storage/box/flashbangs,
		/obj/item/ammo_box/magazine/m556/arg = 5,
		/obj/item/flashlight/seclite,
		/obj/item/grenade/plastic/c4/x4,
		/obj/item/melee/energy/sword/saber,
		/obj/item/shield/energy,
	)
	bio_chips = list(
		/obj/item/bio_chip/mindshield,
		/obj/item/bio_chip/dust
	)
	cybernetic_implants = list(
		/obj/item/organ/internal/cyberimp/chest/nutriment/plus/hardened,
		/obj/item/organ/internal/cyberimp/arm/combat/centcom
	)
