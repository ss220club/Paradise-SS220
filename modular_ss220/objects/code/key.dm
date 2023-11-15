#define ACCESS_VACANT_STORE 401

/obj/item/door_remote/key
	icon = 'modular_ss220/objects/icons/key.dmi'
	icon_state = "key"
	/// Ты уже используешь ключ?
	var/busy = FALSE
	/// Предотвращение спама открытия/закрытия шлюза.
	var/cooldown = 0
	/// Как быстро происходит открытие шлюза.
	var/hack_speed = 5 SECONDS

/obj/item/door_remote/key/afterattack(obj/machinery/door/airlock/D, mob/user)
	if(!istype(D))
		return

	if(HAS_TRAIT(D, TRAIT_CMAGGED))
		to_chat(user, "<span class='danger'>[src] не хочет вставлятся в [D] airlock's access panel, тут повсюду слизь!</span>")
		return

	if(D.is_special)
		to_chat(user, "<span class='danger'>[src] не может поместится в [D] airlock's access panel!</span>")
		return

	if(!D.arePowerSystemsOn())
		to_chat(user, "<span class='danger'>The [D] airlock без питания!</span>")
		return

	if(busy)
		to_chat(user, "<span class='warning'>Ты уже используешь [src] на [D] airlock's access panel!</span>")
		return

	playsound(src, 'sound/items/keyring_unlock.ogg', 50)
	D.add_fingerprint(user)

	busy = TRUE
	if(!do_after(user, hack_speed, target = D, progress = 5))
		busy = FALSE
		return
	busy = FALSE

	if(!D.check_access(ID))
		to_chat(user, "<span class='danger'>[src] похоже не подходит к [D] airlock's access panel!</span>")
		return

	if(!D.density)
		D.close()
		return
	D.open()

/obj/item/door_remote/key/engineer
	name = "ключ от инженерного отдела"
	icon_state = "eng"
	additional_access = list (ACCESS_ENGINE)

/obj/item/door_remote/key/medical
	name = "ключ от медицинского отдела"
	icon_state = "med"
	additional_access = list (ACCESS_MEDICAL)

/obj/item/door_remote/key/supply
	name = "ключ от отдела снабжения"
	icon_state = "supply"
	additional_access = list (ACCESS_CARGO, ACCESS_MINING)

/obj/item/door_remote/key/rnd
	name = "ключ от отдела исследований"
	icon_state = "rnd"
	additional_access = list (ACCESS_RESEARCH)

/obj/item/door_remote/key/sec
	name = "ключ от отдела службы безопасности"
	icon_state = "sec"
	additional_access = list (ACCESS_SECURITY)

/obj/item/door_remote/key/service
	name = "ключ от отдела сервиса"
	icon_state = "service"
	additional_access = list (ACCESS_KITCHEN, ACCESS_BAR, ACCESS_HYDROPONICS, ACCESS_JANITOR)

/obj/item/door_remote/key/command
	name = "ключ командования"
	icon_state = "com"
	additional_access = list(ACCESS_HEADS)

/obj/item/door_remote/key/vacant
	name = "Ключ от свободного офиса"
	desc = "Выкидной ключ темно-синего цвета."
	icon_state = "closed"
	/// Ключ готов к использованию?
	var/ready = FALSE
	additional_access = list (ACCESS_VACANT_STORE)

/obj/item/door_remote/key/vacant/attack_self(mob/user)
	if(cooldown > world.time)
		return
	if(!ready)
		to_chat(user, "<span class='warning'>Ты вытаскиваешь ключ!</span>")
		flick("opens", src)
		icon_state = "open"
		ready = TRUE
		cooldown = world.time + 2 SECONDS
	else
		to_chat(user, "<span class='warning'>Ты складываешь ключ!</span>")
		flick("closes", src)
		icon_state = "closed"
		ready = FALSE
		cooldown = world.time + 2 SECONDS

/obj/item/door_remote/key/vacant/afterattack(obj/machinery/door/airlock/D, mob/user)
	if(!ready)
		to_chat(user, "<span class='danger'>Сперва нужно вытащить ключ!</span>")
		return
	. = ..()
