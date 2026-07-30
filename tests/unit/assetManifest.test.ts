import { describe, expect, it } from 'vitest';

import { assetManifest } from '../../src/game/data/assetManifest';

describe('asset manifest', () => {
  it('contains unique, non-empty keys and URLs', () => {
    const keys = assetManifest.map((asset) => asset.key);

    expect(new Set(keys).size).toBe(keys.length);

    for (const asset of assetManifest) {
      expect(asset.key.trim()).not.toBe('');
      expect(asset.url.trim()).not.toBe('');
    }
  });
});
