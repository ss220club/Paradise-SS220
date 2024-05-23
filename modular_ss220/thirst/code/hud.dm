/datum/hud/human/New(mob/living/carbon/human/owner, ui_style, ui_color, ui_alpha)
	. = ..()
	mymob.hydration_display = new()
	infodisplay += mymob.hydration_display

/atom/movable/screen/hydration
	name = "hydration"
	icon = 'icons/mob/screen_hunger.dmi'
	icon_state = null
	screen_loc = ui_nutrition
