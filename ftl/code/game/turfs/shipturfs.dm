/turf/open/indestructable/ftlfloor
	var/effects = NONE //Bitflag of current modifiers to this turfs
	var/unique_id //links back to our ship
	light_power = 0.5


/turf/closed/indestructable/ftlwall
	icon = 'icons/turf/walls/riveted.dmi'
	icon_state = "riveted"
	smooth = SMOOTH_TRUE