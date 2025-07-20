/mob/living/simple_animal/great_mother
	name = "великая мать"
	desc = "Огромный глазной отросток, который, видимо, управляет всей биомассой биоморфов на планете. Похоже, он полностью беззащитен и может стать лёгкой мишенью."
	health = 800
	maxHealth = 800
	gender = PLURAL
	AIStatus = AI_OFF
	loot = list(/obj/item/food/meat/mother = 15)
	death_sound = 'sound/shadowdemon/shadowdeath.ogg'
	icon = 'modular_ss220/lazarus/icons/great_mother.dmi'
	icon_state = "mother"
	icon_living = "mother"
	move_resist = MOVE_FORCE_STRONG
	faction = list("treacherous_flesh")
	a_intent = INTENT_HARM

/obj/item/food/meat/mother
	name = "плоть влеикой матери"
	desc = "Священная плоть"

/mob/living/simple_animal/great_mother/death(gibbed)
	if(!gibbed)
		gib()
	return ..(TRUE)
