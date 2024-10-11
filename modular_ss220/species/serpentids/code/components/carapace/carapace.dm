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

/datum/component/carapace/Initialize(var/caller_limb, var/allow_self_medning, var/break_threshold, var/control_node = FALSE)
	..()
	limb = parent
	self_medning = allow_self_medning
	broken_treshold = break_threshold

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
	return ((limb.status & ORGAN_BROKEN) ? FALSE : CARAPACE_STOP_SURGERY_STEP)

//Проки, срабатываемые при получении или исцелении урона
/datum/component/carapace/proc/receive_damage(var/affected_limb, brute, burn, sharp, used_weapon = null, list/forbidden_limbs = list(), ignore_resists = FALSE, updating_health = TRUE)
	if(limb.get_damage() > broken_treshold)
		limb.fracture()
	if(limb.internal_organs.len > 0)
		var/obj/item/organ/internal/O = pick(limb.internal_organs)
		O.receive_damage(burn * limb.burn_dam)

/datum/component/carapace/proc/heal_damage(var/affected_limb, brute, burn, internal = 0, robo_repair = 0, updating_health = TRUE)
	if((limb.status & ORGAN_BROKEN) && limb.get_damage() == 0)
		if(self_medning)
			limb.mend_fracture()
		else if(prob(CARAPACE_HEAL_BROKEN_PROB))
			limb.mend_fracture()

//Расширение проков урона и лечения для обращения к компоненту
/obj/item/organ/external/receive_damage(brute, burn, sharp, used_weapon = null, list/forbidden_limbs = list(), ignore_resists = FALSE, updating_health = TRUE)
	. = ..()
	SEND_SIGNAL(src, COMSIG_CARAPACE_RECEIVE_DAMAGE, brute, burn, sharp, used_weapon, forbidden_limbs, ignore_resists, updating_health)
	return

/obj/item/organ/external/heal_damage(brute, burn, internal = 0, robo_repair = 0, updating_health = TRUE)
	. = ..()
	SEND_SIGNAL(src, COMSIG_CARAPACE_HEAL_DAMAGE, brute, burn, internal, robo_repair, updating_health)
	return


//////////////////////////////////////////////////////////////////
//					Хирургия для панциря						//
//////////////////////////////////////////////////////////////////
///Датумы для операций
/datum/surgery/carapace_break
	name = "Break carapace"
	steps = list(
		/datum/surgery_step/saw_carapace,
		/datum/surgery_step/cut_carapace,
		/datum/surgery_step/retract_carapace
	)

	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_GROIN)
	requires_organic_bodypart = TRUE

/datum/surgery/organ_manipulation/carapace
	name = "Organ manipulation"
	steps = list(
		/datum/surgery_step/open_encased/retract,
		/datum/surgery_step/proxy/manipulate_organs,
		/datum/surgery_step/internal/manipulate_organs/finish,
	)
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_GROIN)
	requires_organic_bodypart = TRUE

/datum/surgery/bone_repair/carapace
	name = "Carapace Repair"
	steps = list(
		/datum/surgery_step/glue_bone,
		/datum/surgery_step/set_bone,
		/datum/surgery_step/finish_bone,
		/datum/surgery_step/generic/cauterize
	)
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_GROIN)
	requires_organic_bodypart = TRUE

//Оверрайды для операций, которые могут применяться для панциря.
/datum/surgery/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if((SEND_SIGNAL(affected, COMSIG_CARAPACE_SURGERY_CAN_START) & CARAPACE_STOP_SURGERY_STEP) && !(affected.status & ORGAN_BROKEN))
		return FALSE
	if(src.type in CARAPACE_BLOCK_OPERATION)//отключить стандартные операции класса "манипуляция органов", восстановить кость.
		return FALSE
	. = .. ()

/datum/surgery/bone_repair/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if((SEND_SIGNAL(affected, COMSIG_CARAPACE_SURGERY_CAN_START) & CARAPACE_STOP_SURGERY_STEP))
		return FALSE

/datum/surgery/bone_repair/carapace/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if((SEND_SIGNAL(affected, COMSIG_CARAPACE_SURGERY_CAN_START) & CARAPACE_STOP_SURGERY_STEP) && (affected.status & ORGAN_BROKEN))
		return TRUE
	return FALSE

/datum/surgery/carapace_break/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if((SEND_SIGNAL(affected, COMSIG_CARAPACE_SURGERY_CAN_START) & CARAPACE_STOP_SURGERY_STEP) && !(affected.status & ORGAN_BROKEN))
		return TRUE
	return FALSE

/datum/surgery_step/generic/cut_open/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if((SEND_SIGNAL(affected, COMSIG_CARAPACE_SURGERY_CAN_START) & CARAPACE_STOP_SURGERY_STEP) && !(affected.status & ORGAN_BROKEN))
		user.visible_message("<span class='notice'>Эта конечность [target] покрыта крепким хитином. Сломайте его, прежде чем начать операцию .</span>")
		return SURGERY_BEGINSTEP_ABORT
	. = .. ()

/datum/surgery_step/retract_carapace/end_step(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if((SEND_SIGNAL(affected, COMSIG_CARAPACE_SURGERY_CAN_START) & CARAPACE_STOP_SURGERY_STEP) && !(affected.status & ORGAN_BROKEN))
		affected.fracture()
	. = .. ()

/datum/surgery_step/set_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if((SEND_SIGNAL(affected, COMSIG_CARAPACE_SURGERY_CAN_START) & CARAPACE_STOP_SURGERY_STEP) && !(affected.status & ORGAN_BROKEN))
		affected.mend_fracture()
	. = .. ()
