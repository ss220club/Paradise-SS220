/datum/mind/proc/memory_edit_changeling_primalis(mob/living/carbon/human/H)
	. = _memory_edit_header("changeling primalis")
	if(H in SSticker.mode.ling_hosts)
		. += "<b><font color='red'>INFESTED</font></b>|<a href='?src=[UID()];changeling_primalis=infestor'>[H.changeling_primalis.name]</a>|<a href='?src=[UID()];changeling_primalis=leave'>no</a>"
	else
		. += "<a href='?src=[UID()];changeling_primalis=infest'>infested</a>|<b>NO</b>"

	. += _memory_edit_role_enabled(ROLE_CHANGELING_PRIMALIS)

/datum/mind/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return
	if(href_list["changeling_primalis"])
		var/mob/living/carbon/human/host = src.current
		switch(href_list["changeling_primalis"])
			if("leave")
				host.changeling_primalis.disinfest()
			if("infest")
				var/mob/living/simple_animal/changeling_primalis/ling
				switch(alert("Кто будет играть генокрадом-прималис?", "Кто?", "Выбрать", "Предложить гостам", "Никто"))
					if("Выбрать")
						var/list/mob/dead/observer/candidates = list()
						for(var/mob/dead/observer/C in GLOB.player_list)
							candidates.Add(C)
						var/mob/dead/observer/chosen_one = input("Кто будет играть генокрадом-прималис?", "Кто?") as null|anything in candidates
						if(chosen_one)
							ling = new /mob/living/simple_animal/changeling_primalis(host.loc)
							ling.infest(host)
							ling.key = chosen_one.key
							qdel(chosen_one)
						else
							to_chat(usr, span_warning("No candidates found"))
					if("Предложить гостам")
						ling = new /mob/living/simple_animal/changeling_primalis(host.loc)
						ling.infest(host)
						var/mob/dead/observer/chosen_one = (SSghost_spawns.poll_candidates(question = "Вы хотите поиграть за генокрада-прималис?", role = ROLE_CHANGELING_PRIMALIS, antag_age_check = 1, poll_time = 10 SECONDS, source = ling))
						if(chosen_one)
							ling.key = chosen_one.key
							qdel(chosen_one)
						else
							to_chat(usr, span_warning("No candidates found"))
					if("Никто")
						ling = new /mob/living/simple_animal/changeling_primalis(host.loc)
						ling.infest(host)
			if("infestor")
				usr.client.holder.show_player_panel(host.changeling_primalis)
	. = ..()
