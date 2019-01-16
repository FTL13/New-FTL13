/datum/shiproom
	var/name = "error ship room"
	var/datum/starship/owner_ship

/datum/shiproom/New(var/datum/starship/s)
	owner_ship = s
	