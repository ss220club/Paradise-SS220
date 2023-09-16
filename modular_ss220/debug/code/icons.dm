/atom/proc/getFlatIcon64()
	var/icon/I = getFlatIcon(src)
	usr << ftp(I, "[name].png")
	return icon2base64(I)
