
// --------------------------------------------------------------------------------
// --------------------- TERROR SPIDERS: MISC AI CODE -----------------------------
// --------------------------------------------------------------------------------

/mob/living/simple_animal/hostile/poison/terror_spider/proc/UnlockBlastDoors(target_id_tag)
	for(var/obj/machinery/door/poddoor/P in GLOB.airlocks)
		if(P.density && P.id_tag == target_id_tag && P.z == z && !P.operating)
			P.open()
