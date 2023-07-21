/datum/tts_provider/silero
	name = "Silero"
	is_enabled = TRUE
	api_url = "http://s2.ss220.club:9999/voice"

/datum/tts_provider/silero/vv_edit_var(var_name, var_value)
	. = ..()
	if(var_name == "api_url")
		return FALSE

/datum/tts_provider/silero/send_request(list/req_body, datum/callback/proc_callback)
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_POST, json_encode(req_body), list("content-type" = "application/json"))
	spawn(0)
		request.begin_async()
		UNTIL(request.is_complete())
		var/datum/http_response/response = request.into_response()
		proc_callback.Invoke(response)

/datum/tts_provider/silero/request(text, datum/tts_seed/silero/seed, datum/callback/proc_callback)
	if(throttle_check())
		return FALSE

	var/ssml_text = {"<speak>[text]</speak>"}

	var/list/req_body = list()
	req_body["api_token"] = GLOB.configuration.tts.tts_token_silero
	req_body["text"] = ssml_text
	req_body["sample_rate"] = 24000
	req_body["ssml"] = TRUE
	req_body["speaker"] = seed.value
	req_body["lang"] = "ru"
	req_body["remote_id"] = "[world.port]"
	req_body["put_accent"] = TRUE
	req_body["put_yo"] = FALSE
	req_body["symbol_durs"] = list()
	req_body["format"] = "ogg"
	req_body["word_ts"] = FALSE

	INVOKE_ASYNC(src, PROC_REF(send_request), req_body, proc_callback)

	return TRUE

/datum/tts_provider/silero/process_response(datum/http_response/response)
	var/data = json_decode(response.body)
	// log_debug(response.body)

	if(data["timings"]["003_tts_time"] > 3)
		is_throttled = TRUE
		throttled_until = world.time + 15 SECONDS

	return data["results"][1]["audio"]

	//var/sha1 = data["original_sha1"]

/datum/tts_provider/silero/pitch_whisper(text)
	return {"<prosody pitch="x-low">[text]</prosody>"}

/datum/tts_provider/silero/rate_faster(text)
	return {"<prosody rate="fast">[text]</prosody>"}

/datum/tts_provider/silero/rate_medium(text)
	return {"<prosody rate="medium">[text]</prosody>"}
