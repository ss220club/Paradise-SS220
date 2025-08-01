#define CRAYON_MESSAGE_MAX_LENGTH 16
#define CARDBORG_HEAD 1
#define CARDBORG_BODY 2

/*
 * Crayons
 */
/obj/item/toy/crayon
	name = "crayon"
	desc = "Цветной мелок. Выглядит подозрительно вкусно. Мммм..."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BOTH_EARS
	attack_verb = list("attacked", "coloured")
	toolspeed = 1
	var/colour = COLOR_RED
	var/drawtype = "rune"
	var/list/graffiti = list("body","amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa","up","down","left","right","heart","borgsrogue","voxpox","shitcurity","catbeast","hieroglyphs1","hieroglyphs2","hieroglyphs3","security","syndicate1","syndicate2","nanotrasen","lie","valid","arrowleft","arrowright","arrowup","arrowdown","chicken","hailcrab","brokenheart","peace","scribble","scribble2","scribble3","skrek","squish","tunnelsnake","yip","youaredead")
	var/list/letters = list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	/// What color will this crayon dye clothes, cables, etc? used for for updateIcon purposes on other objs
	var/dye_color = DYE_RED
	var/dat
	var/busy = FALSE
	var/list/validSurfaces = list(/turf/simulated/floor)
	/// How many times this crayon has been gnawed on
	var/times_eaten = 0
	/// How many times a crayon can be bitten before being depleted. You eated it
	var/max_bites = 4
	/// The stored message in the crayon.
	var/preset_message
	/// The index of the character in the message that will be drawn next.
	var/preset_message_index = 0
	/// Can this crayon be consumed or not
	var/consumable = TRUE

/obj/item/toy/crayon/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] засовывает [name] в [user.p_their()] нос и в [user.p_their()] мозг. Похоже, [user.p_theyre()] пытается совершить НаноТрейзенНадзор!</span>")
	return BRUTELOSS|OXYLOSS

/obj/item/toy/crayon/Initialize(mapload)
	. = ..()
	drawtype = pick(pick(graffiti), pick(letters), "rune[rand(1, 8)]")

/obj/item/toy/crayon/activate_self(mob/user)
	if(..())
		return
	update_window(user)

/obj/item/toy/crayon/proc/update_window(mob/living/user as mob)
	var/current_drawtype = drawtype
	if(preset_message_index > 0)
		current_drawtype = copytext(preset_message, 1, preset_message_index)
		current_drawtype += "<u>[preset_message[preset_message_index]]</u>"
		current_drawtype += copytext(preset_message, preset_message_index + 1)
		current_drawtype = uppertext(current_drawtype)
	dat += "<center><h2>Текущий выбор: [current_drawtype]</h2><br>"
	dat += "<a href='byond://?src=[UID()];type=random_letter'>Случайная буква</a><a href='byond://?src=[UID()];type=letter'>Выбрать букву</a><br />"
	dat += "<a href='byond://?src=[UID()];type=message'>Сообщение</a>"
	dat += "<hr>"
	dat += "<h3>Руны:</h3><br>"
	dat += "<a href='byond://?src=[UID()];type=random_rune'>Случайная руна</a>"
	for(var/i = 1; i <= 8; i++)
		dat += "<a href='byond://?src=[UID()];type=rune[i]'>Руна [i]</a>"
		if(!((i + 1) % 3)) //3 buttons in a row
			dat += "<br>"
	dat += "<hr>"
	graffiti.Find()
	dat += "<h3>Граффити:</h3><br>"
	dat += "<a href='byond://?src=[UID()];type=random_graffiti'>Случайное граффити</a>"
	var/c = 1
	for(var/T in graffiti)
		dat += "<a href='byond://?src=[UID()];type=[T]'>[T]</a>"
		if(!((c + 1) % 3)) //3 buttons in a row
			dat += "<br>"
		c++
	dat += "<hr>"
	var/datum/browser/popup = new(user, "crayon", name, 300, 500)
	popup.set_content(dat)
	popup.open()
	dat = ""

