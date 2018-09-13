SUBSYSTEM_DEF(ships)
	name = "Ships"
	wait = 10
	init_order = -3

	var/list/currentships
	var/list/ShipSpawnLocations //Assoc list of key value Ship_spawn landmark and boolean value. TRUE means it is free


/datum/controller/subsystem/ships/Initialize(timeofday)
	var/list/errorList = list()
	var/list/combatmaps = SSmapping.LoadGroup(errorList, "Reebe", "map_files/generic", "SpaceCombat.dmm", default_traits = ZTRAIT_SPACECOMBAT, silent = TRUE)
	
	if(errorList.len)	// our map failed to load
		message_admins("Designated space combat zlevel failed to load!")
		log_game("Designated space combat zlevel failed to load!")
		return FALSE
		
	for(var/datum/parsed_map/PM in combatmaps)
		PM.initTemplateBounds()

/datum/controller/subsystem/ships/CreateShip(var/type)
	var/datum/star_ship