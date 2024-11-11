local API = require("api")
local EVENTS = require("events")

---@param npc AllObject
---@param animation number
EVENTS:subscribe(EVENTS.events.onNpcAnimationChange, function(npc, animation)
    if npc and npc.Id ~= nil then
        print(string.format("NPC %s changed animation to %s", npc.Id, animation))
    end
end)

---@param npc AllObject
EVENTS:subscribe(EVENTS.events.onNpcSpawn, function(npc)
    if npc and npc.Id ~= nil then
        print(string.format("NPC %s spawned", npc.Id))
    end
end)

---@param npc AllObject
EVENTS:subscribe(EVENTS.events.onNpcDeath, function(npc)
    if npc and npc.Id ~= nil then
        print(string.format("NPC %s died", npc.Id))
    end
end)

---@param player AllObject
EVENTS:subscribe(EVENTS.events.onPlayerSpawn, function(player)
    if player and player.Name ~= nil then
        print(string.format("Player %s spawned", player.Name))
    end
end)

---@param player AllObject
EVENTS:subscribe(EVENTS.events.onPlayerDeath, function(player)
    if player and player.Name ~= nil then
        print(string.format("Player %s died", player.Name))
    end
end)

---@param player AllObject
---@param animation number
EVENTS:subscribe(EVENTS.events.onPlayerAnimationChange, function(player, animation)
    if player and player.Name ~= nil then
        print(string.format("Player %s changed animation to %s", player.Name, animation))
    end
end)

---@param health number
EVENTS:subscribe(EVENTS.events.onPlayerHealthChanged, function(health)
    print(string.format("Player health changed to %s", health))
end)

while API.Read_LoopyLoop() do
    EVENTS:trackEvents()
    API.RandomSleep2(10, 0, 0)
end
