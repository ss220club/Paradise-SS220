GLOBAL_LIST_EMPTY(id_cards)

/obj/item/card/id
	var/list/red_alert_given_access = list() // Accesses that were given on red alert

/obj/item/card/id/New()
	. = ..()
	GLOB.id_cards += src

/obj/item/card/id/Destroy()
	GLOB.id_cards -= src
	return ..()

/obj/item/card/id/proc/on_red_alert()
	if(!has_access(list(), list(ACCESS_SECURITY), access))
		return
	red_alert_given_access = get_region_accesses(REGION_ALL) - get_region_accesses(REGION_COMMAND)
	red_alert_given_access -= access

	access += red_alert_given_access

/obj/item/card/id/proc/after_red_alert()
	if(!has_access(list(), list(ACCESS_SECURITY), access))
		return
	access -= red_alert_given_access
	red_alert_given_access.Cut()

/proc/update_ids()
	var/proc_to_call = (GLOB.security_level > SEC_LEVEL_BLUE) ? /obj/item/card/id/proc/on_red_alert : /obj/item/card/id/proc/after_red_alert

	for(var/obj/item/card/id/card as anything in GLOB.id_cards)
		call(card, proc_to_call)()
