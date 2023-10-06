/datum/outfit/admin/srt
	name = "Special Response Team Member"

	uniform = /obj/item/clothing/under/solgov/srt
	suit = /obj/item/clothing/suit/armor/vest/fluff/tactical
	suit_store = /obj/item/gun/energy/gun/blueshield/pdw9
	back = /obj/item/storage/backpack/satchel_blueshield
	belt = /obj/item/storage/belt/military/assault/srt
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/combat/swat
	head = /obj/item/clothing/head/beret/centcom/officer/navy/marine
	l_ear = /obj/item/radio/headset/ert/alt
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	id = /obj/item/card/id/ert/security
	pda = /obj/item/pda/heads/ert/security
	box = box = /obj/item/storage/box/responseteam
	r_pocket = /obj/item/flashlight/seclite
	l_pocket = /obj/item/pinpointer/advpinpointer
	r_hand = /obj/item/gun/projectile/automatic/proto
	backpack_contents = list(
		/obj/item/clothing/mask/gas/explorer/marines,
		/obj/item/storage/box/handcuffs,
		/obj/item/ammo_box/magazine/smgm9mm
	)
	implants = list(
		/obj/item/implant/mindshield
	)
	cybernetic_implants = list(
		/obj/item/organ/internal/cyberimp/arm/baton,
		/obj/item/organ/internal/cyberimp/eyes/hud/security
	)

/datum/outfit/admin/srt/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	ar/obj/item/card/id/I = H.wear_id
	if(istype(I))
		apply_to_card(I, H, get_all_centcom_access("Emergency Response Team Member"), name, "lifetimeid")
	I.assignment = "Special Response Team Member"
	H.sec_hud_set_ID()

/obj/item/clothing/under/solgov/srt
	name = "marine uniform"
	desc = "A comfortable and durable combat uniform"

/obj/item/clothing/head/beret/centcom/officer/navy/marine
	name = "navy blue beret"

/obj/item/storage/belt/military/assault/srt/full/populate_contents()
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/flash(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/restraints/legcuffs/bola/energy(src)
	new /obj/item/ammo_box/magazine/smgm9mm(src)
	new /obj/item/ammo_box/magazine/smgm9mm(src)
	update_icon()











The mindshield bio-chip

The advanced energy revolver

Билл Громов's ID Card ()

The boxed survival kit

The survival medipen

The handgun magazine (.45)

The pocket fire extinguisher

The SMG magazine (9mm)x2

The Nanotrasen Saber SMG

The M1911

The breath mask

The extended-capacity emergency oxygen tank

The miniature titanium crowbar

The flare

The combat knife

The centcomm bounced radio

The synthflesh patch

The emergency autoinjector

The pepperspray

The flashbang

The flash

The energy bola

The SMG magazine (9mm)

The handgun magazine (.45)
