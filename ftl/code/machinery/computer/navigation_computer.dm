/obj/machinery/computer/ftl_navigation
	name = "helms console"
	desc = "A ship control computer."
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	light_color = LIGHT_COLOR_CYAN
	var/mode = "Options"
	var/datum/sector/sector_details

/obj/machinery/computer/ftl_navigation/Initialize()
	. = ..()
	SSftl_navigation.nav_consoles += src

/obj/machinery/computer/ftl_navigation/Destroy()
	. = ..()
	SSftl_navigation.nav_consoles -= src

/obj/machinery/computer/ftl_navigation/ui_interact(mob/user)
	. = ..()
	if(mode != "Spoolup" && SSftl_navigation.ftl_state == FTL_SPOOLUP)
		mode = "Spoolup" //Fuck popup uis
	else if(mode != "Transit" && SSftl_navigation.ftl_state == FTL_JUMPING)
		mode = "Transit"
	else if((mode == "Spoolup" || mode == "Transit") && SSftl_navigation.ftl_state == FTL_IDLE)
		mode = "Options"
	
	var/dat = "fuck tgui: MODE | [mode]<br><br>"
	switch(mode)
		if("Options")
			dat += "Currently located in the [SSftl_navigation.current_sector.name] sector.<br>This is \a [SSftl_navigation.current_sector.sector_type].<br>"
			if(SSftl_navigation.current_sector.planet)
				dat += "\A [SSftl_navigation.current_sector.planet] is within range of the FOB.<br>"
			if(SSftl_navigation.current_sector.station)
				dat += "\A [SSftl_navigation.current_sector.station] is within trading range.<br>"
			dat += "<hr>Adjacent systems:<hr>"
			for(var/sector_typeless in SSftl_navigation.current_sector.connected_sectors)
				var/datum/sector/S = sector_typeless
				dat += "<A href='?src=[REF(src)];details=[S.id]'>[S.name]</A><br>"

		if("Details")
			dat += "<A href='?src=[REF(src)];options=1'>Return to current system</A><br><hr>"
			dat += "Long range scan of [sector_details.name]:<br>"
			//long range results
			if(sector_details.planet)
				dat += "Star charts indicate a planet will be in this region.<br>"
			if(sector_details.station)
				dat += "The Galactic Trading Association lists an operational station open for trading here.<br>"
			//Name only for this sectors connections
			dat += "<hr>Connected sectors:<br>"
			for(var/sector_typeless in sector_details.connected_sectors)
				var/datum/sector/S = sector_typeless
				dat += "-[S.name]<br>"
			dat += "<br><A href='?src=[REF(src)];jump=[sector_details.id]'>Jump to [sector_details.name]</A><br>"

		if("Transit")
			dat += "ship jump do not touch<br>"
		if("Spoolup")
			dat += "spooling up to jump to [SSftl_navigation.to_sector]<br>"
	dat += "<a href='?src=[REF(user)];mach_close=computer'>Close</a>"
	var/datum/browser/popup = new(user, "computer", "idk", 500, 700)
	popup.set_content("<center>[dat]</center>")
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()




/obj/machinery/computer/ftl_navigation/Topic(href, href_list)
	if(..())return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(!allowed(usr))
		to_chat(usr, "<span class='danger'>Access denied.</span>")
		return

	if(href_list["details"])
		mode = "Details"
		sector_details = SSftl_navigation.all_sectors(href_list["details"])
	else if(href_list["jump"])
		mode = "Spoolup"
		updateUsrDialog()
		SSftl_navigation.ftl_init_spoolup(href_list["jump"])

	else if(href_list["options"])
		mode = "Options"

	updateUsrDialog()

/obj/machinery/computer/ftl_navigation/proc/status_update(var/message,var/sound)
	visible_message("[icon2html(src,usr)][name], [message]")
	if(sound)
		playsound(loc,sound,50,0)
