/datum/hud
	var/obj/screen/ammo_counter

/datum/hud/human/New(mob/living/carbon/human/owner, ui_style, ui_color, ui_alpha)
	. = ..()
	ammo_counter = new /obj/screen/ammo_counter()
	ammo_counter.hud = src
	infodisplay += ammo_counter
