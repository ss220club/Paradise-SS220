#define EMERGENCY_NONE			0
#define EMERGENCY_STATION_WIDE	(1<<0)
#define EMERGENCY_MAINTENANCE	(1<<1)
#define EMERGENCY_MANUAL		(1<<2)
#define EMERGENCY_ALARM			(1<<3)

/obj/machinery/door/airlock
	var/is_alert_sensitive = TRUE
	var/emergency_reason = EMERGENCY_NONE

/obj/machinery/door/airlock/Initialize()
	. = ..()
	if(has_constant_processing())
		START_PROCESSING(SSmachines, src)

/obj/machinery/door/airlock/process()
	if(is_station_level(z))
		if(is_alert_sensitive)
			var/area/this_area = get_area(src)
			if(SSsecurity_level.get_current_level_as_number() == SEC_LEVEL_ORANGE \
				&& (this_area.has_power_alarm() || this_area.has_atmos_alarm() || this_area.has_fire_alarm()))
				emergency_reason |= EMERGENCY_ALARM
			else
				emergency_reason &= ~EMERGENCY_ALARM
		var/old_emergency = emergency
		emergency = emergency_reason != EMERGENCY_NONE
		if(emergency != old_emergency)
			update_icon()
	. = ..()
	return has_constant_processing() || .

/obj/machinery/door/airlock/toggle_emergency_status(mob/user)
	. = ..()
	if(emergency)
		emergency_reason |= EMERGENCY_MANUAL
	else
		emergency_reason = EMERGENCY_NONE

/obj/machinery/door/airlock/proc/has_constant_processing()
	return is_alert_sensitive && is_station_level(z)

/obj/machinery/door/airlock/abductor
	is_alert_sensitive = FALSE

/obj/machinery/door/airlock/cult
	is_alert_sensitive = FALSE

/obj/machinery/door/airlock/external
	is_alert_sensitive = FALSE

/obj/machinery/door/airlock/external_no_weld
	is_alert_sensitive = FALSE

/obj/machinery/door/airlock/highsecurity
	is_alert_sensitive = FALSE

/obj/machinery/door/airlock/vault
	is_alert_sensitive = FALSE

/datum/controller/subsystem/mapping/make_maint_all_access()
	for(var/area/station/maintenance/A in existing_station_areas)
		for(var/obj/machinery/door/airlock/D in A)
			D.emergency_reason |= EMERGENCY_MAINTENANCE
	. = ..()

/datum/controller/subsystem/mapping/revoke_maint_all_access()
	for(var/area/station/maintenance/A in existing_station_areas)
		for(var/obj/machinery/door/airlock/D in A)
			D.emergency_reason &= ~EMERGENCY_MAINTENANCE
	. = ..()

/datum/controller/subsystem/mapping/make_station_all_access()
	for(var/obj/machinery/door/airlock/D in GLOB.airlocks)
		if(is_station_level(D.z))
			D.emergency_reason |= EMERGENCY_STATION_WIDE
	. = ..()

/datum/controller/subsystem/mapping/revoke_station_all_access()
	for(var/obj/machinery/door/airlock/D in GLOB.airlocks)
		if(is_station_level(D.z))
			D.emergency_reason &= ~EMERGENCY_STATION_WIDE
	. = ..()

#undef EMERGENCY_NONE
#undef EMERGENCY_STATION_WIDE
#undef EMERGENCY_MAINTENANCE
#undef EMERGENCY_MANUAL
#undef EMERGENCY_ALARM
