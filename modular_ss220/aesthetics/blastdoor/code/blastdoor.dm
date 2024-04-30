/obj/machinery/door/poddoor
	icon = 'modular_ss220/aesthetics/blastdoor/icons/blastdoor.dmi'

/obj/machinery/door/poddoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("opening", src)
			playsound(src, 'modular_ss220/aesthetics/blastdoor/sound/blastdoor.ogg', 30, 1)
		if("closing")
			flick("closing", src)
			playsound(src, 'modular_ss220/aesthetics/blastdoor/sound/blastdoor.ogg', 30, 1)

/obj/machinery/door/poddoor/desert
	icon_state = "closed_d"
	name = "массивная дверь из песчанника"
	desc = "Тяжелая дверь из двух песчанниковых монолитов. Переплетения древних механизмов надежно сокрыты, единственный вариант открыть её - найти рычаг или кнопку. "

/obj/machinery/door/poddoor/desert/do_animate(animation)
	switch(animation)
		if("opening")
			flick("opening_d", src)
			playsound(src, 'sound/machines/blastdoor.ogg', 30, 1)
		if("closing")
			flick("closing_d", src)
			playsound(src, 'sound/machines/blastdoor.ogg', 30, 1)

/obj/machinery/door/poddoor/desert/update_icon_state()
	if(density)
		icon_state = "closed_d"
	else
		icon_state = "open_d"
/obj/machinery/door/poddoor/desert/preopen
	icon_state = "open_d"
	density = FALSE
	opacity = FALSE

