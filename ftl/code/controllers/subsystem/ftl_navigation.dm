SUBSYSTEM_DEF(ftl_navigation)
	name = "FTL Navigation"
	wait = 10
	init_order = INIT_ORDER_FTL_NAV
	flags = SS_NO_FIRE

	var/ftl_state = FTL_IDLE //is the ship in transit, spooling or idle?

	var/datum/sector/current_sector
	var/datum/sector/to_sector

	var/list/visited_sectors = list()

	var/sector_count = 0

	var/list/ship_areas = list()

	var/list/sector_name_fragments = list("le", "xe", "ge", "za", "ce", "bi", "so", "us", "es", "ar", "ma", "in", "di", "re", "a", "er", "at", "en", "be", "ra", "la", "ve", "ti", "ed", "or", "gu", "an", "te", "is", "ri", "on")

	var/list/sector_types = list()
	var/list/planet_types = list()

	var/jump_knockdown_force = 3
	var/jump_throw_force = 0 //Badmin var


/datum/controller/subsystem/ftl_navigation/Initialize(timeofday)
	for(var/A in get_areas(/area/, TRUE)) //Get all areas owned by the ship
		var/area/place = A
		if(place.z != 2) continue
		ship_areas += place

	for(var/type in subtypesof(/datum/planet)) //Get all planet types and weights
		var/datum/planet/P = type
		planet_types += P
		planet_types[type] = initial(P.frequency)

	for(var/type in subtypesof(/datum/sector)) //Get all sector types and weights
		var/datum/sector/S = type
		if(initial(S.frequency) > 0)
			sector_types += S
			sector_types[type] = initial(S.frequency)


	current_sector = new /datum/sector/named/nt_home //Only give them a basic sector to start in
	visited_sectors += current_sector
	generate_connecting_sectors(current_sector)
	for(var/s in current_sector.connected_sectors)
		var/datum/sector/S = s
		generate_connecting_sectors(S)

	var/timer = world.timeofday
	var/count = 0
	var/msg
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		for(var/datum/sub_turf_block/STB in split_block(locate(1,1,z), locate(255,255,z)))
			for(var/t in STB.return_list())
				var/turf/T = t
				if(T.type == /turf/open/space || T.type == /turf/open/space/basic) //I want types only, not subtypes too
					T.ChangeTurf(/turf/open/space/transit/ftl)
					count ++
	if(count > 0)
		msg = "Psst hey. I just lagged the server for [(world.timeofday - timer)/10] seconds due to [count] wrong space tiles on the ship z level. Use /turf/open/space/transit/ftl instead"
		to_chat(world, "<span class='boldannounce'>[msg]</span>")
		warning(msg)

	//baseturf code when floyd is done with SpaceManiac goes here???

	return ..()


/datum/controller/subsystem/ftl_navigation/proc/get_sector(sectorid)
	for(var/s in current_sector.connected_sectors)
		var/datum/sector/S = s
		if(S.id == sectorid) //Try sectors we can jump to
			return S
		for(var/s2 in S.connected_sectors)
			var/datum/sector/S2 = s2
			if(S2.id == sectorid) //Try those sectors
				return S2
	for(var/s3 in visited_sectors)
		var/datum/sector/S3 = s3
		if(S3.id == sectorid) //As a last ditch, try sectors we ever visited.
			return S3
	ftl_state = FTL_IDLE
	WARNING("No sector ID found. Stopped spoolups/jumps just incase")




/datum/controller/subsystem/ftl_navigation/proc/ftl_init_spoolup(sectorid)
	if(ftl_state != FTL_IDLE) return
	ftl_state = FTL_SPOOLUP //Setting early to prevent multiple spoolups
	var/datum/sector/S = get_sector(sectorid)
	if(!S) return
	to_sector = S
	addtimer(CALLBACK(src, .proc/qdel_unvisited_systems, current_sector, to_sector), 20)
	current_sector = null
	spool_up() //Begin FTL
	return TRUE


