import Phaser from 'phaser';

import type { MissingAsset } from '../../types/assets';

export const MISSING_TEXTURE_KEY = '__missing-texture';

export class MissingAssetHandler {
  private readonly failures = new Map<string, MissingAsset>();

  public constructor(private readonly scene: Phaser.Scene) {}

  public attach(loader: Phaser.Loader.LoaderPlugin): void {
    loader.on(Phaser.Loader.Events.FILE_LOAD_ERROR, this.handleLoadError, this);
  }

  public detach(loader: Phaser.Loader.LoaderPlugin): void {
    loader.off(Phaser.Loader.Events.FILE_LOAD_ERROR, this.handleLoadError, this);
  }

  public getFailures(): readonly MissingAsset[] {
    return [...this.failures.values()];
  }

  public ensureFallbackTexture(): string {
    if (this.scene.textures.exists(MISSING_TEXTURE_KEY)) {
      return MISSING_TEXTURE_KEY;
    }

    const size = 16;
    const graphics = this.scene.make.graphics({ x: 0, y: 0 });

    graphics.fillStyle(0x33243d, 1);
    graphics.fillRect(0, 0, size, size);
    graphics.fillStyle(0xd46b73, 1);
    graphics.fillRect(0, 0, size / 2, size / 2);
    graphics.fillRect(size / 2, size / 2, size / 2, size / 2);
    graphics.lineStyle(1, 0xf7edcf, 1);
    graphics.strokeRect(0, 0, size, size);
    graphics.generateTexture(MISSING_TEXTURE_KEY, size, size);
    graphics.destroy();

    return MISSING_TEXTURE_KEY;
  }

  public resolveTextureKey(requestedKey: string): string {
    if (this.scene.textures.exists(requestedKey)) {
      return requestedKey;
    }

    console.warn(`Texture "${requestedKey}" is unavailable; using the fallback texture.`);
    return this.ensureFallbackTexture();
  }

  private handleLoadError(file: Phaser.Loader.File): void {
    const missingAsset = {
      key: file.key,
      url: file.src,
    };

    this.failures.set(file.key, missingAsset);
    console.error(`Failed to load asset "${file.key}" from "${file.src}".`);
  }
}
