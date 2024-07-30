/obj/item/stack/Topic(href, href_list)
	return

/obj/item/stack/list_recipes(mob/user, recipes_sublist)
	return

/datum/stack_recipe/post_build(mob/user, obj/item/stack/S, obj/item/stack/created)
	return

/obj/item/stack/attack_self(mob/user)
	ui_interact(user)

/obj/item/stack/attack_self_tk(mob/user)
	ui_interact(user)

/obj/item/stack/attack_tk(mob/user)
	if(user.stat || !isturf(loc))
		return
	// Allow remote stack splitting, because telekinetic inventory managing
	// is really cool
	if(src in user.tkgrabbed_objects)
		var/obj/item/stack/F = split(user, 1)
		F.attack_tk(user)
		if(src && user.machine == src)
			ui_interact(user)
	else
		..()

/obj/item/stack/attack_hand(mob/user)
	if(user.is_in_inactive_hand(src) && get_amount() > 1)
		change_stack(user, 1)
		if(src && usr.machine == src)
			ui_interact(usr)
	else
		..()

/obj/item/stack/change_stack(mob/user,amount)
	. = ..()
	SStgui.update_uis(src)

/obj/item/stack/attackby(obj/item/W, mob/user, params)
	. = ..()
	SStgui.update_uis(src)

/obj/item/stack/proc/make(mob/user, datum/stack_recipe/recipe_to_make, multiplier)
	if(get_amount() < 1 && !is_cyborg)
		qdel(src)
		return FALSE

	if(!validate_build(user, recipe_to_make, multiplier))
		return FALSE

	if(recipe_to_make.time)
		to_chat(user, "<span class='notice'>Изготовление [recipe_to_make.title]...</span>")
		if(!do_after(user, recipe_to_make.time, target = user))
			return FALSE

		if(!validate_build(user, recipe_to_make, multiplier))
			return FALSE

	var/atom/created
	var/atom/drop_location = user.drop_location()
	if(recipe_to_make.max_res_amount > 1) //Is it a stack?
		created = new recipe_to_make.result_type(drop_location, recipe_to_make.res_amount * multiplier)
	else
		created = new recipe_to_make.result_type(drop_location)
	created.setDir(user.dir)

	use(recipe_to_make.req_amount * multiplier)

	recipe_to_make.post_build(user, src, created)
	if(isitem(created))
		user.put_in_hands(created)

	created.add_fingerprint(user)

	//BubbleWrap - so newly formed boxes are empty
	if(isstorage(created))
		for(var/obj/item/thing in created)
			qdel(thing)
	//BubbleWrap END

	return TRUE

/obj/item/stack/proc/validate_build(mob/builder, datum/stack_recipe/recipe_to_build, multiplier)
	if(!multiplier || multiplier <= 0 || multiplier > 50 || !IS_INT(multiplier)) // Href exploit checks
		message_admins("[key_name_admin(builder)] just attempted to href exploit sheet crafting with an invalid multiplier. Ban highly advised.")
		return FALSE

	if(get_amount() < recipe_to_build.req_amount * multiplier)
		if(recipe_to_build.req_amount * multiplier > 1)
			to_chat(builder, "<span class='warning'>You haven't got enough [src] to build \the [recipe_to_build.req_amount * multiplier] [recipe_to_build.title]\s!</span>")
		else
			to_chat(builder, "<span class='warning'>You haven't got enough [src] to build \the [recipe_to_build.title]!</span>")
		return FALSE

	var/turf/target_turf = get_turf(src)
	if(recipe_to_build.window_checks && !valid_window_location(target_turf, builder.dir))
		to_chat(builder, "<span class='warning'>\The [recipe_to_build.title] won't fit here!</span>")
		return FALSE

	if(recipe_to_build.one_per_turf && (locate(recipe_to_build.result_type) in target_turf))
		to_chat(builder, "<span class='warning'>There is another [recipe_to_build.title] here!</span>")
		return FALSE

	if(recipe_to_build.on_floor && !issimulatedturf(target_turf))
		to_chat(builder, "<span class='warning'>\The [recipe_to_build.title] must be constructed on the floor!</span>")
		return FALSE

	if(recipe_to_build.on_floor_or_lattice && !(issimulatedturf(target_turf) || locate(/obj/structure/lattice) in target_turf))
		to_chat(builder, "<span class='warning'>\The [recipe_to_build.title] must be constructed on the floor or lattice!</span>")
		return FALSE

	if(recipe_to_build.cult_structure)
		if(builder.holy_check())
			return FALSE

		if(!is_level_reachable(builder.z))
			to_chat(builder, "<span class='warning'>The energies of this place interfere with the metal shaping!</span>")
			return FALSE

	return TRUE
