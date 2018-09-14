/obj/item/weapon_chip //Chips that players can use to fire at an enemy
	name = "basic phase cannon chip"
	desc = "I could use this to change the programming of the ship's attack matrix" //lol what does that even mean
	icon = 'ftl/icons/obj/items.dmi'
	icon_state = "permit"

	var/weapon_name = "Phaser Cannon"
	var/icon_name ="phase_cannon"

	var/attackname = "Ship Attack"

	var/hull_damage = 0 //How much integrity damage an attack does to an enemy ships hull
	var/shield_damage = 1000 //How much shield damage an attack does. Wont do anything if it penetrates shields.
	var/evasion_mod = 1 //Scalar of the enemy's evasion chance. 0.5 = 50% lower chance to dodge.

	var/traits = NONE //Does this attack cause any specific modifiers?


	//var/fire_sound = 'sound/effects/phasefire.ogg'
	var/datum/ship_attack/attack_data = new /datum/ship_attack/laser

	var/charge_to_fire = 2000

/obj/item/weapon_chip/Fire()

/obj/item/weapon_chip/ion
	name = "ion cannon chip"
	weapon_name = "Ion Cannon"
	icon_name ="ion_cannon"

	//projectile_type = /obj/item/projectile/ship_projectile/phase_blast/ion
	fire_sound = 'sound/weapons/emitter2.ogg'

	attack_data = new /datum/ship_attack/ion

	charge_to_fire = 10000