// Yogstation use fastprocess subsystem but for Paradise it causes
// movement lag (updates, like it should, 5 times / second).
// This wait time (0.075) is the closest (and laziest) I could get to
// Yogstation's movement speed

// RMNZ: Maybe performance issues?

PROCESSING_SUBSYSTEM_DEF(spacepod)
	name = "Spacepod"
	wait = 0.075
	stat_tag = "SP"
	offline_implications = "Spacepods will no longer process. Shuttle call recommended."
