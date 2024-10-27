// Signals for /mob/living/carbon
#define COMSIG_MOB_ON_EQUIP "on_equip"
#define COMSIG_MOB_ON_CLICK "on_click"

#define COMSIG_GADOM_CAN_GRAB "block_operation"
	#define GADOM_CAN_GRAB (1 << 0)

#define COMSIG_GADOM_LOAD "try_load"

//Расширение прока для переноса ящика на моба
/mob/living/carbon/human/MouseDrop_T(atom/movable/AM, mob/user)
	if(SEND_SIGNAL(usr, COMSIG_GADOM_CAN_GRAB) & GADOM_CAN_GRAB)
		SEND_SIGNAL(usr, COMSIG_GADOM_LOAD, usr, AM)
	. = .. ()

//Расширение для пристегивания моба
/mob/MouseDrop(mob/M as mob, src_location, over_location, src_control, over_control, params)
	if((M != usr) || !istype(M))
		..()
		return
	if(usr == src)
		return
	if(!Adjacent(usr))
		return
	if(IsFrozen(src) && !is_admin(usr))
		to_chat(usr, "<span class='boldannounceic'>Interacting with admin-frozen players is not permitted.</span>")
		return
	if((SEND_SIGNAL(usr, COMSIG_GADOM_CAN_GRAB) & GADOM_CAN_GRAB))
		SEND_SIGNAL(usr, COMSIG_GADOM_LOAD, usr, src)
		return
	. = .. ()
