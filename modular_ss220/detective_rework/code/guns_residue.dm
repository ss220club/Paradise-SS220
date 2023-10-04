/obj/item/ammo_casing
	var/leaves_residue

/obj/item/ammo_casing/proc/leave_residue(mob/living/carbon/human/H)
	for(H)
		if(H.gloves)
			var/obj/item/clothing/G = H.gloves
			G.gunshot_residue = caliber
		else
			H.gunshot_residue = caliber

/obj/item/ammo_casing/energy
	leaves_residue = FALSE

/obj/item/ammo_casing/magic
	leaves_residue = FALSE

/obj/item/gun/process_fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, message = 1, params, zone_override, bonus_spread = 0)
	if(chambered)
		chambered.leave_residue(user)
	. = ..()
