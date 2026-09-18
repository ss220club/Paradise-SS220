/*
/proc/kill_everyone_on_station(override = null)
    for(var/mob/M in GLOB.mob_list)
        if(M.stat != DEAD)
            var/turf/T = get_turf(M)
            if(T && is_station_level(T.z) && !istype(M.loc, /obj/structure/closet/secure_closet/freezer) && !(issilicon(M) && override == "AI malfunction"))
                to_chat(M, SPAN_DANGER("The blast wave tears you atom from atom!"))
                M.ghostize()
                M.dust()
                CHECK_TICK
*/
