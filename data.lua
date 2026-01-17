local function scale_box(box, scale)
  return {
    { box[1][1] * scale, box[1][2] * scale },
    { box[2][1] * scale, box[2][2] * scale }
  }
end

local function scale_structure(structure, scale)
  if not structure then
    return
  end

  for _, direction in pairs(structure) do
    if direction.sheet then
      direction.sheet.scale = scale
    elseif direction.sheets then
      for _, sheet in pairs(direction.sheets) do
        sheet.scale = scale
      end
    end
  end
end

local tunnel = table.deepcopy(data.raw["underground-belt"]["underground-belt"])
tunnel.name = "railway-tunnel"
tunnel.icon = "__base__/graphics/icons/underground-belt.png"
tunnel.icon_size = 64
tunnel.icon_mipmaps = 4
tunnel.minable = { mining_time = 0.1, result = "railway-tunnel" }
tunnel.max_distance = tunnel.max_distance

tunnel.collision_box = scale_box(tunnel.collision_box, 2)
tunnel.selection_box = scale_box(tunnel.selection_box, 2)
scale_structure(tunnel.structure, 2)

-- Allow placement over rails by omitting the rail-layer collision mask.
tunnel.collision_mask = { layers = { "item-layer", "object-layer", "player-layer", "water-tile" } }

local item = table.deepcopy(data.raw.item["underground-belt"])
item.name = "railway-tunnel"
item.icon = "__base__/graphics/icons/underground-belt.png"
item.icon_size = 64
item.icon_mipmaps = 4
item.place_result = "railway-tunnel"
item.subgroup = "transport"
item.order = "b[transport-belt]-d[railway-tunnel]"
item.stack_size = 50

local recipe = table.deepcopy(data.raw.recipe["underground-belt"])
recipe.name = "railway-tunnel"
recipe.enabled = false
recipe.ingredients = {
  { "underground-belt", 2 },
  { "rail", 10 },
  { "iron-plate", 20 }
}
recipe.result = "railway-tunnel"

local technology = table.deepcopy(data.raw.technology["logistics-2"])
technology.name = "railway-tunnel"
technology.effects = {
  { type = "unlock-recipe", recipe = "railway-tunnel" }
}
technology.unit = {
  count = 150,
  ingredients = {
    { "automation-science-pack", 1 },
    { "logistic-science-pack", 1 }
  },
  time = 30
}
technology.prerequisites = { "logistics-2", "railway" }

data:extend({ tunnel, item, recipe, technology })
