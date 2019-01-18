PROCESSING_SUBSYSTEM_DEF(ships)
	name = "Ships"
	wait = 10
	init_order = INIT_ORDER_FTL_SHIPS
	flags = SS_BACKGROUND

	var/list/ships = list()

	var/list/ShipSpawnLocations = list() //Assoc list of key value Ship_spawn landmark and boolean value. TRUE means it is free


/datum/controller/subsystem/processing/ships/Initialize(timeofday)
	. = ..()
	var/datum/space_level/level = SSmapping.add_new_zlevel("Space Combat", list(ZTRAIT_SPACECOMBAT = TRUE))
	var/datum/parsed_map/parsed = load_map(file("_maps/map_files/generic/SpaceCombat.dmm"), 1, 1, level.z_value, no_changeturf=(SSatoms.initialized == INITIALIZATION_INSSATOMS), placeOnTop=TRUE)
	parsed.initTemplateBounds()

	var/SSx = 12
	var/SSy = 8
	var/SSz = 4
	var/SSy_step = 24
	for(var/i in 0 to 4)
		new /obj/effect/landmark/ship_spawn(locate(SSx,SSy+SSy_step*i,SSz))

	CreateShip(/datum/starship/testship) //debug

/datum/controller/subsystem/processing/ships/proc/CreateShip(var/datum/shiptype = /datum/starship/testship)
	var/obj/effect/landmark/ship_spawn/ship_spawn = GetFreeSpawnSlot()
	if(!ship_spawn)		
		message_admins("No more spawn slots for ships, ship not spawned!")
		log_game("No more spawn slots for ships, ship not spawned!")
	new shiptype(ship_spawn.loc, ship_spawn)

/datum/controller/subsystem/processing/ships/proc/GetFreeSpawnSlot()
	for(var/i in SSships.ShipSpawnLocations)
		if(!SSships.ShipSpawnLocations[i])
			continue
		return i

/datum/controller/subsystem/processing/ships/proc/GetUsedSpawnSlot()
	for(var/i in SSships.ShipSpawnLocations)
		if(SSships.ShipSpawnLocations[i])
			continue
		return i
		
/datum/controller/subsystem/processing/ships/proc/DelAllShips()
	for(var/i in ships)
		var/datum/starship/ship = ships[i]
		qdel(ship)

/datum/controller/subsystem/processing/ships/proc/ShipsEngage()
	for(var/i in ships)
		var/datum/starship/S = i
		S.engage_player()

