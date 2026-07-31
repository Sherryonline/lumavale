extends Node

var character_data: Dictionary = {}


func set_character_data(data: Dictionary) -> void:
	character_data = data.duplicate(true)


func get_character_data() -> Dictionary:
	return character_data.duplicate(true)


func clear_character_data() -> void:
	character_data.clear()
