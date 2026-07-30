import Phaser from 'phaser';

import { SCENE_KEYS } from '../config/constants';

export class BootScene extends Phaser.Scene {
  public constructor() {
    super(SCENE_KEYS.boot);
  }

  public create(): void {
    this.cameras.main.setRoundPixels(true);
    this.updateStatus('Loading LumaVale…', 'loading');
    this.scene.start(SCENE_KEYS.preload);
  }

  private updateStatus(message: string, state: string): void {
    const status = document.querySelector<HTMLElement>('#game-status');

    if (status) {
      status.textContent = message;
      status.dataset.state = state;
    }
  }
}
