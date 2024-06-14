/datum/modpack/devices
	name = "Kvass drinks"
	desc = "Добавляет в игру 2 вида кваса и рецепт для их приготовления"
	author = "ThaumicNik"

/datum/reagent/consumable/ethanol/kvass
	name = "Alcoholic Kvass"
	id = "alco_kvass"
	description = "Алкогольный напиток, полученный путём ферментации хлеба"
	color = "#775a1c"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	alcohol_perc = 0.3
	drink_icon = "alco_kvass"
	drinking_glass_icon = 'modular_ss220/kvass/kvass.dmi'
	drink_name = "Стакан алкогольного кваса"
	drink_desc = "Освежающий горьковато-сладкий напиток прямиком из СССП"
	taste_description = "квас"

/datum/reagent/consumable/drink/kvass
	name = "Kvass"
	id = "kvass"
	description = "Квас без алкоголя. Что отличает его от обычной газировки?"
	color = "#574113"
	adj_sleepy = -4 SECONDS
	drink_icon = "kvass"
	drinking_glass_icon = 'modular_ss220/kvass/kvass.dmi'
	drink_name = "Стакан безалкогольного кваса"
	drink_desc = "Квас без алкоголя. Освежает, но по вкусу как-то... блекло?"
	harmless = FALSE
	taste_description = "скучный квас"

/datum/chemical_reaction/kvass
	name = "Kvass"
	id = "kvass"
	result = "kvass"
	required_reagents = list("alco_kvass" = 5, "antihol" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

// fermenting_barrel don't have behavior for non-plant food, so we need some proc for bread
/obj/structure/fermenting_barrel/proc/make_drink(var/obj/item/I, var/drink_id, var/amount)
	reagents.add_reagent(drink_id, amount)
	qdel(I)
	playsound(src, 'sound/effects/bubbles.ogg', 50, TRUE)

/obj/structure/fermenting_barrel/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/food/snacks/sliceable/bread))
		if(!user.drop_item())
			to_chat(user, "<span class='warning'>[I] is stuck to your hand!</span>")
			return FALSE
		I.forceMove(src)
		to_chat(user, "<span class='notice'>You place [I] into [src] to start the fermentation process.</span>")
		addtimer(CALLBACK(src, PROC_REF(make_drink), I, "alco_kvass", 35), rand(80, 120) * speed_multiplier)
		return
	return ..()

/obj/machinery/chem_dispenser/soda/Initialize(mapload)
	dispensable_reagents += "kvass"
	return ..()

/obj/item/handheld_chem_dispenser/soda/Initialize(mapload)
	dispensable_reagents += "kvass"
	return ..()
