/datum/job/warden
	department_account_access = TRUE

/obj/structure/closet/secure_closet/hos/populate_contents()
	. = ..()
	new /obj/item/clothing/gloves/combat(src)
