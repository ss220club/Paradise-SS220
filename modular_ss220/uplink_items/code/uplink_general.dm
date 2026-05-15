/datum/uplink_item/device_tools/shadowlight
	name = "Shadowlight"
	desc = "Устройство, замаскированное под обычный фонарик, но создающее тьму в определенном радиусе. \
			Окутайте себя тьмой и спрячьтесь от посторонних глаз. \
			Практически не работает на ярком свету "
	reference = "SHAD"
	item = /obj/item/flashlight/shadowlight
	cost = 20

/datum/uplink_item/dangerous/chainsaw
	excludefrom = list()

//SS220 Uplink cost changes

/datum/uplink_item/dangerous/revolver
	cost = 70

/datum/uplink_item/dangerous/sword
	cost = 45

/datum/uplink_item/dangerous/dsword
	cost = 70

/datum/uplink_item/dangerous/powerfist
	cost = 60

/datum/uplink_item/dangerous/chainsaw
	cost = 70

/datum/uplink_item/dangerous/universal_gun_kit
	cost = 10

/datum/uplink_item/dangerous/porta_turret
	cost = 10

////////////////////////////////////////
// MARK: AMMUNITION
////////////////////////////////////////

/datum/uplink_item/ammo/pistol
	cost = 2

/datum/uplink_item/ammo/pistolap
	cost = 5

/datum/uplink_item/ammo/pistolfire
	cost = 10

/datum/uplink_item/ammo/pistolhp
	cost = 5

////////////////////////////////////////
// MARK: STEALTHY WEAPONS
////////////////////////////////////////

/datum/uplink_item/stealthy_weapons/garrote
	cost = 15

/datum/uplink_item/stealthy_weapons/throwingweapons
	cost = 15

/datum/uplink_item/stealthy_weapons/foampistol
	cost = 10


/datum/uplink_item/stealthy_weapons/false_briefcase
	cost = 5

/datum/uplink_item/stealthy_weapons/rsg
	cost = 50

/datum/uplink_item/stealthy_weapons/dehy_carp
	cost = 2

/datum/uplink_item/stealthy_weapons/knuckleduster
	cost = 5

////////////////////////////////////////
// MARK: GRENADES AND EXPLOSIVES
////////////////////////////////////////

/datum/uplink_item/explosives/syndicate_minibomb
	cost = 20

/datum/uplink_item/explosives/pizza_bomb
	cost = 15

/datum/uplink_item/explosives/emp
	cost = 15

/datum/uplink_item/explosives/targrenade
	cost = 5

////////////////////////////////////////
// MARK: STEALTHY TOOLS
////////////////////////////////////////

/datum/uplink_item/stealthy_tools/chamsechud
	cost = 5

/datum/uplink_item/stealthy_tools/agent_card
	cost = 5

/datum/uplink_item/stealthy_tools/chameleon_proj
	cost = 15

/datum/uplink_item/stealthy_tools/camera_bug
	cost = 5

/datum/uplink_item/stealthy_tools/dnascrambler
	cost = 5

/datum/uplink_item/stealthy_tools/emplight
	cost = 10

/datum/uplink_item/stealthy_tools/cutouts
	cost = 1

////////////////////////////////////////
// MARK: DEVICES AND TOOLS
////////////////////////////////////////

/datum/uplink_item/device_tools/access_tuner
	cost = 20

/datum/uplink_item/device_tools/surgerybag
	cost = 5

/datum/uplink_item/device_tools/bonerepair
	cost = 5

/datum/uplink_item/device_tools/syndicate_teleporter
	cost = 50

/datum/uplink_item/device_tools/organ_extractor
	cost = 10

/datum/uplink_item/device_tools/c_foam_launcher
	cost = 15

/datum/uplink_item/device_tools/tar_spray
	cost = 10

/datum/uplink_item/device_tools/binary
	cost = 10

/datum/uplink_item/device_tools/cipherkey
	cost = 5

/datum/uplink_item/device_tools/singularity_beacon
	cost = 10

/datum/uplink_item/device_tools/jammer
	cost = 15

/datum/uplink_item/device_tools/decoy_nade
	cost = 5

////////////////////////////////////////
// MARK: SPACE SUITS AND HARDSUITS
////////////////////////////////////////

/datum/uplink_item/suits/modsuit_elite
	cost = 60
	excludefrom = list(UPLINK_TYPE_NUCLEAR)

/datum/uplink_item/suits/space_suit
	cost = 15

/datum/uplink_item/suits/thermal
	cost = 10

/datum/uplink_item/suits/plate_compression
	cost = 5

/datum/uplink_item/suits/chameleon_module
	cost = 5

/datum/uplink_item/suits/smoke_grenade
	cost = 5

////////////////////////////////////////
// MARK: IMPLANTS
////////////////////////////////////////

/datum/uplink_item/bio_chips/freedom
	cost = 20

/datum/uplink_item/bio_chips/protofreedom
	cost = 5

/datum/uplink_item/bio_chips/storage
	cost = 30

/datum/uplink_item/bio_chips/mindslave
	cost = 40

/datum/uplink_item/bio_chips/basic_adrenal
	cost = 15

/datum/uplink_item/bio_chips/proto_adrenal
	cost = 5

////////////////////////////////////////
// MARK: CYBERNETICS
////////////////////////////////////////

/datum/uplink_item/cyber_implants/hackerman_deck
	cost = 15 // Probably slightly less useful than an emag with heat / cooldown, but I am not going to make it cheaper or everyone picks it over emag

/datum/uplink_item/cyber_implants/razorwire
	cost = 15

/datum/uplink_item/cyber_implants/mantis_kit
	cost = 35
	excludefrom = list(UPLINK_TYPE_NUCLEAR)
