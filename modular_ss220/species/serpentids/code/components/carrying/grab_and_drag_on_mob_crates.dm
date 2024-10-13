/*
=== Перенос ящиков ===
Компонент для переноса ящиков карго на мобах. Срабатывает в случае граб-интента, драг-энд-дропа ящика на модель
*/

#define COMSIG_GADOM_UNMOB_LOAD "try_load_cargo"
#define COMSIG_GADOM_UNMOB_UNLOAD "try_unload_cargo"

#define COMSIG_GADOM_UNMOB_CAN_GRAB "block_operation"
#define GADOM_UNMOB_ALLOW_TO_GRAB (1<<0)

//Для отслеживания кто несет объект
/atom/movable
	var/mob/living/carbon/human/crate_carrying_person = null

//Для расширения движения (иначе возникает графический глич и ящик пропадает при движении)
/atom/movable/Move(atom/newloc, direct = 0, movetime)
	. = .. ()
	var/mob/living/carbon/human/puppet = src
	if(ishuman(puppet))
		if(!isnull(puppet.loaded))
			puppet.loaded.forceMoveCrate(puppet)

//Клонированый и изменны прок движения, чтобы не трогать основной
/atom/movable/proc/forceMoveCrate(atom/destination)
	var/turf/old_loc = loc
	loc = destination.loc //изменение здесь (добавлено .loc)
	moving_diagonally = 0

	if(old_loc)
		old_loc.Exited(src, destination)
		for(var/atom/movable/AM in old_loc)
			AM.Uncrossed(src)

	if(destination)
		destination.Entered(src)
		for(var/atom/movable/AM in destination)
			if(AM == src)
				continue
			AM.Crossed(src, old_loc)
		var/turf/oldturf = get_turf(old_loc)
		var/turf/destturf = get_turf(destination)
		var/old_z = (oldturf ? oldturf.z : null)
		var/dest_z = (destturf ? destturf.z : null)
		if(old_z != dest_z)
			onTransitZ(old_z, dest_z)


	Moved(old_loc, NONE)

	return TRUE

/datum/component/gadom_cargo
	var/mob/living/carbon/human/carrier = null
	var/list/allowed_races = list(/datum/species/serpentid)

/datum/component/gadom_cargo/Initialize()
	..()
	carrier = parent

/datum/component/gadom_cargo/RegisterWithParent()
	RegisterSignal(parent, COMSIG_GADOM_UNMOB_LOAD, PROC_REF(try_load_cargo))
	RegisterSignal(parent, COMSIG_GADOM_UNMOB_UNLOAD, PROC_REF(try_unload_cargo))
	RegisterSignal(parent, COMSIG_GADOM_UNMOB_CAN_GRAB, PROC_REF(block_operation))

/datum/component/gadom_cargo/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_GADOM_UNMOB_LOAD)
	UnregisterSignal(parent, COMSIG_GADOM_UNMOB_UNLOAD)
	UnregisterSignal(parent, COMSIG_GADOM_UNMOB_CAN_GRAB)

/datum/component/gadom_cargo/proc/block_operation()
	SIGNAL_HANDLER
	return GADOM_UNMOB_ALLOW_TO_GRAB

/datum/component/gadom_cargo/proc/try_load_cargo(datum/component_holder, mob/user, atom/movable/AM)
	var/datum/species/spiece = user.dna.species
	if((user.a_intent == "grab") && (spiece.type in allowed_races))
		if(user.incapacitated() || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) || get_dist(user, AM) > 1)
			return
		if(!istype(AM))
			return
		if(!do_after(user, 20 * user.dna.species.action_mult, FALSE, AM))
			return
		load(AM)

/datum/component/gadom_cargo/proc/load(atom/movable/AM)
	if(carrier.loaded || AM.anchored || get_dist(carrier, AM) > 1)
		return

	if(!isitem(AM) && !ismachinery(AM) && !isstructure(AM) && !ismob(AM))
		return
	if(!isturf(AM.loc))
		return

	var/obj/structure/closet/crate/holding_crate
    if(istype(AM,/obj/structure/closet/crate))
        holding_crate = AM
        if(holding_crate)
            holding_crate.close()

	if(isobj(AM))
		var/obj/O = AM
		if(O.has_buckled_mobs() || (locate(/mob) in AM))
			return

	if(!isliving(AM))
		AM.crate_carrying_person = carrier
		//AM.forceMove(carrier) - //блокировка стандартного прока
		AM.forceMoveCrate(carrier)

	carrier.loaded = AM
	carrier.update_icon()

/datum/component/gadom_cargo/proc/try_unload_cargo()
	var/dirn = carrier.dir
	if(!carrier.loaded)
		return

	if(carrier.loaded)
        carrier.loaded.forceMove(carrier.loc)
        carrier.loaded.pixel_y = initial(carrier.loaded.pixel_y)
        carrier.loaded.layer = initial(carrier.loaded.layer)
        carrier.loaded.plane = initial(carrier.loaded.plane)
        if(dirn)
            var/turf/T = carrier.loc
            var/turf/newT = get_step(T,dirn)
            if(carrier.loaded.CanPass(carrier.loaded, newT))
                step(carrier.loaded, dirn)
        carrier.loaded.crate_carrying_person = null
        carrier.loaded = null
    carrier.update_icon(UPDATE_OVERLAYS)

//Расширение прока для переноса ящика на моба
/mob/living/carbon/human/MouseDrop_T(atom/movable/AM, mob/user)
	if(SEND_SIGNAL(usr, COMSIG_GADOM_UNMOB_CAN_GRAB) & GADOM_UNMOB_ALLOW_TO_GRAB)
		SEND_SIGNAL(usr, COMSIG_GADOM_UNMOB_LOAD, usr, AM)
	. = .. ()

//Расширение прока на отстегивание ящика
/datum/species/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if(SEND_SIGNAL(H, COMSIG_GADOM_UNMOB_CAN_GRAB) & GADOM_UNMOB_ALLOW_TO_GRAB && H.loaded)
		SEND_SIGNAL(H, COMSIG_GADOM_UNMOB_UNLOAD, M)
	. = .. ()
