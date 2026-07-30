export const GAME_WIDTH = 480;
export const GAME_HEIGHT = 270;
export const GAME_BACKGROUND_COLOR = '#243c35';

export const SCENE_KEYS = {
  boot: 'BootScene',
  preload: 'PreloadScene',
  town: 'TownScene',
  forest: 'ForestScene',
} as const;

export const GAME_DEPTHS = {
  ground: 0,
  groundDecoration: 10,
  buildings: 20,
  player: 30,
  abovePlayer: 40,
} as const;
