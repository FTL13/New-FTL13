/obj/item/weapon_chip/projectile
	var/fire_delay = 5 //Time between shots
	var/shots_fired = 1

/obj/item/weapon_chip/projectile/Fire(var/turf/T)

/obj/item/weapon_chip/ion
	name = "ion cannon chip"
	weapon_name = "Ion Cannon"
	icon_name ="ion_cannon"

	//projectile_type = /obj/item/projectile/ship_projectile/phase_blast/ion
	fire_sound = 'sound/weapons/emitter2.ogg'

	attack_data = new /datum/ship_attack/ion

	charge_to_fire = 10000