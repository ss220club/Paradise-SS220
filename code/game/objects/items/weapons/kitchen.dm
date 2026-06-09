/* Kitchen tools
 * Contains:
 *		Utensils
 *		Spoons
 *		Forks
 *		Knives
 *		Kitchen knives
 *		Butcher's cleaver
 *		Rolling Pins
 *		Candy Moulds
 *		Sushi Mat
 *		Circular cutter
 */

/obj/item/kitchen
	name = "base type kitchen item"
	desc = ABSTRACT_TYPE_DESC
	icon = 'icons/obj/kitchen.dmi'
	origin_tech = "materials=1"
	materials = list(MAT_METAL = 100)

/*
 * Utensils
 */
/obj/item/kitchen/utensil
	name = "base type kitchen utensil"
	lefthand_file = 'icons/mob/inhands/utensil_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/utensil_righthand.dmi'
	force = 5.0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 5
	flags = CONDUCT
	attack_verb = list("attacked", "stabbed", "poked")
	hitsound = 'sound/weapons/bladeslice.ogg'
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, RAD = 0, FIRE = 50, ACID = 30)
	materials = list(MAT_METAL = 100)
	var/max_contents = 1
	new_attack_chain = TRUE

/obj/item/kitchen/utensil/Initialize(mapload)
	//Initialize(mapload)
	. = ..()
	if(prob(60))
		src.pixel_y = rand(0, 4)

	create_reagents(5)
	RegisterSignal(src, COMSIG_ATTACK, PROC_REF(on_attack))

/obj/item/kitchen/utensil/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(user.a_intent != INTENT_HELP)
		return

	if(!istype(target, /mob/living/carbon))
		return

	var/mob/living/carbon/feed_target = target
	if(length(contents))
		var/obj/item/food/toEat = contents[1]
		if(istype(toEat))
			if(feed_target.eat(toEat, user))
				toEat.On_Consume(feed_target, user)
				overlays.Cut()
			return ITEM_INTERACT_COMPLETE

	return ..()

/obj/item/kitchen/utensil/proc/on_attack(datum/source, mob/living/carbon/target, mob/living/user)
	if(!istype(target) || user.a_intent == INTENT_HELP)
		return
	if(user.zone_selected != "head" && user.zone_selected != "eyes")
		return
	if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
		target = user

	eyestab(target, user)

	return COMPONENT_SKIP_ATTACK

/obj/item/kitchen/utensil/fork
	name = "fork"
	desc = "Это вилка. Один удар - четыре дырки. Держите подальше от розеток. "
	icon_state = "fork"

