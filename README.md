# LumaVale

LumaVale is a cozy fantasy 2D top-down pixel-art web game. This repository
currently contains the single-player technical foundation built with Phaser 3,
TypeScript, and Vite.

## Requirements

- Node.js 20.19 or newer
- npm 10 or newer

## Getting started

```bash
npm install
npm run dev
```

The development server runs at `http://127.0.0.1:5173`.

## Commands

| Command              | Purpose                                  |
| -------------------- | ---------------------------------------- |
| `npm run dev`        | Start the Vite development server        |
| `npm run build`      | Type-check and create a production build |
| `npm run lint`       | Run ESLint                               |
| `npm run format`     | Format supported files with Prettier     |
| `npm run typecheck`  | Run TypeScript without emitting files    |
| `npm test`           | Run unit tests once                      |
| `npm run test:watch` | Run unit tests in watch mode             |
| `npm run test:e2e`   | Run Playwright end-to-end tests          |

## Current foundation

- 480×270 internal game resolution
- responsive `FIT` scaling with centered canvas
- pixel-art rendering with rounded pixels
- Arcade Physics
- `BootScene` → `PreloadScene` startup flow
- centralized asset manifest and missing-asset fallback handling
- Vitest unit tests and Playwright browser tests

Production art is intentionally not included yet. Add assets under
`public/assets/` and register them in
`src/game/data/assetManifest.ts`.
