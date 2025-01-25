/obj/item/radio
	/// overlay when speaker is on
	var/overlay_speaker_idle = null
	/// overlay when receiving a message
	var/overlay_speaker_active = null

	/// overlay when mic is on
	var/overlay_mic_idle = null
	/// overlay when speaking a message (is displayed simultaneously with speaker_active)
	var/overlay_mic_active = null

/obj/item/radio/update_overlays()
	. = ..()
	if(b_stat)
		return
	if(broadcasting && overlay_mic_idle)
		. += overlay_mic_idle
	if(listening && overlay_speaker_idle)
		. += overlay_speaker_idle

/obj/item/radio/ToggleReception()
	. = ..()
	if(!isnull(overlay_speaker_idle))
		update_icon()

/obj/item/radio/ToggleBroadcast()
	. = ..()
	if(!isnull(overlay_mic_idle))
		update_icon()

/obj/item/radio/hear_talk(mob/M, list/message_pieces, verb)
	. = ..()
	if(!isnull(overlay_speaker_active))
		flick_overlay_view(image(icon, src, overlay_speaker_active), src, 5 SECONDS)

/obj/item/radio/talk_into(mob/living/M, list/message_pieces, channel, verbage)
	. = ..()
	if(!isnull(overlay_mic_active))
		flick_overlay_view(image(icon, src, overlay_mic_active), src, 5 SECONDS)
