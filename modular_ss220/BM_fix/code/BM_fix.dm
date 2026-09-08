// cards_ids.dm

/obj/item/card/id/RebuildHTML()
	var/photo_block = ""
	if(photo)
		var/photo_front = "'data:image/png;base64,[icon2base64(icon(photo, dir = SOUTH))]'"
		var/photo_side = "'data:image/png;base64,[icon2base64(icon(photo, dir = WEST))]'"
		photo_block = {"<td align = center valign = top>Photo:<br><img src=[photo_front] height=80 width=80 border=4>
	<img src=[photo_side] height=80 width=80 border=4></td>"}

	dat = {"<table><tr><td>
	Name: [registered_name]</A><BR>
	Sex: [sex]</A><BR>
	Age: [age]</A><BR>
	Rank: [assignment]</A><BR>
	Fingerprint: [fingerprint_hash]</A><BR>
	Blood Type: [blood_type]<BR>
	DNA Hash: [dna_hash]<BR><BR>
	[photo_block]</tr></table>"}


// turf_decal.dm

/turf
	var/list/decal_save_list
	var/list/pending_decal_dirs



// decal_painter.dm

/datum/painter/decal
	max_decals = 10

/datum/painter/decal/remove_decals(atom/target)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return
	var/list/datum/element/decal/decals = target_turf.get_decals()
	for(var/datum/element/decal/dcl in decals)
		dcl.Detach(target)
	target_turf.RemoveElement(/datum/element/decal)
	// RemoveElement() above only detaches the live, in-world element - it
	// never touched decal_save_list, so an erased decal kept coming back
	// on every subsequent Save/Load forever. Clear the saved record too;
	// this removes everything on the tile at once, matching the
	// all-at-once semantics of RemoveElement(/datum/element/decal) above.
	target_turf.decal_save_list = null
