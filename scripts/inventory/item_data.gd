class_name ItemData
extends Resource

enum ItemType {
	MATERIAL,
	CONSUMABLE,
	EQUIPMENT,
}

@export var id: StringName
@export var display_name: String
@export_multiline var description: String
@export var item_type: ItemType
@export var icon: Texture2D
@export var max_stack: int = 99
@export var sell_price: int = 0
@export var heal_amount: int = 0
