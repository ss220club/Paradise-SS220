/mob/living/silicon/robot/update_icons()
	. = ..()
	hat_icons()

/mob/living/silicon/robot/drone/update_icons()
	. = ..()
	hat_icons()

/mob/living/silicon/death(gibbed)
	if(gibbed)
		drop_hat()
	. = ..()

/mob/living/silicon/robot/deconstruct()
	drop_hat()
	. = ..()

/mob/living/silicon/robot/get_module_sprites(selected_module)
	. = ..()
	robot_module_hat_offset(icon_state)

/mob/living/silicon/grabbedby(mob/living/user)
	remove_from_head(user)

//Если вдруг кто-то захочет сразу спавнить боргов с шапками
/mob/living/silicon/New()
	..()
	regenerate_icons()

//Для уже готовых спавнов боевых боргов
/mob/living/silicon/robot/New()
	..()
	robot_module_hat_offset(icon_state)

/mob/living/silicon/robot/initialize_module(selected_module, selected_sprite, list/module_sprites)
	..()
	robot_module_hat_offset(icon_state)

/datum/emote/flip/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(isrobot(user))
		var/mob/living/silicon/robot/borg = user
		message = "кувырком опрокинул шляпу!"
		borg.drop_hat()

/mob/living/silicon/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/clothing/head) && user.a_intent == INTENT_HELP)
		place_on_head(user.get_active_hand(), user)
		return
	. = ..()

/mob/living/silicon/Topic(href, href_list)
	if(..())
		return 1

	if(!(iscarbon(usr) || usr.incapacitated() || !Adjacent(usr)))
		usr << browse(null, "window=mob[UID()]")
		usr.unset_machine()
		return

	if (!can_be_hatted)
		return 0

	if(href_list["remove_inv"])
		var/remove_from = href_list["remove_inv"]
		switch(remove_from)
			if("head")
				remove_from_head(usr)
		show_inv(usr)

	else if(href_list["add_inv"])
		var/add_to = href_list["add_inv"]
		switch(add_to)
			if("head")
				place_on_head(usr.get_active_hand(), usr)
		show_inv(usr)

	if(usr != src)
		return 1

/mob/living/silicon/show_inv(mob/user)
	if(user.incapacitated() || !Adjacent(user))
		return
	user.set_machine(src)

	var/dat = {"<meta charset="UTF-8"><div align='center'><b>Inventory of [name]</b></div><p>"}
	dat += "<br><B>Head:</B> <A href='?src=[UID()];[inventory_head ? "remove_inv=head'>[inventory_head]" : "add_inv=head'>Nothing"]</A>"

	var/datum/browser/popup = new(user, "mob\ref[src]", "[src]", 440, 500)
	popup.set_content(dat)
	popup.open()
