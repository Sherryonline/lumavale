class_name SlimeSpawnManager
extends Node2D

const SLIME_SCENE := preload("res://scenes/monsters/slime.tscn")

@export var max_active := 3
@export var respawn_enabled := true
@export var respawn_min := 5.0
@export var respawn_max := 10.0

var _spawn_points: Array[Marker2D] = []
var _active: Array[WeakRef] = []


func _ready() -> void:
	for child: Node in get_children():
		if child is Marker2D:
			_spawn_points.append(child as Marker2D)
	_spawn_initial()


func spawn_slime() -> void:
	_cleanup()
	if _active.size() >= max_active or _spawn_points.is_empty():
		return
	var point := _spawn_points.pick_random() as Marker2D
	if GameState.player != null and GameState.player.global_position.distance_to(point.global_position) < 48.0:
		return
	var slime := SLIME_SCENE.instantiate()
	get_parent().add_child(slime)
	slime.global_position = point.global_position
	_active.append(weakref(slime))
	slime.tree_exited.connect(_schedule_respawn)


func _spawn_initial() -> void:
	for index: int in mini(max_active, _spawn_points.size()):
		spawn_slime()


func _schedule_respawn() -> void:
	_cleanup()
	if not respawn_enabled:
		return
	await get_tree().create_timer(randf_range(respawn_min, respawn_max)).timeout
	spawn_slime()


func _cleanup() -> void:
	var alive: Array[WeakRef] = []
	for ref: WeakRef in _active:
		if ref.get_ref() != null:
			alive.append(ref)
	_active = alive
