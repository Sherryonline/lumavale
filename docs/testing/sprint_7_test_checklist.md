# Sprint 7 Playable Core Test Checklist

Use this checklist for manual QA on desktop and Web. Mark each item with `PASS`, `FAIL`, or `N/A`, and record the exact scene, browser, and resolution used.

## Character Flow

- Create a Warrior.
- Create a Ranger.
- Create an Alchemist.
- Confirm character and enter gameplay.
- Selected appearance appears on the gameplay player.
- Character name is preserved.
- Starting stats are applied.
- Player is not duplicated after entering gameplay.

## Movement And Map

- Move with WASD.
- Move with arrow keys.
- Diagonal movement is not faster than cardinal movement.
- Player collides with map boundaries.
- Player collides with town building and forest rock.
- Camera stays inside map bounds.
- Travel Town to Forest.
- Travel Forest to Town.
- Spam a zone exit and verify transition does not duplicate the player.
- Transition while moving and verify velocity resets.
- Resize the window while moving.

## Combat

- Player attack hits a Slime.
- Player attack can miss.
- Attack cooldown blocks spam.
- One attack damages a target at most once.
- Slime attacks the player.
- Player invulnerability prevents repeated damage.
- HP never becomes negative.
- Health Potion healing never exceeds max HP.
- Player death triggers respawn.
- Attacking while dead is blocked.

## Monster

- Slime idles.
- Slime wanders near its spawn.
- Slime detects the player.
- Slime chases the player.
- Slime attacks in range.
- Slime disengages when appropriate.
- Slime can be hurt.
- Slime dies.
- Loot spawns once.
- Respawn does not occur on top of the player.

## Inventory

- Pick up Slime Gel.
- Item stacks increase correctly.
- Max stack is respected.
- Inventory full keeps world item on the ground.
- Health Potion can be used.
- Health Potion cannot be used at full HP.
- Quantity never becomes negative.
- Pickup does not duplicate.
- Inventory opens and closes repeatedly.

## Quest

- Accept `Slime Cleanup` at the Town Quest Board.
- Kill progress updates only while quest is active.
- Collection progress tracks Slime Gel quantity.
- Quest does not update before acceptance.
- Quest reaches ready-to-claim state.
- Claim reward once.
- Second claim is blocked.
- Inventory-full reward case blocks completion until reward can fit.
- Save in the middle of quest progress.
- Load in the middle of quest progress.
- Completed state persists.

## Save And Load

- New game starts without a save.
- Existing save loads without crashing.
- Save occurs after zone change.
- Save occurs after pickup.
- Save occurs after quest reward claim.
- Browser refresh preserves supported Web save data.
- Invalid save is ignored with a warning.
- Missing item ID does not crash inventory UI.
- Save version mismatch does not crash.
- Reset save works from debug panel in debug builds.

## Web

- Godot Web export succeeds.
- `builds/web/index.html` exists.
- `builds/web/index.pck` exists.
- `builds/web/index.wasm` exists.
- No missing resource 404 in browser console.
- Character Selection runs.
- Town runs.
- Forest runs.
- Combat works.
- Inventory works.
- Save/load works within Web storage limits.
- UI is readable at 960x540, 1280x720, 1600x900, and 1920x1080.

## Notes

- Sprint 7 uses prototype map geometry and temporary shape visuals for gameplay validation.
- Final art, sound, advanced combat roles, merchant transactions, crafting, and multiplayer are out of scope.
