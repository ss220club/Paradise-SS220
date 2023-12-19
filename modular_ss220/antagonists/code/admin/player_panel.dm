/datum/admins/check_antagonists()
	if(!check_rights(R_ADMIN))
		return
	if(SSticker && SSticker.current_state >= GAME_STATE_PLAYING)
		var/dat = "<html><meta charset='utf-8'><head><title>Round Status</title></head><body><h1><B>Round Status</B></h1>"
		dat += "Current Game Mode: <B>[SSticker.mode.name]</B><BR>"
		dat += "Round Duration: <B>[round(ROUND_TIME / 36000)]:[add_zero(num2text(ROUND_TIME / 600 % 60), 2)]:[add_zero(num2text(ROUND_TIME / 10 % 60), 2)]</B><BR>"
		dat += "<B>Emergency shuttle</B><BR>"
		if(SSshuttle.emergency.mode < SHUTTLE_CALL)
			dat += "<a href='?src=[UID()];call_shuttle=1'>Call Shuttle</a><br>"
		else
			var/timeleft = SSshuttle.emergency.timeLeft()
			if(SSshuttle.emergency.mode < SHUTTLE_DOCKED)
				dat += "ETA: <a href='?_src_=holder;edit_shuttle_time=1'>[seconds_to_full_clock(timeleft)]</a><br>"
				dat += "<a href='?_src_=holder;call_shuttle=2'>Send Back</a><br>"
			else
				dat += "ETA: <a href='?_src_=holder;edit_shuttle_time=1'>[seconds_to_full_clock(timeleft)]</a><br>"

		dat += "<a href='?src=[UID()];delay_round_end=1'>[SSticker.delay_end ? "End Round Normally" : "Delay Round End"]</a><br>"
		dat += "<br><b>Antagonist Teams</b><br>"
		dat += "<a href='?src=[UID()];check_teams=1'>View Teams</a><br>"
		if(SSticker.mode.syndicates.len)
			dat += "<br><table cellspacing=5><tr><td><B>Syndicates</B></td><td></td></tr>"
			for(var/datum/mind/N in SSticker.mode.syndicates)
				var/mob/M = N.current
				if(M)
					dat += check_antagonists_line(M)
				else
					dat += "<tr><td><i>Nuclear Operative not found!</i></td></tr>"
			dat += "</table><br><table><tr><td><B>Nuclear Disk(s)</B></td></tr>"
			for(var/obj/item/disk/nuclear/N in GLOB.poi_list)
				dat += "<tr><td>[N.name], "
				var/atom/disk_loc = N.loc
				while(!isturf(disk_loc))
					if(ismob(disk_loc))
						var/mob/M = disk_loc
						dat += "carried by <a href='?src=[UID()];adminplayeropts=[M.UID()]'>[M.real_name]</a> "
					if(isobj(disk_loc))
						var/obj/O = disk_loc
						dat += "in \a [O.name] "
					disk_loc = disk_loc.loc
				dat += "in [disk_loc.loc] at ([disk_loc.x], [disk_loc.y], [disk_loc.z])</td></tr>"
			dat += "</table>"

		if(SSticker.mode.rev_team)
			dat += "<br><table cellspacing=5><tr><td><B>Revolutionaries</B></td><td></td></tr>"
			for(var/datum/mind/N in SSticker.mode.head_revolutionaries)
				var/mob/M = N.current
				if(!M)
					dat += "<tr><td><i>Head Revolutionary not found!</i></td></tr>"
				else
					dat += check_antagonists_line(M, "(leader)")
			for(var/datum/mind/N in SSticker.mode.revolutionaries)
				var/mob/M = N.current
				if(M)
					dat += check_antagonists_line(M)
			dat += "</table><table cellspacing=5><tr><td><B>Target(s)</B></td><td></td><td><B>Location</B></td></tr>"
			for(var/datum/mind/N in SSticker.mode.get_living_heads())
				var/mob/M = N.current
				if(M)
					dat += check_antagonists_line(M)
					var/turf/mob_loc = get_turf(M)
					dat += "<td>[mob_loc.loc]</td></tr>"
				else
					dat += "<tr><td><i>Head not found!</i></td></tr>"
			dat += "</table>"


		if(SSticker.mode.blob_overminds.len)
			dat += check_role_table("Blob Overminds", SSticker.mode.blob_overminds)
			dat += "<i>Blob Tiles: [length(GLOB.blobs)]</i>"

		if(SSticker.mode.changelings.len)
			dat += check_role_table("Changelings", SSticker.mode.changelings)

		if(SSticker.mode.wizards.len)
			dat += check_role_table("Wizards", SSticker.mode.wizards)

		if(SSticker.mode.apprentices.len)
			dat += check_role_table("Apprentices", SSticker.mode.apprentices)

		if(SSticker.mode.cult.len)
			var/datum/game_mode/gamemode = SSticker.mode
			var/datum/objective/current_sac_obj = gamemode.cult_objs.current_sac_objective()
			dat += check_role_table("Cultists", SSticker.mode.cult)
			if(current_sac_obj)
				dat += "<br>Current cult objective: <br>[current_sac_obj.explanation_text]"
			else if(gamemode.cult_objs.cult_status == NARSIE_NEEDS_SUMMONING)
				dat += "<br>Current cult objective: Summon [SSticker.cultdat ? SSticker.cultdat.entity_name : "Nar'Sie"]"
			else if(gamemode.cult_objs.cult_status == NARSIE_HAS_RISEN)
				dat += "<br>Current cult objective: Feed [SSticker.cultdat ? SSticker.cultdat.entity_name : "Nar'Sie"]"
			else if(gamemode.cult_objs.cult_status == NARSIE_HAS_FALLEN)
				dat += "<br>Current cult objective: Kill all non-cultists"
			else
				dat += "<br>Current cult objective: None! (This is most likely a bug, or var editing gone wrong.)"
			dat += "<br>Sacrifice objectives completed: [gamemode.cult_objs.sacrifices_done]"
			dat += "<br>Sacrifice objectives needed for summoning: [gamemode.cult_objs.sacrifices_required]"
			dat += "<br>Summoning locations: [english_list(gamemode.cult_objs.obj_summon.summon_spots)]"
			dat += "<br><a href='?src=[UID()];cult_mindspeak=[UID()]'>Cult Mindspeak</a>"

			if(gamemode.cult_objs.cult_status == NARSIE_DEMANDS_SACRIFICE)
				dat += "<br><a href='?src=[UID()];cult_adjustsacnumber=[UID()]'>Modify amount of sacrifices required</a>"
				dat += "<br><a href='?src=[UID()];cult_newtarget=[UID()]'>Reroll sacrifice target</a>"
			else
				dat += "<br>Modify amount of sacrifices required (Summon available!)</a>"
				dat += "<br>Reroll sacrifice target (Summon available!)</a>"

			dat += "<br><a href='?src=[UID()];cult_newsummonlocations=[UID()]'>Reroll summoning locations</a>"
			dat += "<br><a href='?src=[UID()];cult_unlocknarsie=[UID()]'>Unlock Nar'Sie summoning</a>"

		if(SSticker.mode.traitors.len)
			dat += check_role_table("Traitors", SSticker.mode.traitors)

		if(SSticker.mode.blood_brothers.len)
			dat += check_role_table("Blood Brothers", SSticker.mode.blood_brothers)

		if(SSticker.mode.implanted.len)
			dat += check_role_table("Mindslaves", SSticker.mode.implanted)

		if(SSticker.mode.abductors.len)
			dat += check_role_table("Abductors", SSticker.mode.abductors)

		if(SSticker.mode.abductees.len)
			dat += check_role_table("Abductees", SSticker.mode.abductees)

		if(SSticker.mode.vampires.len)
			dat += check_role_table("Vampires", SSticker.mode.vampires)

		if(SSticker.mode.vampire_enthralled.len)
			dat += check_role_table("Vampire Thralls", SSticker.mode.vampire_enthralled)

		if(SSticker.mode.xenos.len)
			dat += check_role_table("Xenos", SSticker.mode.xenos)

		if(SSticker.mode.superheroes.len)
			dat += check_role_table("Superheroes", SSticker.mode.superheroes)

		if(SSticker.mode.supervillains.len)
			dat += check_role_table("Supervillains", SSticker.mode.supervillains)

		if(SSticker.mode.greyshirts.len)
			dat += check_role_table("Greyshirts", SSticker.mode.greyshirts)

		if(SSticker.mode.eventmiscs.len)
			dat += check_role_table("Event Roles", SSticker.mode.eventmiscs)

		if(GLOB.ts_spiderlist.len)
			var/list/spider_minds = list()
			for(var/mob/living/simple_animal/hostile/poison/terror_spider/S in GLOB.ts_spiderlist)
				if(S.ckey)
					spider_minds += S.mind
			if(spider_minds.len)
				dat += check_role_table("Terror Spiders", spider_minds)

				var/count_eggs = 0
				var/count_spiderlings = 0
				var/count_infected = 0
				for(var/obj/structure/spider/eggcluster/terror_eggcluster/E in GLOB.ts_egg_list)
					if(is_station_level(E.z))
						count_eggs += E.spiderling_number
				for(var/obj/structure/spider/spiderling/terror_spiderling/L in GLOB.ts_spiderling_list)
					if(!L.stillborn && is_station_level(L.z))
						count_spiderlings += 1
				count_infected = length(GLOB.ts_infected_list)
				dat += "<table cellspacing=5><tr><td>Growing TS on-station: [count_eggs] egg\s, [count_spiderlings] spiderling\s, [count_infected] infected</td></tr></table>"

		if(SSticker.mode.ert.len)
			dat += check_role_table("ERT", SSticker.mode.ert)

		//list active security force count, so admins know how bad things are
		var/list/sec_list = check_active_security_force()
		dat += "<br><table cellspacing=5><tr><td><b>Security</b></td><td></td></tr>"
		dat += "<tr><td>Total: </td><td>[sec_list[1]]</td>"
		dat += "<tr><td>Active: </td><td>[sec_list[2]]</td>"
		dat += "<tr><td>Dead: </td><td>[sec_list[3]]</td>"
		dat += "<tr><td>Antag: </td><td>[sec_list[4]]</td>"
		dat += "</table>"

		dat += "</body></html>"
		usr << browse(dat, "window=roundstatus;size=400x500")
	else
		alert("The game hasn't started yet!")
