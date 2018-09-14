//Weapons console
/mob/camera/aiEye/remote/weapons
	visible_icon = 1
	icon = 'icons/obj/abductor.dmi'
	icon_state = "camera_target"
	var/datum/action/innate/fire_weapon/fire_weapon
	var/datum/action/innate/jump_to_ship/jump_to_ship

/mob/camera/aiEye/remote/weapons/Initialize()
	. = ..()
	fire_weapon = new
	jump_to_ship = new

/mob/camera/aiEye/remote/weapons/setLoc(var/t)
	var/area/new_area = get_area(t)
	if(new_area && new_area.weaponconsole_compatible)
		return ..()
	else
		return

/mob/camera/aiEye/remote/weapons/proc/JumpToShip()
	var/obj/effect/landmark/ship_spawn = SSships.GetUsedSpawnSlot()
	if(!ship_spawn)
		return
	setLoc(ship_spawn.loc)


/obj/machinery/computer/camera_advanced/weapons
	name = "Weapons Console"
	desc = "Used to aim nearby weapons"
	icon_screen = "cameras"
	icon_keyboard = "security_key"
	var/datum/action/innate/fire_weapon/fire_weapon
	var/datum/action/innate/fire_weapon/jump_to_ship

/obj/machinery/computer/camera_advanced/weapons/Initialize()
	z_lock |= SSmapping.levels_by_trait(ZTRAIT_SPACECOMBAT)

/obj/machinery/computer/camera_advanced/weapons/CreateEye()
	eyeobj = new /mob/camera/aiEye/remote/weapons(get_turf(src))
	eyeobj.origin = src
	eyeobj.visible_icon = 1
	eyeobj.icon = 'icons/obj/abductor.dmi'
	eyeobj.icon_state = "camera_target"

/obj/machinery/computer/camera_advanced/weapons/GrantActions(mob/living/user)
	..()

	if(fire_weapon)
		fire_weapon.target = src
		fire_weapon.Grant(user)
		actions += fire_weapon

	if(jump_to_ship)
		jump_to_ship.target = src
		jump_to_ship.Grant(user)
		actions += jump_to_ship

/datum/action/innate/fire_weapon
	name = "Fire Weapon"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "monkey_down"

/datum/action/innate/fire_weapon/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/C = owner
	var/mob/camera/aiEye/remote/weapons/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/weapons/console = target

	explosion(remote_eye.loc, 0,0,1,1)

/datum/action/innate/jump_to_ship
	name = "Jump to enemy ship"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "monkey_down"

/datum/action/innate/jump_to_ship/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/C = owner
	var/mob/camera/aiEye/remote/weapons/remote_eye = C.remote_control

	remote_eye.JumpToShip()
