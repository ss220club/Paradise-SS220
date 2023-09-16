/atom/proc/getFlatIcon64()
	var/icon/I = getFlatIcon(src)
	usr << ftp(I, "[name]_\ref[src]")
	return icon2base64(I)
