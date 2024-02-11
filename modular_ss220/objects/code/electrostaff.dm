/obj/item/melee/electrostaff
	name = "электропосох"
	desc = "Шоковая палка, только более мощная, двуручная и доступная наиболее авторитетным членам силовых структур Nanotrasen. А еще у неё нет тупого конца."
	lefthand_file = 'modular_ss220/objects/icons/inhands/melee_lefthand.dmi'
	righthand_file = 'modular_ss220/objects/icons/inhands/melee_righthand.dmi'
	icon = 'modular_ss220/objects/icons/melee.dmi'
	belt_icon = "stunbaton"
	var/base_icon = "electrostaff"
	icon_state = "electrostaff_orange"
	slot_flags = SLOT_FLAG_BELT
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	throwforce = 7
	origin_tech = "combat=5"
	attack_verb = list("attacked", "beaten")
	/// What sound plays when its opening
	var/sound_on = 'modular_ss220/objects/sound/weapons/melee/electrostaff/on.ogg'
	/// What sound plays when its hiting and turned on
	var/hitsound_on = 'modular_ss220/objects/sound/weapons/melee/electrostaff/hit.ogg'
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 50, RAD = 0, FIRE = 80, ACID = 80)
	/// How many seconds does the knockdown last for?
	var/knockdown_duration = 15 SECONDS
	/// how much stamina damage does this baton do?
	var/stam_damage = 80
	var/burn_damage = 5

	/// Is the baton currently turned on
	var/turned_on = FALSE
	/// How much power does it cost to stun someone
	var/hitcost = 1600 // 6 hits to 0 power
	var/obj/item/stock_parts/cell/high/cell = null
	/// the initial cooldown tracks the time between swings. tracks the world.time when the baton is usable again.
	var/cooldown = 3.5 SECONDS
	/// the time it takes before the target falls over
	var/knockdown_delay = 2.5 SECONDS

	/// allows one-time reskinning
	var/unique_reskin = TRUE
	/// the skin choice
	var/current_skin = null
	var/list/options = list()

/obj/item/melee/electrostaff/Initialize(mapload)
	. = ..()
	current_skin = "_orange"
	AddComponent(/datum/component/two_handed, force_unwielded = force, force_wielded = force, wield_callback = CALLBACK(src, PROC_REF(on_wield)), unwield_callback = CALLBACK(src, PROC_REF(on_unwield)))
	options["Оранжевое свечение"] = "_orange"
	options["Красное свечение"] = "_red"
	options["Фиолетовое свечение"] = "_purple"
	options["Синее свечение"] = "_blue"

/obj/item/melee/electrostaff/loaded/Initialize(mapload) //this one starts with a cell pre-installed.
	link_new_cell()
	return ..()

/obj/item/melee/electrostaff/Destroy()
	if(cell?.loc == src)
		QDEL_NULL(cell)
	return ..()

/obj/item/melee/electrostaff/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is putting the live [name] in [user.p_their()] mouth! It looks like [user.p_theyre()] trying to commit suicide.</span>")
	return FIRELOSS

/obj/item/melee/electrostaff/update_icon_state()
	if(HAS_TRAIT(src, TRAIT_WIELDED))
		if(cell?.charge >= hitcost)
			icon_state = "[base_icon][current_skin]_active"
		else
			if(cell != null)
				icon_state = "[base_icon][current_skin]1"
			else
				icon_state = "[base_icon][current_skin]_nocell1"
	else
		if(cell != null)
			icon_state = "[base_icon][current_skin]"
		else
			icon_state = "[base_icon][current_skin]_nocell"
	return ..()

/obj/item/melee/electrostaff/proc/link_new_cell(unlink = FALSE)
	if(unlink)
		cell = null
	else
		cell = new(src)

/obj/item/melee/electrostaff/examine(mob/user)
	. = ..()
	if(unique_reskin)
		. += "<span class='notice'>Alt-клик, чтобы изменить скин предмета.</span>"
	if(cell)
		. += "<span class='notice'>Электропосох заряжен на [round(cell.percent())]%.</span>"
	else
		. += "<span class='warning'>В электропосохе отсутствует источник питания.</span>"
	. += "<span class='notice'>При включении этот предмет обожжет и отправит в отключку любого по кому попадет, после небольшой задержки. При использовании с намерением причинить вред он также травмирует, даже будучи выключенным.</span>"
	. += "<span class='notice'>Этот предмет не имеет внешних разьемов для подзарядки. Используйте <b>отвертку</b>, чтобы получить доступ к внутренней батарее для ее замены или зарядки.</span>"

/obj/item/melee/electrostaff/get_cell()
	return cell

