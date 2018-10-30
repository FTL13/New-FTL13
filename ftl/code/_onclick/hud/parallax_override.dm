/*
tldr: Parallax layer 3 is useless. 
We will move it to the front and use it for custom sector layers

We also prep the planet layer to be updated.
*/


/obj/screen/parallax_layer/layer_1
  icon = 'ftl/icons/effects/parallax/parallax.dmi'
  icon_state = "empty"
  blend_mode = BLEND_OVERLAY
  speed = 4
  layer = 50
  
  
/obj/screen/parallax_layer/layer_1/Initialize()
  . = ..()
  SSftl_navigation.parallax_layer1 += src
  
  
/obj/screen/parallax_layer/layer_1/update_o(view)
  icon_state = SSftl_navigation.parallax_layer1_icon
  . = ..(view)
  
  
/obj/screen/parallax_layer/layer_2
  icon_state = "layer1"
  speed = 0.6
  layer = 1


/obj/screen/parallax_layer/layer_3
  icon_state = "layer2"
  speed = 1
  layer = 2


/obj/screen/parallax_layer/planet
  icon = 'ftl/icons/effects/parallax/planets.dmi'
  

/obj/screen/parallax_layer/planet/Initialize()
  . = ..()
  SSftl_navigation.parallax_planets += src
  icon_state = SSftl_navigation.parallax_planet_icon


/obj/screen/parallax_layer/planet/update_o() //No need to return. The return proc just returns
  icon_state = SSftl_navigation.parallax_planet_icon