/datum/controller/subsystem/ftl_navigation/proc/qdel_unvisited_systems(var/datum/sector/oldS, var/datum/sector/toS)
	for(var/s in oldS.connected_sectors) //Cleans up unvisited sectors.
		var/datum/sector/S = s
		oldS.connected_sectors -= S
		if(S != toS) qdel(S)


/datum/controller/subsystem/ftl_navigation/proc/generate_connecting_sectors(var/datum/sector/S)
	var/datum/sector/N
	var/new_sector
	for(var/a in 1 to rand(1,3))
		new_sector = pickweight(sector_types)
		N = new new_sector
		if(N.unique) sector_types -= new_sector //If the sector is unique remove it from the spawn pool
		S.connected_sectors += N
	S.generated_sectors = TRUE



/datum/controller/subsystem/ftl_navigation/proc/ftl_transition(var/ftl_start = TRUE)
	message_admins("Changing FTL effects")
	ftl_parallax(ftl_start)
	ftl_handle_transit_turfs(ftl_start)
	if(ftl_start)
		ftl_state = FTL_JUMPING
		message_admins("FTL has begun")
		addtimer(CALLBACK(src, .proc/ftl_transition, FALSE), 100)
	else leave_ftl()


/datum/controller/subsystem/ftl_navigation/proc/leave_ftl()
	current_sector = to_sector
	current_sector.visited = TRUE
	visited_sectors += to_sector
	to_sector = null
	for(var/s in current_sector.connected_sectors)
		var/datum/sector/S = s
		generate_connecting_sectors(S)
	ftl_state = FTL_IDLE
	message_admins("FTL has ended")


/datum/controller/subsystem/ftl_navigation/proc/ftl_parallax(var/ftl_start = TRUE)
	for(var/a in ship_areas)
		var/area/A = a
		A.parallax_movedir = ftl_start ? 4 : 0
		for(var/atom/movable/AM in A)
			if(length(AM.client_mobs_in_contents))
				AM.update_parallax_contents()


/datum/controller/subsystem/ftl_navigation/proc/ftl_handle_transit_turfs(var/ftl_start = TRUE)
	var/throw_dir
	var/flavor_text
	if(ftl_start)
		throw_dir = WEST
		flavor_text = "<span class='notice'>You feel the ship lurch as it enters FTL.</span>"
	else
		throw_dir = EAST
		flavor_text = "<span class='notice'>You feel the ship lurch as it exits FTL.</span>"
	var/starttime = world.timeofday
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		for(var/datum/sub_turf_block/STB in split_block(locate(1,1,z), locate(255,255,z)))
			for(var/t in STB.return_list())
				var/turf/T = t
				if(istype(T,/turf/open/space/transit/ftl))
					var/turf/open/space/transit/ftl/F = T
					F.ftl_turf_update(ftl_start)
				for(var/obj/machinery/light/L in T.contents) //Makes lights flicker, since I liked how lighting would falter during FTL
					L.flicker (4,15)
				for(var/mob/living/M in T.contents) //Messing with players
					if(M.buckled && M.client) shake_camera(M,3,1)
					else
						if(M.client)
							shake_camera(M,8,1)
							to_chat(M,flavor_text)
						if(jump_throw_force)
							var/turf/target = get_edge_target_turf(M, throw_dir)
							var/range = jump_throw_force
							var/speed = range/5
							M.throw_at(target,range,speed)
						if(jump_knockdown_force)
							M.Knockdown(jump_knockdown_force)
	message_admins("Fake FTL effects took [(world.timeofday - starttime)/10] seconds")


// /datum/controller/subsystem/starmap/proc/ftl_message(var/message)
// 	for(var/obj/machinery/computer/ftl_navigation/C in ftl_consoles)
// 		C.status_update(message)


//And now we handle the ass that is ftl spoolup

/datum/controller/subsystem/ftl_navigation/proc/spool_up()
	message_admins("We have begun spooling FTL")
	addtimer(CALLBACK(src, .proc/ftl_transition), 50)
