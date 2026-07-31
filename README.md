# LumaVale

LumaVale is a cozy fantasy 2D top-down game built with Godot 4.

## Project structure

```text
LumaVale/
├── addons/       # Godot editor plugins
├── assets/
│   ├── art/      # Sprites, tilesets, textures, and visual references
│   ├── audio/    # Music and sound effects
│   ├── fonts/    # Project fonts
│   └── shaders/  # CanvasItem shaders
├── scenes/
│   ├── world/    # World orchestration scenes
│   ├── player/   # Player scenes
│   ├── npc/      # NPC scenes
│   ├── ui/       # Interface scenes
│   └── maps/     # Town, forest, mine, and dungeon maps
├── scripts/      # Shared GDScript that does not belong beside a scene
├── resources/    # Reusable `.tres` and `.res` resources
├── data/         # Static game data
├── autoload/     # Global services registered as autoloads
└── project.godot
```

## Baseline

- Godot 4 with the Compatibility renderer
- 480×270 internal viewport
- aspect-preserving canvas stretch
- pixel snapping and nearest texture filtering
- minimal runnable main scene

Open `project.godot` in Godot and run the project with <kbd>F6</kbd> or
<kbd>F5</kbd>.