/obj/item/kitchen/utensil/fork/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(!istype(target, /obj/machinery))
		return ..()

	if(istype(target, /obj/machinery/nuclearbomb)) // we're trying to be a little silly, not very silly
		return ..()

	var/obj/machinery/machine = target
	var/wiresexposed = FALSE

	if(istype(machine, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/air_lock = machine
		if(air_lock.security_level) //the door has a plating protecting the wires
			to_chat(user, SPAN_NOTICE("You scrape at the shielding of \the [target] with \the [src], to no effect."))
			return ITEM_INTERACT_COMPLETE

	//these have different variable names for if the panel is open or not. For some reason.
	if(istype(machine, /obj/machinery/alarm))
		var/obj/machinery/alarm/air_alarm = machine
		wiresexposed = air_alarm.wiresexposed

	if(istype(machine, /obj/machinery/firealarm))
		var/obj/machinery/firealarm/fire_alarm = machine
		wiresexposed = fire_alarm.wiresexposed

	// if we cant access the wires
	if(!machine.panel_open && !wiresexposed)
		return ITEM_INTERACT_COMPLETE

	var/datum/wires/internal_wires = machine.get_internal_wires()
	var/uncut_wire_count = 0
	if(internal_wires)
		uncut_wire_count = length(internal_wires.wires - internal_wires.cut_wires)

	if(prob(50))
		// if the machine isn't powered or we're using a non-conductive fork, we waste our attempt at getting shocked
		if(!machine.has_power() || !(flags & CONDUCT))
			to_chat(user, SPAN_NOTICE("You clumsily stick [src] into the open panel of [target]."))
			return ITEM_INTERACT_COMPLETE

		to_chat(user, SPAN_DANGER("You stick [src] into the open panel of [target]."))
		do_sparks(3, TRUE, machine)
		//electrocute the mob, we're not checking distance because some machines are bigger than 1x1
		electrocute_mob(user, get_area(machine), machine, machine.siemens_strength, FALSE)
	else if(prob(50) && uncut_wire_count) // 50% of 50% = 25%
		to_chat(user, SPAN_NOTICE("You stick [src] into the open panel of [target] and tear one of the wires."))
		internal_wires.cut_random_uncut_wire()
	else
		to_chat(user, SPAN_NOTICE("You stick [src] into the open panel of [target]. That was fun!"))

	return ITEM_INTERACT_COMPLETE


/obj/item/kitchen/utensil/pfork
	name = "plastic fork"
	desc = "Ура, её не нужно мыть!"
	icon_state = "pfork"
	flags = NONE
	materials = list(MAT_PLASTIC = 2000)

/obj/item/kitchen/utensil/spoon
	name = "spoon"
	desc = "Это ложка. Ей можно стукнуть по лбу, а также увидеть в ней свое перевернутое отражение."
	icon_state = "spoon"
	attack_verb = list("attacked", "poked")

/obj/item/kitchen/utensil/pspoon
	name = "plastic spoon"
	desc = "Это пластиковая ложка. Как скучно."
	icon_state = "pspoon"
	attack_verb = list("attacked", "poked")
	flags = NONE
	materials = list(MAT_PLASTIC = 2000)

/obj/item/kitchen/utensil/pspoon/mre
	name = "\improper MRE spoon"
	desc = "A military-grade plastic spoon. Robust construction, thin end towards enemy."
	icon_state = "pspoon_mre"
	force = 10
	attack_verb = list("attacked", "poked", "stabbed", "shanked")

/obj/item/kitchen/utensil/spork
	name = "spork"
	desc = "Это вилколожка. Восхитительный инновационный дизайн."
	icon_state = "spork"
	attack_verb = list("attacked", "sporked")

/obj/item/kitchen/utensil/pspork
	name = "plastic spork"
	desc = "Это пластиковая вилколожка. Не соответствует ничьим ожиданиям!"
	icon_state = "pspork"
	attack_verb = list("attacked", "sporked")
	flags = NONE
	materials = list(MAT_PLASTIC = 2000)

/*
 * Knives
 */
/obj/item/kitchen/knife
	name = "kitchen knife"
	desc = "Универсальный поварской нож производства компании Космическая Нарезка. Гарантированно остаётся острым на долгие годы."
	icon_state = "knife"
	lefthand_file = 'icons/mob/inhands/weapons_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons_righthand.dmi'
	flags = CONDUCT
	force = 10
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	throw_speed = 3
	throw_range = 6
	materials = list(MAT_METAL = 12000)
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharp = TRUE
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, RAD = 0, FIRE = 50, ACID = 50)
	var/bayonet = FALSE	//Can this be attached to a gun?

/obj/item/kitchen/knife/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/surgery_initiator/robo/sharp)
	RegisterSignal(src, COMSIG_BIT_ATTACH, PROC_REF(add_bit))
	RegisterSignal(src, COMSIG_CLICK_ALT, PROC_REF(remove_bit))

/obj/item/kitchen/knife/suicide_act(mob/user)
	user.visible_message(pick(SPAN_SUICIDE("[user] is slitting [user.p_their()] wrists with [src]! It looks like [user.p_theyre()] trying to commit suicide!"), \
						SPAN_SUICIDE("[user] is slitting [user.p_their()] throat with [src]! It looks like [user.p_theyre()] trying to commit suicide!"), \
						SPAN_SUICIDE("[user] is slitting [user.p_their()] stomach open with [src]! It looks like [user.p_theyre()] trying to commit seppuku!")))
	return BRUTELOSS

/obj/item/kitchen/knife/plastic
	name = "plastic knife"
	desc = "Самое тупое из лезвий."
	icon_state = "pknife"
	sharp = FALSE
	flags = NONE
	materials = list(MAT_PLASTIC = 2000)

/obj/item/kitchen/knife/ritual
	name = "ritual knife"
	desc = "Сверхъестественные силы, которые когда-то питали этот клинок, теперь бездействуют."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/kitchen/knife/shiv
	name = "glass shiv"
	desc = "Какой-то острый осколок завёрнутый в ткань, так же делала пра-пра-пра-пра-бабушка."
	icon = 'icons/obj/weapons/melee.dmi'
	icon_state = "glass_shiv"
	flags = NONE
	materials = list(MAT_METAL = 100, MAT_GLASS = 2000)

/obj/item/kitchen/knife/shiv/carrot
	name = "carrot shiv"
	desc = "В отличие от других морковок, эту, вероятно, стоит держать подальше от глаз."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "carrotshiv"
	force = 8
	throwforce = 12 //fuck git
	materials = list()
	origin_tech = "biotech=3;combat=2"
	attack_verb = list("shanked", "shivved")
	armor = null
	materials = list()

