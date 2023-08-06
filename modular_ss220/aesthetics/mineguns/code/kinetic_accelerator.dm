/obj/item/gun/energy/kinetic_accelerator
	icon = 'modular_ss220/aesthetics/mineguns/icons/energy.dmi'
	icon_state = "kineticgun"
	item_state = "kineticgun"
	flight_x_offset = 22
	flight_y_offset = 8
	knife_x_offset = 25
	knife_y_offset = 12

	empty_state = "kineticgun_empty"

/obj/item/gun/energy/kinetic_accelerator/update_overlays()
	. = ..()
	if(empty_state && !can_shoot())
		. += empty_state

	if(gun_light && can_flashlight)
		var/iconF = "icon"
		if(gun_light.on)
			iconF = "flight_on"
		. +=  image(icon = icon, icon_state = iconF, pixel_x = flight_x_offset, pixel_y = flight_y_offset)
	if(bayonet && can_bayonet)
		. += knife_overlay

/obj/item/gun/energy/kinetic_accelerator/experimental
	icon_state = "kineticgun_h"
	item_state = "kineticgun_h"
	lefthand_file = 'modular_ss220/aesthetics/mineguns/icons/inhands/items_lefthand.dmi'
	righthand_file = 'modular_ss220/aesthetics/mineguns/icons/inhands/items_righthand.dmi'
