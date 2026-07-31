class_name AppearanceItem
extends Resource

enum Category {
	BODY,
	HAIR,
	EYES,
	TOP,
	BOTTOM,
	SHOES,
	ACCESSORY,
	WEAPON,
}

@export var id: StringName
@export var display_name: String
@export var category: Category = Category.BODY
@export var icon: Texture2D
@export var sprite_frames: SpriteFrames
@export var back_sprite_frames: SpriteFrames
@export var locked: bool = false