/obj/item/melee/electrostaff/proc/deductcharge(amount)
	if(!cell)
		return
	cell.use(amount)
	if(cell.rigged)
		cell = null
		turned_on = FALSE
		update_icon()
	if(cell.charge < (hitcost)) // If after the deduction the baton doesn't have enough charge for a stun hit it turns off.
		turned_on = FALSE
		update_icon()
		playsound(src, "sparks", 75, TRUE, -1)

/obj/item/melee/electrostaff/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stock_parts/cell))
		var/obj/item/stock_parts/cell/C = I
		if(cell)
			to_chat(user, "<span class='warning'>[src] уже имеет батарею!</span>")
			return
		if(C.maxcharge < hitcost)
			to_chat(user, "<span class='warning'>[src] требует батарею высокого более высокого обьема!</span>")
			return
		if(!user.unEquip(I))
			return
		I.forceMove(src)
		cell = I
		to_chat(user, "<span class='notice'>Вы установили [I] в [src].</span>")

/obj/item/melee/electrostaff/screwdriver_act(mob/living/user, obj/item/I)
	if(!cell)
		to_chat(user, "<span class='warning'>Установленные батареи отсутствуют!</span>")
		return
	if(!I.use_tool(src, user, volume = I.tool_volume))
		return
	user.put_in_hands(cell)
	to_chat(user, "<span class='notice'>Вы достали [cell] из [src].</span>")
	cell.update_icon()
	cell = null
	turned_on = FALSE
	update_icon(UPDATE_ICON_STATE)

/obj/item/melee/electrostaff/proc/on_wield(obj/item/source, mob/living/carbon/user)
	if(cell?.charge >= hitcost)
		turned_on = TRUE
		to_chat(user, "<span class='notice'>[src] включен.</span>")
		playsound(src, sound_on, 75, TRUE, -1)
	else
		if(!cell)
			to_chat(user, "<span class='warning'>[src] не имеет источника питания!</span>")
		else
			to_chat(user, "<span class='warning'>[src] разряжен.</span>")
	update_icon()
	add_fingerprint(user)

/obj/item/melee/electrostaff/proc/on_unwield(obj/item/source, mob/living/carbon/user)
	turned_on = FALSE
	if(cell?.charge >= hitcost)
		to_chat(user, "<span class='notice'>[src] выключен.</span>")
		playsound(src, "sparks", 75, TRUE, -1)
	else
		if(!cell)
			to_chat(user, "<span class='warning'>[src] не имеет источника питания!</span>")
		else
			to_chat(user, "<span class='warning'>[src] разряжен.</span>")
	update_icon()
	add_fingerprint(user)

/obj/item/melee/electrostaff/attack(mob/M, mob/living/user)
	if(turned_on && HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
		if(electrostaff_stun(user, user, skip_cooldown = TRUE)) // for those super edge cases where you clumsy baton yourself in quick succession
			user.visible_message("<span class='danger'>[user] неожиданно попадает по [user.p_themselves()] с помощью [src]!</span>",
							"<span class='userdanger'>Вы неожиданно попадаете по себе с помощью [src]!</span>")
		return
	if(user.mind?.martial_art?.no_baton && user.mind?.martial_art?.can_use(user))
		to_chat(user, user.mind.martial_art.no_baton_reason)
		return
	if(issilicon(M)) // Can't stunbaton borgs and AIs
		return ..()

	if(!isliving(M))
		return
	var/mob/living/L = M

	if(user.a_intent == INTENT_HARM)
		if(turned_on)
			electrostaff_stun(L, user)
		return ..() // Whack them too if in harm intent

	if(!turned_on)
		L.visible_message("<span class='warning'>[user] ткнул [L] с помощью [src]. К счастью он был выключен.</span>",
			"<span class='danger'>[L == user ? "Вы ткнули себя самого" : "[user] ткнул вас"] с помощью [src]. К счастью он был выключен.</span>")
		return

	if(electrostaff_stun(L, user))
		user.do_attack_animation(L)

/// returning false results in no baton attack animation, returning true results in an animation.
/obj/item/melee/electrostaff/proc/electrostaff_stun(mob/living/L, mob/user, skip_cooldown = FALSE)
	if(cooldown > world.time && !skip_cooldown)
		return FALSE

	var/user_UID = user.UID()
	if(HAS_TRAIT_FROM(L, TRAIT_WAS_BATONNED, user_UID)) // prevents double baton cheese.
		return FALSE

	cooldown = world.time + initial(cooldown) // tracks the world.time when hitting will be next available.
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.check_shields(src, 0, "[user]'s [name]", MELEE_ATTACK)) //No message; check_shields() handles that
			playsound(L, 'sound/weapons/genhit.ogg', 50, TRUE)
			return FALSE
		H.Confused(15 SECONDS)
		H.Jitter(15 SECONDS)
		H.apply_damage(stam_damage, STAMINA)
		if(user.a_intent == INTENT_HARM)
			H.apply_damage(burn_damage, BURN)
		H.SetStuttering(15 SECONDS)

	ADD_TRAIT(L, TRAIT_WAS_BATONNED, user_UID) // so one person cannot hit the same person with two separate batons
	L.apply_status_effect(STATUS_EFFECT_DELAYED, knockdown_delay, CALLBACK(L, TYPE_PROC_REF(/mob/living/, KnockDown), knockdown_duration), COMSIG_LIVING_CLEAR_STUNS)
	addtimer(CALLBACK(src, PROC_REF(electrostaff_delay), L, user_UID), knockdown_delay)

	SEND_SIGNAL(L, COMSIG_LIVING_MINOR_SHOCK, 33)

	if(user)
		L.lastattacker = user.real_name
		L.lastattackerckey = user.ckey
		L.visible_message("<span class='danger'>[user] оглушил [L] при помощи [src]!</span>",
			"<span class='userdanger'>[L == user ? "Вы оглушили сами себя" : "[user] оглушил вас"] при помощи [src]!</span>")
		add_attack_logs(user, L, "stunned")
	playsound(src, hitsound_on, 50, TRUE, -1)
	deductcharge(hitcost)
	return TRUE

