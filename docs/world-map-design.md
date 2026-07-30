# LumaVale – World Map Design

## Purpose

This document defines the world hierarchy, initial playable maps, map transitions, and standard Tiled layer structure for LumaVale.

Phase 0 focuses only on the minimum map design required to support the first vertical slice.

---

# World Hierarchy

```text
World
├── LumaVale Town
│   ├── Town Square
│   ├── Marketplace
│   ├── Tavern
│   └── Blacksmith
├── Whispering Forest
├── Ember Mine
└── Ancient Hollow
```

## World Area Purpose

| Area              | Purpose                                   | MVP Status          |
| ----------------- | ----------------------------------------- | ------------------- |
| Town Square       | Starting area, quest hub, NPC interaction | Vertical Slice      |
| Marketplace       | Trading and merchant services             | Future MVP          |
| Tavern            | Social and narrative location             | Future MVP          |
| Blacksmith        | Equipment and crafting services           | Future MVP          |
| Whispering Forest | Exploration, gathering, and basic combat  | Vertical Slice      |
| Ember Mine        | Rare resources and higher danger          | Post-Vertical Slice |
| Ancient Hollow    | Dungeon and boss encounters               | Post-Vertical Slice |

---

# Phase 0 Scope

Phase 0 requires only:

* One world map diagram
* One Town Square map
* One Whispering Forest prototype
* One transition between the two maps
* Standardized Tiled layers
* Spawn and interaction markers

Phase 0 does not require completed art, advanced combat, NPC schedules, or multiple playable zones.

---

# World Map Diagram

```text
                    ┌──────────────────────┐
                    │    Ancient Hollow    │
                    │ Dungeon and Bosses   │
                    └──────────▲───────────┘
                               │
                               │ Future Route
                               │
┌──────────────────┐     ┌─────┴──────────────┐
│    Ember Mine    │◄────│ Whispering Forest │
│ Rare Resources  │     │ Explore and Fight  │
└──────────────────┘     └─────────▲──────────┘
                                   │
                            Forest Gate
                                   │
                         ┌─────────┴──────────┐
                         │  LumaVale Town    │
                         │                   │
                         │  Town Square      │
                         │  Marketplace      │
                         │  Tavern           │
                         │  Blacksmith       │
                         └────────────────────┘
```

Only the route between **Town Square** and **Whispering Forest** is active in the first vertical slice.

---

# Map 1 – LumaVale Town Square

## Purpose

Town Square is the player's starting location and primary safe area.

The map should immediately communicate:

* Where the player is
* Where to obtain a quest
* Which objects are interactive
* How to enter Whispering Forest
* How to return to important town services

## Required Locations

```text
Town Square
├── Player Spawn
├── Quest Board
├── Merchant
├── Blacksmith
├── Tavern
└── Forest Gate
```

## Suggested Layout

```text
┌──────────────────────────────────────┐
│             Tavern                   │
│                                      │
│ Merchant       Town Plaza     Blacksmith
│                                      │
│              Quest Board             │
│                                      │
│            Player Spawn              │
│                                      │
│             Forest Gate              │
└──────────────────────────────────────┘
```

## Design Rules

* The Quest Board must be visible shortly after spawning.
* The Forest Gate must be visually distinct.
* The player must not walk behind inaccessible building interiors.
* Important NPCs should not block the main path.
* The player should reach the Forest Gate within 20–30 seconds.
* Decorative objects must not hide interactive objects.

---

# Map 2 – Whispering Forest Prototype

## Purpose

Whispering Forest proves the exploration, gathering, combat, and return loop.

## Required Content

```text
Whispering Forest
├── Town Return Gate
├── Player Spawn
├── Slime Spawn Area
├── Herb Nodes
├── Tree Resource Nodes
├── Treasure Chest
└── Small Exploration Path
```

## Suggested Layout

```text
┌──────────────────────────────────────┐
│        Trees and blocked area        │
│                                      │
│ Herb Area         Slime Area         │
│                                      │
│       Main Exploration Path          │
│                                      │
│ Tree Resource      Treasure Chest    │
│                                      │
│ Spawn Point        Return Gate       │
└──────────────────────────────────────┘
```

## Design Rules

