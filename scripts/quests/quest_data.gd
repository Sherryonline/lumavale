class_name QuestData
extends Resource

@export var id: StringName
@export var title: String
@export_multiline var description: String
@export var objectives: Array[Resource]
@export var reward_gold: int
@export var reward_items: Array[Resource]
