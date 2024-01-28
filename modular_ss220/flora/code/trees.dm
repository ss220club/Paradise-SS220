/obj/structure/flora/tree/sakura
	name = "Сакура"
	desc = "Зимняя вишня в цвету. Красота!"
	icon = 'modular_ss220/flora/icons/sakura.dmi'
	icon_state = "cherry_blossom_1"
	pixel_y = 10

// тут нужен метод, который будет спавнить анимацию цветения на тайле с деревом.
// минимально: раз в 30 минут метод либо создаёт анимацию цветения в тайле дерева
// либо убирает её, если она была создана ранее
// максимально (неравные отрезки): через 30 минут после начала раунда спавнит анимацию
// через 15 минут от начала анимации убирает её и снова запускает таймер 30 минут
/*/obj/structure/flora/tree/sakura/proc/start_blossom(turf/T)
	var/is_blossom_exist = FALSE
	if(!is_blossom_exist)
		new /obj/effect/blossom(T, src)
		is_blossom_exist = TRUE
	else */


