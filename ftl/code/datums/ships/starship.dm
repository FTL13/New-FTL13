/datum/starship
	var/name
	var/static/ship_count = 0
	var/unique_id

	var/obj/effect/landmark/ship_spawn/ship_spawn_slot //Slot this ship occupies in the ShipSpawnLocations assoc list from the ships subsystem

	var/hull_integrity

	var/shield_integrity
	var/max_shield_integrity

	var/traits = FTL_CANCELLING //Special bitfield for things such as preventing FTL. Should we move this to the TG trait system? (Would allow us to have better control over what applies traits etc)

	var/dodge_chance = 30 //Base chance to dodge a shot
	var/list


	//Modifiers, these are changed by the ships rooms
	var/dodge_modifier = 1 //Higher is better
	var/firerate_modifier = 1

	var/list/shiprooms = list()

	var/datum/map_template/ftl/combat/template
	var/prefix = "ftl/_maps/ships/"
	var/combat_map = "combat/generic_ship.dmm"

/datum/starship/New(turf/T, var/obj/effect/landmark/ship_spawn/new_ship_spawn_slot)
	. = ..()
	unique_id = "[name] [++ship_count]"
	SSships.ships[unique_id] = src
	shield_integrity = max_shield_integrity

	template = new("[prefix][combat_map]")
	template.load(T, TRUE)
	var/list/turfs = template.get_affected_turfs(T, TRUE)
	//var/list/turfs = block(	locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
							//locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))

	ship_spawn_slot = new_ship_spawn_slot
	SSships.ShipSpawnLocations[ship_spawn_slot] = FALSE //This slot is taken now, cya chump.

	var/list/shipareas = list()
	for(var/turf/open/indestructible/ftlfloor/floor in turfs) //Find all unique areas on the ship
		floor.unique_id = unique_id
		shipareas |= get_area(floor)

	for(var/i in shipareas) //Create shiprooms for these unique areas
		var/area/ftl/shiproom/A = i

		if(!istype(A))
			continue

		CreateShipRoom(A)

/datum/starship/Destroy()
	. = ..()
	SSships.ShipSpawnLocations[ship_spawn_slot] = TRUE //This slot is free for a new ship now.
	SSships.ships -= unique_id
	for(var/i in template.get_affected_turfs(ship_spawn_slot.loc, TRUE)) //this is so shit TODO: kill this unless this is our best way of cleaning up.
		var/turf/T = i
		for(var/x in T.contents)
			qdel(x)
		T.ScrapeAway()
		CHECK_TICK

/datum/starship/proc/CreateShipRoom(var/Atype)
	switch(Atype)
		if(BRIDGE)
			var/datum/shiproom/bridge/x = new(src)
			shiprooms[Atype] = x
		if(SHIELDS)
			var/datum/shiproom/shields/x = new(src)
			shiprooms[Atype] = x
		if(WEAPONS)
			var/datum/shiproom/weapons/x = new(src)
			shiprooms[Atype] = x
		if(ENGINE)
			var/datum/shiproom/engine/x = new(src)
			shiprooms[Atype] = x
		else
			var/datum/shiproom/empty/x = new(src)
			shiprooms[Atype] = x


/datum/starship/proc/adjust_shield(value)
	shield_integrity = CLAMP(shield_integrity + value, 0 , max_shield_integrity)

/datum/starship/proc/set_shield(value)
	shield_integrity = CLAMP(value, 0 , max_shield_integrity)

/datum/starship/proc/adjust_hull(value) //use this to change hull level or i kill you
	hull_integrity = min(hull_integrity + value, initial(hull_integrity))
	if(hull_integrity <= 0)
		qdel(src) //we dead

/datum/starship/proc/calculate_fire_rate()
	var/datum/shiproom/weapons/R = shiprooms[WEAPONS]
	return R.get_integrity_modifier()

/datum/starship/proc/calculate_dodge_rate()
	var/datum/shiproom/bridge/RB = shiprooms[BRIDGE]
	if(!RB.is_active())
		return 0 //Bridge is down. fuck we cant steer REEEEEEEEEEE
	var/datum/shiproom/engine/RE = shiprooms[ENGINE]
	return RE.get_integrity_modifier()

/datum/starship/proc/calculate_max_shield()
	var/datum/shiproom/shields/RS = shiprooms[SHIELDS]
	max_shield_integrity = initial(max_shield_integrity) * RS.get_integrity_modifier()
	set_shield(shield_integrity) //Ensure it isn't over the cap

/datum/starship/proc/get_dodge_chance()
	return dodge_chance * dodge_modifier

/datum/starship/testship
	hull_integrity = 50
	max_shield_integrity = 20



