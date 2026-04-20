USER_VERB_AND_CONTEXT_MENU(cmd_admin_offer_control, R_ADMIN, "Offer Control To Ghosts", "offers control to ghosts", VERB_CATEGORY_ADMIN, mob/M in GLOB.mob_list)
	if(!istype(M))
		alert("This can only be used on instances of type /mob")
		return

	offer_control(M)
