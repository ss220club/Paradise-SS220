/obj/item/stack
	is_examine_bites = FALSE
	integrity_bite = 1 // stack sheet now
	nutritional_value = 5

/obj/item/stack/item_bite(mob/living/carbon/target, mob/user)
	amount -= integrity_bite
	if(amount <= 0)
		to_chat(user, SPAN_NOTICE("[target == user ? "Вы доели" : "[target] доел"] [src.name]."))
		qdel(src)
