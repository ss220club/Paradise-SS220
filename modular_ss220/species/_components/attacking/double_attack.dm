/*
===Компонент на атаку парного оружия
Срабатывает при атаке оружием. Второе оружие через паузу в 0.2 секунды запускает атаку.

Срабатывает только, если оружие одинаковое.
*/

/datum/component/double_attack
	var/state_attack = FALSE

/datum/component/double_attack/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOB_ITEM_ATTACK, PROC_REF(hand_pre_attack))

/datum/component/double_attack/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_ITEM_ATTACK)

/datum/component/double_attack/proc/hand_pre_attack(obj/item/weapon, mob/living/target, mob/living/user, def_zone)
	SIGNAL_HANDLER
	var/hand_item = user.get_active_hand()
	state_attack = TRUE
	if(hand_item && state_attack)
		addtimer(CALLBACK(src, PROC_REF(hand_attack), target, user, def_zone, hand_item), (user.next_move_modifier / 5) SECONDS)

/datum/component/double_attack/proc/hand_attack(mob/living/target, mob/living/user, def_zone, obj/item/hand_item)
	if(QDELETED(src) || QDELETED(target) || user != hand_item.loc  || !user.Adjacent(target))
		return
	hand_item.attack(target, user, def_zone)
	state_attack = FALSE

//Расширение базового прока атаки для запуска сигнала
/obj/item/attack(mob/living/M, mob/living/user, def_zone)
	. = .. ()
	SEND_SIGNAL(src, COMSIG_MOB_ITEM_ATTACK, M, user, def_zone)
