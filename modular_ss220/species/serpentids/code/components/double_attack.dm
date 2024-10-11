/*
===Компонент на атаку парного оружия
Срабатывает при атаке оружием. Второе оружие через паузу в 0.2 секунды запускает атаку.

Срабатывает только, если оружие одинаковое.
*/

#define COMSIG_DOUBLEATTACK_PROCESS "hand_pre_attack"
#define COMSIG_DOUBLEATTACK_SYNC "sync_states"
#define COMSIG_DOUBLEATTACK_CHECK "check_state"
	#define DOUBLEATTACK_CHECK_ACTIVE (1<<0)

/datum/component/double_attack
	var/obj/item/hand_item = null
	var/state_attack = FALSE

/datum/component/double_attack/Initialize(obj/item/weapon)
	hand_item = weapon

/datum/component/double_attack/RegisterWithParent()
	RegisterSignal(parent, COMSIG_DOUBLEATTACK_PROCESS, PROC_REF(hand_pre_attack))
	RegisterSignal(parent, COMSIG_DOUBLEATTACK_CHECK, PROC_REF(check_state))
	RegisterSignal(parent, COMSIG_DOUBLEATTACK_SYNC, PROC_REF(sync_states))

/datum/component/double_attack/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_DOUBLEATTACK_PROCESS)
	UnregisterSignal(parent, COMSIG_DOUBLEATTACK_CHECK)
	UnregisterSignal(parent, COMSIG_DOUBLEATTACK_SYNC)

//Проверка, что оружие запустило атаку (для избегания цепи атак)
/datum/component/double_attack/proc/check_state()
	SIGNAL_HANDLER
	return state_attack ? DOUBLEATTACK_CHECK_ACTIVE : 0

//Синхронизация состояния атак, чтобы оба оружия понимали, что они запустили атаку
/datum/component/double_attack/proc/sync_states(weapon, newstate)
	SIGNAL_HANDLER
	state_attack = newstate

/datum/component/double_attack/proc/hand_pre_attack(obj/item/weapon, mob/living/target, mob/living/user, def_zone)
	SIGNAL_HANDLER
	hand_item = user.get_active_hand()
	if(SEND_SIGNAL(hand_item, COMSIG_DOUBLEATTACK_CHECK) && DOUBLEATTACK_CHECK_ACTIVE)
		return
	state_attack = TRUE
	SEND_SIGNAL(hand_item, COMSIG_DOUBLEATTACK_SYNC, state_attack)
	if(hand_item)
		addtimer(CALLBACK(src, PROC_REF(hand_attack), target, user, def_zone), (user.next_move_modifier / 5) SECONDS)
		addtimer(CALLBACK(src, PROC_REF(hand_post_attack)), (user.next_move_modifier / 2) SECONDS)

/datum/component/double_attack/proc/hand_attack(mob/living/target, mob/living/user, def_zone)
	if(QDELETED(src) || QDELETED(target) || user != hand_item.loc  || !user.Adjacent(target))
		return
	hand_item.attack(target, user, def_zone)

/datum/component/double_attack/proc/hand_post_attack()
	state_attack = FALSE
	SEND_SIGNAL(hand_item, COMSIG_DOUBLEATTACK_SYNC, state_attack)

//Расширение базового прока атаки для запуска сигнала
/obj/item/attack(mob/living/M, mob/living/user, def_zone)
	. = .. ()
	SEND_SIGNAL(src, COMSIG_DOUBLEATTACK_PROCESS, M, user, def_zone)

