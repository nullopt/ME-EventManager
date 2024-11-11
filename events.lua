--[[
    File: events.lua
    Description: This file contains the EventSystem class which manages event subscriptions, triggering, and tracking for NPCs and Players.
    Author: nullopt
    Version: 1.0.0
]]

local API = require("api")

---@class EventSystem
---@field public listeners table<string, function[]>
---@field public events Events
---@field private _npcs table<number, AllObject>
---@field private _players table<number, AllObject>
---@field private _previousNpcAnimations table<number, number>
---@field private _previousPlayerAnimations table<number, number>
---@field private _previousPlayerHealth number
local EventSystem = {
    listeners = {},
    ---@class Events
    ---@field onNpcSpawn string
    ---@field onNpcDeath string
    ---@field onNpcAnimationChange string
    ---@field onPlayerSpawn string
    ---@field onPlayerDeath string
    ---@field onPlayerAnimationChange string
    ---@field onPlayerHealthChanged string
    ---@field onItemSpawn string
    ---@field onItemDespawn string
    events = {
        onNpcSpawn = "onNpcSpawn",
        onNpcDeath = "onNpcDeath",
        onNpcAnimationChange = "onNpcAnimationChange",
        onPlayerSpawn = "onPlayerSpawn",
        onPlayerDeath = "onPlayerDeath",
        onPlayerAnimationChange = "onPlayerAnimationChange",
        onPlayerHealthChanged = "onPlayerHealthChanged",
        onItemSpawn = "onItemSpawn",
        onItemDespawn = "onItemDespawn",
    },
    _npcs = {},
    _players = {},
    _items = {},
    _previousNpcAnimations = {},
    _previousPlayerAnimations = {},
    _previousPlayerHealth = API.GetHP_(),
}

---@description Subscribe to an event
---@param eventName string: The name of the event
---@param callback function: The function to call when the event is triggered
function EventSystem:subscribe(eventName, callback)
    if not self.listeners[eventName] then
        self.listeners[eventName] = {}
    end
    table.insert(self.listeners[eventName], callback)
end

---@description Unsubscribe from an event
---@param eventName string: The name of the event
function EventSystem:unsubscribe(eventName)
    if not self.listeners[eventName] then return end
    self.listeners[eventName] = {}
end

---@description Trigger an event
---@param eventName string: The name of the event
---@param ... any: Additional arguments to pass to the event listeners
function EventSystem:trigger(eventName, ...)
    if not self.listeners[eventName] then return end
    for _, listener in ipairs(self.listeners[eventName]) do
        local success, err = xpcall(listener, debug.traceback, ...)
        if not success then
            print(err)
        end
    end
end

---@description Track events - to be called in the main loop
function EventSystem:trackEvents()
    self:_allEntitiesLoop()
end

---@description Track NPC events
---@param entity AllObject: The NPC entity
function EventSystem:_allNpcsLoop(entity, currentNpcs)
    currentNpcs[entity.Unique_Id] = entity
    if not self._npcs[entity.Unique_Id] then
        self:trigger(self.events.onNpcSpawn, entity)
    end
    if self._previousNpcAnimations[entity.Unique_Id] and self._previousNpcAnimations[entity.Unique_Id] ~= entity.Anim then
        self:trigger(self.events.onNpcAnimationChange, entity, entity.Anim)
    end
    self._previousNpcAnimations[entity.Unique_Id] = entity.Anim
end

---@description Track player events
---@param entity AllObject: The player entity
function EventSystem:_allPlayersLoop(entity, currentPlayers)
    currentPlayers[entity.Unique_Id] = entity
    if not self._players[entity.Unique_Id] then
        self:trigger(self.events.onPlayerSpawn, entity)
    end
    if self._previousPlayerAnimations[entity.Unique_Id] and self._previousPlayerAnimations[entity.Unique_Id] ~= entity.Anim then
        self:trigger(self.events.onPlayerAnimationChange, entity, entity.Anim)
    end
    if self._previousPlayerHealth and self._previousPlayerHealth ~= API.GetHP_() then
        self:trigger(self.events.onPlayerHealthChanged, self._previousPlayerHealth, API.GetHP_())
    end
    self._previousPlayerAnimations[entity.Unique_Id] = entity.Anim
    self._previousPlayerHealth = API.GetHP_()
end

function EventSystem:_allItemsLoop(entity, currentItems)
    currentItems[entity.Unique_Id] = entity
    if not self._items[entity.Unique_Id] then
        self:trigger(self.events.onItemSpawn, entity)
    end
end

function EventSystem:_allEntitiesLoop()
    ---@type AllObject[]
    local allEntities = API.ReadAllObjectsArray({ -1 }, { -1 }, {})
    ---@type table<number, AllObject>
    local currentNpcs = {}
    ---@type table<number, AllObject>
    local currentPlayers = {}
    ---@type table<number, AllObject>
    local currentItems = {}

    for _, entity in ipairs(allEntities) do
        if entity.Type == 1 then
            self:_allNpcsLoop(entity, currentNpcs)
        elseif entity.Type == 2 then
            self:_allPlayersLoop(entity, currentPlayers)
        elseif entity.Type == 3 then
            self:_allItemsLoop(entity, currentItems)
        end
    end

    -- Check for NPC deaths
    for uniqueId, npc in pairs(self._npcs) do
        if not currentNpcs[uniqueId] then
            self:trigger(self.events.onNpcDeath, npc)
            currentNpcs[uniqueId] = nil
            self._previousNpcAnimations[uniqueId] = nil
        end
    end

    -- Check for player deaths
    for uniqueId, player in pairs(self._players) do
        if not currentPlayers[uniqueId] then
            self:trigger(self.events.onPlayerDeath, player)
            currentPlayers[uniqueId] = nil
            self._previousPlayerAnimations[uniqueId] = nil
        end
    end

    -- Check for item despawns
    -- TODO: check multiple items despawning on the same tick
    for uniqueId, item in pairs(self._items) do
        if not currentItems[uniqueId] then
            self:trigger(self.events.onItemDespawn, item)
            currentItems[uniqueId] = nil
        end
    end

    -- Update tracked entities
    self._npcs = currentNpcs
    self._players = currentPlayers
    self._items = currentItems
end

return EventSystem
