SUBSYSTEM_DEF(gpt220)
	name = "GPT 220"
	init_order = INIT_ORDER_DEFAULT
	wait = 1 SECONDS
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

/datum/controller/subsystem/gpt220/Initialize()
	return

/datum/controller/subsystem/gpt220/fire(resumed = FALSE)
	return

/datum/controller/subsystem/gpt220/proc/request_completition(system_message, prompt, datum/callback/callback)
	var/endpoint = GLOB.configuration.gpt.endpoint
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
		"model" = GLOB.configuration.gpt.model
	))
	var/list/headers = list(
		"content-type" = "application/json",
		"authorization" = "Bearer [GLOB.configuration.gpt.access_token]"
	)

	SShttp.create_async_request(RUSTG_HTTP_METHOD_POST, endpoint, body, headers, callback)
