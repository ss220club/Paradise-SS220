// Скучный квас
/obj/structure/reagent_dispensers/kvassbarrel
	name = "Бочка кваса"
	desc = "Бочка кваса. Такие в СССП можно встретить повсюду жарким летом."
	icon = 'modular_ss220/objects/icons/kvassbarrel.dmi'
	icon_state = "kvassbarrel"
	reagent_id = "kvass"
	tank_volume = 1000
	anchored = FALSE
	face_while_pulling = FALSE

/datum/supply_packs/organic/kvassbarrel
	name = "Бочка безалкогольного кваса"
	contains = list(/obj/structure/reagent_dispensers/kvassbarrel)
	cost = 250
	containertype = /obj/structure/largecrate
	containername = "бочка безалкогольного кваса"

// Алкогольный квас
/obj/structure/reagent_dispensers/alcokvassbarrel
	name = "Бочка кваса"
	desc = "Бочка кваса. Такие в СССП можно встретить повсюду жарким летом."
	icon = 'modular_ss220/objects/icons/kvassbarrel.dmi'
	icon_state = "kvassbarrel"
	reagent_id = "alco_kvass"
	tank_volume = 1000
	anchored = FALSE
	face_while_pulling = FALSE

/obj/structure/reagent_dispensers/alcokvassbarrel/examine(mob/user)
	. = ..()
	if(user.Adjacent(src))
		. += "<span class='notice'>В этой, кажется, алкогольный...</span>" // Опознать бочку алкогольного кваса можно при ближнем осмотре

/datum/supply_packs/organic/alcokvassbarrel
	name = "Бочка алкогольного кваса"
	contains = list(/obj/structure/reagent_dispensers/alcokvassbarrel)
	cost = 500
	containertype = /obj/structure/largecrate
	containername = "бочка алкогольного кваса"
	contraband = TRUE // Для заказа требуется взлом консоли
