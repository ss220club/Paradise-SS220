/client/view_var_Topic(href, href_list, hsrc)
	. = ..()
	if(href_list["changetts"])
		if(!check_rights(R_ADMIN))
			return
		var/atom/A = locateUID(href_list["changetts"])
		A.change_tts_seed()

/atom/vv_get_dropdown()
	. = ..()
	.["Change TTS"] = "?_src_=vars;changetts=[UID()]"
