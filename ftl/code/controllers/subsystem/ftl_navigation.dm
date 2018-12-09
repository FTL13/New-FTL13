SUBSYSTEM_DEF(ftl_navigation)
	name = "FTL Navigation"
	wait = 10
	init_order = INIT_ORDER_FTL_NAV
	flags = SS_NO_FIRE

	var/ftl_state = FTL_IDLE //is the ship in transit, spooling or idle?

	var/datum/sector/current_sector
	var/datum/sector/to_sector

	var/list/visited_sectors = list()

	var/list/all_sectors = list()

	var/sector_count = 0

	var/list/ship_areas = list()

	var/list/sector_name_fragments = list("le", "xe", "ge", "za", "ce", "bi", "so", "us", "es", "ar", "ma", "in", "di", "re", "a", "er", "at", "en", "be", "ra", "la", "ve", "ti", "ed", "or", "gu", "an", "te", "is", "ri", "on")

	var/list/sector_types = list()
	var/list/planet_types = list()
	
	var/parallax_layer1_icon = "empty"
	var/parallax_planet_icon = "habitable"
	
	var/list/parallax_layer1 = list()
	var/list/parallax_planets = list()

	var/list/nav_consoles = list()

	var/jump_knockdown_force = 3
	var/jump_throw_force = 0 //Badmin var


/datum/controller/subsystem/ftl_navigation/Initialize(timeofday)
	for(var/type in subtypesof(/datum/planet)) //Get all planet types and weights
		var/datum/planet/P = type
		planet_types[type] = initial(P.frequency)

	for(var/type in subtypesof(/datum/sector)) //Get all sector types and weights
		var/datum/sector/S = type
		if(initial(S.frequency) > 0)
			sector_types[type] = initial(S.frequency)


	current_sector = new /datum/sector/named/nt_home //Only give them a basic sector to start in
	visited_sectors += current_sector
	generate_connecting_sectors(current_sector)
	for(var/sector_typeless in current_sector.connected_sectors)
		var/datum/sector/S = sector_typeless
		generate_connecting_sectors(S)

	return ..()
	
	
/datum/controller/subsystem/ftl_navigation/proc/update_layer1_parallax(var/newicon)
	parallax_layer1_icon = newicon
	for(var/thing in parallax_layer1)
		var/obj/screen/parallax_layer/layer_1/L = thing
		L.icon_state = parallax_layer1_icon
		
	for(var/thing_client in GLOB.clients)
		var/client/C = thing_client
		C.parallax_layers_cached[1].update_o(C.view) //We only want to update the topmost layer
		
/datum/controller/subsystem/ftl_navigation/proc/update_planet_parallax(var/newicon)
	parallax_planet_icon = newicon
	for(var/thing in parallax_planets)
		var/obj/screen/parallax_layer/planet/P = thing
		P.icon_state = parallax_planet_icon
		
/datum/controller/subsystem/ftl_navigation/proc/update_planet_alpha(var/A = 255)
	for(var/thing in parallax_planets)
		var/obj/screen/parallax_layer/planet/P = thing
		P.alpha = A
	

/datum/controller/subsystem/ftl_navigation/proc/ftl_init_spoolup(sectorid)
	if(ftl_state != FTL_IDLE)
		return
	ftl_state = FTL_SPOOLUP //Setting early to prevent multiple spoolups
	var/datum/sector/S = all_sectors[sectorid]
	if(!S)
		return
	to_sector = S
	spool_up() //Begin FTL
	addtimer(CALLBACK(src, .proc/qdel_unvisited_systems, current_sector, to_sector), 20)
	return TRUE


/datum/controller/subsystem/ftl_navigation/proc/qdel_unvisited_systems(var/datum/sector/old_sector, var/datum/sector/new_sector)
	for(var/sector_loop in old_sector.connected_sectors) //Cleans up unvisited sectors.
		var/datum/sector/sector = sector_loop
		if(sector != new_sector)
			old_sector.connected_sectors -= sector
			SSftl_navigation.all_sectors -= sector.id
			qdel(sector)


/datum/controller/subsystem/ftl_navigation/proc/generate_connecting_sectors(var/datum/sector/S)
	var/datum/sector/N
	var/new_sector
	for(var/a in 1 to rand(1,3))
		new_sector = pickweight(sector_types)
		N = new new_sector
		if(N.unique)
			sector_types -= new_sector //If the sector is unique remove it from the spawn pool
		S.connected_sectors += N
	S.generated_sectors = TRUE



/datum/controller/subsystem/ftl_navigation/proc/ftl_transition(var/ftl_start = TRUE)
	ftl_parallax(ftl_start)
	ftl_handle_transit_turfs(ftl_start)
	if(ftl_start)
		update_layer1_parallax("transit")
		update_planet_alpha(0)
		current_sector = null
		ftl_state = FTL_JUMPING
		SSships.DelAllShips()
		ftl_message("FTL has begun")
		addtimer(CALLBACK(src, .proc/ftl_transition, FALSE), 100) //Time spent in FTL
	else
		leave_ftl()
		update_layer1_parallax(current_sector.parallax_icon)
		if(current_sector.planet)
			update_planet_parallax(current_sector.planet.parallax_icon)
			update_planet_alpha(255)


/datum/controller/subsystem/ftl_navigation/proc/leave_ftl()
	current_sector = to_sector
	current_sector.visited = TRUE
	visited_sectors += to_sector
	to_sector = null
	if(current_sector.ship_to_spawn)
		SSships.CreateShip(current_sector.ship_to_spawn)
	for(var/sector_type in current_sector.connected_sectors)
		var/datum/sector/sector_to_gen = sector_type
		generate_connecting_sectors(sector_to_gen)
	ftl_state = FTL_IDLE


/datum/controller/subsystem/ftl_navigation/proc/ftl_parallax(var/ftl_start = TRUE)
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		for(var/area_in_z in SSmapping.areas_in_z["[z]"]) //Get all areas owned by the ship
			var/area/A = area_in_z
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
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		for(var/returned_turf in block(locate(1,1,z), locate(255,255,z)))
			CHECK_TICK
			var/turf/T = returned_turf
			if(istype(T,/turf/open/space/transit/ftl))
				var/turf/open/space/transit/ftl/F = T
				F.ftl_turf_update(ftl_start)
			for(var/obj/machinery/light/L in T.contents) //Makes lights flicker, since I liked how lighting would falter during FTL
				L.flicker (4,15)
			for(var/mob/living/M in T.contents) //Messing with players
				if(M.buckled && M.client)
					shake_camera(M,3,1)
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


/datum/controller/subsystem/ftl_navigation/proc/ftl_message(var/message, var/sound_effect)
	for(var/typeless_console in nav_consoles)
		var/obj/machinery/computer/ftl_navigation/C = typeless_console
		C.status_update(message, sound_effect)


//And now we handle the ass that is ftl spoolup

/datum/controller/subsystem/ftl_navigation/proc/spool_up()
	ftl_message("We have begun spooling FTL")
	addtimer(CALLBACK(src, .proc/ftl_transition), 50)
