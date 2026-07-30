export interface ImageAssetDefinition {
  readonly type: 'image';
  readonly key: string;
  readonly url: string;
}

export interface TilemapAssetDefinition {
  readonly type: 'tilemapTiledJSON';
  readonly key: string;
  readonly url: string;
}

export type AssetDefinition = ImageAssetDefinition | TilemapAssetDefinition;

export interface MissingAsset {
  readonly key: string;
  readonly url: string;
}
