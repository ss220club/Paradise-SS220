/datum/hud/simple_animal/changeling_primalis/New(mob/user)
	..()
	lingchemdisplay = new /atom/movable/screen/ling/chems()
	lingchemdisplay.invisibility = 0
	infodisplay += lingchemdisplay
