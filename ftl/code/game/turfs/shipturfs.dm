/turf/open/indestructible/ftlfloor
	icon = 'ftl/icons/turf/shipfloors.dmi'
	icon_state = "test3"
	var/effects = NONE //Bitflag of current modifiers to this turfs
	var/unique_id //links back to our ship

/turf/open/indestructible/ftlfloor/proc/GetOurShip()
	return SSships.currentships[unique_id]

/turf/open/indestructible/ftlfloor/proc/GetOurShipRoom()
	return SSships.currentships[unique_id].shiprooms[get_area(src)]

/turf/open/indestructible/ftlfloor/proc/HitByShipProjectile(var/attack_info)

/turf/closed/indestructible/ftlwall
	icon = 'ftl/icons/turf/shipfloors.dmi'
	icon_state = "test2"
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/closed/indestructible/ftlwall)
