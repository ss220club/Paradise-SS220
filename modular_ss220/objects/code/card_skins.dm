/obj/item/card/id
	var/skinable = TRUE
	var/obj/item/id_skin/skin_applied = null

/obj/item/card/id/guest
	skinable = FALSE

/obj/item/card/id/data
	skinable = FALSE

/obj/item/card/id/away
	skinable = FALSE

/obj/item/card/id/thunderdome
	skinable = FALSE

/obj/item/card/id/attackby(obj/item/item as obj, mob/user as mob, params)
	. = ..()
	if(istype(item, /obj/item/id_skin))
		if(skin_applied)
			to_chat(usr, span_warning("На карте уже есть наклейка, сначала соскребите её!"))
			return
		if(!skinable)
			to_chat(usr, span_warning("Наклейка не подходит для [src]!"))
			return
		to_chat(user, span_notice("Вы начинаете наносить наклейку на карту."))
		if(do_after(usr, 2 SECONDS, target = src, progress = TRUE, allow_moving = TRUE))
			var/obj/item/id_skin/skin = item
			var/mutable_appearance/card_skin = mutable_appearance(skin.icon, skin.icon_state)
			card_skin.color = skin.color
			to_chat(user, span_notice("Вы наклеили [skin.pronoun_name] на [src]."))
			desc += "<br>[skin.info]"
			skin_applied = item
			user.drop_item()
			item.forceMove(src)
			skin_applied = item
			add_overlay(card_skin)
			return

/obj/item/card/id/AltClick(mob/user)
	remove_skin()

/obj/item/card/id/verb/remove_skin()
	set name = "Соскрести наклейку"
	set category = "Object"
	set src in range(0)

	if(usr.stat || HAS_TRAIT(usr, TRAIT_UI_BLOCKED) || usr.restrained())
		return

	if(skin_applied != null)
		if(usr.a_intent == INTENT_HARM)
			to_chat(usr, span_warning("Вы срываете наклейку с карты!"))
			src.overlays.Cut()
			playsound(src.loc, 'sound/items/poster_ripped.ogg', 50, 1)
			skin_applied = null
			desc = initial(desc)
		else if(usr.a_intent == INTENT_HELP)
			to_chat(usr, span_notice("Вы начинаете аккуратно снимать наклейку с карты."))
			if(do_after(usr, 5 SECONDS, target = src, progress = TRUE))
				to_chat(usr, span_notice("Вы сняли наклейку с карты."))
				skin_applied.forceMove(get_turf(src))
				if(!usr.get_active_hand() && Adjacent(usr))
					usr.put_in_hands(skin_applied)
				skin_applied = null
				desc = initial(desc)
				src.overlays.Cut()
	else
		to_chat(usr, span_warning("На карте нет наклейки!"))

/obj/item/id_skin
	name = "\improper наклейка на карту"
	desc = "Этим можно изменить внешний вид своей карты! Покажи службе безопасности какой ты стильный."
	icon = 'modular_ss220/objects/icons/id_skins.dmi'
	icon_state = ""
	var/pronoun_name = "наклейку"
	var/info = "На ней наклейка."
	var/list/color_list = list("Красный", "Зелёный", "Синий", "Жёлтый", "Оранжевый", "Фиолетовый", "Голубой", "Циановый", "Аквамариновый", "Розовый")

/obj/item/id_skin/proc/change_color()
	var/choice = input(usr, "Какой цвет предпочитаете?", "Выбор цвета") as null|anything in list("Выбрать предустановленный", "Выбрать вручную")
	if(!choice)
		return
	switch(choice)
		if("Выбрать предустановленный")
			choice = input(usr, "Выберите цвет", "Выбор цвета") as null|anything in color_list
			if(!choice)
				return
			switch(choice)
				if("Красный")
					color = LIGHT_COLOR_RED
				if("Зелёный")
					color = LIGHT_COLOR_GREEN
				if("Синий")
					color = LIGHT_COLOR_LIGHTBLUE
				if("Жёлтый")
					color = LIGHT_COLOR_HOLY_MAGIC
				if("Оранжевый")
					color = LIGHT_COLOR_ORANGE
				if("Фиолетовый")
					color = LIGHT_COLOR_LAVENDER
				if("Голубой")
					color = LIGHT_COLOR_LIGHT_CYAN
				if("Циановый")
					color = LIGHT_COLOR_CYAN
				if("Аквамариновый")
					color = LIGHT_COLOR_BLUEGREEN
				if("Розовый")
					color = LIGHT_COLOR_PINK
		if("Выбрать вручную")
			color = input(usr,"Выберите цвет") as color