/obj/item/toy/crayon/Topic(href, href_list, hsrc)
	var/temp = "a"
	preset_message_index = 0
	switch(href_list["type"])
		if("random_letter")
			temp = pick(letters)
		if("letter")
			temp = input("Выберите букву.", "Каракули") in letters
		if("random_rune")
			temp = "rune[rand(1, 8)]"
		if("random_graffiti")
			temp = pick(graffiti)
		if("message")
			var/regex/graffiti_chars = regex("\[^a-zA-Z0-9+\\-!?=%&,.#\\/\]", "g")
			var/new_preset = input(usr, "Укажите сообщение. Максимальная длина [CRAYON_MESSAGE_MAX_LENGTH] символов.")
			new_preset = copytext(new_preset, 1, CRAYON_MESSAGE_MAX_LENGTH)
			preset_message = lowertext(graffiti_chars.Replace(new_preset, ""))
			if(preset_message != "")
				log_admin("[key_name(usr)] has set the message of [src] to \"[preset_message]\".")
				preset_message_index = 1
		else
			temp = href_list["type"]
	if((usr.restrained() || usr.stat || !usr.is_in_active_hand(src)))
		return
	drawtype = temp
	update_window(usr)

/obj/item/toy/crayon/after_attack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return
	if(busy)
		return
	if(is_type_in_list(target,validSurfaces))
		var/temp = "руку"
		if(preset_message_index > 0)
			temp = "букву"
			drawtype = preset_message[preset_message_index]
		else if(letters.Find(drawtype))
			temp = "букву"
		else if(graffiti.Find(drawtype))
			temp = "граффити"
		to_chat(user, "<span class='notice'>Вы начинаете рисовать [temp] на [target.name].</span>")
		busy = TRUE
		if(instant || do_after(user, 50 * toolspeed, target = target))
			var/obj/effect/decal/cleanable/crayon/C = new /obj/effect/decal/cleanable/crayon(target,colour,drawtype,temp)
			C.add_hiddenprint(user)
			to_chat(user, "<span class='notice'>Вы закончили рисовать [temp].</span>")

			if(preset_message_index > 0)
				preset_message_index++
				if(preset_message_index > length(preset_message))
					preset_message_index = 1
				update_window(usr)

			if(uses)
				uses--
				if(!uses)
					to_chat(user, "<span class='danger'>Вы использовали свой [name]!</span>")
					qdel(src)
		busy = FALSE

/obj/item/toy/crayon/attack(mob/living/target, mob/living/carbon/human/user)
	if(..() || !consumable)
		return FINISH_ATTACK
	if(target == user)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(!H.check_has_mouth())
				to_chat(user, "<span class='warning'>У вас нет рта!</span>")
				return
		times_eaten++
		playsound(loc, 'sound/items/eatfood.ogg', 50, 0)
		user.adjust_nutrition(5)
		if(times_eaten < max_bites)
			to_chat(user, "<span class='notice'>Вы откусываете [name]. Вкусно!</span>")
		else
			to_chat(user, "<span class='warning'>Вы полностью сгрызли [name], больше кусать нечего!</span>")
			qdel(src)

/obj/item/toy/crayon/examine(mob/user)
	. = ..()
	if(!user.Adjacent(src) || !times_eaten)
		return
	if(times_eaten == 1)
		. += "<span class='notice'>[src] был надкушен кем-то!</span>"
	else
		. += "<span class='notice'>[src] был надкушен несколько раз!</span>"

/obj/item/toy/crayon/red
	name = "red crayon"
	icon_state = "crayonred"
	colour = COLOR_RED
	dye_color = DYE_RED

/obj/item/toy/crayon/orange
	name = "orange crayon"
	icon_state = "crayonorange"
	colour = COLOR_ORANGE
	dye_color = DYE_ORANGE

/obj/item/toy/crayon/yellow
	name = "yellow crayon"
	icon_state = "crayonyellow"
	colour = COLOR_YELLOW
	dye_color = DYE_YELLOW

/obj/item/toy/crayon/green
	name = "green crayon"
	icon_state = "crayongreen"
	colour = COLOR_GREEN
	dye_color = DYE_GREEN

/obj/item/toy/crayon/blue
	name = "blue crayon"
	icon_state = "crayonblue"
	colour = COLOR_BLUE
	dye_color = DYE_BLUE

/obj/item/toy/crayon/purple
	name = "purple crayon"
	icon_state = "crayonpurple"
	colour = COLOR_PURPLE
	dye_color = DYE_PURPLE

