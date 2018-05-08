data:extend({
  {
    type = "item",
    name = "alien-biomass",
	icon = "__AlienWall__/graphics/icons/biomass/alien-artifacts.png",
	icon_size = 32,
    flags = {"goes-to-main-inventory"},
    subgroup = "raw-resource",
    order = "f[alien-biomass]",
    stack_size = 50
  },
  {
    type = "recipe",
    name = "alien-bioconstruct",
	flags = {"goes-to-main-inventory"},
    order = "f[alien-bioconstruct]",
    enabled = "false",
    ingredients = {{"alien-biomass", 5}},
    result = "alien-bioconstruct"
  },
  
    {
    type = "item",
    name = "alien-bioconstruct",
	icon = "__AlienWall__/graphics/icons/biomass/alien-bioconstruct.png",
	icon_size = 32,
    flags = {"goes-to-main-inventory"},
    subgroup = "raw-material",
    order = "f[alien-bioconstruct]",
    stack_size = 50,
	durability = 1,
  }
})