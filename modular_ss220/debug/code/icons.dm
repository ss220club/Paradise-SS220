/proc/getFlatIcon64(image/thing)
	var/icon/I = getFlatIcon(thing)
	return icon2base64(I)
