datum/player_attack //Player 
	var/attackname = "Ship Attack"

	var/hull_damage = 0 //How much integrity damage an attack does to an enemy ships hull
	var/shield_damage = 1000 //How much shield damage an attack does. Wont do anything if it penetrates shields.
	var/evasion_mod = 1 //Scalar of the enemy's evasion chance. 0.5 = 50% lower chance to dodge.

	var/traits = NONE //Does this attack cause any specific modifiers?

datum/player_attack