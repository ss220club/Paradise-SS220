#define COMSIG_IS_CONDITION_PASSED "is_condition_passed"
#define COMSIG_PICK_LEGENDARY_ITEM "pick_legendary_item"
#define COMPONENT_CONDITION_PASSED 1 << 0
#define COMPONENT_CONDITION_FAILED 0 << 0

/datum/component/condition_locked_pickup
	var/pickup_damage
	var/force = 20

/datum/component/condition_locked_pickup/Initialize(required_role, ckey_whitelist, pickup_damage = 0)
		src.pickup_damage = pickup_damage
		AddComponent(/datum/component/ckey_and_role_locked_pickup, _ckeys = ckey_whitelist, _required_role = required_role)

/datum/component/condition_locked_pickup/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, PROC_REF(try_pick_up))


/datum/component/condition_locked_pickup/proc/try_pick_up(obj/item/I, mob/living/user)

	if(!(SEND_SIGNAL(src, COMSIG_IS_CONDITION_PASSED) & COMPONENT_CONDITION_PASSED))
		user.Weaken(10 SECONDS)
		user.unEquip(I, force, silent = FALSE)
		to_chat(user, span_userdanger("Вы недостойны."))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(pickup_damage, pickup_damage * 2), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(pickup_damage, pickup_damage * 2))
	return

/datum/component/ckey_and_role_locked_pickup
	var/list/ckeys = list()
	var/required_role

/datum/component/ckey_and_role_locked_pickup/Initialize(list/_ckeys = list(), _required_role = null)
	ckeys = _ckeys
	required_role = _required_role
	RegisterSignal(parent, COMSIG_IS_CONDITION_PASSED, PROC_REF(check_requirements))

/datum/component/ckey_and_role_locked_pickup/proc/check_requirements()
	SIGNAL_HANDLER
	if(usr.client.ckey in ckeys)
		return COMPONENT_CONDITION_PASSED

	if(required_role in usr.mind.vars)
		if(usr.mind.vars[required_role])
			return COMPONENT_CONDITION_PASSED
	return COMPONENT_CONDITION_FAILED
