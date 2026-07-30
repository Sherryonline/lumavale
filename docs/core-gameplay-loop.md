# LumaVale – Core Gameplay Loop

## Purpose

This document defines the gameplay loops that drive the player's experience.

Every feature implemented in the MVP should strengthen one or more of these loops.

---

# Core Gameplay Loop

The primary gameplay loop is designed to create a satisfying cycle of exploration, progression, and reward.

```text
Accept Quest
        ↓
Leave Town
        ↓
Explore the World
        ↓
Gather Resources or Fight Monsters
        ↓
Obtain Rewards
        ↓
Return to Town
        ↓
Craft, Sell, or Upgrade Equipment
        ↓
Unlock the Next Quest
        ↓
Repeat
```

## Design Goals

- Every action should move the player toward a meaningful reward.
- Returning to town should always feel valuable.
- Players should always know what to do next.
- The gameplay loop should remain enjoyable whether playing solo or with others.

---

# Micro Loop (30–60 Seconds)

The micro loop represents the player's moment-to-moment gameplay.

```text
Observe
    ↓
Move
    ↓
Interact
    ↓
Receive Feedback
    ↓
Choose the Next Action
```

## Examples

- Spot a Slime nearby.
- Walk toward it.
- Defeat the Slime.
- Collect dropped resources.
- Decide whether to continue exploring or return to town.

## Design Goals

- Immediate player feedback.
- Quick decision making.
- Constant interaction.
- No unnecessary waiting.

---

# Short Session Loop (3–5 Minutes)

A complete short play session should provide a clear objective and a satisfying reward.

```text
Accept a Small Quest
        ↓
Defeat 3 Slimes
        ↓
Collect 5 Herbs
        ↓
Return to Town
        ↓
Claim Rewards
```

## Typical Rewards

- Experience
- Gold
- Crafting Materials
- Equipment
- Reputation

---

# Long-Term Progression Loop

Multiple short sessions contribute to long-term character growth.

```text
Complete Quests
        ↓
Gain Experience
        ↓
Improve Equipment
        ↓
Unlock New Areas
        ↓
Access More Difficult Challenges
        ↓
Repeat
```

---

# Player Guidance Rule

At any point during gameplay, the player should always see at least one meaningful objective.

The game should always provide one or more of the following:

- An active quest
- An interactable object
- A new area to explore
- An upcoming world event
- A nearby reward worth pursuing

The player should never feel lost or unsure of what to do next.

---

# Design Principles

- Minimize downtime.
- Reward curiosity.
- Keep sessions meaningful even if they last only a few minutes.
- Every completed activity should contribute to long-term progression.
- Exploration should always provide value.

---

# MVP Validation Checklist

The gameplay loop is considered successful if:

- Players understand what to do within the first minute.
- Players can complete a meaningful activity in under five minutes.
- Every completed quest provides visible progression.
- Returning to town always feels rewarding.
- Players always have a clear next objective.