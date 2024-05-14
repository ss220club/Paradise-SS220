// rust_utils.dm - DM API for rust_utils extension library
//
// To configure, create a `rust_utils.config.dm` and set what you care about from
// the following options:
//
// #define RUST_UTILS "path/to/rust_utils"
// Override the .dll/.so detection logic with a fixed path or with detection
// logic of your own.
//
// #define RUSTG_OVERRIDE_BUILTINS
// Enable replacement rust-g functions for certain builtins. Off by default.

#ifndef RUST_UTILS
// Default automatic RUST_UTILS detection.
// On Windows, looks in the standard places for `rust_utils.dll`.
// On Linux, looks in `.`, `$LD_LIBRARY_PATH`, and `~/.byond/bin` for either of
// `librust_utils.so` (preferred) or `rust_utils` (old).

/* This comment bypasses grep checks */ /var/__rust_utils

/proc/__detect_rust_utils()
	if(world.system_type == UNIX)
		if(fexists("./librust_utils.so"))
			// No need for LD_LIBRARY_PATH badness.
			return __rust_utils = "./librust_utils.so"
		else if(fexists("./rust_utils"))
			// Old dumb filename.
			return __rust_utils = "./rust_utils"
		else if(fexists("[world.GetConfig("env", "HOME")]/.byond/bin/rust_utils"))
			// Old dumb filename in `~/.byond/bin`.
			return __rust_utils = "rust_utils"
		else
			// It's not in the current directory, so try others
			return __rust_utils = "librust_utils.so"
	else
		return __rust_utils = "rust_utils"

#define RUST_UTILS (__rust_utils || __detect_rust_utils())
#endif

/// Gets the version of rust_g
/proc/rust_utils_get_version() return RUSTG_CALL(RUST_UTILS, "get_version")()

#define rust_utils_regex_replace(text, regex, regex_params, replacement) RUSTG_CALL(RUST_UTILS, "regex_replace")(text, regex, regex_params, replacement)
