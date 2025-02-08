// translate
/obj/item/t_scanner
	name = "T-ray сканнер"
	desc = "Излучатель и сканер терагерцового излучения, используемый для обнаружения скрытых объектов под полом, таких как кабели и трубы."

// debug
/obj/item/t_scanner/mod
	name = "Модификация T-ray сканнера"
	desc = "Предмодифицированный сканнер, который не должен был попасть в ваши руки. Отнесите его в ближайший научный отдел \
	\nдля изучения кодерами."
	icon = 'modular_ss220/devices/icons/device.dmi'
	icon_state = "t-ray0"
	origin_tech = "magnets=3;engineering=3"
	var/scan_range = 3
	var/pulse_duration = 8

/obj/item/t_scanner/mod/scan()
	t_ray_scan(loc, pulse_duration, scan_range)

// new scanners
/obj/item/t_scanner/mod/extended_range
	name = "Расширенный T-ray сканнер"
	desc = "Расширенный T-ray сканнер с увеличенной дальностью и стандартной продолжительностью отображения скрытых инженерных коммуникаций."
	icon_state = "t-ray-range0"
	scan_range = 5
	origin_tech = "magnets=3;engineering=3"

/obj/item/t_scanner/mod/pulse
	name = "Пульсовой T-ray сканнер"
	desc = "Пульсовый T-ray сканнер с увеличенной длительностью и стандартной дальностью отображения скрытых инженерных коммуникаций."
	icon_state = "t-ray-pulse0"
	pulse_duration = 2 SECONDS
	origin_tech = "magnets=5;engineering=3"

/obj/item/t_scanner/mod/advanced
	name = "Продвинутый T-ray сканнер"
	desc = "Продвинутый T-ray сканнер с увеличенной длительностью и дальностью отображения скрытых инженерных коммуникаций."
	icon_state = "t-ray-advanced0"
	pulse_duration = 2 SECONDS
	scan_range = 5
	origin_tech = "magnets=7;engineering=3"

/obj/item/t_scanner/mod/science
	name = "Научный T-ray сканнер"
	desc = "Научный T-ray сканнер, дальнейшее развитие улучшенного T-ray сканнера."
	icon_state = "t-ray-science0"
	scan_range = 7
	pulse_duration = 5 SECONDS
	origin_tech = "magnets=8;engineering=5"
	materials = list(MAT_METAL=500)

/obj/item/t_scanner/mod/security
	name = "Специализированный T-ray сканнер"
	desc = "Специальный вариант T-ray сканнера, используемый для обнаружения биологических объектов. Устройство уязвимо для ЭМИ излучения."
	icon = 'modular_ss220/devices/icons/device.dmi'
	lefthand_file = 'modular_ss220/devices/icons/inhands/items_lefthand.dmi'
	righthand_file = 'modular_ss220/devices/icons/inhands/items_righthand.dmi'
	item_state = "sb_t-ray"
	icon_state = "sb_t-ray0"
	scan_range = 4
	pulse_duration = 15
	var/was_alerted = FALSE // Protection against spam alerts from this scanner
	var/burnt = FALSE // Did emp break us?
	var/datum/effect_system/spark_spread/spark_system	//The spark system, used for generating... sparks?
	origin_tech = "combat=3;magnets=5;biotech=5"

/obj/item/t_scanner/mod/security/Initialize(mapload)
	. = ..()
	//Sets up a spark system
	spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/t_scanner/mod/security/toggle_on()
	if(!burnt)
		on = !on
		icon_state = copytext(icon_state, 1, length(icon_state))+"[on]"
	if(on)
		START_PROCESSING(SSobj, src)

/obj/item/t_scanner/mod/security/emp_act(severity)
	. = ..()
	if(prob(25) && !burnt)
		burnt = TRUE
		on = FALSE;
