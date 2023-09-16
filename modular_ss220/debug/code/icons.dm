/proc/flatbicon(obj, use_class = TRUE)
	return bicon(getFlatIcon(obj))

/atom/proc/download_flaticon()
	var/icon/I = getFlatIcon(src)
	usr << ftp(I, "[name].png")
