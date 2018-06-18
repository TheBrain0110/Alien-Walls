data:extend({
  {
	type = "recipe",
	name = "alien-bioconstruct",
	--icon = '__AlienWall__/graphics/icons/biomass/alien-bioconstruct.png',
	--icon_size = 32,
	flags = {"goes-to-main-inventory"},
	subgroup = "materials",
	order = "a[alien-bioconstruct]-a",
	category = "crafting",
	enabled = "false",
	energy_required = 10,
	ingredients = 
	{
	  {"alien-artifact", 1},
	  {"steel-plate", 4}
	},
	result = "alien-bioconstruct",
	result_count = 2
  },
  {
	type = "recipe",
    name = "hybridizedWall",
	enabled = false,
    energy_required = 5,
    ingredients =
    {
	  {"alien-bioconstruct", 1},
	  {"stone-brick", 10},
    },
    result = "hybridizedWall"
  },
  {
    type = "recipe",
    name = "hybridizedGate",
	enabled = false,
    energy_required = 6,
    ingredients =
    {
	  {"alien-bioconstruct", 1},
	  {"stone-brick", 5},
	  {"iron-gear-wheel", 5},
    },
    result = "hybridizedGate"
	}
})