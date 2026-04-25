/obj/machinery/door/airlock/attack_larva(mob/user)
	for(var/atom/movable/movable in get_turf(src))
		if(movable != src && movable.density && !movable.CanPass(user, user.loc))
			to_chat(user, SPAN_WARNING("[movable] мешает вам протиснуться под [src]!"))
			return
	if(locked || welded) //Can't pass through airlocks that have been bolted down or welded
		to_chat(user, SPAN_WARNING("[src] герметично закрыт. Вы не можете протиснуться!"))
		return
	user.visible_message(
		SPAN_WARNING("[user] протискивается через [src]!"),
		SPAN_WARNING("Вы протискиваетесь через [src]."),
		null)
	user.forceMove(get_turf(src))
