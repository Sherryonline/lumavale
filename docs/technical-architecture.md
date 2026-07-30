# LumaVale – Technical Architecture (Phase 0)

## Purpose

This document defines the single-player web-game foundation for Phase 0.
Persistence, multiplayer, and backend services remain outside the current
architecture.

---

## Technology Stack

| Layer                 | Technology            |
| --------------------- | --------------------- |
| Build and development | Vite                  |
| Language              | TypeScript            |
| Game engine           | Phaser 3              |
| Physics               | Phaser Arcade Physics |
| Unit testing          | Vitest                |
| Browser testing       | Playwright            |
| Linting               | ESLint                |
| Formatting            | Prettier              |
| Package manager       | npm                   |

React, Next.js, Tailwind, Zustand, Supabase, and multiplayer infrastructure are
not part of this phase.

---

## Runtime Architecture

```text
Browser
  └── Vite entry point
      └── Phaser.Game
          ├── BootScene
          └── PreloadScene
              ├── asset manifest
              ├── missing-asset handler
              └── future gameplay scenes and systems
```

The game renders at an internal resolution of 480×270. Phaser uses `FIT`
scaling to preserve the 16:9 aspect ratio and centers the canvas in the
available browser space. Pixel-art rendering and rounded pixels are enabled.

All gameplay data remains local during Phase 0.

---

## Source Boundaries

```text
src/
├── game/
│   ├── config/    # Phaser configuration and constants
│   ├── scenes/    # Scene lifecycle and orchestration
│   ├── entities/  # Game-world objects
│   ├── systems/   # Reusable game behavior
│   └── data/      # Static manifests and game data
├── types/         # Shared TypeScript contracts
├── main.ts        # Browser and Phaser startup
└── style.css      # Canvas shell and page presentation
```

Scenes coordinate flow. Systems contain reusable behavior. Data modules remain
declarative. Shared types do not depend on scene instances.

---

## Asset Loading

Assets are declared in one manifest and loaded by `PreloadScene`. Loader
failures are recorded and reported without stopping startup. A generated
high-contrast placeholder texture is available whenever a requested texture is
missing.

Production art is not bundled with the foundation.

---

## Architecture Principles

- Keep scene flow explicit.
- Prefer small systems and composition over deep inheritance.
- Keep framework dependencies at the application boundary.
- Add dependencies only when required by the current milestone.
- Validate gameplay locally before introducing persistence or networking.

## Excluded from Phase 0

- React and Next.js
- Supabase or other backend services
- Authentication and cloud saves
- Multiplayer, Socket.IO, Redis, or dedicated servers
- Complex state-machine libraries
