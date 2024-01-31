/obj/effect/decal/sakura_leaves
	name = "Кучка листьев сакуры"
	desc = "Опавшие листья сакуры"
	density = FALSE
	layer = TURF_DECAL_LAYER
	icon = 'modular_ss220/objects/icons/sakura.dmi'
	icon_state = "leaves_on_ground"

// нужен метод, который позволяет поджечь листвую => декаль должен исчезнуть. Это он?
/obj/effect/decal/sakura_leaves/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume, global_overlay = TRUE)
	..()
	qdel(src)

// нужен метод, который позволяет удалить декаль, используя /obj/item/cultivator,
// не уверен, что всё верно написал, метод нуждается в проверке
// + не нашёл звука шелеста листьев, подставил звук копания земли
/obj/effect/decal/sakura_leaves/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cultivator))
		var/obj/item/shovel/S // так нужно, чтобы обращаться к звуку лопаты ниже
		var/obj/item/cultivator/C = I
		user.visible_message("<span class='notice'>[user] is clearing leaves from the ground [src]...</span>", "<span class='notice'>You begin clearing leaves from the ground [src]...</span>", "<span class='warning'>You hear a sound of leaves rustling.</span>")
		playsound(src, S.usesound, 50, 1)
		if(!do_after(user, 50 * C.toolspeed, target = src))
			return
		user.visible_message("<span class='notice'>[user] clears leaves from the ground [src]!</span>", "<span class='notice'>You clear  from the ground [src]!</span>")
		qdel(src)
	else
		return ..()
