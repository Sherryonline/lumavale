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
      switch (asset.type) {
        case 'image':
          this.load.image(asset.key, asset.url);
          break;
        case 'tilemapTiledJSON':
          this.load.tilemapTiledJSON(asset.key, asset.url);
          break;
      }
    }
  }

  public create(): void {
    this.cameras.main.setRoundPixels(true);
    this.missingAssets?.detach(this.load);
    this.missingAssets?.ensureFallbackTexture();

    const failures = this.missingAssets?.getFailures() ?? [];

    if (failures.length > 0) {
      this.showLoadError(failures.length);
      return;
    }

    this.updateStatus('Entering LumaVale Town…', 'loading');
    this.scene.start(SCENE_KEYS.town);
  }

  private updateStatus(message: string, state: string): void {
    const status = document.querySelector<HTMLElement>('#game-status');

    if (status) {
      status.textContent = message;
      status.dataset.state = state;
    }
  }

  private showLoadError(failureCount: number): void {
    const message = `Unable to load ${failureCount} required Town asset(s).`;

    console.error(`[PreloadScene] ${message}`);
    this.add
      .text(240, 135, message, {
        align: 'center',
        color: '#ffe5df',
        fontFamily: 'Arial, sans-serif',
        fontSize: '12px',
        wordWrap: { width: 400 },
      })
      .setOrigin(0.5);
    this.updateStatus(message, 'error');
  }
}
