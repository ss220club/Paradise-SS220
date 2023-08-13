/client/proc/view_pingstat()
	set category = "Debug"
	set name = "View Pingstat"
	set desc = "Open the Pingstat Report"

	if(!check_rights(R_HOST))
		return

	var/msg = {"<html><meta charset="UTF-8"><head><title>Pingstat Report</title></head><body>"}
	var/color
	msg += "<TABLE border ='1'><TR>"
	msg += "<TH>Player</TH>"
	msg += "<TH>Quality</TH>"
	msg += "<TH>Ping</TH>"
	msg += "<TH>AvgPing</TH>"
	msg += "<TH>Url</TH>"
	msg += "<TH>IP</TH>"
	msg += "<TH>Country</TH>"
	msg += "<TH>CountryCode</TH>"
	msg += "<TH>Region</TH>"
	msg += "<TH>Region Name</TH>"
	msg += "<TH>City</TH>"
	msg += "<TH>Timezone</TH>"
	msg += "<TH>ISP</TH>"
	msg += "<TH>Mobile</TH>"
	msg += "<TH>Proxy</TH>"
	msg += "<TH>Status</TH>"

	msg += "</TR>"
	for(var/client/C in GLOB.clients)
		msg += "<TR>"

		msg += "<TD>[key_name_admin(C.mob)]</TD>"
		color = "rgb([C.lastping], [255 - clamp(text2num(C.lastping), 0, 255)], 0)"
		msg += "<TD bgcolor='[color]' >&nbsp;</TD>"
		msg += "<TD><b>[C.lastping]<b></TD>"
		msg += "<TD><b>[round(C.avgping,1)]<b></TD>"
		msg += "<TD>[C.url]</TD>"

		if(C.geoip.status != "updated")
			C.geoip.try_update_geoip(C, C.address)
		msg += "<TD>[C.geoip.ip]</TD>"
		msg += "<TD>[C.geoip.country]</TD>"
		msg += "<TD>[C.geoip.countryCode]</TD>"
		msg += "<TD>[C.geoip.region]</TD>"
		msg += "<TD>[C.geoip.regionName]</TD>"
		msg += "<TD>[C.geoip.city]</TD>"
		msg += "<TD>[C.geoip.timezone]</TD>"
		msg += "<TD>[C.geoip.isp]</TD>"
		msg += "<TD>[C.geoip.mobile]</TD>"
		msg += "<TD>[C.geoip.proxy]</TD>"
		msg += "<TD>[C.geoip.status]</TD>"

		msg += "</TR>"

	msg += "</TABLE></BODY></HTML>"
	src << browse(msg, "window=pingstat_report;size=1500x600")
