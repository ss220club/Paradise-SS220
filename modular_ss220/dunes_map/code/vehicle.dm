/obj/vehicle/motorcycle/desert
	name = "пустынный байк"
	desc = "Быстрый и высокоманевренный транспорт для передвижения по пустыне."
	vehicle_move_delay = 0.2
	icon = 'modular_ss220/dunes_map/icons/vehicle.dmi'
	icon_state = "desertbike_4dir"
	auto_door_open = FALSE
	max_integrity = 200
	var/stepsound = 'sound/weapons/chainsawstart.ogg'


/obj/vehicle/motorcycle/desert/Initialize(mapload)
	. = ..()
	bikecover = mutable_appearance(icon, "desertbike_4dir_overlay", ABOVE_MOB_LAYER)
