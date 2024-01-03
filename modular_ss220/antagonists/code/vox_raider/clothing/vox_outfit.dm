// Outfit
/datum/outfit/admin/vox
	name = "Vox Clothing"
	uniform = /obj/item/clothing/under/vox/jumpsuit
	gloves = /obj/item/clothing/gloves/vox
	shoes = /obj/item/clothing/shoes/roman/vox
	mask = /obj/item/clothing/mask/breath/vox/respirator
	l_ear = /obj/item/radio/headset/vox
	id = /obj/item/card/id/syndicate/vox
	l_pocket = /obj/item/melee/classic_baton/telescopic
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double/vox

	back = /obj/item/storage/backpack/vox
	backpack_contents = list(
		/obj/item/flashlight = 1,
		/obj/item/flash = 1,
		// /obj/item/gun/energy/noisecannon = 1,
		/obj/item/clothing/suit/space/vox/pressure = 1,
		/obj/item/clothing/head/helmet/space/vox/pressure = 1,
	)

/datum/outfit/admin/vox/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/choosen = rand(1, 8)
	switch(choosen)
		if(1)
			uniform = /obj/item/clothing/under/vox/jumpsuit/red
		if(2)
			uniform = /obj/item/clothing/under/vox/jumpsuit/teal
		if(3)
			uniform = /obj/item/clothing/under/vox/jumpsuit/blue
		if(4)
			uniform = /obj/item/clothing/under/vox/jumpsuit/green
		if(5)
			uniform = /obj/item/clothing/under/vox/jumpsuit/yellow
		if(6)
			uniform = /obj/item/clothing/under/vox/jumpsuit/purple
		else
			uniform = /obj/item/clothing/under/vox/jumpsuit

	if(prob(5))
		uniform = /obj/item/clothing/suit/hooded/vox_robes

	if(prob(50))
		back = /obj/item/storage/backpack/satchel_flat/vox
		if(prob(25))
			back = /obj/item/storage/backpack/duffel/vox

/datum/outfit/admin/vox/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/I = H.wear_id
	if(istype(I))
		apply_to_card(I, H, get_all_accesses(), "Vox Raider", "syndie")

/datum/outfit/admin/vox/carapace
	name = "Vox Carapace"
	uniform = /obj/item/clothing/suit/hooded/vox_robes
	suit = /obj/item/clothing/suit/space/vox/carapace
	gloves = /obj/item/clothing/gloves/color/yellow/vox
	shoes = /obj/item/clothing/shoes/magboots/vox
	head = /obj/item/clothing/head/helmet/space/vox/carapace
	mask = /obj/item/clothing/mask/gas/syndicate
	glasses = /obj/item/clothing/glasses/thermal/monocle
	l_ear = /obj/item/radio/headset/vox/alt


/datum/outfit/admin/vox/carapace/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	uniform = /obj/item/clothing/suit/hooded/vox_robes
	back = /obj/item/storage/backpack/vox


// ==================== Raiders ====================
/datum/outfit/admin/vox/raider
	name = "vox raider"
	suit = /obj/item/clothing/suit/space/hardsuit/vox
	suit_store = /obj/item/tank/internals/emergency_oxygen/double/vox
	gloves = /obj/item/clothing/gloves/color/yellow/vox
	shoes = /obj/item/clothing/shoes/magboots/vox
	l_ear = /obj/item/radio/headset/vox/alt

/datum/outfit/admin/vox/raider/trooper
	name = "vox raider trooper"
	suit = /obj/item/clothing/suit/space/hardsuit/vox/trooper
	shoes = /obj/item/clothing/shoes/magboots/vox/combat

/datum/outfit/admin/vox/raider/scout
	name = "vox raider scout"
	suit = /obj/item/clothing/suit/space/hardsuit/vox/scout
	shoes = /obj/item/clothing/shoes/magboots/vox/scout

/datum/outfit/admin/vox/raider/medic
	name = "vox raider medic"
	suit = /obj/item/clothing/suit/space/hardsuit/vox/medic

/datum/outfit/admin/vox/raider/mechanic
	name = "vox raider mechanic"
	suit = /obj/item/clothing/suit/space/hardsuit/vox/mechanic
	shoes = /obj/item/clothing/shoes/magboots/vox/heavy

/datum/outfit/admin/vox/raider/heavy
	name = "vox raider heavy"
	suit = /obj/item/clothing/suit/space/hardsuit/vox/heavy
	shoes = /obj/item/clothing/shoes/magboots/vox/heavy


// ==================== Mercenaries ====================
/datum/outfit/admin/vox/merc
	name = "vox mercenary"
	suit = /obj/item/clothing/suit/armor/vox_merc
	head = /obj/item/clothing/head/helmet/vox_merc
	gloves = /obj/item/clothing/gloves/color/yellow/vox
	shoes = /obj/item/clothing/shoes/magboots/vox
	l_ear = /obj/item/radio/headset/vox/alt

/datum/outfit/admin/vox/merc/storm
	name = "vox mercenary stormtrooper"
	suit = /obj/item/clothing/suit/armor/vox_merc/stormtrooper
	head = /obj/item/clothing/head/helmet/vox_merc/stormtrooper
	shoes = /obj/item/clothing/shoes/magboots/vox/combat

/datum/outfit/admin/vox/merc/fieldmedic
	name = "vox mercenary field medic"
	suit = /obj/item/clothing/suit/armor/vox_merc/fieldmedic
	head = /obj/item/clothing/head/helmet/vox_merc/fieldmedic

/datum/outfit/admin/vox/merc/bomber
	name = "vox mercenary bomber"
	suit = /obj/item/clothing/suit/armor/vox_merc/bomber
	head = /obj/item/clothing/head/helmet/vox_merc/bomber
	shoes = /obj/item/clothing/shoes/magboots/vox/heavy

/datum/outfit/admin/vox/merc/laminar
	name = "vox mercenary laminar"
	suit = /obj/item/clothing/suit/armor/vox_merc/laminar
	head = /obj/item/clothing/head/helmet/vox_merc/laminar

/datum/outfit/admin/vox/merc/laminar/scout
	name = "vox mercenary laminar scout"
	suit = /obj/item/clothing/suit/armor/vox_merc/laminar/scout
	shoes = /obj/item/clothing/shoes/magboots/vox/scout

/datum/outfit/admin/vox/merc/stealth
	name = "vox mercenary stealth"
	suit = /obj/item/clothing/suit/armor/vox_merc/stealth
	head = /obj/item/clothing/head/helmet/vox_merc/stealth
