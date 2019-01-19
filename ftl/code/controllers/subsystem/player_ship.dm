PROCESSING_SUBSYSTEM_DEF(player_ship)
	name = "Player Ship"
	wait = 10
	init_order = INIT_ORDER_FTL_NAV
	flags = SS_BACKGROUND

	var/hull_integrity
	var/max_hull_integrity = 50
	
	var/shield_integrity
	var/max_shield_integrity = 10

	var/dodge_chance = 5 //Make this based on some kind of upgrade later

/datum/controller/subsystem/processing/player_ship/Initialize(timeofday)
	. = ..()
	hull_integrity = max_hull_integrity
	shield_integrity = max_shield_integrity

/datum/controller/subsystem/processing/player_ship/proc/hit(var/datum/shipweapon/W)
	if(prob(get_dodge_chance() * W.evasion_mod))
		message_admins("shot missed")
		return
	if(shield_integrity) //shot blocked by shields TODO: Make this visibly hit the shields and add actual visual shields.
		adjust_shield(-W.shield_damage)
		message_admins("player shield hit")
		return
	adjust_hull(-W.hull_damage)
	
/datum/controller/subsystem/processing/player_ship/proc/adjust_hull(var/change)
	hull_integrity = min(hull_integrity + change, max_hull_integrity)
	if(hull_integrity <= 0)
		ship_destruction()

/datum/controller/subsystem/processing/player_ship/proc/adjust_shield(var/change)
	shield_integrity = min(shield_integrity + change, max_shield_integrity)

/datum/controller/subsystem/processing/player_ship/proc/ship_destruction()
	return

/datum/controller/subsystem/processing/player_ship/proc/get_dodge_chance() //Make this more advanced later
	return dodge_chance