/obj/item/kitchen/knife/butcher
	name = "butcher's cleaver"
	desc = "Огромный нож, используемый для рубки мяса и его нарезки. Это так же включает продукцию из клоунов."
	icon_state = "butch"
	force = 15
	throwforce = 8
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(MAT_METAL = 18000)

/obj/item/kitchen/knife/butcher/meatcleaver
	name = "meat cleaver"
	icon_state = "mcleaver"
	inhand_icon_state = "butch"
	force = 25
	throwforce = 15

/obj/item/kitchen/knife/butcher/meatcleaver/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/butchers_humans)

/obj/item/kitchen/knife/combat
	name = "combat knife"
	desc = "Военный боевой нож для выживания."
	icon_state = "combatknife"
	worn_icon_state = "knife"
	inhand_icon_state = "knife"
	force = 20
	throwforce = 20
	origin_tech = "materials=3;combat=4"
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "cut")
	bayonet = TRUE

/obj/item/kitchen/knife/combat/survival
	name = "survival knife"
	desc = "Охотничий нож для выживания."
	icon_state = "survivalknife"
	force = 15
	throwforce = 15

/obj/item/kitchen/knife/combat/survival/bone
	name = "bone dagger"
	desc = "Острый костяной нож. Самый минимум для выживания."
	icon_state = "bone_dagger"
	inhand_icon_state = "bone_dagger"
	materials = list()
	flags = NONE

/obj/item/kitchen/knife/combat/cyborg
	name = "cyborg knife"
	desc = "Пласталевый нож, устанавливаемый киборгам. Крайне острый и прочный."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "knife"
	origin_tech = null

/obj/item/kitchen/knife/cheese
	name = "cheese knife"
	desc = "A blunt knife used to slice cheese."
	icon_state = "knife-cheese"
	materials = list(MAT_METAL = 4000)
	force = 3

/obj/item/kitchen/knife/pizza_cutter
	name = "pizza cutter"
	desc = "A simple circular blade on a handle, used to cut pizza."
	icon_state = "pizza_cutter"
	materials = list(MAT_METAL = 10000)
	force = 8

/*
 * Rolling Pins
 */

/obj/item/kitchen/rollingpin
	name = "скалка"
	desc = "Используется, чтобы вырубить бармена."
	icon_state = "rolling_pin"
	force = 8
	throwforce = 10
	throw_speed = 3
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	materials = list(MAT_WOOD = 10000)

/* Trays moved to /obj/item/storage/bag */

/*
 * Candy Moulds
 */

/obj/item/reagent_containers/cooking/mould
	name = "generic candy mould"
	desc = "Непонятно, что это вообще такое."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mould"
	force = 5
	throwforce = 5
	throw_speed = 3
	throw_range = 3
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "smashed")
	materials = list(MAT_PLASTIC = 2000)

/obj/item/reagent_containers/cooking/mould/make_mini()
	transform *= 0.5

/obj/item/reagent_containers/cooking/mould/unmake_mini()
	transform = null

/obj/item/reagent_containers/cooking/mould/bear
	name = "bear-shaped candy mould"
	desc = "Формочка в виде маленького медведя."
	icon_state = "mould_bear"

/obj/item/reagent_containers/cooking/mould/worm
	name = "worm-shaped candy mould"
	desc = "Формочка в виде червячка."
	icon_state = "mould_worm"

/obj/item/reagent_containers/cooking/mould/bean
	name = "bean-shaped candy mould"
	desc = "Формочка в виде боба."
	icon_state = "mould_bean"

/obj/item/reagent_containers/cooking/mould/ball
	name = "ball-shaped candy mould"
	desc = "Формочка в виде маленькой сферы"
	icon_state = "mould_ball"

/obj/item/reagent_containers/cooking/mould/cane
	name = "cane-shaped candy mould"
	desc = "Формочка в виде трости."
	icon_state = "mould_cane"

/obj/item/reagent_containers/cooking/mould/cash
	name = "cash-shaped candy mould"
	desc = "Формочка в виде фальшивых денег"
	icon_state = "mould_cash"

/obj/item/reagent_containers/cooking/mould/coin
	name = "coin-shaped candy mould"
	desc = "Формочка в виде монеты."
	icon_state = "mould_coin"

/obj/item/reagent_containers/cooking/mould/loli
	name = "sucker mould"
	desc = "Формочка в виде леденца."
	icon_state = "mould_loli"

/// circular cutter by Ume

/obj/item/kitchen/cutter
	name = "generic circular cutter"
	desc = "Универсальный круглый резак для печенья и других изделий."
	icon_state = "circular_cutter"
	force = 5
	throwforce = 5
	throw_speed = 3
	throw_range = 3
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("bashed", "slashed", "pricked", "thrashed")
