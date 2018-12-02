SUBSYSTEM_DEF(ships)
	name = "Ships"
	wait = 10
	init_order = -3
	flags = SS_NO_FIRE

	var/list/currentships = list()
	var/list/ShipSpawnLocations = list() //Assoc list of key value Ship_spawn landmark and boolean value. TRUE means it is free


/datum/controller/subsystem/ships/Initialize(timeofday)
	. = ..()
	var/list/errorList = list()
	var/list/combatmaps = SSmapping.LoadGroup(errorList, "Space Combat", "map_files/generic", "SpaceCombat.dmm", default_traits = list(ZTRAIT_SPACECOMBAT = TRUE), silent = TRUE)
	
	if(errorList.len)	// our map failed to load
		message_admins("Designated space combat zlevel failed to load!")
		log_game("Designated space combat zlevel failed to load!")
		return FALSE
		
	for(var/datum/parsed_map/PM in combatmaps)
		PM.initTemplateBounds()
	CreateShip(/datum/starship/testship) //debug

/datum/controller/subsystem/ships/proc/CreateShip(var/datum/shiptype)
	var/obj/effect/landmark/ship_spawn/ship_spawn = GetFreeSpawnSlot()
	if(!ship_spawn)		
		message_admins("No more spawn slots for ships, ship not spawned!")
		log_game("No more spawn slots for ships, ship not spawned!")
	new shiptype(ship_spawn.loc, ship_spawn)

/datum/controller/subsystem/ships/proc/GetFreeSpawnSlot()
	for(var/i in SSships.ShipSpawnLocations)
		if(!SSships.ShipSpawnLocations[i])
			continue
		return i

/datum/controller/subsystem/ships/proc/GetUsedSpawnSlot()
	for(var/i in SSships.ShipSpawnLocations)
		if(SSships.ShipSpawnLocations[i])
			continue
		return i