/datum/shiproom
	var/name = "error ship room"
	var/datum/starship/owner_ship
	var/integrity = 10

/datum/shiproom/New(var/datum/starship/s)
	owner_ship = s
	
/datum/shiproom/proc/adjust_integrity(change)
	integrity = CLAMP(integrity + change, 0, initial(integrity))

/datum/shiproom/proc/is_active()
	return(integrity > 0)

/datum/shiproom/proc/get_integrity_modifier()
	return integrity / initial(integrity)
