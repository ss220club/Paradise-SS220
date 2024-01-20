// Security
/datum/job/officer/equip(mob/living/carbon/human/H, visualsOnly, announce)
	. = ..()
	if(flag == JOB_CADET)
		return
	var/accessory = new /obj/item/clothing/accessory/rank/sec(H)
	H.equip_or_collect(accessory, SLOT_HUD_IN_BACKPACK)

/datum/job/detective/equip(mob/living/carbon/human/H, visualsOnly, announce)
	. = ..()
	var/accessory = new /obj/item/clothing/accessory/rank/sec/detective(H)
	H.equip_or_collect(accessory, SLOT_HUD_IN_BACKPACK)

/datum/job/warden/equip(mob/living/carbon/human/H, visualsOnly, announce)
	. = ..()
	var/accessory = new /obj/item/clothing/accessory/rank/sec/warden(H)
	H.equip_or_collect(accessory, SLOT_HUD_IN_BACKPACK)

/datum/job/hos/equip(mob/living/carbon/human/H, visualsOnly, announce)
	. = ..()
	var/accessory = new /obj/item/clothing/accessory/rank/sec/officer(H)
	H.equip_or_collect(accessory, SLOT_HUD_IN_BACKPACK)
