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

#define RUST_UTILS_CALL call_ext

/proc/rust_utils_get_version() return RUST_UTILS_CALL(RUST_UTILS, "get_version")()

#define rustutils_file_write_b64decode(text, fname) RUST_UTILS_CALL(RUST_UTILS, "file_write")(text, fname, "true")

#define rustutils_regex_replace(text, re, re_params, replacement) RUST_UTILS_CALL(RUST_UTILS, "regex_replace")(text, re, re_params, replacement)

#define rustutils_cyrillic_to_latin(text) RUST_UTILS_CALL(RUST_UTILS, "cyrillic_to_latin")("[text]")
#define rustutils_latin_to_cyrillic(text) RUST_UTILS_CALL(RUST_UTILS, "latin_to_cyrillic")("[text]")