/obj/item/id_skin/colored
	name = "\improper голо-наклейка на карту"
	desc = "Голографическая наклейка на карту. Вы можете выбрать цвет который она примет."
	icon_state = "colored"
	pronoun_name = "голо-наклейку"
	info = "На ней голо-наклейка."

/obj/item/id_skin/colored/attack_self(mob/living as mob)
	change_color()

/obj/item/id_skin/prisoner
	name = "\improper тюремная наклейка на карту"
	icon_state = "prisoner"
	pronoun_name = "тюремную наклейку"
	info = "На ней тюремная наклейка."

/obj/item/id_skin/silver
	name = "\improper серебрянная наклейка на карту"
	icon_state = "silver"
	pronoun_name = "серебрянную наклейку"
	info = "На ней серебрянная наклейка."

/obj/item/id_skin/silver/colored
	name = "\improper металлическая голо-наклейка"
	desc = "Голографическая наклейка на карту, изготовленная из специального материала, похожего на металл. Вы можете выбрать цвет который она примет."
	pronoun_name = "металлическую голо-наклейку"
	icon_state = "colored_shiny"
	info = "На ней металлическая голо-наклейка."

/obj/item/id_skin/silver/colored/attack_self(mob/living as mob)
	change_color()

/obj/item/id_skin/gold
	name = "\improper золотая наклейка на карту"
	icon_state = "gold"
	pronoun_name = "золотую наклейку"
	info = "На ней золотая наклейка."

/obj/item/id_skin/business
	name = "\improper бизнесменская наклейка на карту"
	icon_state = "business"
	pronoun_name = "бизнесменскую наклейку"
	info = "На ней бизнесменская наклейка."

/obj/item/id_skin/lifetime
	name = "\improper стильная наклейка на карту"
	icon_state = "lifetime"
	pronoun_name = "стильную наклейку"
	info = "На ней стильная наклейка."

/obj/item/id_skin/ussp
	name = "\improper коммунистическая наклейка на карту"
	icon_state = "ussp"
	pronoun_name = "коммунистическую наклейку"
	info = "На ней коммунистическая наклейка."

/obj/item/id_skin/clown
	name = "\improper клоунская наклейка на карту"
	icon_state = "clown"
	pronoun_name = "клоунскую наклейку"
	info = "На ней клоунская наклейка. HONK!"

/obj/item/id_skin/rainbow
	name = "\improper радужная наклейка на карту"
	icon_state = "rainbow"
	pronoun_name = "радужную наклейку"
	info = "На ней радужная наклейка. Одобряемо."

/obj/item/id_skin/space
	name = "\improper КОСМИЧЕСКАЯ наклейка на карту"
	desc = "Яркая, блестящая и бескрайняя. Прямо как хозяин карты на которую её приклеят."
	icon_state = "space"
	pronoun_name = "КОСМИЧЕСКУЮ наклейку"
	info = "Есть 3 вещи на которые можно смотреть вечно. Это четвёртая."

/obj/item/id_skin/kitty
	name = "\improper кото-клейка на карту"
	desc = "Прекрасная наклейка, которая делает вашу карту похожей на котика."
	icon_state = "kitty"
	pronoun_name = "кото-клейку"
	info = "Так и хочется погладить, жаль это всего-лишь наклейка..."

/obj/item/id_skin/kitty/colored
	name = "\improper цветная кото-клейка на карту"
	desc = "Прекрасная наклейка, которая делает вашу карту похожей на котика. Эта может менять цвет."
	icon_state = "colored_kitty"
	pronoun_name = "кото-клейку"
	info = "Так и хочется погладить, жаль это всего-лишь наклейка..."

/obj/item/id_skin/kitty/colored/attack_self(mob/living as mob)
	change_color()

/obj/item/id_skin/neon
	name = "\improper неоновая наклейка на карту"
	desc = "Неоновая наклейка в цианово-розовых цветах."
	icon_state = "neon"
	pronoun_name = "неоновую наклейку"
	info = "Кажется будто она светится."

/obj/item/id_skin/neon/colored
	name = "\improper цветная неоновая наклейка на карту"
	desc = "Какая же она яркая... Ещё и цвета меняет!"
	icon_state = "colored_neon"
	pronoun_name = "неоновую наклейку"
	info = "Кажется будто она светится."

/obj/item/id_skin/neon/colored/attack_self(mob/living as mob)
	change_color()
