import Phaser from 'phaser';

import { SCENE_KEYS } from '../config/constants';
import { TOWN_OBJECT_NAMES, type TownSpawnName } from '../config/townMapConfig';
import { Player } from '../entities/Player';
import { createTownMap, getObjectRectangle } from '../maps/TownMap';

interface TownSceneData {
  readonly spawnAt?: TownSpawnName;
}

export class TownScene extends Phaser.Scene {
  private spawnAt: TownSpawnName = TOWN_OBJECT_NAMES.playerSpawn;
  private forestExitOverlap?: Phaser.Physics.Arcade.Collider;
  private transitionTimer?: Phaser.Time.TimerEvent;
  private isTransitioning = false;

  public constructor() {
    super(SCENE_KEYS.town);
  }

  public init(data: TownSceneData): void {
    this.spawnAt = data.spawnAt ?? TOWN_OBJECT_NAMES.playerSpawn;
    this.isTransitioning = false;
  }

  public create(): void {
    try {
      const town = createTownMap(this);
      const spawn = town.getSpawnPoint(this.spawnAt);
      const player = new Player(this, spawn.x, spawn.y);

      this.physics.world.setBounds(0, 0, town.map.widthInPixels, town.map.heightInPixels);
      this.cameras.main.setBounds(0, 0, town.map.widthInPixels, town.map.heightInPixels);
      this.cameras.main.setRoundPixels(true);
      this.cameras.main.startFollow(player, true, 0.15, 0.15);

      this.physics.add.collider(player, town.collisionObjects);

      if (town.collisionTileLayer) {
        this.physics.add.collider(player, town.collisionTileLayer);
      }

      const exitBounds = getObjectRectangle(town.forestExit);
      const forestExitZone = this.add.zone(
        exitBounds.centerX,
        exitBounds.centerY,
        exitBounds.width,
        exitBounds.height,
      );

      this.physics.add.existing(forestExitZone, true);
      this.forestExitOverlap = this.physics.add.overlap(player, forestExitZone, () => {
        this.transitionToForest(player);
      });

      this.events.once(Phaser.Scenes.Events.SHUTDOWN, this.handleShutdown, this);
      this.updateStatus('LumaVale Town', 'ready');
    } catch (error: unknown) {
      this.showMapError(error);
    }
  }

  private transitionToForest(player: Player): void {
    if (this.isTransitioning) {
      return;
    }

    this.isTransitioning = true;
    this.forestExitOverlap?.destroy();
    this.forestExitOverlap = undefined;
    player.stopMovement();

    const body = player.body as Phaser.Physics.Arcade.Body;
    body.enable = false;

    this.updateStatus('Entering Whispering Forest…', 'loading');
    this.cameras.main.fadeOut(250, 23, 35, 31);
    this.transitionTimer = this.time.delayedCall(250, () => {
      this.scene.start(SCENE_KEYS.forest);
    });
  }

  private handleShutdown(): void {
    this.forestExitOverlap?.destroy();
    this.forestExitOverlap = undefined;
    this.transitionTimer?.remove(false);
    this.transitionTimer = undefined;
  }

  private showMapError(error: unknown): void {
    const message = error instanceof Error ? error.message : 'Unknown Town map error.';

    console.error(`[TownScene] ${message}`, error);
    this.add
      .text(240, 135, `Town could not be loaded.\n${message}`, {
        align: 'center',
        color: '#ffe5df',
        fontFamily: 'Arial, sans-serif',
        fontSize: '12px',
        wordWrap: { width: 420 },
      })
      .setScrollFactor(0)
      .setOrigin(0.5);
    this.updateStatus(`Town could not be loaded: ${message}`, 'error');
  }

  private updateStatus(message: string, state: string): void {
    const status = document.querySelector<HTMLElement>('#game-status');

    if (status) {
      status.textContent = message;
      status.dataset.state = state;
      status.dataset.scene = SCENE_KEYS.town;
    }
  }
}
