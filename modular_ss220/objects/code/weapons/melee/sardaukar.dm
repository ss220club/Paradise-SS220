/obj/item/melee/sardaukar
	name = "\improper виброклинок"
	desc = "Виброклинок гвардейцев Императора. Микрогенератор ультразвука в рукояти позволяет лезвию вибрировать \
	с огромной частотой, что позволяет даже при касательном ударе нанести глубокие раны. Воины Куи'кверр-Кэтиш \
	обучаются мастерству ближнего боя с детства, поэтому в их руках он особо опасен и жесток. \
	Каждый будущий гвардеец добывает свой клинок в ритуальном бою и его сохранность есть вопрос жизни и смерти владельца."
	icon = 'modular_ss220/objects/icons/melee.dmi'
	icon_state = "sardaukar"
	item_state = "sardaukar"
	lefthand_file = 'modular_ss220/objects/icons/inhands/melee_lefthand.dmi'
	righthand_file = 'modular_ss220/objects/icons/inhands/melee_righthand.dmi'
	hitsound = 'modular_ss220/objects/sound/weapons/melee/sardaukar/knifehit1.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	force = 20
	throwforce = 15
	throw_speed = 2
	throw_range = 5
	armour_penetration_percentage = 75
	slot_flags = SLOT_FLAG_BELT
	w_class = WEIGHT_CLASS_NORMAL
	sharp = TRUE
	flags = CONDUCT

/obj/item/melee/sardaukar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/parry, _stamina_constant = 2, _stamina_coefficient = 0.5, _parryable_attack_types = ALL_ATTACK_TYPES)
