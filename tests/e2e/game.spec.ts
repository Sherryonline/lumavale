import { expect, test } from '@playwright/test';

test('starts the Phaser game at the intended internal resolution', async ({ page }) => {
  await page.goto('/');

  const canvas = page.locator('#game-container canvas');
  const status = page.locator('#game-status');

  await expect(canvas).toBeVisible();
  await expect(status).toHaveAttribute('data-state', 'ready');

  const internalResolution = await canvas.evaluate((element: HTMLCanvasElement) => ({
    width: element.width,
    height: element.height,
  }));

  expect(internalResolution).toEqual({ width: 480, height: 270 });
});