/obj/item/toy/crayon/random/Initialize(mapload)
	. = ..()
	icon_state = pick("crayonred", "crayonorange", "crayonyellow", "crayongreen", "crayonblue", "crayonpurple")
	switch(icon_state)
		if("crayonred")
			name = "red crayon"
			colour = COLOR_RED
			dye_color = DYE_RED
		if("crayonorange")
			name = "orange crayon"
			colour = COLOR_ORANGE
			dye_color = DYE_ORANGE
		if("crayonyellow")
			name = "yellow crayon"
			colour = COLOR_YELLOW
			dye_color = DYE_YELLOW
		if("crayongreen")
			name = "green crayon"
			colour = COLOR_GREEN
			dye_color = DYE_GREEN
		if("crayonblue")
			name = "blue crayon"
			colour = COLOR_BLUE
			dye_color = DYE_BLUE
		if("crayonpurple")
			name = "purple crayon"
			colour = COLOR_PURPLE
			dye_color = DYE_PURPLE

/obj/item/toy/crayon/black
	name = "black crayon"
	icon_state = "crayonblack"
	colour = "#000000"
	dye_color = DYE_BLACK

/obj/item/toy/crayon/white
	name = "white crayon"
	icon_state = "crayonwhite"
	colour = "#FFFFFF"
	dye_color = DYE_WHITE

/obj/item/toy/crayon/white/chalk
	name = "detective's chalk"
	desc = "Кусочек белого мела для разметки места преступления."
	gender = PLURAL
	toolspeed = 0.25

/obj/item/toy/crayon/mime
	name = "mime crayon"
	desc = "Очень грустно выглядящий карандаш."
	icon_state = "crayonmime"
	colour = "#FFFFFF"
	dye_color = DYE_MIME
	uses = 0

/obj/item/toy/crayon/mime/update_window(mob/living/user as mob)
	dat += "<center><span style='border:1px solid #161616; background-color: [colour];'>&nbsp;&nbsp;&nbsp;</span><a href='byond://?src=[UID()];color=1'>Изменить цвет</a></center>"
	..()

/obj/item/toy/crayon/mime/Topic(href,href_list)
	if(!Adjacent(usr) || usr.incapacitated())
		return
	if(href_list["color"])
		if(colour != COLOR_WHITE)
			colour = COLOR_WHITE
		else
			colour = COLOR_BLACK
		update_window(usr)
	else
		..()

/obj/item/toy/crayon/rainbow
	name = "rainbow crayon"
	icon_state = "crayonrainbow"
	colour = "#FFF000"
	dye_color = DYE_RAINBOW
	uses = 0

/obj/item/toy/crayon/rainbow/update_window(mob/living/user as mob)
	dat += "<center><span style='border:1px solid #161616; background-color: [colour];'>&nbsp;&nbsp;&nbsp;</span><a href='byond://?src=[UID()];color=1'>Изменить цвет</a></center>"
	..()

/obj/item/toy/crayon/rainbow/Topic(href,href_list[])
	if(!Adjacent(usr) || usr.incapacitated())
		return
	if(href_list["color"])
		var/temp = tgui_input_color(usr, "Пожалуйста, выберите цвет мелка.", "Цвет мелка")
		if(isnull(temp))
			return
		colour = temp
		update_window(usr)
	else
		..()


//Spraycan stuff

/obj/item/toy/crayon/spraycan
	name = "\improper Nanotrasen-brand Rapid Paint Applicator"
	desc = "Металлический контейнер с краской-спреем."
	icon_state = "spraycan_cap"
	slot_flags = ITEM_SLOT_BELT
	var/capped = TRUE
	instant = TRUE
	validSurfaces = list(/turf/simulated/floor,/turf/simulated/wall)
	dye_color = null // not technically a crayon, so we're not gonna have it dye stuff in the laundry machine
	consumable = FALSE // To stop you from eating spraycans. It's TOO SILLY!

/obj/item/toy/crayon/spraycan/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ACTIVATE_SELF, TYPE_PROC_REF(/datum, signal_cancel_activate_self))
	update_icon()

/obj/item/toy/crayon/spraycan/activate_self(mob/user)
	if(..())
		return
	var/choice = tgui_input_list(user, "Вы хотите...", "Spraycan Options", list("Проверить колпачок","Изменить рисунок", "Изменить цвет"))
	switch(choice)
		if("Проверить колпачок")
			to_chat(user, "<span class='notice'>Вы [capped ? "открыли" : "закрыли"] крышку [src].</span>")
			capped = !capped
			update_icon()
		if("Изменить рисунок")
			update_window(user)
		if("Изменить цвет")
			colour = tgui_input_color(user,"Пожалуйста, выберите цвет краски.","Цвет краски")
			if(isnull(colour))
				return
			update_icon()

