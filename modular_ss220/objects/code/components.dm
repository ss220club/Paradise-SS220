#define COMSIG_IS_CONDITION_PASSED "is_condition_passed"
#define COMSIG_PICK_LEGENDARY_ITEM "pick_legendary_item"
#define COMPONENT_CONDITION_PASSED 1 << 0

/datum/component/condition_locked_pickup
	var/pickup_damage

/datum/component/condition_locked_pickup/Initialize(required_role, ckey_whitelist, pickup_damage = 0)
		src.pickup_damage = pickup_damage
		AddComponent(/datum/component/pass_condition, _ckeys = ckey_whitelist, _required_role = required_role)

/datum/component/condition_locked_pickup/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, PROC_REF(try_pick_up))


/datum/component/condition_locked_pickup/proc/try_pick_up(obj/item/I, mob/living/user)
	SIGNAL_HANDLER
	if(!(SEND_SIGNAL(src, COMSIG_IS_CONDITION_PASSED, user) & COMPONENT_CONDITION_PASSED))
		user.Weaken(10 SECONDS)
		user.unEquip(src, pickup_damage, silent = FALSE)
		to_chat(user, span_userdanger("Вы недостойны."))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(pickup_damage, pickup_damage * 2), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(pickup_damage, pickup_damage * 2))
	return

/datum/component/pass_condition
	var/list/ckeys = list()
	var/required_role

/datum/component/pass_condition/Initialize(list/_ckeys = list(), _required_role = null)
	ckeys = _ckeys
	required_role = _required_role
	RegisterSignal(parent, COMSIG_IS_CONDITION_PASSED, PROC_REF(check_requirements))

/datum/component/pass_condition/proc/check_requirements(mob/living/user)
	SIGNAL_HANDLER
	if(user.client.ckey in ckeys || user.mind.vars[required_role])
		return COMPONENT_CONDITION_PASSED

