/*
===Модуль панциря (карапаса)
Цепляется на конечность. Особенность в том, что изначально придает конечности усиленную броню, но по достиженю трешхолда слома (устаналивается тут) конечность ломается

Сломанная конечность увеличивает входящий по ней урон. Считает и брут и берн уроны. В случае получения берн урона процент урона переносится на органы.area

Сопротивление/уязвимость к урону ожогами всегда ниже/выше сопротивления травмам.

Панцирь блокирует стандартные операции, пока не будет сломан.

Панцирь самовосстановится, если полностью вылечить конечность. Но есть параметр, который разрешает 100% или иное заживление при исцелении урона конечности.
*/
//Базовый трешхолд урона, при достижение или выше которого будет слом.
#define CARAPACE_BROKEN_STATE 20
//Базовая уязвимость к урону травмами (0.8 = 80%)
#define CARAPACE_BASIC_BRUTE_VULNERABILITY 0.8
//Бонус к уязвимости ожогу относительно урона травм
#define CARAPACE_ADDITIVE_BURN_VULNERABILITY 0.1
//Функция на будущее - позволяет переносить проценты урона
#define CARAPACE_DAMAGE_TRANSFER_PERCENTAGES 1
//Вероятность восстановления конечности при достижении 0 урона
#define CARAPACE_HEAL_BROKEN_PROB 50
//Список операций, которые будут заблокированы пока панцирь не будет сломан
#define CARAPACE_BLOCK_OPERATION list(/datum/surgery/bone_repair,/datum/surgery/bone_repair/skull,/datum/surgery/organ_manipulation)

#define COMSIG_CARAPACE_RECEIVE_DAMAGE "receive_damage"
#define COMSIG_CARAPACE_HEAL_DAMAGE "heal_damage"

#define COMSIG_CARAPACE_SURGERY_CAN_START "block_operation"
	#define CARAPACE_STOP_SURGERY_STEP (1<<0)

/datum/component/carapace
	var/obj/item/organ/external/limb
	var/self_medning = FALSE
	var/broken_treshold = CARAPACE_BROKEN_STATE
	var/brute_resistance = CARAPACE_BASIC_BRUTE_VULNERABILITY

/datum/component/carapace/Initialize(var/caller_limb, var/allow_self_medning, var/break_threshold)
	..()
	limb = parent
	self_medning = allow_self_medning
	broken_treshold = break_threshold
	update_resistance(limb)

/datum/component/carapace/RegisterWithParent()
	RegisterSignal(parent, COMSIG_CARAPACE_RECEIVE_DAMAGE, PROC_REF(receive_damage))
	RegisterSignal(parent, COMSIG_CARAPACE_HEAL_DAMAGE, PROC_REF(heal_damage))
	RegisterSignal(parent, COMSIG_CARAPACE_SURGERY_CAN_START, PROC_REF(block_operation))

/datum/component/carapace/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_CARAPACE_RECEIVE_DAMAGE)
	UnregisterSignal(parent, COMSIG_CARAPACE_HEAL_DAMAGE)
	UnregisterSignal(parent, COMSIG_CARAPACE_SURGERY_CAN_START)

/datum/component/carapace/proc/block_operation()
	SIGNAL_HANDLER
	return ((limb.status & ORGAN_BROKEN) ? CARAPACE_STOP_SURGERY_STEP : FALSE)

//Прок на обновление сопротивления урона
/datum/component/carapace/proc/update_resistance(var/affected_limb)
	if (limb.status & ORGAN_BROKEN)
		limb.brute_mod = (100 + limb.get_damage()) / 100
	else
		limb.brute_mod = brute_resistance
	limb.burn_mod = limb.brute_mod + CARAPACE_ADDITIVE_BURN_VULNERABILITY

//Проки, срабатываемые при получении или исцелении урона
/datum/component/carapace/proc/receive_damage(var/affected_limb, brute, burn, sharp, used_weapon = null, list/forbidden_limbs = list(), ignore_resists = FALSE, updating_health = TRUE)
	if (limb.get_damage() > broken_treshold)
		limb.fracture()
	if (limb.internal_organs.len > 0)
		var/obj/item/organ/internal/O = pick(limb.internal_organs)
		O.receive_damage(burn * limb.burn_dam)
	update_resistance()

/datum/component/carapace/proc/heal_damage(var/affected_limb, brute, burn, internal = 0, robo_repair = 0, updating_health = TRUE)
	if ((limb.status & ORGAN_BROKEN) && limb.get_damage() == 0)
		if (self_medning)
			limb.mend_fracture()
		else if(prob(CARAPACE_HEAL_BROKEN_PROB))
			limb.mend_fracture()
	update_resistance()

//Расширение проков урона и лечения для обращения к компоненту
/obj/item/organ/external/receive_damage(brute, burn, sharp, used_weapon = null, list/forbidden_limbs = list(), ignore_resists = FALSE, updating_health = TRUE)
	. = ..()
	SEND_SIGNAL(src, COMSIG_CARAPACE_RECEIVE_DAMAGE, brute, burn, sharp, used_weapon, forbidden_limbs, ignore_resists, updating_health)
	return

/obj/item/organ/external/heal_damage(brute, burn, internal = 0, robo_repair = 0, updating_health = TRUE)
	. = ..()
	SEND_SIGNAL(src, COMSIG_CARAPACE_HEAL_DAMAGE, brute, burn, internal, robo_repair, updating_health)
	return
