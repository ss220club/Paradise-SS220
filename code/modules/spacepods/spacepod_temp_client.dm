/client
	var/mouseParams = null
	///Used in MouseDrag to preserve the last mouse-entered location
	var/datum/mouse_location_ref = null
	///Used in MouseDrag to preserve the last mouse-entered object
	var/datum/mouse_object_ref
	var/mouseControlObject = null
