import Phaser from 'phaser';

import { createGameConfig } from './game/config/gameConfig';
import './style.css';

const gameContainer = document.querySelector<HTMLElement>('#game-container');

if (!gameContainer) {
  throw new Error('Unable to start LumaVale: the game container is missing.');
}

let game: Phaser.Game | undefined;

try {
  game = new Phaser.Game(createGameConfig(gameContainer));
} catch (error: unknown) {
  const message = error instanceof Error ? error.message : 'An unknown startup error occurred.';
  const status = document.querySelector<HTMLElement>('#game-status');

  console.error('LumaVale failed to start.', error);

  if (status) {
    status.dataset.state = 'error';
    status.textContent = `Unable to start LumaVale: ${message}`;
  }
}

window.addEventListener('beforeunload', () => {
  game?.destroy(true);
  game = undefined;
});
