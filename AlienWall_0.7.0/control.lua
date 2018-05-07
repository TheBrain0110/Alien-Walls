require("util")
require("variable")

-- As with many things, I'm tempted to dynamically generate this list. But it works for now.
wallNames = {"hybrid-wall", "hybrid-wall-tier-2", "hybrid-wall-tier-3", "hybrid-wall-tier-4", "hybrid-wall-tier-5"}
gateNames = {"hybrid-gate", "hybrid-gate-tier-2", "hybrid-gate-tier-3", "hybrid-gate-tier-4", "hybrid-gate-tier-5"}
regenrate = nil
walltier = nil


function upgrade_wall_section(wall)
   -- Get the current health percentage. We don't want all the new wall sections to be at max health if the old ones weren't.
   local healthPercent = wall.health / game.entity_prototypes[wall.name].max_health
   local pos = wall.position
   local dir = wall.direction
   local newWall = {}
   -- Is the current thing a gate?
   if string.find(wall.name, "gate") ~= nil then
      -- Create a gate.
      wall.destroy()
      newWall = game.surfaces[1].create_entity{name = gateNames[walltier], position = pos, direction = dir, force = game.forces.player}
      -- Set the health of the new level gate.
      newWall.health = game.entity_prototypes[gateNames[walltier]].max_health * healthPercent
   else
      -- Create a wall section.
      -- Currently hardcodes to use surface[1]. Very rarely do maps use multiple surfaces, but something to keep in mind.
      -- Must destroy existing wall first, otherwise create_entity fails and returns nil.
      wall.destroy()
      newWall = game.surfaces[1].create_entity{name = wallNames[walltier], position = pos, direction = dir, force = game.forces.player}
      -- Set the health of the new level wall.
      newWall.health = game.entity_prototypes[wallNames[walltier]].max_health * healthPercent
   end
   return newWall
end

function update_walls()
   local newWalls = {}
   -- Replace each wall section (or gate) with one of the newer wall/gate level.
   for _, wall in pairs(global.alienwall) do
	   game.players[1].print("I'm a wall in the registry array!")
	   game.players[1].print(tostring(wall))
      -- If it's dead we don't need to upgrade.
      -- No need to remove it either, as the current list will be obsolete soon.
      if wall.valid then
         local newWall = upgrade_wall_section(wall)
         -- Insert into the list of new wall sections.
         table.insert(newWalls, newWall)
      end
   end
   -- The old list is obsolete now, simply overwrite.
   global.alienwall = newWalls
end

function on_built(entity)
    -- We have to consider different names now, with the levels. So use string.find to check if it's a wall/gate.
    if string.find(entity.name, "hybrid%-wall") or string.find(entity.name, "hybrid%-gate") then
      -- If we're at level 2 we'll need to upgade.
      local newWall = upgrade_wall_section(entity)
      -- Store it in the global list for later healing and possible levelling.
      table.insert(global.alienwall, newWall)
    end
end

function heal_wall()
   if global.alienwall ~= nil then
      for k,alienwall in pairs(global.alienwall) do
         if alienwall.valid then
            local health = alienwall.health
            if health < game.entity_prototypes[alienwall.name].max_health then -- Haven't profiled it, but instinct tells me this might be an expensive lookup to do inside the loop for each wall piece. See about caching the current tier's max HP maybe?
                alienwall.health = health + regenrate
            end
         else
            table.remove(global.alienwall, k)
         end
      end
   end
end

function update_current_tier(force)
	-- Regen rates could probably also be a list in variable.lua / mod-settings.json.
	-- Ideally, the regen rates would also be tied to the wall entities and we wouldn't be relying on globals at all. Would make multiplayer forces work properly as well. But that's another project for another time.
	if force.technologies["alien-hybrid-upgrade-1"].researched then
        global.alienregenrate = 5
        global.alienwalltier = 2
	end
	if force.technologies["alien-hybrid-upgrade-2"].researched then
        global.alienregenrate = 10
        global.alienwalltier = 3
	end
	if force.technologies["alien-hybrid-upgrade-3"].researched then
        global.alienregenrate = 15
        global.alienwalltier = 4
	end
	if force.technologies["alien-hybrid-upgrade-4"].researched then
        global.alienregenrate = 25
        global.alienwalltier = 5
	end
    regenrate = global.alienregenrate
    walltier = global.alienwalltier
end

function init()
   global.alienwall = {}
   global.alienregenrate = HybridRegen
   global.alienwalltier = 1
   regenrate = global.alienregenrate
   walltier = global.alienwalltier
end

function load()
	regenrate = global.alienregenrate
	walltier = global.alienwalltier
    -- Replacing all walls on startup may or may not be a good idea, but should help keep things consistent
    -- The `game` global isn't available during init, or `on_load`.
    -- update_walls()
end

script.on_init(init)
script.on_load(load)

script.on_event(defines.events.on_built_entity, function(event) on_built(event.created_entity) end)
script.on_event(defines.events.on_robot_built_entity, function(event) on_built(event.created_entity) end)

script.on_event(defines.events.on_tick, function(event)
      if (game.tick % 60) == 0 then
          heal_wall()
      end
end)

script.on_event(defines.events.on_research_finished, function(event)
    local research = event.research.name
    if string.find(research, "alien%-hybrid%-upgrade") then
        update_current_tier(game.player.force)
		-- I'm still not sure if it's possible to handle multiple player forces with different tiers, but in theory you'd call the force of the one doing the research here, not `player`.
        update_walls()
    end
end   
)