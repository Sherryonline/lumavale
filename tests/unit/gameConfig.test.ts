import { describe, expect, it } from 'vitest';

import {
  GAME_BACKGROUND_COLOR,
  GAME_HEIGHT,
  GAME_WIDTH,
  SCENE_KEYS,
} from '../../src/game/config/constants';

describe('game foundation constants', () => {
  it('uses a 480x270 internal resolution', () => {
    expect(GAME_WIDTH).toBe(480);
    expect(GAME_HEIGHT).toBe(270);
    expect(GAME_WIDTH / GAME_HEIGHT).toBe(16 / 9);
  });

  it('defines the initial scene flow', () => {
    expect(SCENE_KEYS.boot).toBe('BootScene');
    expect(SCENE_KEYS.preload).toBe('PreloadScene');
  });

  it('provides a valid game background color', () => {
    expect(GAME_BACKGROUND_COLOR).toMatch(/^#[\da-f]{6}$/i);
  });
});
