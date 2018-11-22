/turf/open/indestructible/ftlfloor
	icon = 'ftl/icons/turf/shipfloors.dmi'
	icon_state = "test3"
	var/effects = NONE //Bitflag of current modifiers to this turfs
	var/unique_id //links back to our ship

/turf/open/indestructible/ftlfloor/proc/GetOurShip()
	return SSships.currentships[unique_id]

/turf/open/indestructible/ftlfloor/proc/GetOurShipRoom()
	return SSships.currentships[unique_id].shiprooms[get_area(src)]

/turf/open/indestructible/ftlfloor/proc/HitByShipProjectile(var/datum/player_attack/attack_info)
	var/datum/starship/S = GetOurShip()
	S.adjust_hull(-attack_info.hull_damage)
	message_admins("[GetOurShipRoom()]")

/turf/closed/indestructible/ftlwall
	icon = 'ftl/icons/turf/shipfloors.dmi'
	icon_state = "test2"
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/closed/indestructible/ftlwall)
