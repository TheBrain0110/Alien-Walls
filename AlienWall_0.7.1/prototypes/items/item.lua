data:extend({
  {
	type = "item",
	name = "alien-bioconstruct",
	icon = "__AlienWall__/graphics/icons/biomass/alien-bioconstruct.png",
	icon_size = 32,
	flags = {"goes-to-main-inventory"},
	subgroup = "materials",
	order = "a[exo-skeleton]-a",
	stack_size = 50,
	durability = 1,
  },
  {
    type = "item",
    name = "hybridizedWall",
    icon = "__AlienWall__/graphics/icons/wall/hybrid-wall.png",
	icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "structures",
    order = "a[hybridWall]",
    place_result = "hybridWall",
    stack_size = 50
  },
  {
    type = "item",
    name = "hybridizedGate",
    icon = "__AlienWall__/graphics/icons/gate/hybrid-gate.png",
	icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "structures",
    order = "b[hybridGate]",
    place_result = "hybridGate",
    stack_size = 50
  }
})