/obj/item/toy/crayon/spraycan/after_attack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return
	if(capped)
		to_chat(user, "<span class='warning'>Вы не можете нарисовать [target] пока колпачок закрыт!</span>")
		return
	if(istype(target, /obj/item/clothing/head/cardborg) || istype(target, /obj/item/clothing/suit/cardborg))	// Spraypainting your cardborg suit for more fashion options.
		cardborg_recolor(target, user)
		return
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/attackee = target
	if(uses < 10)
		to_chat(user, "<span class='warning'>Осталось недостаточно краски, чтобы оказать какой-либо реальный эффект!</span>")
		return
	uses -= 10
	user.visible_message("<span class='danger'>[user] распыляет [src] прямо в лицо [target]!</span>")
	if(!attackee.is_eyes_covered()) // eyes aren't covered? ARGH IT BURNS.
		attackee.Confused(6 SECONDS)
		attackee.KnockDown(6 SECONDS)
	attackee.EyeBlurry(6 SECONDS)
	attackee.EyeBlind(2 SECONDS)

	attackee.lip_style = "spray_face"
	attackee.lip_color = colour
	attackee.update_body()

	play_spray_sound(user)

/obj/item/toy/crayon/spraycan/proc/play_spray_sound(mob/user)
	playsound(user, 'sound/effects/spray.ogg', 5, TRUE, 5)

/obj/item/toy/crayon/spraycan/update_icon_state()
	icon_state = "spraycan[capped ? "_cap" : ""]"

/obj/item/toy/crayon/spraycan/update_overlays()
	. = ..()
	var/image/I = image('icons/obj/crayons.dmi',icon_state = "[capped ? "spraycan_cap_colors" : "spraycan_colors"]")
	I.color = colour
	. += I

/obj/item/toy/crayon/spraycan/proc/cardborg_recolor(obj/target, mob/user)
	var/is_cardborg_head = CARDBORG_BODY
	if(istype(target, /obj/item/clothing/head/cardborg))    // Differentiating between head and body.
		is_cardborg_head = CARDBORG_HEAD
	var/selected_disguise
	var/static/list/disguise_options = list(
		"Standard" = image('icons/mob/robots.dmi', "Standard"),
		"Security" = image('icons/mob/robots.dmi', "security-radial"),
		"Engineering" = image('icons/mob/robots.dmi', "engi-radial"),
		"Mining" = image('icons/mob/robots.dmi', "mining-radial"),
		"Service" = image('icons/mob/robots.dmi', "serv-radial"),
		"Medical" = image('icons/mob/robots.dmi', "med-radial"),
		"Janitor" = image('icons/mob/robots.dmi', "jan-radial"),
		"Hunter" = image('icons/mob/robots.dmi', "xeno-radial"),
		"Death Bot" = image('icons/mob/robots.dmi', "spidersyndi-preview")
		)
	selected_disguise = show_radial_menu(user, target, disguise_options, require_near = TRUE, radius = 42)

	if(!selected_disguise)
		return
	var/static/list/disguise_spraypaint_items = list(
		"Standard" = list(/obj/item/clothing/head/cardborg, /obj/item/clothing/suit/cardborg),
		"Security" = list(/obj/item/clothing/head/cardborg/security, /obj/item/clothing/suit/cardborg/security),
		"Engineering" = list(/obj/item/clothing/head/cardborg/engineering, /obj/item/clothing/suit/cardborg/engineering),
		"Mining" = list(/obj/item/clothing/head/cardborg/mining, /obj/item/clothing/suit/cardborg/mining),
		"Service" = list(/obj/item/clothing/head/cardborg/service, /obj/item/clothing/suit/cardborg/service),
		"Medical" = list(/obj/item/clothing/head/cardborg/medical, /obj/item/clothing/suit/cardborg/medical),
		"Janitor" = list(/obj/item/clothing/head/cardborg/janitor, /obj/item/clothing/suit/cardborg/janitor),
		"Hunter" = list(/obj/item/clothing/head/cardborg/xeno, /obj/item/clothing/suit/cardborg/xeno),
		"Death Bot" = list(/obj/item/clothing/head/cardborg/deathbot, /obj/item/clothing/suit/cardborg/deathbot)
	)
	selected_disguise = disguise_spraypaint_items[selected_disguise][is_cardborg_head]
	playsound(user, 'sound/effects/spray.ogg', 5, TRUE, 5)
	user.unequip(target)
	user.put_in_hands(new selected_disguise())	// Spawn the desired cardborg item.
	qdel(target)								// Get rid of the old one.

#undef CRAYON_MESSAGE_MAX_LENGTH
#undef CARDBORG_HEAD
#undef CARDBORG_BODY
