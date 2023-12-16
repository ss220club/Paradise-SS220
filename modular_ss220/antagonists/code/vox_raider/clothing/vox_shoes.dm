
/obj/item/clothing/shoes/magboots/vox
	desc = "A pair of heavy, jagged armoured foot pieces, seemingly suitable for a velociraptor."
	name = "vox magclaws"
	item_state = "boots-vox"
	icon_state = "boots-vox"
	icon = 'icons/obj/clothing/species/vox/shoes.dmi'
	species_restricted = list("Vox","Vox Armalis")
	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/feet.dmi',
		"Vox Armalis" = 'icons/mob/species/armalis/feet.dmi'
		)

/obj/item/clothing/shoes/magboots/vox/attack_self(mob/user)
	if(magpulse)
		flags &= ~NOSLIP
		magpulse = 0
		flags |= NODROP
		to_chat(user, "You relax your deathgrip on the flooring.")
	else
		//make sure these can only be used when equipped.
		if(!ishuman(user))
			return
		var/mob/living/carbon/human/H = user
		if(H.shoes != src)
			to_chat(user, "You will have to put on the [src] before you can do that.")
			return


		flags |= NOSLIP
		magpulse = 1
		flags &= ~NODROP	//kinda hard to take off magclaws when you are gripping them tightly.
		to_chat(user, "You dig your claws deeply into the flooring, bracing yourself.")
		to_chat(user, "It would be hard to take off the [src] without relaxing your grip first.")

//In case they somehow come off while enabled.
/obj/item/clothing/shoes/magboots/vox/dropped(mob/user as mob)
	..()
	if(src.magpulse)
		user.visible_message("The [src] go limp as they are removed from [usr]'s feet.", "The [src] go limp as they are removed from your feet.")
		flags &= ~NOSLIP
		magpulse = 0
		flags &= ~NODROP

/obj/item/clothing/shoes/magboots/vox/examine(mob/user)
	. = ..()
	if(magpulse)
		. += "<span class='notice'>It would be hard to take these off without relaxing your grip first.</span>"//theoretically this message should only be seen by the wearer when the claws are equipped.
