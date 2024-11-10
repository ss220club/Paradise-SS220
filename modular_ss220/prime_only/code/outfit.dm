// MARK: Prime outfits

/datum/outfit/job/explorer
	uniform = /obj/item/clothing/under/rank/cargo/expedition_prime
	head = /obj/item/clothing/head/soft/black
	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel_norm

/datum/outfit/job/admin/delta817
	name = "Delta 817 - ARG, no armor"
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
	id = /obj/item/card/id/centcom
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

/datum/outfit/job/admin/delta817/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/I = H.wear_id
	if(istype(I))
		apply_to_card(I, H, get_centcom_access("Nanotrasen Navy Officer"), "Normandy Special Forces")
	I.rank = "Nanotrasen Navy Officer"
	I.assignment = "Normandy Special Forces"
	H.sec_hud_set_ID()

/datum/outfit/job/admin/delta817/arg
	name = "Delta 817 - ARG, armor"
	back = /obj/item/mod/control/pre_equipped/responsory/commander

/datum/outfit/job/admin/delta817/nf10
	name = "Delta 817 - NF10, armor"
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

/datum/outfit/job/admin/delta817/l6saw
	name = "Delta 817 - l6saw, armor"
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

/datum/outfit/job/admin/delta817/ikmk2
	name = "Delta 817 - IK-M2, armor"
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

/datum/outfit/job/admin/delta817/pulse
	name = "Delta 817 - pulse, armor"
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

/datum/outfit/job/admin/ntspecops/normandy
	name = "SOO Normandy"
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

/datum/outfit/job/admin/ntnavyofficer/traisen
	name = "Heinrich Traisen III"
	r_hand = /obj/item/storage/belt/sheath/saber/cane_rapier
	head = /obj/item/clothing/head/ntrep
	mask = /obj/item/clothing/mask/gas/navy_officer
	suit = /obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt
	back = /obj/item/storage/backpack/satchel


/datum/outfit/job/admin/ntnavyofficer/traisen/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/I = H.wear_id
	if(istype(I))
		apply_to_card(I, H, get_centcom_access("Nanotrasen Navy Officer"), "Nanotrasen Chief Executive Officer")
	I.rank = "Nanotrasen Navy Officer"
	I.assignment = "Nanotrasen Chief Executive Officer"
	H.sec_hud_set_ID()

/datum/outfit/job/admin/ntnavyofficer/field/hr_officer
	name = "Central HR Officer"
	suit = /obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt
	l_pocket = /obj/item/dualsaber/legendary_saber/flame
	gloves = /obj/item/clothing/gloves/color/white
	uniform = /obj/item/clothing/under/rank/procedure/representative

/datum/outfit/job/admin/ntnavyofficer/field/secretary_officer
	name = "Special Operations Secretary"
	l_pocket = /obj/item/dualsaber/legendary_saber/sorrow_catcher
	head = /obj/item/clothing/head/helmet/space/deathsquad/beret
	mask = /obj/item/clothing/mask/breath/breathscarf
	suit = /obj/item/clothing/suit/space/deathsquad/officer/field
	backpack_contents = list(
		/obj/item/gun/projectile/revolver/reclinable/rsh12,
		/obj/item/ammo_box/speed_loader_mm127,
		/obj/item/clothing/accessory/holster,
	)

/datum/outfit/job/admin/ntnavyofficer/field/secretary_officer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/I = H.wear_id
	if(istype(I))
		apply_to_card(I, H, get_centcom_access("Nanotrasen Navy Officer"), "Special Operations Secretary")
	I.rank = "Nanotrasen Navy Officer"
	I.assignment = "Special Operations Secretary"
	H.sec_hud_set_ID()

/datum/outfit/job/admin/ntnavyofficer/field/alt2
	name = "NT Navy Officer alt. Cloak gold, scarf"
	suit = /obj/item/clothing/suit/space/deathsquad/officer/field/cloak_nt/gold
	mask = /obj/item/clothing/mask/breath/breathscarf

/datum/outfit/job/admin/ntnavyofficer/field/operational_officer
	name = "Operational Group Commander"
	suit = /obj/item/clothing/suit/browntrenchcoat/blueshield_chef
	mask = /obj/item/clothing/mask/gas/navy_officer
	head = /obj/item/clothing/head/beret/centcom/officer/blueshield_chef
	gloves = /obj/item/clothing/gloves/color/white
	l_pocket = /obj/item/dualsaber/legendary_saber/eris_star

/datum/outfit/job/admin/ntnavyofficer/field/operational_officer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/card/id/I = H.wear_id
	if(istype(I))
		apply_to_card(I, H, get_centcom_access("Nanotrasen Navy Officer"), "Operational Group Commander")
	I.rank = "Nanotrasen Navy Officer"
	I.assignment = "Operational Group Commander"
	H.sec_hud_set_ID()

/datum/outfit/job/admin/ntnavyofficer/field/alt3
	name = "NT Navy Officer alt. Hat, m1911, cane"
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
