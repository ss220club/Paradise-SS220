/atom/proc/CanAllowThrough(atom/movable/mover, border_dir)
	SHOULD_CALL_PARENT(TRUE)
	if(mover.pass_flags == PASSEVERYTHING)
		return TRUE
	if(mover.pass_flags & pass_flags_self)
		return TRUE
	if(mover.throwing && (pass_flags_self & LETPASSTHROW))
		return TRUE
	return !density


/proc/get_mob_in_atom_without_warning(atom/A)
	if(!istype(A))
		return null
	if(ismob(A))
		return A

	return locate(/mob) in A
