/datum/cinematic/credits

/datum/cinematic/New(watcher, datum/callback/special_callback)
	. = ..()
	screen = new/obj/screen/cinematic/credits(src)

/datum/cinematic/credits/play_cinematic()
	if(!SScredits.end_titles || SScredits.end_titles.len == 0)
		SScredits.end_titles = SScredits.generate_titles()

	var/list/credits = list()

	play_cinematic_sound(SScredits.title_music)

	play_credits_for_all_watchers(credits)

	stoplag(SScredits.credit_roll_speed)

	QDEL_NULL(credits)

	special_callback?.Invoke()

	stop_cinematic()

/datum/cinematic/credits/proc/play_credits_for_all_watchers(list/credits)
	for(var/client/client in watching)
		play_credits_for_watcher(credits,client)

/datum/cinematic/credits/proc/play_credits_for_watcher(list/credits, client/client)
	for(var/end_title in SScredits.end_titles)
		if(!client)
			return
		var/obj/screen/credit/title = new(null, end_title, client)
		title.rollem()
		credits += title
		stoplag(SScredits.credit_spawn_speed)

	stoplag(SScredits.credit_roll_speed)

/obj/screen/cinematic/credits
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "black"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	plane = 30

/obj/screen/credit
	icon_state = "blank"
	mouse_opacity = 0
	alpha = 0
	screen_loc = "CENTER-7,CENTER-7"
	plane = 21

	var/matrix/target
	var/client/parent

/obj/screen/credit/Initialize(mapload, credited, client/client)
	. = ..()

	parent = client
	maptext = {"<div style="font:'Small Fonts'">[credited]</div>"}
	maptext_height = world.icon_size * 2
	maptext_width = world.icon_size * 14

/obj/screen/credit/proc/rollem()
	var/matrix/M = matrix(transform)
	M.Translate(0, SScredits.credit_animate_height)
	animate(src, transform = M, time = SScredits.credit_roll_speed)
	target = M
	animate(src, alpha = 255, time = SScredits.credit_ease_duration, flags = ANIMATION_PARALLEL)
	spawn(SScredits.credit_roll_speed - SScredits.credit_ease_duration)
		if(!QDELETED(src))
			animate(src, alpha = 0, transform = target, time = SScredits.credit_ease_duration)
			sleep(SScredits.credit_ease_duration)
			qdel(src)
	parent.screen += src

/obj/screen/credit/Destroy()
	if(parent)
		parent.screen -= src
		LAZYREMOVE(parent.credits, src)
		parent = null
	return ..()