* The return gate must remain easy to find.
* The player should encounter the first resource within 15 seconds.
* The player should encounter the first Slime within 30 seconds.
* The treasure chest should reward basic exploration.
* The prototype should contain at least one optional path.
* Collision boundaries must prevent the player from leaving the playable area.
* The map should be completable without a minimap.

---

# Map Transition

The first vertical slice uses two transitions:

```text
Town Square Forest Gate
        ↓
Whispering Forest Spawn

Whispering Forest Return Gate
        ↓
Town Square Forest Gate Spawn
```

## Transition Flow

1. Player enters the portal or interaction area.
2. Player movement is temporarily disabled.
3. A short fade-out begins.
4. The target map is loaded.
5. The player appears at the target spawn point.
6. A fade-in completes.
7. Player movement is enabled.

## Transition Requirements

Each portal must define:

* `targetMap`
* `targetSpawnId`
* `interactionType`
* `isEnabled`

Example object properties:

```text
name: forest_gate
type: portal
targetMap: whispering-forest
targetSpawnId: forest_entry
interactionType: overlap
isEnabled: true
```

## Recommended Interaction

For Phase 0, use automatic overlap transition.

Later versions may require pressing an interaction key to prevent accidental transitions.

---

# Standard Tiled Layer Structure

All maps must use the following layer names and order.

```text
Ground
GroundDetails
Paths
BuildingsBack
Objects
Decorations
Collision
Interaction
SpawnPoints
NPCPaths
BuildingsFront
AbovePlayer
```

Layer names are case-sensitive and must remain consistent across every map.

---

# Layer Definitions

## 1. Ground

Base terrain tiles.

Examples:

* Grass
* Dirt
* Stone floor
* Wooden floor

Required: Yes

---

## 2. GroundDetails

Visual details placed directly above the ground.

Examples:

* Small flowers
* Grass variations
* Cracks
* Fallen leaves

Required: Optional

This layer must not contain collision.

---

## 3. Paths

Walkable routes that guide player movement.

Examples:

* Dirt paths
* Stone roads
* Forest trails

Required: Recommended

---

## 4. BuildingsBack

Building sections rendered behind the player.

Examples:

* Building walls
* Roof back sections
* Large environmental structures

Required: Town maps only

---

## 5. Objects

World objects rendered near player level.

Examples:

* Tables
* Barrels
* Fences
* Resource nodes
* Quest Board

Required: Yes

---

## 6. Decorations

Non-interactive visual objects.

Examples:

* Flowers
* Signs
* Small rocks
* Banners

Required: Optional

Decorations must not contain gameplay logic.

---

## 7. Collision

Defines blocked areas.

Examples:

* Walls
* Trees
* Water
* Buildings
* Map boundaries

Recommended type: Object Layer

The layer may contain:

* Rectangles
* Polygons
* Tile collision markers

The layer should be hidden during normal gameplay.

---

## 8. Interaction

Defines gameplay interaction areas.

Examples:

* Portal zones
* NPC interaction zones
* Quest Board trigger
* Treasure chest trigger
* Resource gathering zones

Recommended type: Object Layer

Each object must include a clear `type`.

Example values:

```text
portal
npc
quest_board
resource
treasure_chest
```

---

## 9. SpawnPoints

Defines entity spawn locations.

Recommended type: Object Layer

Example object names:

```text
player_default
forest_entry
town_return
slime_spawn_01
slime_spawn_02
merchant_spawn
guard_spawn
farmer_spawn
```

Each spawn point must have a unique name within the map.

---

## 10. NPCPaths

Defines movement paths for NPCs.

Recommended type: Object Layer using polylines.

Example properties:

```text
npcId: farmer_01
pathType: patrol
speed: 40
loop: true
```

NPC path logic is not required in Phase 0, but the layer should be reserved.

---

## 11. BuildingsFront

Building parts rendered in front of the player.

Examples:

* Roof edges
* Door frames
* Tall foreground walls

Required: Town maps only

---

## 12. AbovePlayer

Elements that must always render above the player.

Examples:

* Tree canopy
* Archways
* Foreground shadows
* Hanging banners

Required: Optional

---

# Layer Type Summary

