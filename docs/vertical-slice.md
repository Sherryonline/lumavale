# LumaVale – First Vertical Slice

## Purpose

The first vertical slice defines the smallest playable version of LumaVale that can demonstrate the game's core potential.

It is not the full MVP.

The goal is to prove that the core gameplay loop, visual direction, player interaction, and basic living-world experience are enjoyable before expanding the project.

---

# Scope Strategy

The complete MVP may eventually include one town and multiple zones.

However, Phase 0 and Phase 1 will focus only on:

* LumaVale Town Square
* Whispering Forest

The Mine, Dungeon, multiplayer systems, complex economy, and PvP are excluded from the first vertical slice.

---

# Playable Area

## LumaVale Town Square

The Town Square is the player's safe starting area.

It includes:

* Player spawn point
* Quest Board
* Merchant
* Blacksmith
* Tavern
* Gate to Whispering Forest

## Town Purpose

The Town Square allows the player to:

* Understand the current objective
* Accept a basic quest
* Interact with NPCs
* Review collected items
* Return after exploration
* Receive rewards
* Prepare for the next journey

---

## Whispering Forest

The Whispering Forest is the first exploration and combat area.

It includes:

* Slime enemies
* Herb gathering nodes
* Tree resource nodes
* One treasure chest
* Gate back to LumaVale Town Square

## Forest Purpose

The Whispering Forest allows the player to:

* Explore a small outdoor area
* Fight a basic enemy
* Gather resources
* Collect loot
* Complete a quest objective
* Return safely to town

---

# Vertical Slice Features

The first vertical slice includes only the following features.

## Player

* Character movement
* WASD controls
* Camera follow
* Collision with map objects
* Player spawn and respawn

## World

* Town Square map
* Whispering Forest map
* Transition between maps
* Basic day and night visual change
* Interactable world objects

## NPC Interaction

* Merchant interaction
* Blacksmith interaction
* Basic dialogue window
* Quest Board interaction
* Simple NPC interaction prompt

## Quest

One basic quest:

> Enter Whispering Forest, defeat three Slimes, collect five Herbs, and return to the Quest Board.

The quest must support:

* Quest acceptance
* Objective tracking
* Progress updates
* Quest completion
* Reward collection

## Combat

* Basic melee attack
* Slime health
* Player health
* Damage feedback
* Slime death
* Basic cooldown
* Player death and respawn

## Resources and Loot

* Herb gathering
* Wood gathering
* Slime loot drop
* Treasure chest reward
* Loot pickup

## Inventory

* Open and close inventory
* Display collected items
* Display item quantities
* Add items
* Remove quest items when required

---

# Core Playable Flow

```text
Spawn in LumaVale Town Square
        ↓
Read the Quest Board
        ↓
Accept the first quest
        ↓
Travel through the forest gate
        ↓
Explore Whispering Forest
        ↓
Defeat three Slimes
        ↓
Collect five Herbs
        ↓
Pick up loot
        ↓
Return to LumaVale Town Square
        ↓
Complete the quest
        ↓
Receive a reward
```

---

# First Quest Definition

## Quest Name

A Slime Problem

## Quest Description

Slimes have appeared near the herb gathering area in Whispering Forest. Remove the threat and collect fresh Herbs for the town.

## Objectives

* Defeat 3 Slimes
* Collect 5 Herbs
* Return to the Quest Board

## Reward

* 50 Gold
* 20 Experience
* 1 Minor Health Potion

## Completion Condition

The quest can only be completed when all objectives are finished and the player returns to the Quest Board.

---

# Out of Scope

The following features must not be implemented in the first vertical slice:

* Multiplayer
* Co-op
* PvP
* Authentication
* Cloud save
* Player marketplace
* Crafting system
* Equipment system
* Multiple character classes
* Skill trees
* Dungeon
* Mine
* World boss
* Dynamic economy
* Complex NPC schedules
* Weather simulation
* Large world events
* Mobile support
* Controller support

Temporary local save may be used only when required for development testing.

---

# Technical Boundaries

The vertical slice should remain simple and replaceable.

## Allowed

* Local game state
* Hard-coded quest data
* Hard-coded item data
* Simple state-machine enemy behavior
* Placeholder assets
* One player character
* One enemy type
* One quest
* Two small maps

## Not Allowed

* Premature multiplayer architecture
* Large database schema
* Generic systems for future features
* Complex dependency injection
* Multiple gameplay frameworks
* Features added only for possible future use

---

# Acceptance Criteria

The vertical slice is complete when:

* The player spawns correctly in LumaVale Town Square.
* The player can move using WASD.
* The camera follows the player smoothly.
* The player cannot walk through blocked objects.
* The player can interact with the Quest Board.
* The player can accept the first quest.
* The player can enter Whispering Forest.
* The player can defeat Slimes using a melee attack.
* Slimes provide visible damage and death feedback.
* The player can gather Herbs and Wood.
* The player can pick up dropped loot.
* Collected items appear in the inventory.
* Quest progress updates correctly.
* The player can return to town.
* The player can complete the quest and receive the reward.
* The scene visibly changes between day and night.
* The complete gameplay flow can be finished in 5–10 minutes.
* The player always has a visible next objective.
* No Critical or Blocker defect prevents completion of the gameplay flow.

---

# Success Questions

Before expanding the game, the vertical slice must answer these questions:

1. Is movement responsive and enjoyable?
2. Is basic combat understandable and satisfying?
3. Does exploration provide enough visual and gameplay feedback?
4. Does returning to town feel meaningful?
5. Can a new player understand the objective without external instructions?
6. Does the world feel like the beginning of a living fantasy town?
7. Is the core loop enjoyable enough to repeat?

If the answer to these questions is not clearly positive, the team should improve the vertical slice instead of adding more features.

---

# Scope Protection Rule

Any new feature proposed during Phase 0 or Phase 1 must be evaluated against the following question:

> Is this feature required to complete or validate the first playable loop?

If the answer is no, the feature must be postponed.
