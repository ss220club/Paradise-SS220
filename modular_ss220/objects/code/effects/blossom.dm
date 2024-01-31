/obj/effect/blossom
	name = "Цветение сакуры"
	desc = "Метель из лепестков сакуры"
	icon = 'modular_ss220/objects/icons/sakura.dmi'
	icon_state = "blossom_less"
	pixel_y = 10
	layer = 9.1
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/obj/structure/flora/tree/sakura/parent_tree

// Я не понимаю логику методов New и Destroy, т.к. они опираются на какие-то стандартные
// методы и переменные START/STOP_PROCESSING(SSobj, src)
// просто скопировал и изменил их из класса snowcloud
/obj/effect/blossom/New(turf, obj/structure/flora/tree/sakura/Sakura)
	..()
	START_PROCESSING(SSobj, src)
	//if(Sakura && istype(Sakura))
		//parent_tree = Sakura

/obj/effect/blossom/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

// нужен метод, который удаляет анимацию, если родительское дерево было уничтожено
/obj/effect/blossom/proc/delete_blossom(turf/T)

// нужен метод, который спавнит в тайле дерева /obj/effect/decal/sakura_leaves,
// если анимация цветения была активной хотя бы 5 минут
// + в тайле ещё нет декали sakura_leaves
// + тайл на является /turf/simulated/floor/grass/sakura
/obj/effect/blossom/proc/make_sakura_leaves(turf/T)
	if(!locate(/obj/effect/decal/sakura_leaves, T) && !locate(/turf/simulated/floor/grass/sakura, T))
		return
	addtimer(CALLBACK(src, PROC_REF(delete_blossom)), 5 MINUTES)
	new /obj/effect/decal/sakura_leaves(T, src)

// нужен метод, который превращает тайл под анимацией в /turf/simulated/floor/grass/sakura,
// если а) анимация работала 15 минут, б) тайл под анимацией - это grass или jungle grass
// также этот метод должен одновременно убирать декаль sakura_leaves, но
// возможно это поведение лучше унести в класс sakura_leaves.dm
