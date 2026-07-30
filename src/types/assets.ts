export interface ImageAssetDefinition {
  readonly type: 'image';
  readonly key: string;
  readonly url: string;
}

export type AssetDefinition = ImageAssetDefinition;

export interface MissingAsset {
  readonly key: string;
  readonly url: string;
}
