/obj/effect/landmark/ship_spawn
	name = "generic ship spawn"
	icon_state = "generic_event"
	layer = HIGH_LANDMARK_LAYER

/obj/effect/landmark/ship_spawn/Initialize()
	. = ..()
	SSships.ShipSpawnLocations[src] = TRUE

/obj/effect/landmark/ship_spawn/Destroy()
	return QDEL_HINT_LETMELIVE