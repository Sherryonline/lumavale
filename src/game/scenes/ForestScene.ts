import Phaser from 'phaser';

import { SCENE_KEYS } from '../config/constants';

export class ForestScene extends Phaser.Scene {
  public constructor() {
    super(SCENE_KEYS.forest);
  }

  public create(): void {
    this.cameras.main.setBackgroundColor('#1d3b2a');
    this.cameras.main.fadeIn(250, 23, 35, 31);

    this.add
      .text(240, 125, 'Whispering Forest', {
        color: '#d8e9c8',
        fontFamily: 'Georgia, serif',
        fontSize: '22px',
        fontStyle: 'bold',
      })
      .setOrigin(0.5);
    this.add
      .text(240, 151, 'Forest gameplay will be implemented next.', {
        color: '#a9c49c',
        fontFamily: 'Arial, sans-serif',
        fontSize: '10px',
      })
      .setOrigin(0.5);

    const status = document.querySelector<HTMLElement>('#game-status');

    if (status) {
      status.textContent = 'Whispering Forest';
      status.dataset.state = 'ready';
      status.dataset.scene = SCENE_KEYS.forest;
    }
  }
}
