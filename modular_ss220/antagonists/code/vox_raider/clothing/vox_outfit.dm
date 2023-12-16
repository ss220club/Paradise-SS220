// Outfit
/datum/outfit/admin/vox
	name = "Vox Raider"
	uniform = /obj/item/clothing/under/vox/jumpsuit
	suit = /obj/item/clothing/suit/space/vox/carapace
	back = /obj/item/storage/backpack
	gloves = /obj/item/clothing/gloves/color/yellow/vox
	shoes = /obj/item/clothing/shoes/magboots/vox
	head = /obj/item/clothing/head/helmet/space/vox/carapace
	mask = /obj/item/clothing/mask/gas/syndicate
	l_ear = /obj/item/radio/headset/syndicate
	glasses = /obj/item/clothing/glasses/thermal/monocle
	id = /obj/item/card/id/syndicate/vox
	l_pocket = /obj/item/melee/classic_baton/telescopic
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double/vox
	backpack_contents = list(
		/obj/item/flashlight = 1,
		/obj/item/restraints/handcuffs/cable/zipties = 1,
		/obj/item/flash = 1,
		/obj/item/gun/energy/noisecannon = 1
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











/datum/outfit/admin/vox/carapace
	name = "Vox Raide Carapace"
	uniform = /obj/item/clothing/under/vox/vox_robes
	suit = /obj/item/clothing/suit/space/vox/carapace
	back = /obj/item/storage/backpack
	gloves = /obj/item/clothing/gloves/color/yellow/vox
	shoes = /obj/item/clothing/shoes/magboots/vox
	head = /obj/item/clothing/head/helmet/space/vox/carapace
	mask = /obj/item/clothing/mask/gas/syndicate
	l_ear = /obj/item/radio/headset/syndicate
	glasses = /obj/item/clothing/glasses/thermal/monocle
	id = /obj/item/card/id/syndicate/vox
	l_pocket = /obj/item/melee/classic_baton/telescopic
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double/vox
	backpack_contents = list(
		/obj/item/flashlight = 1,
		/obj/item/restraints/handcuffs/cable/zipties = 1,
		/obj/item/flash = 1,
		/obj/item/gun/energy/noisecannon = 1
	)

/datum/outfit/admin/vox/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(isvoxarmalis(H))
		. = ..()
	else
		H.equip_vox_raider()
		H.regenerate_icons()

/datum/outfit/admin/vox/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/I = H.wear_id
	if(istype(I))
		apply_to_card(I, H, get_all_accesses(), "Vox Armalis", "syndie")
