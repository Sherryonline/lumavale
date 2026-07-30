import { describe, expect, it } from 'vitest';

import townMapFixture from '../../public/assets/maps/town.json';

interface TiledObjectFixture {
  readonly name: string;
  readonly type: string;
}

interface TiledLayerFixture {
  readonly name: string;
  readonly type: string;
  readonly objects?: readonly TiledObjectFixture[];
}

const layers = townMapFixture.layers as readonly TiledLayerFixture[];

describe('Town Tiled map contract', () => {
  it('contains every required layer', () => {
    const layerNames = new Set(layers.map((layer) => layer.name));

    expect(layerNames).toEqual(
      new Set(['Ground', 'GroundDecoration', 'Buildings', 'AbovePlayer', 'Collision', 'Objects']),
    );
  });

  it('contains the required spawn and transition objects', () => {
    const objectLayer = layers.find((layer) => layer.name === 'Objects');
    const objectNames = new Set(objectLayer?.objects?.map((object) => object.name));

    expect(objectNames).toEqual(new Set(['player_spawn', 'town_respawn', 'forest_exit']));
  });

  it('defines wall, building, and water collision areas', () => {
    const collisionLayer = layers.find((layer) => layer.name === 'Collision');
    const collisionTypes = new Set(collisionLayer?.objects?.map((object) => object.type));

    expect(collisionTypes).toEqual(new Set(['wall', 'building', 'water']));
  });
});
