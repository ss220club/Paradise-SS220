GLOBAL_LIST_INIT(radios_broadcasting_common, list(
	/obj/item/radio/intercom,
	/obj/item/radio/centcom,
	/obj/item/radio/uplink,
	/obj/item/radio/syndicate,
	/obj/item/radio/headset/heads,
	/obj/item/radio/headset/ert,
	/obj/item/radio/headset/alt/deathsquad,
	/obj/item/radio/headset/skrellian,
	/obj/item/radio/headset/centcom,
	/obj/item/radio/headset/syndicate,
	/obj/item/radio/headset/uplink,
	/obj/item/radio/headset/chameleon,
	/obj/item/radio/headset/deadsay,
))

/obj/item/radio
	var/can_broadcast_into_common = FALSE

/obj/item/radio/Initialize(mapload)
	. = ..()
	if(is_type_in_list(src, GLOB.radios_broadcasting_common))
		can_broadcast_into_common = TRUE

/obj/item/radio/handle_message_mode(mob/living/M, list/message_pieces, message_mode)
	// Check if it can be send to common.
	if(!message_mode || message_mode == "headset")
		if(!can_broadcast_into_common && SSsecurity_level.current_security_level.number_level < SEC_LEVEL_GAMMA)
			return RADIO_CONNECTION_FAIL
	return ..()

/obj/item/radio/intercom
	canhear_range = 1

/obj/item/radio/intercom/department
	canhear_range = 1
