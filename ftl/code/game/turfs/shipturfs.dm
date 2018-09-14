/turf/open/indestructible/ftlfloor
	icon = 'ftl/icons/turf/shipfloors.dmi'
	icon_state = "test4"
	var/effects = NONE //Bitflag of current modifiers to this turfs
	var/unique_id //links back to our ship

/turf/closed/indestructible/ftlwall
	icon = 'ftl/icons/turf/shipfloors.dmi'
	icon_state = "test2"
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/closed/indestructible/ftlwall)
