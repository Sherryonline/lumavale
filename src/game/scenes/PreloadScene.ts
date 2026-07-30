import Phaser from 'phaser';

import { SCENE_KEYS } from '../config/constants';
import { assetManifest } from '../data/assetManifest';
import { MissingAssetHandler } from '../systems/MissingAssetHandler';

export class PreloadScene extends Phaser.Scene {
  private missingAssets?: MissingAssetHandler;

  public constructor() {
    super(SCENE_KEYS.preload);
  }

  public preload(): void {
    this.missingAssets = new MissingAssetHandler(this);
    this.missingAssets.attach(this.load);

    for (const asset of assetManifest) {
      if (asset.type === 'image') {
        this.load.image(asset.key, asset.url);
      }
    }
  }

  public create(): void {
    this.cameras.main.setRoundPixels(true);
    this.missingAssets?.detach(this.load);
    this.missingAssets?.ensureFallbackTexture();

    const failures = this.missingAssets?.getFailures() ?? [];

    this.add
      .text(240, 117, 'LumaVale', {
        color: '#f7edcf',
        fontFamily: 'Georgia, serif',
        fontSize: '24px',
        fontStyle: 'bold',
      })
      .setOrigin(0.5);

    this.add
      .text(240, 147, failures.length > 0 ? 'Ready with asset warnings' : 'Foundation ready', {
        color: failures.length > 0 ? '#f0a59a' : '#b9d8b4',
        fontFamily: 'Arial, sans-serif',
        fontSize: '10px',
      })
      .setOrigin(0.5);

    this.updateStatus(
      failures.length > 0
        ? `Ready with ${failures.length} missing asset warning(s).`
        : 'LumaVale is ready.',
      failures.length > 0 ? 'warning' : 'ready',
    );
  }

  private updateStatus(message: string, state: string): void {
    const status = document.querySelector<HTMLElement>('#game-status');

    if (status) {
      status.textContent = message;
      status.dataset.state = state;
    }
  }
}
