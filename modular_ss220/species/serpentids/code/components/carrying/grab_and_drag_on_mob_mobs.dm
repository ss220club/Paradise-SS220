/*
=== Перенос мобов ===
Компонент для переноса мобов на мобах. Срабатывает в случае граб-интента, драг-энд-дропа моба на модель (аля стул)
*/

#define COMSIG_GADOM_MOB_LOAD "try_load_mob"
#define COMSIG_GADOM_MOB_UNLOAD "try_unload_mob"

#define COMSIG_GADOM_MOB_CAN_GRAB "block_operation"
	#define GADOM_MOB_ALLOW_TO_GRAB (1<<0)

/mob/living/carbon/human
	var/atom/movable/loaded = null
	var/mob/living/passenger = null

/datum/component/gadom_living
	var/mob/living/carbon/human/carrier = null
	var/list/allowed_races = list(/datum/species/serpentid)

/datum/component/gadom_living/Initialize()
	..()
	carrier = parent

/datum/component/gadom_living/RegisterWithParent()
	RegisterSignal(parent, COMSIG_GADOM_MOB_LOAD, PROC_REF(try_load_mob))
	RegisterSignal(parent, COMSIG_GADOM_MOB_UNLOAD, PROC_REF(try_unload_mob))
	RegisterSignal(parent, COMSIG_GADOM_MOB_CAN_GRAB, PROC_REF(block_operation))

/datum/component/gadom_living/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_GADOM_MOB_LOAD)
	UnregisterSignal(parent, COMSIG_GADOM_MOB_UNLOAD)
	UnregisterSignal(parent, COMSIG_GADOM_MOB_CAN_GRAB)

/datum/component/gadom_living/proc/block_operation(datum/component_holder)
	SIGNAL_HANDLER
	var/datum/dna/genetic_info = carrier.dna
	var/datum/species/spiece = genetic_info.species
	var/signal_result = (((carrier.a_intent != "grab") && (spiece.type in allowed_races)) ? FALSE : GADOM_MOB_ALLOW_TO_GRAB)
	return signal_result

/datum/component/gadom_living/proc/try_load_mob(datum/component_holder, mob/user, mob/target)
	var/mob/living/carbon/human/puppet = component_holder
	var/datum/dna/genetic_info = carrier.dna
	var/datum/species/spiece = genetic_info.species
	if(user.incapacitated() || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) || get_dist(user, puppet) > 1)
		return
	if(!istype(target))
		return
	if(do_after(puppet, 20 * puppet.dna.species.action_mult, FALSE, target))
		load(puppet, target)


/datum/component/gadom_living/proc/load(mob/living/carbon/human/puppet, atom/movable/AM)
	if(carrier.loaded|| AM.anchored || get_dist(puppet, AM) > 1)
		return

	if(!isitem(AM) && !ismachinery(AM) && !isstructure(AM) && !ismob(AM))
		return
	if(!isturf(AM.loc))
		return

	if(isliving(AM))
		if(!load_mob(AM))
			return

	carrier.loaded = AM
	carrier.update_icon()

/datum/component/gadom_living/proc/load_mob(mob/living/M)
	carrier.can_buckle = TRUE
	carrier.buckle_lying = FALSE
	if(carrier.buckle_mob(M))
		carrier.passenger = M
		carrier.loaded = M
		carrier.can_buckle = FALSE

		return TRUE
	return FALSE

/datum/component/gadom_living/proc/try_unload_mob(mob/user)
	SIGNAL_HANDLER
	if(!carrier.passenger)
		return

	carrier.loaded = null
	carrier.passenger = null
	carrier.unbuckle_all_mobs()
	carrier.can_buckle = TRUE
	carrier.update_icon(UPDATE_OVERLAYS)

//Обновление при отстегивании для восстановления слоя моба
/mob/living/carbon/human/post_unbuckle_mob(mob/living/M)
	.=..()
	loaded = null
	passenger = null
	M.layer = initial(M.layer)
	M.pixel_y = initial(M.pixel_y)

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
	var/signal_call	= SEND_SIGNAL(usr, COMSIG_GADOM_MOB_CAN_GRAB)
	if(signal_call & GADOM_MOB_ALLOW_TO_GRAB)
		SEND_SIGNAL(usr, COMSIG_GADOM_MOB_LOAD, usr, src)
		return
	. = .. ()

/datum/species/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	var/signal_call	= SEND_SIGNAL(usr, COMSIG_GADOM_MOB_CAN_GRAB)
	if((signal_call & GADOM_MOB_ALLOW_TO_GRAB) && H.loaded)
		SEND_SIGNAL(H, COMSIG_GADOM_MOB_UNLOAD, M)
	. = .. ()


