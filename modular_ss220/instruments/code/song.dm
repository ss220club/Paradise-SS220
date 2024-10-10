#define MUSIC_INTERVAL_TICK 0.01

/datum/song/sanitize_tempo(new_tempo)
	new_tempo = abs(new_tempo)
	var/result = clamp(round(new_tempo, MUSIC_INTERVAL_TICK), MUSIC_INTERVAL_TICK, 5 SECONDS)
	return result

/datum/song/ui_act(action, params)
	. = ..()
	switch(action)
		if("setbpm")
			set_bpm(round(text2num(params["new"]), 1))

/datum/song/set_bpm(bpm)
	tempo = sanitize_tempo(600 / bpm)
	SStgui.update_uis(parent)
