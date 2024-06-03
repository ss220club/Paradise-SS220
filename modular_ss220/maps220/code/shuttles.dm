// Nanotrasen shuttles
/obj/machinery/computer/shuttle/nanotrasen
	name = "nanotrasen shuttle terminal"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	req_access = list(ACCESS_CENT_SPECOPS_COMMANDER)
	bubble_icon = "syndibot"
	circuit = /obj/item/circuitboard/shuttle/nanotrasen
	shuttleId = "nanotrasen"
	possible_destinations = "syndicate_away;syndicate_z5;syndicate_z3;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s;syndicate_custom"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	flags = NODECONSTRUCT

/obj/machinery/computer/shuttle/nanotrasen/recall
	name = "nanotrasen shuttle recall terminal"
	circuit = /obj/item/circuitboard/shuttle/nanotrasen/recall
	possible_destinations = "syndicate_away"

/obj/machinery/computer/shuttle/nanotrasen/drop_pod
	name = "nanotrasen assault pod control"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "syndie_assault_pod"
	req_access = list(ACCESS_CENT_SPECOPS_COMMANDER)
	circuit = /obj/item/circuitboard/shuttle/nanotrasen/drop_pod
	shuttleId = "nt_drop_pod"
	possible_destinations = null

/obj/machinery/computer/shuttle/nanotrasen/drop_pod/can_call_shuttle(user, action)
	if(action == "move")
		if(z != level_name_to_num(CENTCOMM))
			to_chat(user, "<span class='warning'>Pods are one way!</span>")
			return FALSE
	return ..()

// Docking ports
/obj/docking_port/mobile/assault_pod/nanotrasen
	id = "nt_drop_pod"

/obj/docking_port/mobile/assault_pod/nanotrasen/request()
	if(z == initial(src.z)) //No launching pods that have already launched
		return ..()

// Circuits
/obj/item/circuitboard/shuttle/nanotrasen/recall
	board_name = "Nanotrasen Shuttle Recall Terminal"
	icon_state = "generic"
	build_path = /obj/machinery/computer/shuttle/nanotrasen/recall

/obj/item/circuitboard/shuttle/nanotrasen/drop_pod
	board_name = "Nanotrasen Drop Pod"
	icon_state = "generic"
	build_path = /obj/machinery/computer/shuttle/nanotrasen/drop_pod

// Specific shuttle items
/obj/item/assault_pod/nanotrasen
	shuttle_id = "nt_drop_pod"
