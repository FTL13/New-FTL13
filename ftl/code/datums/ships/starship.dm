/datum/starship
	var/name
	var/static/ship_count = 0
	var/unique_id

	var/hull_integrity
	var/shield_integrity
	var/traits
	var/status

	var/list/shiprooms

	var/datum/map_template/ftl/combat/template
	var/prefix = "ftl/_maps/ships/"
	var/combat_map = "combat/generic_ship.dmm"

/datum/starship/New(turf/T)
	unique_id = "[name] [++ship_count])"

	var/map = "[prefix][combat_map]"
	template = new(map)
	template.load(T)

	var/shipareas
	for(var/turf/open/indestructable/ftlfloor/floor in template.get_affected_turfs())
		floor.unique_id = unique_id
		
		var/area/ftl/shiproom/A = get_area(floor)
		if(!shiprooms.Find(A))
			continue

		shipareas += A
		CreateShipRoom(A)

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
			var/datum/shiproom/x = new(src)
			shiprooms[Atype] = x
			

	