/obj/structure/chair/plastic
	name = "\improper складной пластиковый стул"
	desc = "Как бы вы ни ёрзали, все равно будет неудобно."
	icon = 'modular_ss220/objects/icons/plastic.dmi'
	icon_state = "plastic_chair"
	resistance_flags = FLAMMABLE
	max_integrity = 50
	buildstacktype = /obj/item/stack/sheet/plastic
	buildstackamount = 2
	item_chair = /obj/item/chair/plastic

/obj/structure/chair/plastic/post_buckle_mob(mob/living/Mob)
	Mob.pixel_y += 2
	.=..()
	if(iscarbon(Mob))
		INVOKE_ASYNC(src, PROC_REF(snap_check), Mob)

/obj/structure/chair/plastic/post_unbuckle_mob(mob/living/Mob)
	Mob.pixel_y -= 2

/obj/structure/chair/plastic/proc/snap_check(mob/living/carbon/Mob)
	if (Mob.nutrition >= NUTRITION_LEVEL_FAT)
		to_chat(Mob, span_warning("Стул начинает хрустеть и трещать, ты слишком тяжёлый!"))
		if(do_after(Mob, 6 SECONDS, progress = FALSE))
			Mob.visible_message(span_notice("\improper [Mob] садится на пластиковый стул, и проламывает его своим весом!"))
			new /obj/effect/decal/cleanable/plastic(loc)
			qdel(src)

/obj/item/chair/plastic
	name = "\improper складной пластиковый стул"
	desc = "Почему-то, всегда можно найти под рингом."
	icon = 'modular_ss220/objects/icons/plastic.dmi'
	icon_state = "folded_chair"
	item_state = "folded_chair"
	lefthand_file = 'modular_ss220/objects/icons/inhands/chairs_lefthand.dmi'
	righthand_file = 'modular_ss220/objects/icons/inhands/chairs_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 7
	throw_range = 5
	break_chance = 25
	origin_type = /obj/structure/chair/plastic

/obj/effect/decal/cleanable/plastic
	name = "\improper пластиковые осколки"
	desc = "Куски рваного, сломанного, никчёмного пластика."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shards"
	color = "#c6f4ff"
