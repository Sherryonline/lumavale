# LumaVale

LumaVale is a cozy fantasy 2D top-down RPG prototype built with Godot 4.7. The current project focus is a small playable vertical slice: create a character, enter Town, travel to Forest, fight Slimes, pick up loot, use inventory items, complete a quest, and persist local progress.

## Current Entry Flow

```text
CharacterSelectionV2
-> scenes/main.tscn
-> scenes/world/world_root.tscn
-> Town / Forest prototype maps
```

## Core Systems

- Character Selection V2 with role and modular appearance selection.
- `GameSession` for selected character data.
- `ThemeManager` for production UI theme scaling.
- `EventBus`, `GameState`, `SceneRouter`, and `SaveManager` autoloads.
- Prototype Town and Forest maps.
- InputMap movement, attack, interact, inventory, pause, and use item actions.
- Player health, melee attack, invulnerability, death, and respawn.
- Slime AI, loot drops, and respawn manager.
- Inventory model with 24 slots.
- Health Potion consumable.
- Slime Cleanup quest with gold and item reward.
- HUD, inventory screen, quest board, and debug panel.

## Run Locally

Open `project.godot` in Godot 4.7 and press `F5`.

Headless startup validation:

```powershell
& 'D:\Developing app\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64.exe' --headless --path 'D:\sherrypjs\lumavale' --quit-after 5
```

Run gameplay scene directly:

```powershell
& 'D:\Developing app\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64.exe' --headless --path 'D:\sherrypjs\lumavale' --scene 'res://scenes/main.tscn' --quit-after 5
```

## Web Export

Use the existing Web export preset:

```powershell
& 'D:\Developing app\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64.exe' --headless --path 'D:\sherrypjs\lumavale' --export-release 'Web' 'builds/web/index.html'
```

Serve locally after export:

```powershell
python -m http.server 8080 --directory builds/web
```

Then open `http://localhost:8080`.

## QA

Manual QA checklist:

- `docs/testing/sprint_7_test_checklist.md`

## Known Sprint 7 Limits

- Maps use prototype geometry and labeled temporary shapes.
- Warrior has the only complete combat implementation; Ranger and Alchemist use the same basic attack path for stability.
- Merchant and Blacksmith are labeled placeholders.
- Inventory UI is functional but intentionally simple: no drag-and-drop, sorting, filtering, or equipment comparison.
- Save/load is local only. Cloud save is out of scope.
- Web browser verification still requires a local manual browser pass after export.
