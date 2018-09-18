/turf/open/space/transit/ftl
	name = "\proper space"
	icon_state = "black"
	dir = EAST
	baseturfs = /turf/open/space/transit/ftl
	flags_1 = NOJAUNT_1 //This line goes out to every wizard that ever managed to escape the den. I'm sorry.
	explosion_block = INFINITY
//fix paralax off




/turf/open/space/transit/ftl/proc/ftl_turf_update(ftl_start)
	if(!locate(/obj/structure/lattice) in src)
		for(var/obj/O in contents)
			throw_atom(O)
	if(ftl_start)
		update_icon() //Update us using icon state defined in the transit level proc
	else
		icon_state = SPACE_ICON_STATE //Update us using the normal space define


/turf/open/space/transit/ftl/throw_atom(atom/movable/AM) //TODO: Talk about how we handle players who fall off the ship
	set waitfor = FALSE
	if(!AM || istype(AM, /obj/docking_port))
		return
	if(AM.loc != src) 	// Multi-tile objects are "in" multiple locs but its loc is it's true placement.
		return			// Don't move multi tile objects if their origin isnt in transit
	if(SSftl_navigation.ftl_state != FTL_JUMPING) return //Only throw if we are in transit
	var/max = world.maxx-TRANSITIONEDGE
	var/min = 1+TRANSITIONEDGE

	var/list/possible_transtitons = list()
	for(var/A in SSmapping.z_list)
		var/datum/space_level/D = A
		if (D.linkage == CROSSLINKED)
			possible_transtitons += D.z_value
	var/_z = pick(possible_transtitons)

	//now select coordinates for a border turf
	var/_x
	var/_y
	switch(dir)
		if(SOUTH)
			_x = rand(min,max)
			_y = max
		if(WEST)
			_x = max
			_y = rand(min,max)
		if(EAST)
			_x = min
			_y = rand(min,max)
		else
			_x = rand(min,max)
			_y = min

	var/turf/T = locate(_x, _y, _z)
	AM.forceMove(T)
