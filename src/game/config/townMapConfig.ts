export const TOWN_ASSET_KEYS = {
  map: 'town-map',
  tiles: 'town-tiles',
} as const;

export const TOWN_TILESET_NAME = 'town-tiles';

export const TOWN_LAYER_NAMES = {
  ground: 'Ground',
  groundDecoration: 'GroundDecoration',
  buildings: 'Buildings',
  abovePlayer: 'AbovePlayer',
  collision: 'Collision',
  objects: 'Objects',
} as const;

export const TOWN_OBJECT_NAMES = {
  playerSpawn: 'player_spawn',
  forestExit: 'forest_exit',
  townRespawn: 'town_respawn',
} as const;

export type TownSpawnName = (typeof TOWN_OBJECT_NAMES)[keyof Pick<
  typeof TOWN_OBJECT_NAMES,
  'playerSpawn' | 'townRespawn'
>];
