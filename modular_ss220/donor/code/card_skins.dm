/obj/item/card/id/attackby(obj/item/W as obj, mob/user as mob, params)
	. = ..()
	if(istype(W, /obj/item/id_skin/))
		var/obj/item/id_skin/skin = W
		var/mutable_appearance/card_skin = mutable_appearance(skin.icon, skin.icon_state)
		card_skin.color = skin.color
		to_chat(user, "Вы наклеили [skin.pronoun_name] на [src].")
		if(skin.override_name)
			name = skin.name
		desc = initial(desc)
		src.overlays.Cut()
		desc += "<br>[skin.info]"
		add_overlay(card_skin)
		qdel(skin)
		return

/obj/item/id_skin
	name = "\improper наклейка на карту"
	desc = "Этим можно изменить внешний вид своей карты! Покажи службе безопасности какой ты стильный."
	icon = 'modular_ss220/donor/icons/id_skins.dmi'
	icon_state = "skin"
	var/pronoun_name = "наклейку"
	var/info = "На ней наклейка."
	var/override_name = FALSE

/obj/item/id_skin/colored
	name = "\improper голо-наклейка на карту"
	desc = "Голографическая наклейка на карту, вы можете выбрать цвет который она примет. После наклеивания на карту, сменить цвет нельзя!"
	icon_state = "colored"
	pronoun_name = "голо-наклейку"
	info = "На ней голо-наклейка."
	color = null
	var/list/color_list = list("Красный", "Зелёный", "Синий", "Жёлтый", "Оранжевый", "Фиолетовый", "Голубой", "Циановый", "Аквамариновый", "Розовый")

/obj/item/id_skin/colored/attack_self(mob/living/user as mob)
	var/choice = input(user,"Какой цвет предпочитаете?") in list("Выбрать предустановленный", "Выбрать вручную")
	switch(choice)
		if("Выбрать предустановленный")
			choice = input(user,"Выберите цвет") in color_list
			switch(choice)
				if("Красный")
					color = COLOR_RED_LIGHT
				if("Зелёный")
					color = COLOR_GREEN
				if("Синий")
					color = COLOR_CYAN_BLUE
				if("Жёлтый")
					color = COLOR_YELLOW
				if("Оранжевый")
					color = COLOR_SUN
				if("Фиолетовый")
					color = COLOR_VIOLET
				if("Голубой")
					color = COLOR_BABY_BLUE
				if("Циановый")
					color = COLOR_CYAN
				if("Аквамариновый")
					color = COLOR_CRYSTAL
				if("Розовый")
					color = COLOR_PINK
		if("Выбрать вручную")
			color = input(user,"Выберите цвет") as color

/obj/item/id_skin/silver
	name = "\improper серебрянная наклейка на карту"
	icon_state = "silver"
	pronoun_name = "серебрянную наклейку"
	info = "На ней серебрянная наклейка."
