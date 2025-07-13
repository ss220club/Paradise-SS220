/mob/living/trapped_mind
	name = "Заключённый разум"
	real_name = "Заключённый разум"
	hud_type = /datum/hud/trapped_mind
	see_in_dark = 6


/datum/hud/trapped_mind/New(mob/user)
	..()

	user.overlay_fullscreen("see_through_darkness", /atom/movable/screen/fullscreen/stretch/see_through_darkness)
