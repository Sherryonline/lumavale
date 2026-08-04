extends Node

const WORLD_SCENE := "res://scenes/world/world_root.tscn"

var _transitioning := false
var requested_spawn_id: StringName = &""
var requested_zone_id: StringName = &""


func change_scene(scene_path: String, spawn_id: StringName = &"") -> void:
	if _transitioning:
		return
	_transitioning = true
	requested_spawn_id = spawn_id
	var error := get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("SceneRouter failed to change scene to %s. Error %s." % [scene_path, error])
	_transitioning = false


func change_zone(zone_id: StringName, spawn_id: StringName) -> void:
	if _transitioning:
		return
	_transitioning = true
	requested_zone_id = zone_id
	requested_spawn_id = spawn_id
	GameState.set_zone(zone_id, spawn_id)
	SaveManager.save_game()
	if get_tree().current_scene != null and get_tree().current_scene.has_method("load_zone"):
		get_tree().current_scene.call("load_zone", zone_id, spawn_id)
	else:
		var error := get_tree().change_scene_to_file(WORLD_SCENE)
		if error != OK:
			push_error("SceneRouter failed to open world scene. Error %s." % error)
	_transitioning = false


func reload_current_scene() -> void:
	if _transitioning:
		return
	_transitioning = true
	get_tree().reload_current_scene()
	_transitioning = false
