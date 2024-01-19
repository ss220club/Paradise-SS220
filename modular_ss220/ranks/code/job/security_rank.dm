
/datum/job/officer/New()
	. = ..()
	backpack_contents |= /obj/item/clothing/accessory/rank/sec

/datum/job/detective/New()
	. = ..()
	backpack_contents |= /obj/item/clothing/accessory/rank/sec

/datum/job/warden/New()
	. = ..()
	backpack_contents |= /obj/item/clothing/accessory/rank/sec/officer

/datum/job/hos/New()
	. = ..()
	backpack_contents |= /obj/item/clothing/accessory/rank/sec/officer