| Layer          | Recommended Tiled Type | Collision | Visible During Gameplay |
| -------------- | ---------------------- | --------: | ----------------------: |
| Ground         | Tile Layer             |        No |                     Yes |
| GroundDetails  | Tile Layer             |        No |                     Yes |
| Paths          | Tile Layer             |        No |                     Yes |
| BuildingsBack  | Tile Layer             |  Optional |                     Yes |
| Objects        | Tile or Object Layer   |  Optional |                     Yes |
| Decorations    | Tile Layer             |        No |                     Yes |
| Collision      | Object Layer           |       Yes |                      No |
| Interaction    | Object Layer           |        No |                      No |
| SpawnPoints    | Object Layer           |        No |                      No |
| NPCPaths       | Object Layer           |        No |                      No |
| BuildingsFront | Tile Layer             |  Optional |                     Yes |
| AbovePlayer    | Tile Layer             |        No |                     Yes |

---

# Object Naming Convention

Use lowercase `snake_case`.

## Examples

```text
forest_gate
town_return_gate
quest_board_main
merchant_01
slime_spawn_01
herb_node_01
treasure_chest_01
```

Avoid names such as:

```text
Object1
SpawnNew
Gate Test
NPC Final Final
```

---

# Map File Naming Convention

```text
town-square.json
whispering-forest.json
```

Tileset files:

```text
lumavale-terrain.tsx
lumavale-buildings.tsx
lumavale-objects.tsx
```

Image files:

```text
lumavale-terrain.png
lumavale-buildings.png
lumavale-objects.png
```

---

# Suggested Project Structure

```text
assets/
└── maps/
    ├── town-square.json
    ├── whispering-forest.json
    └── tilesets/
        ├── lumavale-terrain.tsx
        ├── lumavale-terrain.png
        ├── lumavale-buildings.tsx
        ├── lumavale-buildings.png
        ├── lumavale-objects.tsx
        └── lumavale-objects.png

docs/
└── world-map-design.md
```

The final asset location may change when the Phaser client is initialized.

---

# Tiled Export Requirements

Export each map as Tiled JSON.

Recommended configuration:

* Map orientation: Orthogonal
* Render order: Right-down
* Infinite map: Disabled for the first prototype
* Tile size: 16×16 or 32×32 pixels
* Export format: JSON
* Tilesets: External TSX files
* Compression: None during early development

Do not mix tile sizes within the same map.

---

# Phaser Integration Notes

Phaser can load tilemap data, create renderable tilemap layers, inspect map layers, and manipulate tiles at runtime. Tiled object layers are appropriate for non-tile data such as spawn points, trigger zones, paths, and collision markers.

Phaser Editor can also import JSON maps created in Tiled and provides tools for working with tilemap layers.

The initial workflow should be:

```text
Create Map in Tiled
        ↓
Export as JSON
        ↓
Load JSON and Tilesets in Phaser
        ↓
Create Visible Tile Layers
        ↓
Read Collision and Object Layers
        ↓
Create Portals, Spawn Points, and Interactions
```

---

# Phase 0 Deliverables

Step 0.5 is complete when the following files or designs exist:

* World hierarchy diagram
* Town Square map draft
* Whispering Forest prototype map
* Portal from Town Square to Whispering Forest
* Return portal from Whispering Forest to Town Square
* Standard layer structure
* Collision objects
* Interaction objects
* Named spawn points
* Tiled JSON exports

---

# Acceptance Criteria

* The world hierarchy clearly shows all planned locations.
* Only Town Square and Whispering Forest are implemented.
* Both maps use the standard layer names.
* Layer names and order are consistent.
* Collision areas are separated from visible map art.
* Interaction zones use named objects.
* Every required spawn point has a unique identifier.
* The player can transition between both maps.
* The player appears at the correct target spawn point.
* The player cannot leave the playable map boundary.
* The Town Square Quest Board is easy to locate.
* The first Slime or resource can be reached quickly in the forest.
* Ember Mine and Ancient Hollow remain outside Phase 0 implementation.
* The map structure can be loaded by Phaser without manual restructuring.

---

# Scope Protection Rule

Phase 0 must not include:

* Full Marketplace interior
* Full Tavern interior
* Full Blacksmith interior
* Ember Mine implementation
* Ancient Hollow implementation
* Procedural generation
* Large seamless open world
* Minimap
* Fast travel
* Weather system
* Complex NPC navigation
* Multiplayer map synchronization

These features must be postponed until the first vertical slice proves the core gameplay loop.
