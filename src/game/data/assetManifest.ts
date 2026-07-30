import type { AssetDefinition } from '../../types/assets';

/**
 * Keep asset declarations centralized so missing files are handled consistently.
 * The foundation intentionally ships without production art assets.
 */
export const assetManifest: readonly AssetDefinition[] = [];
