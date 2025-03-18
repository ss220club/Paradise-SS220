//List of different corpse types
// MARK: Syndicate
/obj/effect/mob_spawn/human/corpse/syndicate
	name = "Syndicate Operative"
	mob_name = "Syndicate Operative"
	id_job = "err#unkwn"
	hair_colour = "#000000"
	facial_hair_colour = "#000000"
	id_access_list = list(ACCESS_SYNDICATE)
	outfit = /datum/outfit/syndicatecorpse
	del_types = list()
	disable_pda = TRUE

/obj/effect/mob_spawn/human/corpse/syndicate/Initialize(mapload)
	mob_name = "[mob_name] [pick(GLOB.last_names)]"
	brute_damage = rand(0, 200)
	skin_tone = rand(40,120)
	return ..()

/datum/outfit/syndicatecorpse
	name = "Corpse of a Syndicate Operative"
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/jacket/bomber/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	l_ear = /obj/item/radio/headset/syndicate_fake
	mask = /obj/item/clothing/mask/gas/syndicate
	head = /obj/item/clothing/head/helmet/swat/syndicate
	back = /obj/item/storage/backpack/satchel
	box = /obj/item/storage/box/survival_syndie/traitor/loot
	l_pocket = /obj/item/tank/internals/emergency_oxygen/engi/syndi
	id = /obj/item/card/id
	pda = /obj/item/pda/syndicate_fake
	internals_slot = ITEM_SLOT_LEFT_POCKET
	var/modsuit

/datum/outfit/syndicatecorpse/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(modsuit && prob(1))
		back = modsuit
		box = null
		head = null
		suit = null

/datum/outfit/syndicatecorpse/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H?.w_uniform)
		var/obj/item/clothing/under/U = H.w_uniform
		var/obj/item/clothing/accessory/holster/W = new /obj/item/clothing/accessory/holster(U)
		U.accessories += W
		W.on_attached(U)

// MARK: Syndicate modsuit
/obj/effect/mob_spawn/human/corpse/syndicate/modsuit
	name = "Syndicate Commando"
	mob_name = "Syndicate Commando"
	outfit = /datum/outfit/syndicatecorpse/modsuit

/datum/outfit/syndicatecorpse/modsuit
	name = "Corpse of a Syndicate Commando"
	modsuit = /obj/item/mod/control/pre_equipped/traitor

// MARK: Syndicate elite modsuit
/obj/effect/mob_spawn/human/corpse/syndicate/modsuit/elite
	name = "Syndicate Quartermaster"
	mob_name = "Syndicate Quartermaster"
	outfit = /datum/outfit/syndicatecorpse/modsuit/elite

/datum/outfit/syndicatecorpse/modsuit/elite
	name = "Corpse of a Syndicate Quartermaster"
	modsuit = /obj/item/mod/control/pre_equipped/traitor_elite

/obj/effect/mob_spawn/human/corpse/clown/corpse
	roundstart = TRUE
	instant = TRUE

/obj/effect/mob_spawn/human/corpse/mime/corpse
	roundstart = TRUE
	instant = TRUE

/obj/effect/mob_spawn/human/corpse/pirate
	name = "Pirate"
	mob_name = "Pirate"
	hair_style = "bald"
	facial_hair_style = "shaved"
	outfit = /datum/outfit/piratecorpse

/datum/outfit/piratecorpse
	name = "Corpse of a Pirate"
	uniform = /obj/item/clothing/under/costume/pirate
	suit = /obj/item/clothing/suit/space/eva
	shoes = /obj/item/clothing/shoes/jackboots
	glasses = /obj/item/clothing/glasses/eyepatch
	head = /obj/item/clothing/head/helmet/space/eva
	back = /obj/item/tank/jetpack/carbondioxide

/obj/effect/mob_spawn/human/corpse/pirate/ranged
	name = "Pirate Gunner"
	mob_name = "Pirate Gunner"
	outfit = /datum/outfit/piratecorpse

/datum/outfit/piratecorpse/ranged
	name = "Corpse of a Pirate Gunner"


/obj/effect/mob_spawn/human/corpse/soviet
	name = "Soviet"
	mob_name = "Soviet"
	hair_style = "bald"
	facial_hair_style = "shaved"
	outfit = /datum/outfit/sovietcorpse

/datum/outfit/sovietcorpse
	name = "Corpse of a Soviet"
	uniform = /obj/item/clothing/under/new_soviet
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/sovietsidecap


/obj/effect/mob_spawn/human/corpse/soviet/ranged
	outfit = /datum/outfit/sovietcorpse/ranged

/datum/outfit/sovietcorpse/ranged
	name = "Corpse of a Ranged Soviet"
	suit = /obj/item/clothing/suit/sovietcoat

/obj/effect/mob_spawn/human/corpse/soviet_nian
	name = "Soviet Nian"
	mob_name = "Soviet Nian"
	mob_species = /datum/species/moth
	hair_style = "bald"
	facial_hair_style = "shaved"
	outfit = /datum/outfit/soviet_nian

/datum/outfit/soviet_nian
	name = "Soviet Nian"
	uniform = /obj/item/clothing/under/new_soviet
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/ushanka
	r_pocket = /obj/item/reagent_containers/drinks/drinkingglass/shotglass
	l_pocket = /obj/item/reagent_containers/drinks/bottle/vodka

/obj/effect/mob_spawn/human/corpse/wizard
	name = "Corpse of a Space Wizard"
	outfit = /datum/outfit/wizardcorpse

/obj/effect/mob_spawn/human/corpse/wizard/officer/Initialize(mapload)
	mob_name = "[pick(GLOB.wizard_first)], [pick(GLOB.wizard_second)]"
	. = ..()

/datum/outfit/wizardcorpse
	name = "Corpse of a Space Wizard"
	uniform = /obj/item/clothing/under/color/lightpurple
	suit = /obj/item/clothing/suit/wizrobe
	shoes = /obj/item/clothing/shoes/sandal
	head = /obj/item/clothing/head/wizard

/obj/effect/mob_spawn/human/corpse/seed_vault_diona
	name = "Corpse of a Diona"
	mob_species = /datum/species/diona
	outfit = /datum/outfit/seed_vault_diona

/datum/outfit/seed_vault_diona
	name = "Unknown Diona"
	uniform = /obj/item/clothing/under/rank/civilian/hydroponics
	belt = /obj/item/storage/bag/plants
	mask = /obj/item/clothing/mask/breath
	r_pocket = /obj/item/paper/crumpled/ruins/lavaland/seed_vault/discovery
	l_pocket = /obj/item/tank/internals/emergency_oxygen/engi/empty

