#define CHAT_MESSAGE_APPROX_LHEIGHT	11
#define CHAT_MESSAGE_EOL_FADE		(0.7 SECONDS)
#define CHAT_MESSAGE_SPAWN_TIME		(0.2 SECONDS)
#define CHAT_MESSAGE_EXP_DECAY		0.7
#define CHAT_MESSAGE_HEIGHT_DECAY	0.9
#define CHAT_LAYER_Z_STEP			0.0001
#define CHAT_LAYER_MAX_Z			(CHAT_LAYER_MAX - CHAT_LAYER) / CHAT_LAYER_Z_STEP
#define CHAT_MESSAGE_WIDTH			96
#define CHAT_MESSAGE_GRACE_PERIOD 	(0.2 SECONDS)

/mob
	var/chat_message_y_offset = 0

/datum/chatmessage/finish_image_generation(mheight, atom/target, mob/owner, complete_text, lifespan)
	var/rough_time = REALTIMEOFDAY
	approx_lines = max(1, mheight / CHAT_MESSAGE_APPROX_LHEIGHT)

	// Translate any existing messages upwards, apply exponential decay factors to timers
	message_loc = target
	if(owned_by.seen_messages)
		var/idx = 1
		var/combined_height = approx_lines
		for(var/datum/chatmessage/m as anything in owned_by.seen_messages[message_loc])
			combined_height += m.approx_lines

			var/time_alive = rough_time - m.animate_start
			var/lifespan_until_fade = m.animate_lifespan - CHAT_MESSAGE_EOL_FADE

			if(time_alive >= lifespan_until_fade) // If already fading out or dead, just shift upwards
				animate(m.message, pixel_y = m.message.pixel_y + mheight, time = CHAT_MESSAGE_SPAWN_TIME, flags = ANIMATION_PARALLEL)
				continue

			// Ensure we don't accidentially spike alpha up or something silly like that
			m.message.alpha = m.get_current_alpha(time_alive)

			var/adjusted_lifespan_until_fade = lifespan_until_fade * (CHAT_MESSAGE_EXP_DECAY ** idx++) * (CHAT_MESSAGE_HEIGHT_DECAY ** combined_height)
			m.animate_lifespan = adjusted_lifespan_until_fade + CHAT_MESSAGE_EOL_FADE

			var/remaining_lifespan_until_fade = adjusted_lifespan_until_fade - time_alive
			if(remaining_lifespan_until_fade > 0) // Still got some lifetime to go; stay faded in for the remainder, then fade out
				animate(m.message, alpha = 255, time = remaining_lifespan_until_fade)
				animate(alpha = 0, time = CHAT_MESSAGE_EOL_FADE)
			else // Current time alive is beyond new adjusted lifespan, your time has come my son
				animate(m.message, alpha = 0, time = CHAT_MESSAGE_EOL_FADE)

			// We run this after the alpha animate, because we don't want to interrup it, but also don't want to block it by running first
			// Sooo instead we do this. bit messy but it fuckin works
			animate(m.message, pixel_y = m.message.pixel_y + mheight, time = CHAT_MESSAGE_SPAWN_TIME, flags = ANIMATION_PARALLEL)

	// Reset z index if relevant
	if(current_z_idx >= CHAT_LAYER_MAX_Z)
		current_z_idx = 0

	// Build message image
	message = image(loc = message_loc, layer = CHAT_LAYER + CHAT_LAYER_Z_STEP * current_z_idx++)
	message.plane = GAME_PLANE
	message.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	message.alpha = 0
	message.pixel_y = owner.bound_height * 0.95 + owner.chat_message_y_offset
	message.maptext_width = CHAT_MESSAGE_WIDTH
	message.maptext_height = mheight
	message.maptext_x = (CHAT_MESSAGE_WIDTH - owner.bound_width) * -0.5
	message.maptext = complete_text

	animate_start = rough_time
	animate_lifespan = lifespan

	// View the message
	LAZYADDASSOCLIST(owned_by.seen_messages, message_loc, src)
	owned_by.images |= message

	// Fade in
	animate(message, alpha = 255, time = CHAT_MESSAGE_SPAWN_TIME)
	// Stay faded in
	animate(alpha = 255, time = lifespan - CHAT_MESSAGE_SPAWN_TIME - CHAT_MESSAGE_EOL_FADE)
	// Fade out
	animate(alpha = 0, time = CHAT_MESSAGE_EOL_FADE)

	// Register with the runechat SS to handle destruction
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), lifespan + CHAT_MESSAGE_GRACE_PERIOD, TIMER_DELETE_ME, SSrunechat)

#undef CHAT_MESSAGE_SPAWN_TIME
#undef CHAT_MESSAGE_EOL_FADE
#undef CHAT_MESSAGE_GRACE_PERIOD
#undef CHAT_MESSAGE_EXP_DECAY
#undef CHAT_MESSAGE_HEIGHT_DECAY
#undef CHAT_MESSAGE_APPROX_LHEIGHT
#undef CHAT_MESSAGE_WIDTH
#undef CHAT_LAYER_Z_STEP
#undef CHAT_LAYER_MAX_Z