/obj/item/melee/electrostaff/proc/electrostaff_delay(mob/living/target, user_UID)
	REMOVE_TRAIT(target, TRAIT_WAS_BATONNED, user_UID)

/obj/item/melee/electrostaff/emp_act(severity)
	. = ..()
	if(cell)
		deductcharge(1000 / severity)

/obj/item/melee/electrostaff/wash(mob/living/user, atom/source)
	if(turned_on && cell?.charge)
		flick("baton_active", source)
		electrostaff_stun(user, user, skip_cooldown = TRUE)
		user.visible_message("<span class='warning'>[user] ударил шоком [user.p_themselves()] пока пытался помыть активированный [src]!</span>",
							"<span class='userdanger'>Зря вы пытались помыть [src] пока он активирован.</span>")
		return TRUE
	..()

/obj/item/melee/electrostaff/AltClick(mob/user)
	..()
	if(user.incapacitated())
		to_chat(user, "<span class='warning'>Вы не можете этого сделать прямо сейчас!</span>")
		return
	if(unique_reskin && loc == user)
		reskin_staff(user)

/obj/item/melee/electrostaff/proc/reskin_staff(mob/M)
	var/list/skins = list()
	for(var/I in options)
		skins[I] = image(icon, icon_state = "[base_icon][options[I]]")
	var/choice = show_radial_menu(M, src, skins, radius = 40, custom_check = CALLBACK(src, PROC_REF(reskin_radial_check), M), require_near = TRUE)

	if(choice && reskin_radial_check(M))
		current_skin = options[choice]
		to_chat(M, "[choice] идеально подходит вашему посоху.")
		unique_reskin = FALSE
		update_icon()
		M.update_inv_r_hand()
		M.update_inv_l_hand()

/obj/item/melee/electrostaff/proc/reskin_radial_check(mob/user)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!src || !H.is_in_hands(src) || HAS_TRAIT(H, TRAIT_HANDS_BLOCKED))
		return FALSE
	return TRUE

/obj/item/weaponcrafting/gunkit/electrostaff
	name = "\improper electrostaff parts kit"
	desc = "Возьмите 2 оглушающие дубинки. Соедините их вместе, поместив внутрь батарею. Используйте остальные инструменты (лишних винтиков быть не должно)."
	origin_tech = "combat=6;materials=4"
	outcome = /obj/item/melee/electrostaff/loaded

/datum/design/electrostaff
	name = "Electrostaff Parts Kit"
	desc = "Лучше, чем 2 станбатона по отдельности."
	id = "electrostaff"
	req_tech = list("combat" = 7, "magnets" = 5, "powerstorage" = 5)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 4000, MAT_GLASS = 1000, MAT_GOLD = 3000, MAT_SILVER = 1500)
	build_path = /obj/item/weaponcrafting/gunkit/electrostaff
	category = list("Weapons")

/datum/crafting_recipe/electrostaff
	name = "Electrostaff"
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = list(/obj/item/melee/electrostaff/loaded)
	reqs = list(/obj/item/melee/baton = 2,
				/obj/item/stock_parts/cell/high = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weaponcrafting/gunkit/electrostaff = 1)
	time = 10 SECONDS
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON


