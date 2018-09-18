/datum/sector
  var/name = ""
  var/id
  var/unique = FALSE
  var/frequency = 10
  var/visited = FALSE

  var/sector_type = "bad sector"
  //
  // var/datum/faction/controlling_faction
  //
  var/datum/planet/planet
  var/datum/station/station

  var/list/connected_sectors = list()
  var/generated_sectors = FALSE

  var/planet_prob = 50
  var/station_prob = 50


/datum/sector/New()
  SSftl_navigation.sector_count ++
  id = "[SSftl_navigation.sector_count]"
  for(var/i in 1 to rand(2,4))
    name += pick(SSftl_navigation.sector_name_fragments)
  name = capitalize(name) + " [id]"
  if(prob(planet_prob))
    var/p = pickweight(SSftl_navigation.planet_types)
    planet = new p

  if(prob(station_prob))
    station = new /datum/station

/datum/sector/empty
  sector_type = "empty sector"

/datum/planet
  var/name = "null planet"
  var/frequency = 1


/datum/planet/habitable
  name = "habitable planet"


/datum/planet/ice
  name = "ice planet"


/datum/planet/barren
  name = "barren planet"


/datum/planet/gas
  name = "gas giant"


/datum/station
  var/name = "station"
  var/unique = FALSE
  var/frequency = 10


/*
In a nutshell, named sectors are custom sectors that we define.
They will only spawn once and will not randomly generate. It's all down to coders.
Want to recreate Dolos? Go for it
Sol 3 sure why not.

*/
/datum/sector/named
  name = "Named Sector"
  unique = TRUE
  frequency = -1

/datum/sector/named/New()
  SSftl_navigation.sector_count ++
  id = "[SSftl_navigation.sector_count]"
  name += " [id]"

  if(prob(planet_prob))
    var/p = pickweight(SSftl_navigation.planet_types)
    planet = new p

  if(prob(station_prob))
    station = new /datum/station

/datum/sector/named/dolos
  name = "Dolos 1" //The intention is to let an antag emag the console to force a jump to this system.
  frequency = -1 //Will not randomly spawn, but is unique
  sector_type = "Syndicate Homeworld"

/datum/sector/named/nt_home
  name = "Gooftown"
  frequency = -1 //Will not randomly spawn, but is unique
  sector_type = "Nanotrasen Homeworld"

/datum/sector/named/sol
  name = "Sol 3"
  frequency = 1
  sector_type = "Sol Gov Homeworld"
