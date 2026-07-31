class_name RoleData
extends Resource

@export var id: StringName
@export var display_name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var portrait: Texture2D
@export var hp: int
@export var attack: int
@export var defense: int
@export var speed: int
@export var energy: int
@export var difficulty: String
@export var starting_weapon: AppearanceItem
@export var available: bool = true
