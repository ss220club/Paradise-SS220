/*
=== Перенос ящиков ===
Компонент для переноса ящиков карго на мобах. Срабатывает в случае граб-интента, драг-энд-дропа ящика на модель
*/
//Для отслеживания кто несет объект
/atom/movable
	var/mob/living/carbon/human/crate_carrying_person = null

//Для расширения движения (иначе возникает графический глич и ящик пропадает при движении)
/mob/living/carbon/human/Move(NewLoc, direct)
	. = .. ()
	var/mob/living/carbon/human/puppet = src
	if(puppet.loaded)
		puppet.loaded.forceMove(puppet.loc)

/datum/component/gadom_cargo
	var/mob/living/carbon/human/carrier = null

/datum/component/gadom_cargo/Initialize()
	..()
	carrier = parent

/datum/component/gadom_cargo/RegisterWithParent()
	RegisterSignal(parent, COMSIG_GADOM_LOAD, PROC_REF(try_load_cargo))
	RegisterSignal(parent, COMSIG_GADOM_UNLOAD, PROC_REF(try_unload_cargo))
	RegisterSignal(parent, COMSIG_GADOM_CAN_GRAB, PROC_REF(block_operation))

/datum/component/gadom_cargo/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_GADOM_LOAD)
	UnregisterSignal(parent, COMSIG_GADOM_UNLOAD)
	UnregisterSignal(parent, COMSIG_GADOM_CAN_GRAB)

/datum/component/gadom_cargo/proc/block_operation()
	SIGNAL_HANDLER
	return carrier.a_intent == "grab" ? GADOM_CAN_GRAB : FALSE

/datum/component/gadom_cargo/proc/try_load_cargo(datum/component_holder, mob/user, atom/movable/AM)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(pre_load), component_holder, user, AM)

/datum/component/gadom_cargo/proc/pre_load(datum/component_holder, mob/user, mob/AM)
	if(user.a_intent == "grab")
		if(user.incapacitated() || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) || get_dist(user, AM) > 1)
			return
		if(!istype(AM, /obj/structure/closet/crate/))
			return
		if(!do_after(user, GADOM_BASIC_LOAD_TIMER * user.dna.species.action_mult, FALSE, AM))
			return
		load(AM)

/datum/component/gadom_cargo/proc/load(atom/movable/AM)
	if(carrier.loaded || carrier.passenger || AM.anchored || get_dist(carrier, AM) > 1)
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
		AM.forceMove(carrier.loc)

	carrier.loaded = AM
	carrier.update_icon()
	carrier.throw_alert("serpentid_holding", /atom/movable/screen/alert/carrying)

/datum/component/gadom_cargo/proc/try_unload_cargo()
	SIGNAL_HANDLER
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
		carrier.clear_alert("serpentid_holding")
	carrier.update_icon(UPDATE_OVERLAYS)
