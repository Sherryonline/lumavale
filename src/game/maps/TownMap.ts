import Phaser from 'phaser';

import { GAME_DEPTHS } from '../config/constants';
import {
  TOWN_ASSET_KEYS,
  TOWN_LAYER_NAMES,
  TOWN_OBJECT_NAMES,
  TOWN_TILESET_NAME,
  type TownSpawnName,
} from '../config/townMapConfig';

const REQUIRED_TILE_LAYERS = [
  TOWN_LAYER_NAMES.ground,
  TOWN_LAYER_NAMES.groundDecoration,
  TOWN_LAYER_NAMES.buildings,
  TOWN_LAYER_NAMES.abovePlayer,
] as const;

const REQUIRED_OBJECTS = [
  TOWN_OBJECT_NAMES.playerSpawn,
  TOWN_OBJECT_NAMES.forestExit,
  TOWN_OBJECT_NAMES.townRespawn,
] as const;

export class TownMapValidationError extends Error {
  public constructor(message: string) {
    super(message);
    this.name = 'TownMapValidationError';
  }
}

export interface TownMapData {
  readonly map: Phaser.Tilemaps.Tilemap;
  readonly collisionObjects: Phaser.Physics.Arcade.StaticGroup;
  readonly collisionTileLayer?: Phaser.Tilemaps.TilemapLayer;
  readonly forestExit: Phaser.Types.Tilemaps.TiledObject;
  getSpawnPoint(name: TownSpawnName): Phaser.Math.Vector2;
}

export function createTownMap(scene: Phaser.Scene): TownMapData {
  const map = scene.make.tilemap({ key: TOWN_ASSET_KEYS.map });

  validateLayers(map);

  const tileset = map.addTilesetImage(TOWN_TILESET_NAME, TOWN_ASSET_KEYS.tiles);

  if (!tileset) {
    throw new TownMapValidationError(
      `Required tileset "${TOWN_TILESET_NAME}" is not present in the Town map.`,
    );
  }

  const ground = createRequiredLayer(map, TOWN_LAYER_NAMES.ground, tileset);
  const groundDecoration = createRequiredLayer(map, TOWN_LAYER_NAMES.groundDecoration, tileset);
  const buildings = createRequiredLayer(map, TOWN_LAYER_NAMES.buildings, tileset);
  const abovePlayer = createRequiredLayer(map, TOWN_LAYER_NAMES.abovePlayer, tileset);

  ground.setDepth(GAME_DEPTHS.ground);
  groundDecoration.setDepth(GAME_DEPTHS.groundDecoration);
  buildings.setDepth(GAME_DEPTHS.buildings);
  abovePlayer.setDepth(GAME_DEPTHS.abovePlayer);

  const objectsLayer = map.getObjectLayer(TOWN_LAYER_NAMES.objects);

  if (!objectsLayer) {
    throw new TownMapValidationError(
      `Required object layer "${TOWN_LAYER_NAMES.objects}" is missing.`,
    );
  }

  const objectsByName = new Map(objectsLayer.objects.map((object) => [object.name, object]));

  for (const objectName of REQUIRED_OBJECTS) {
    if (!objectsByName.has(objectName)) {
      throw new TownMapValidationError(
        `Required object "${objectName}" is missing from layer "${TOWN_LAYER_NAMES.objects}".`,
      );
    }
  }

  const collisionObjects = scene.physics.add.staticGroup();
  const collisionObjectLayer = map.getObjectLayer(TOWN_LAYER_NAMES.collision);
  let collisionTileLayer: Phaser.Tilemaps.TilemapLayer | undefined;

  if (collisionObjectLayer) {
    createObjectCollisions(scene, collisionObjects, collisionObjectLayer.objects);
  } else {
    collisionTileLayer = createRequiredLayer(map, TOWN_LAYER_NAMES.collision, tileset);
    collisionTileLayer.setCollisionByExclusion([-1]);
    collisionTileLayer.setVisible(false);
  }

  return {
    map,
    collisionObjects,
    collisionTileLayer,
    forestExit: getRequiredObject(objectsByName, TOWN_OBJECT_NAMES.forestExit),
    getSpawnPoint(name: TownSpawnName): Phaser.Math.Vector2 {
      const object = getRequiredObject(objectsByName, name);
      return new Phaser.Math.Vector2(object.x ?? 0, object.y ?? 0);
    },
  };
}

export function getObjectRectangle(
  object: Phaser.Types.Tilemaps.TiledObject,
): Phaser.Geom.Rectangle {
  const width = object.width ?? 0;
  const height = object.height ?? 0;
  const left = object.x ?? 0;
  const y = object.y ?? 0;
  const top = object.gid ? y - height : y;

  return new Phaser.Geom.Rectangle(left, top, width, height);
}

function validateLayers(map: Phaser.Tilemaps.Tilemap): void {
  const tileLayerNames = new Set(map.layers.map((layer) => layer.name));
  const objectLayerNames = new Set(map.objects.map((layer) => layer.name));

  for (const layerName of REQUIRED_TILE_LAYERS) {
    if (!tileLayerNames.has(layerName)) {
      throw new TownMapValidationError(`Required tile layer "${layerName}" is missing.`);
    }
  }

  if (
    !tileLayerNames.has(TOWN_LAYER_NAMES.collision) &&
    !objectLayerNames.has(TOWN_LAYER_NAMES.collision)
  ) {
    throw new TownMapValidationError(
      `Required collision layer "${TOWN_LAYER_NAMES.collision}" is missing.`,
    );
  }

  if (!objectLayerNames.has(TOWN_LAYER_NAMES.objects)) {
    throw new TownMapValidationError(
      `Required object layer "${TOWN_LAYER_NAMES.objects}" is missing.`,
    );
  }
}

function createRequiredLayer(
  map: Phaser.Tilemaps.Tilemap,
  layerName: string,
  tileset: Phaser.Tilemaps.Tileset,
): Phaser.Tilemaps.TilemapLayer {
  const layer = map.createLayer(layerName, tileset);

  if (!layer) {
    throw new TownMapValidationError(`Unable to create required tile layer "${layerName}".`);
  }

  return layer;
}

function createObjectCollisions(
  scene: Phaser.Scene,
  group: Phaser.Physics.Arcade.StaticGroup,
  objects: readonly Phaser.Types.Tilemaps.TiledObject[],
): void {
  for (const object of objects) {
    const bounds = getObjectRectangle(object);

    if (bounds.width <= 0 || bounds.height <= 0) {
      console.warn(`[TownMap] Ignoring collision object "${object.name}" because it has no area.`);
      continue;
    }

    const zone = scene.add.zone(bounds.centerX, bounds.centerY, bounds.width, bounds.height);
    group.add(zone);
  }
}

function getRequiredObject(
  objects: ReadonlyMap<string, Phaser.Types.Tilemaps.TiledObject>,
  name: string,
): Phaser.Types.Tilemaps.TiledObject {
  const object = objects.get(name);

  if (!object) {
    throw new TownMapValidationError(`Required Town object "${name}" is missing.`);
  }

  return object;
}
