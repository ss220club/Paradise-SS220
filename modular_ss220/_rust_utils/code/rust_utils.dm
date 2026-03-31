#ifndef RUST_UTILS

/* This comment bypasses grep checks */ /var/__rust_utils

/proc/__detect_rust_utils()
	if(world.system_type == UNIX)
		if(fexists("./librust_utils.so"))
			// No need for LD_LIBRARY_PATH badness.
			return __rust_utils = "./librust_utils.so"
		// It's not in the current directory, so try others
		return __rust_utils = "librust_utils.so"
	else
		if(fexists("./librust_utils.dll"))
			return __rust_utils = "./librust_utils.dll"
		return __rust_utils = "librust_utils.dll"

#define RUST_UTILS (__rust_utils || __detect_rust_utils())
#endif

#ifndef RUST_UTILS_API
#define RUST_UTILS_API
#define RUST_UTILS_CALL(func, args...) call_ext(RUST_UTILS, "byond:[#func]_ffi")(args)

/// Gets the version of rust_utils
/proc/rust_utils_get_version()
	return RUST_UTILS_CALL(get_version)

/proc/rustutils_file_write_b64decode(text, fname)
	return RUST_UTILS_CALL(file_write, text, fname, "true")

/proc/rustutils_regex_replace(text, re, re_params, replacement)
	return RUST_UTILS_CALL(regex_replace, text, re, re_params, replacement)

/proc/rustutils_cyrillic_to_latin(text)
	return RUST_UTILS_CALL(cyrillic_to_latin, "[text]")

/proc/rustutils_latin_to_cyrillic(text)
	return RUST_UTILS_CALL(latin_to_cyrillic, "[text]")

#undef RUST_UTILS_CALL
#endif
