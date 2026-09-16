/obj/effect/spawner/random/library_book/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	if(initialized)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	initialized = TRUE
	return INITIALIZE_HINT_LATELOAD

/obj/effect/spawner/random/library_book/LateInitialize()
	spawn_loot()
	qdel(src)
