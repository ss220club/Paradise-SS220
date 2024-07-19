/datum/mind/proc/memory_edit_treacherous_flesh(mob/living/carbon/human/H)
	. = _memory_edit_header("treacherous flesh")
	if(H in SSticker.mode.ling_hosts)
		if(H.treacherous_flesh)
			. += "<b><font color='red'>INFESTED</font></b>|<a href='?src=[UID()];treacherous_flesh=infestor'>[H.treacherous_flesh.name]</a>|<a href='?src=[UID()];treacherous_flesh=leave'>no</a>"
		else
			. += "<b><font color='red'>INFESTED (Inactive)</font></b>|<a href='?src=[UID()];treacherous_flesh=play'>play as</a>|<a href='?src=[UID()];treacherous_flesh=clear'>no</a>"
	else
		. += "<a href='?src=[UID()];treacherous_flesh=infest'>infested</a>|<b>NO</b>"

	. += _memory_edit_role_enabled(ROLE_TREACHEROUS_FLESH)

/datum/mind/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return
	if(href_list["treacherous_flesh"])
		var/mob/living/carbon/human/host = src.current
		switch(href_list["treacherous_flesh"])
			if("leave")
				host.treacherous_flesh.disinfest()
			if("infest")
				var/obj/effect/mob_spawn/treacherous_flesh/spawner = new /obj/effect/mob_spawn/treacherous_flesh
				host.contents += spawner
				spawner.host = host
				SSticker.mode.ling_hosts += host
				var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_TREACHEOUS_FLESH]
				hud.add_to_hud(host)
				var/image/holder = host.hud_list[TREACHEOUS_FLESH_HUD]
				holder.icon_state = "infested_hud"
			if("infestor")
				usr.client.holder.show_player_panel(host.treacherous_flesh)
			if("play")
				for(var/obj/effect/mob_spawn/treacherous_flesh/spawner in host.contents)
					spawner.attack_ghost(usr)
					continue
			if("clear")
				for(var/obj/effect/mob_spawn/treacherous_flesh/spawner in host.contents)
					qdel(spawner)
				SSticker.mode.ling_hosts.Remove(host)
	. = ..()
