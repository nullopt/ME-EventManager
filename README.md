# ME-EventSystem

The `EventSystem` is a Lua module designed to manage event subscriptions, triggering, and tracking for NPCs, Players, and Items within a game environment. It provides a flexible way to handle various game events such as spawning, death, animation changes, and health changes.

## Features

- **Event Subscription**: Allows functions to subscribe to specific events.
- **Event Unsubscription**: Allows functions to unsubscribe from specific events.
- **Event Triggering**: Triggers events and notifies all subscribed listeners.
- **Entity Tracking**: Tracks NPCs, Players, and Items, and triggers events based on their state changes.

## Events

The `EventSystem` supports the following events:

- `onNpcSpawn`: Triggered when an NPC spawns.
- `onNpcDeath`: Triggered when an NPC dies.
- `onNpcAnimationChange`: Triggered when an NPC's animation changes.
- `onPlayerSpawn`: Triggered when a player spawns.
- `onPlayerDeath`: Triggered when a player dies.
- `onPlayerAnimationChange`: Triggered when a player's animation changes.
- `onPlayerHealthChanged`: Triggered when a player's health changes.
- `onItemSpawn`: Triggered when an item spawns.
- `onItemDespawn`: Triggered when an item despawns.
- `onTargetBuffGain`: Triggered when a target gains a buff.
- `onTargetBuffLose`: Triggered when a target loses a buff.
- `onCastAbility`: Triggered when a player casts an ability.

## Usage

### Subscribing to Events

To subscribe to an event, use the `subscribe` method:

```lua
EventSystem:subscribe("eventName", function(eventData)
    -- Handle the event
end)
```

### Unsubscribing from Events

To unsubscribe from an event, use the `unsubscribe` method:

```lua
EventSystem:unsubscribe("eventName")
```

### Triggering Events

Events are automatically triggered by the system based on entity state changes. However, you can manually trigger an event using the `trigger` method:

```lua
EventSystem:trigger("eventName", eventData)
```

### Tracking Events

To track events, call the `trackEvents` method within your main game loop:

```lua
EventSystem:trackEvents()
```

## Internal Methods

- `_allEntitiesLoop`: Iterates over all entities and triggers appropriate events.
- `_allNpcsLoop`: Handles NPC-specific events.
- `_allPlayersLoop`: Handles player-specific events.
- `_allItemsLoop`: Handles item-specific events.

## Examples

See the `events-test.lua` file for examples of how to use the `EventSystem`.

## Author

- **nullopt**

## Version

- **1.0.0**

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.