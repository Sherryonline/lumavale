import Phaser from 'phaser';

import { GAME_DEPTHS } from '../config/constants';

const PLAYER_TEXTURE_KEY = '__player-placeholder';
const PLAYER_SPEED = 80;

interface MovementKeys {
  up: Phaser.Input.Keyboard.Key;
  down: Phaser.Input.Keyboard.Key;
  left: Phaser.Input.Keyboard.Key;
  right: Phaser.Input.Keyboard.Key;
}

export class Player extends Phaser.Physics.Arcade.Sprite {
  private readonly cursors?: Phaser.Types.Input.Keyboard.CursorKeys;
  private readonly movementKeys?: MovementKeys;

  public constructor(scene: Phaser.Scene, x: number, y: number) {
    Player.ensureTexture(scene);
    super(scene, x, y, PLAYER_TEXTURE_KEY);

    scene.add.existing(this);
    scene.physics.add.existing(this);

    this.setDepth(GAME_DEPTHS.player);
    this.setCollideWorldBounds(true);

    const body = this.body as Phaser.Physics.Arcade.Body;
    body.setSize(10, 12);
    body.setOffset(1, 4);

    const keyboard = scene.input.keyboard;

    if (keyboard) {
      this.cursors = keyboard.createCursorKeys();
      this.movementKeys = keyboard.addKeys({
        up: Phaser.Input.Keyboard.KeyCodes.W,
        down: Phaser.Input.Keyboard.KeyCodes.S,
        left: Phaser.Input.Keyboard.KeyCodes.A,
        right: Phaser.Input.Keyboard.KeyCodes.D,
      }) as MovementKeys;
    }
  }

  public override preUpdate(time: number, delta: number): void {
    super.preUpdate(time, delta);
    this.updateMovement();
  }

  public stopMovement(): void {
    this.setVelocity(0, 0);
  }

  private updateMovement(): void {
    if (!this.body?.enable) {
      return;
    }

    const left = this.cursors?.left.isDown || this.movementKeys?.left.isDown;
    const right = this.cursors?.right.isDown || this.movementKeys?.right.isDown;
    const up = this.cursors?.up.isDown || this.movementKeys?.up.isDown;
    const down = this.cursors?.down.isDown || this.movementKeys?.down.isDown;
    const direction = new Phaser.Math.Vector2(
      Number(Boolean(right)) - Number(Boolean(left)),
      Number(Boolean(down)) - Number(Boolean(up)),
    );

    if (direction.lengthSq() === 0) {
      this.stopMovement();
      return;
    }

    direction.normalize().scale(PLAYER_SPEED);
    this.setVelocity(direction.x, direction.y);
  }

  private static ensureTexture(scene: Phaser.Scene): void {
    if (scene.textures.exists(PLAYER_TEXTURE_KEY)) {
      return;
    }

    const graphics = scene.make.graphics({ x: 0, y: 0 });

    graphics.fillStyle(0x5c3b2e, 1);
    graphics.fillRect(2, 0, 8, 4);
    graphics.fillStyle(0xf1c49b, 1);
    graphics.fillRect(3, 3, 6, 5);
    graphics.fillStyle(0x6f8f69, 1);
    graphics.fillRect(1, 8, 10, 7);
    graphics.fillStyle(0x243c35, 1);
    graphics.fillRect(1, 15, 4, 1);
    graphics.fillRect(7, 15, 4, 1);
    graphics.generateTexture(PLAYER_TEXTURE_KEY, 12, 16);
    graphics.destroy();
  }
}
