SUBSYSTEM_DEF(gpt220)
	name = "GPT 220"
	flags = SS_NO_FIRE | SS_NO_INIT

/datum/controller/subsystem/gpt220/proc/request_completition(system_message, prompt, datum/callback/callback)
	var/endpoint = GLOB.configuration.gpt_configuration.endpoint
	var/list/body = json_encode(list(
		"messages" = list(
			list(
				"role" = "system",
				"content" = system_message
			),
			list(
				"role" = "user",
				"content" = prompt
			)
		),
		"temperature" = 1,
		"top_p" = 1,
		"max_tokens" = 100,
		"model" = GLOB.configuration.gpt_configuration.model
	))
	var/list/headers = list(
		"content-type" = "application/json",
		"authorization" = "Bearer [GLOB.configuration.gpt_configuration.access_token]"
	)

	SShttp.create_async_request(RUSTG_HTTP_METHOD_POST, endpoint, body, headers, callback)
