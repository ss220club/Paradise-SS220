/datum/tts_provider/white_dream
	name = "White Dream"
	is_enabled = TRUE
	api_url = "https://pubtts.ss14.su/api/v1/tts"
	skipExplicitFileSave = TRUE

/datum/tts_provider/white_dream/vv_edit_var(var_name, var_value)
	if(var_name == "api_url")
		return FALSE
	return ..()

/datum/tts_provider/white_dream/request(text, datum/tts_seed/white_dream/seed, datum/callback/proc_callback, fileName)
	if(throttle_check())
		return FALSE

	var/ssml_text = {"[text]"}

	var/requestQuery = {"speaker=[seed.value]&ext=ogg&text=[url_encode(ssml_text)]"}

	SShttp.create_async_request(RUSTG_HTTP_METHOD_GET, {"[api_url]?[requestQuery]"}, "", list("content-type" = "application/json", "Authorization" = {"Bearer [GLOB.configuration.tts.tts_token_white_dream]"}), proc_callback, fileName)

	return TRUE

/datum/tts_provider/white_dream/process_response(datum/http_response/response)
	return "voice"

/datum/tts_provider/white_dream/pitch_whisper(text)
	return {"[text]"}

/datum/tts_provider/white_dream/rate_faster(text)
	return {"[text]"}

/datum/tts_provider/white_dream/rate_medium(text)
	return {"[text]"}
