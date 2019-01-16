/datum/shiproom/empty
	name = "empty room"

/datum/shiproom/bridge
	name = "bridge room"

/datum/shiproom/bridge/adjust_integrity()
	.=..()
	owner_ship.calculate_dodge_rate()

/datum/shiproom/shields
	name = "shields room"

/datum/shiproom/shields/adjust_integrity()
	.=..()
	owner_ship.calculate_max_shield()

/datum/shiproom/weapons
	name = "weapons room"

/datum/shiproom/weapons/adjust_integrity()
	.=..()
	owner_ship.calculate_fire_rate()

/datum/shiproom/engine
	name = "engine room"

/datum/shiproom/engine/adjust_integrity()
	.=..()
	owner_ship.calculate_dodge_rate()