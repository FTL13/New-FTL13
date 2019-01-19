/datum/component/airsiphon
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/moles_per_tick = 1
	var/atom/our_atom

/datum/component/airsiphon/Initialize(moles_per_tick)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	START_PROCESSING(SSplayer_ship, src)
	our_atom = parent
	src.moles_per_tick = moles_per_tick
	return ..()

/datum/component/airsiphon/Destroy()
	STOP_PROCESSING(SSplayer_ship, src)
	return ..()

/datum/component/airsiphon/process()
	message_admins("gasleak")
	var/datum/gas_mixture/air = our_atom.return_air()
	air.remove(moles_per_tick)
	our_atom.air_update_turf()