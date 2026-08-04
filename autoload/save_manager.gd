extends Node

const SAVE_PATH := "user://lumavale_save.json"


func save_game() -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveManager could not open save file for writing.")
		return false
	file.store_string(JSON.stringify(GameState.to_save_data(), "\t"))
	return true


func load_game() -> Dictionary:
	if not has_save():
		return {}
	var text := FileAccess.get_file_as_string(SAVE_PATH)
	var parsed: Variant = JSON.parse_string(text)
	if not (parsed is Dictionary):
		push_warning("SaveManager found an invalid save file. Ignoring it.")
		return {}
	return parsed as Dictionary


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func delete_save() -> bool:
	if not has_save():
		return true
	var error := DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
	if error != OK:
		push_warning("SaveManager could not delete save file. Error %s." % error)
	return error == OK
