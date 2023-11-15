#define ACCESS_VACANT_STORE 401

/obj/item/door_remote/key
	icon = 'modular_ss220/objects/icons/key.dmi'
	icon_state = "key"
	/// Are you already using the key?
	var/busy = FALSE
	/// This prevents spamming the key.
	var/cooldown = 0
	/// How fast does the key open an airlock.
	var/hack_speed = 1 SECONDS

/obj/item/door_remote/key/attack_self(mob/user)
	return

/obj/item/door_remote/key/afterattack(obj/machinery/door/airlock/attacked_airlock, mob/user)
	if(!istype(attacked_airlock))
		return

	if(HAS_TRAIT(attacked_airlock, TRAIT_CMAGGED))
		to_chat(user, "<span class='danger'>[src] не хочет вставлятся в панель доступа [attacked_airlock], тут повсюду слизь!</span>")
		return

	if(attacked_airlock.is_special)
		to_chat(user, "<span class='danger'>[src] не может поместится в панель доступа [attacked_airlock]!</span>")
		return

	if(!attacked_airlock.arePowerSystemsOn())
		to_chat(user, "<span class='danger'>[attacked_airlock] без питания!</span>")
		return

	if(busy)
		to_chat(user, "<span class='warning'>Ты уже используешь [src] на панели доступа [attacked_airlock]!</span>")
		return

	playsound(src, 'sound/items/keyring_unlock.ogg', 10)
	attacked_airlock.add_fingerprint(user)

	busy = TRUE
	if(!do_after(user, hack_speed, target = attacked_airlock, progress = 1))
		busy = FALSE
		return
	busy = FALSE

	if(!attacked_airlock.check_access(ID))
		to_chat(user, "<span class='danger'>[src] похоже не подходит к панели доступа [attacked_airlock]!</span>")
		return

	if(!attacked_airlock.density)
		attacked_airlock.close()
		return
	attacked_airlock.open()

/obj/item/door_remote/key/engineer
	name = "\improper ключ от инженерного отдела"
	icon_state = "eng"
	additional_access = list (ACCESS_ENGINE)

/obj/item/door_remote/key/medical
	name = "\improper ключ от медицинского отдела"
	icon_state = "med"
	additional_access = list (ACCESS_MEDICAL)

/obj/item/door_remote/key/supply
	name = "\improper ключ от отдела снабжения"
	icon_state = "supply"
	additional_access = list (ACCESS_CARGO, ACCESS_MINING)

/obj/item/door_remote/key/rnd
	name = "\improper ключ от отдела исследований"
	icon_state = "rnd"
	additional_access = list (ACCESS_RESEARCH)

/obj/item/door_remote/key/sec
	name = "\improper ключ от отдела службы безопасности"
	icon_state = "sec"
	additional_access = list (ACCESS_SECURITY)

/obj/item/door_remote/key/service
	name = "\improper ключ от отдела сервиса"
	icon_state = "service"
	additional_access = list (ACCESS_KITCHEN, ACCESS_BAR, ACCESS_HYDROPONICS, ACCESS_JANITOR)

/obj/item/door_remote/key/command
	name = "\improper ключ командования"
	icon_state = "com"
	additional_access = list(ACCESS_HEADS)

/obj/item/door_remote/key/vacant
	name = "\improper Ключ от свободного офиса"
	desc = "Выкидной ключ темно-синего цвета."
	icon_state = "closed"
	/// key ready to use?
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

/obj/item/door_remote/key/vacant/afterattack(obj/machinery/door/airlock/attacked_airlock, mob/user)
	if(!ready)
		to_chat(user, "<span class='danger'>Сперва нужно вытащить ключ!</span>")
		return
	. = ..()

/obj/item/storage/box/keys
	name = "Коробка с ключами"
	desc = "Коробка с ключами к отделам. Имеют неполный доступ к шлюзам."

/obj/item/storage/box/keys/populate_contents()
	new /obj/item/door_remote/key/sec(src)
	new /obj/item/door_remote/key/sec(src)
	new /obj/item/door_remote/key/supply(src)
	new /obj/item/door_remote/key/supply(src)
	new /obj/item/door_remote/key/service(src)
	new /obj/item/door_remote/key/service(src)
	new /obj/item/door_remote/key/engineer(src)
	new /obj/item/door_remote/key/engineer(src)
	new /obj/item/door_remote/key/rnd(src)
	new /obj/item/door_remote/key/rnd(src)
	new /obj/item/door_remote/key/command(src)
	new /obj/item/door_remote/key/command(src)
	new /obj/item/door_remote/key/medical(src)
	new /obj/item/door_remote/key/medical(src)
	new /obj/item/door_remote/key/vacant(src)
	new /obj/item/door_remote/key/vacant(src)
