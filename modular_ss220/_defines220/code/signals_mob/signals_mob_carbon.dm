// Signals for /mob/living/carbon
/// вызывается через /datum/component/mob_overlay_shift/proc/shift_call(mob/living/carbon/human/mob) : (/datum/component/mob_overlay_shift)
#define COMSIG_MOB_ON_EQUIP "on_equip"
#define COMSIG_MOB_ON_CLICK "on_click"

/// вызывается через /datum/component/gadom_cargo/proc/block_operation() : (/datum/component/gadom_cargo) (/datum/component/gadom_living)
#define COMSIG_GADOM_CAN_GRAB "block_operation"
	#define GADOM_CAN_GRAB (1 << 0)

/// вызывается через datum/component/gadom_living/proc/try_load_mob()  : (/datum/component/gadom_cargo)
/// вызывается через datum/component/gadom_cargo/proc/try_load_cargo() : (/datum/component/gadom_living)
#define COMSIG_GADOM_LOAD "try_load"
