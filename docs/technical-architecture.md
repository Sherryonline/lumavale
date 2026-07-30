# LumaVale – Technical Architecture (Phase 0)

## Purpose

This document defines the technology stack for Phase 0 and establishes the architectural boundaries for the project.

The focus is to build a solid foundation before introducing persistence, multiplayer, or complex backend services.

---

# Technology Stack

| Layer            | Technology          |
| ---------------- | ------------------- |
| Frontend Shell   | Next.js             |
| Language         | TypeScript          |
| Game Engine      | Phaser 3            |
| Styling          | Tailwind CSS        |
| State Management | Zustand             |
| Map Editor       | Tiled               |
| Testing          | Vitest + Playwright |
| Linting          | ESLint              |
| Formatting       | Prettier            |
| Package Manager  | npm                 |
| Hosting          | Vercel              |

---

# Project Architecture

```text
Browser
    │
    ▼
Next.js
    │
    ▼
Phaser Game
    │
    ▼
Game Systems
    │
    ├── Player
    ├── Camera
    ├── Map
    ├── NPC
    ├── Combat
    ├── Inventory
    └── Quest
```

During Phase 0, all gameplay data may remain local.

No backend communication is required.

---

# Phase 0 Scope

Included:

* Local game state
* Phaser scenes
* Tilemap loading
* Input handling
* Camera
* NPC interaction
* Quest prototype
* Local inventory
* Local save (optional)

---

# Not Included

The following technologies are intentionally postponed:

* Supabase
* Socket.IO
* Redis
* Dedicated game server
* Marketplace service
* Complex state machine libraries
* Cloud save
* Authentication
* Multiplayer

These systems will be introduced only after the single-player gameplay foundation has been validated.

---

# Architecture Principles

* Keep systems modular.
* Prefer composition over inheritance.
* Build only what is needed for the current phase.
* Avoid premature optimization.
* Delay infrastructure until gameplay is proven enjoyable.

Every new dependency should have a clear purpose and support the current milestone.
