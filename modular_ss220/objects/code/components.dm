#define COMSIG_IS_CONDITION_PASSED "is_condition_passed"
#define COMSIG_PICK_LEGENDARY_ITEM "pick_legendary_item"

/datum/component/condition_locked_pickup

/datum/component/condition_locked_pickup/Initialize(required_role, ckey_whitelist)
	if(required_role)
		AddComponent(/datum/component/role_condition, _required_role = required_role)
		log_debug("Компонент для проверки роли добавлен")
	if(ckey_whitelist)
		AddComponent(/datum/component/ckey_condition, _ckeys = ckey_whitelist)
		log_debug("Компонент для проверки сикея добавлен")

/datum/component/condition_locked_pickup/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, PROC_REF(try_pick_up))
	log_debug("Сигнал зарегистрирован")

/datum/component/condition_locked_pickup/proc/try_pick_up(obj/item/I, mob/living/user)
	log_debug("Попытка поднять легендарный меч")
	log_debug("Родитель - [parent]")
	log_debug("src - [src]")
	log_debug("user - [user]")
	if(FALSE in SEND_SIGNAL(src, COMSIG_IS_CONDITION_PASSED, user))

		user.Weaken(10 SECONDS)
		user.unEquip(src, 24, silent = FALSE)
		to_chat(user, span_userdanger("Вы недостойны."))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(12, 24), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(12, 24))
	return

/datum/component/ckey_condition
	var/list/ckeys = list()

/datum/component/ckey_condition/Initialize(list/_ckeys = list())
	ckeys = _ckeys
	RegisterSignal(parent, COMSIG_IS_CONDITION_PASSED, PROC_REF(check_ckey))

/datum/component/ckey_condition/proc/check_ckey(mob/living/user)
	log_debug("check_ckey: Родитель - [parent]")
	log_debug("check_ckey: src - [src]")
	log_debug("check_ckey: user - [user]")
	if(user.client.ckey in ckeys)
		log_debug("Сикей валиден")
		return TRUE
	return FALSE

/datum/component/role_condition
	var/required_role

/datum/component/role_condition/Initialize(_required_role = null)
	required_role = _required_role
	RegisterSignal(parent, COMSIG_IS_CONDITION_PASSED, PROC_REF(check_role))

/datum/component/role_condition/proc/check_role(mob/living/user)
	log_debug("check_role: Родитель - [parent]")
	log_debug("check_role: src - [src]")
	log_debug("check_role: user - [user]")
	if(required_role in user.mind.vars)
		log_debug("Роль валидна")
		return user.mind.vars[required_role]
	return FALSE
