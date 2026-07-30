import type { AssetDefinition } from '../../types/assets';
import { TOWN_ASSET_KEYS } from '../config/townMapConfig';

/**
 * Keep asset declarations centralized so missing files are handled consistently.
 * The foundation intentionally ships without production art assets.
 */
export const assetManifest: readonly AssetDefinition[] = [
  {
    type: 'tilemapTiledJSON',
    key: TOWN_ASSET_KEYS.map,
    url: '/assets/maps/town.json',
  },
  {
    type: 'image',
    key: TOWN_ASSET_KEYS.tiles,
    url: '/assets/environments/town-tiles.svg',
  },
];
