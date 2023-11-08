/client/New(TopicData)
	. = ..()

	if(!SSdbcore.IsConnected)
		return

	if(SSqueue.queue_enabled)


