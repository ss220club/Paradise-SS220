/obj/item/areaeditor/permit/wooden_ceiling
	name = "деревянный потолок"
	icon_state = "ceiling"
	icon = 'modular_ss220/lazarus/icons/wooden_ceiling.dmi'
	desc = "С помощью этого предмета возможно построить достаточно прочную крышу."
	fluffnotice = "Этот небольшой набор стройматериалов позволит построить крышу, способную выдержать бурю. Нужно лишь убедиться, что хижина огорожена стенами и имеет дверь."
	w_class = WEIGHT_CLASS_BULKY

/datum/modpack/lazarus/initialize()
	..()

	GLOB.wood_recipes += list(
		null,
		new /datum/stack_recipe("деревянный потолок", /obj/item/areaeditor/permit/wooden_ceiling, 40, 1, 20)
	)
