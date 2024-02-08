/obj/item/melee/electrostaff
	name = "электропосох"
	desc = "Шоковая палка, только более мощная, двуручная и доступная наиболее авторитетным членам силовых структур Nanotrasen. А еще у неё нет тупого конца."
	icon = 'icons/obj/baton.dmi'
	base_icon_state = "stunbaton"
	icon_state = "stunbaton"
	slot_flags = SLOT_FLAG_BACK
	force = 5
	throwforce = 3
	attack_verb = list("beaten")
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 50, RAD = 0, FIRE = 80, ACID = 80)
	/// How many seconds does the knockdown last for?
	var/knockdown_duration = 15 SECONDS
	/// how much stamina damage does this baton do?
	var/stam_damage = 80 // 2 hits or 1 hit + 2 disabler shots
	/// Is the baton currently turned on
	var/turned_on = FALSE
	/// How much power does it cost to stun someone
	var/hitcost = 2000
	var/obj/item/stock_parts/cell/high/cell = null
	/// the initial cooldown tracks the time between swings. tracks the world.time when the baton is usable again.
	var/cooldown = 3.5 SECONDS
	/// the time it takes before the target falls over
	var/knockdown_delay = 2.5 SECONDS
	var/burn_damage = 10

/obj/item/melee/electrostaff/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded = force, force_wielded = force, wield_callback = CALLBACK(src, PROC_REF(on_wield)), unwield_callback = CALLBACK(src, PROC_REF(on_unwield)))

/obj/item/melee/electrostaff/Destroy()
	if(cell?.loc == src)
		QDEL_NULL(cell)
	return ..()

/obj/item/melee/electrostaff/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is putting the live [name] in [user.p_their()] mouth! It looks like [user.p_theyre()] trying to commit suicide.</span>")
	return FIRELOSS

///obj/item/chainsaw/attack_self(mob/user)
//	if(src == user.get_active_hand()) //update inhands
//		user.update_inv_l_hand()
//		user.update_inv_r_hand()
//	for(var/X in actions)
//		var/datum/action/A = X
//		A.UpdateButtonIcon()
//	update_icon()

/obj/item/melee/electrostaff/update_icon_state()
	if(HAS_TRAIT(src, TRAIT_WIELDED))
		if(cell && cell.charge > 0)
			icon_state = "[base_icon_state]_active" // Спрайты, исправить, двуруч
		else
			icon_state = "[base_icon_state]_nocell" // Спрайты, исправить, двуруч
	else
		icon_state = base_icon_state
	return ..()

/obj/item/melee/electrostaff/proc/link_new_cell(unlink = FALSE)
	if(unlink)
		cell = null
	else
		cell = new(src)

/obj/item/melee/electrostaff/examine(mob/user)
	. = ..()
	if(cell)
		. += "<span class='notice'>Электропосох заряжен на [round(cell.percent())]%.</span>"
	else
		. += "<span class='warning'>В электропосохе отсутствует источник питания.</span>"
	. += "<span class='notice'>При включении этот предмет обожжет и отправит в отключку любого, по кому попадет, после небольшой задержки. При использовании с намерением причинить вред он также травмирует, даже если он выключен.</span>"
	. += "<span class='notice'>Этот предмет не имеет внешних разьемов для подзарядки. Используйте отвертку, чтобы получить доступ к внутренней батарейке.</span>"

/obj/item/melee/electrostaff/get_cell()
	return cell

/obj/item/melee/electrostaff/mob_can_equip(mob/user, slot, disable_warning = TRUE)
	if(turned_on && (slot == SLOT_HUD_BACK))
		to_chat(user, "<span class='warning'>Вы не можете экипировать [src] пока он активен!</span>")
		return FALSE
	return ..(user, slot, disable_warning = TRUE) // call parent but disable warning

/obj/item/melee/electrostaff/proc/deductcharge(amount)
	if(!cell)
		return
	cell.use(amount)
	if(cell.rigged)
		cell = null
		turned_on = FALSE
		update_icon(UPDATE_ICON_STATE)
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

/obj/item/melee/electrostaff/proc/on_wield(obj/item/source, mob/living/carbon/user)
	if(cell?.charge >= hitcost)
		turned_on = TRUE
		to_chat(user, "<span class='notice'>[src] [turned_on ? "включен" : "выключен"].</span>")
		playsound(src, "sparks", 75, TRUE, -1)
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
		to_chat(user, "<span class='notice'>[src] [turned_on ? "включен" : "выключен"].</span>")
		playsound(src, "sparks", 75, TRUE, -1)
	else
		if(!cell)
			to_chat(user, "<span class='warning'>[src] не имеет источника питания!</span>")
		else
			to_chat(user, "<span class='warning'>[src] разряжен.</span>")
	update_icon()
	add_fingerprint(user)

///obj/item/melee/electrostaff/throw_impact(mob/living/carbon/human/hit_mob)
//	. = ..()
//	if(!. && turned_on && istype(hit_mob))
//		thrown_electrostaff_stun(hit_mob)

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
	playsound(src, 'sound/weapons/egloves.ogg', 50, TRUE, -1)
	deductcharge(hitcost)
	return TRUE

/*/obj/item/melee/electrostaff/proc/thrown_electrostaff_stun(mob/living/carbon/human/L)
	if(cooldown > world.time)
		return FALSE

	var/user_UID = thrownby
	var/mob/user = locateUID(thrownby)
	if(!istype(user) || (user.mind?.martial_art?.no_baton && user.mind?.martial_art?.can_use(user)))
		return

	if(HAS_TRAIT_FROM(L, TRAIT_WAS_BATONNED, user_UID))
		return FALSE

	cooldown = world.time + initial(cooldown)
	if(L.check_shields(src, 0, "[user]'s [name]", MELEE_ATTACK))
		playsound(L, 'sound/weapons/genhit.ogg', 50, TRUE)
		return FALSE
	L.Confused(6 SECONDS)
	L.Jitter(6 SECONDS)
	L.apply_damage(40, STAMINA)
	L.SetStuttering(6 SECONDS)

	ADD_TRAIT(L, TRAIT_WAS_BATONNED, user_UID) // so one person cannot hit the same person with two separate batons
	addtimer(CALLBACK(src, PROC_REF(electrostaff_delay), L, user_UID), 2 SECONDS)

	SEND_SIGNAL(L, COMSIG_LIVING_MINOR_SHOCK, 33)

	L.lastattacker = user.real_name
	L.lastattackerckey = user.ckey
	L.visible_message("<span class='danger'>[src] оглушил [L]!</span>")
	add_attack_logs(user, L, "stunned")
	playsound(src, 'sound/weapons/egloves.ogg', 50, TRUE, -1)
	deductcharge(hitcost)
	return TRUE*/

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
							"<span class='userdanger'>Вы зря пытались помыть [src] пока он активирован.</span>")
		return TRUE
	..()
