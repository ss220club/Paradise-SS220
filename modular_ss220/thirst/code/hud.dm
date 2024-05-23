/datum/hud/human/New(mob/living/carbon/human/owner, ui_style, ui_color, ui_alpha)
	. = ..()
	mymob.hydration_display = new()
	infodisplay += mymob.hydration_display

/atom/movable/screen/hydration
	name = "hydration"
	icon = 'modular_ss220/thirst/icons/screen_alert.dmi'
	icon_state = null
	screen_loc = ui_hydration
