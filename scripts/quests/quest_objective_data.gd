class_name QuestObjectiveData
extends Resource

enum ObjectiveType {
	DEFEAT_MONSTER,
	COLLECT_ITEM,
}

@export var objective_type: ObjectiveType
@export var target_id: StringName
@export var required_quantity: int = 1
@export var display_text: String
