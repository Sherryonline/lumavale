class_name WorldRoot
extends Node

const TOWN_SCENE := preload("res://scenes/maps/town_prototype.tscn")
const FOREST_SCENE := preload("res://scenes/maps/forest_prototype.tscn")
const PLAYER_SCENE := preload("res://scenes/player.tscn")

var _current_map: Node
var _player: Node

@onready var map_container: Node2D = $MapContainer
@onready var entity_container: Node2D = $EntityContainer
@onready var player_container: Node2D = $PlayerContainer
@onready var hud: Control = $WorldUI/HUD
@onready var inventory_screen: Control = $WorldUI/InventoryScreen
@onready var transition_layer: ColorRect = $TransitionLayer


func _ready() -> void:
	GameState.ensure_runtime_defaults()
	if SaveManager.has_save() and GameSession.get_character_data().is_empty():
		GameState.apply_save_data(SaveManager.load_game())
	load_zone(GameState.current_zone, GameState.current_spawn)
	EventBus.player_died.connect(_on_player_died)


func load_zone(zone_id: StringName, spawn_id: StringName) -> void:
	_clear_map()
	var scene := TOWN_SCENE if zone_id == &"town" else FOREST_SCENE
	_current_map = scene.instantiate()
	map_container.add_child(_current_map)
	_spawn_player(spawn_id)
	_apply_camera_bounds()
	GameState.set_zone(zone_id, spawn_id)


func _clear_map() -> void:
	for child: Node in map_container.get_children():
		child.queue_free()
	for child: Node in entity_container.get_children():
		child.queue_free()


func _spawn_player(spawn_id: StringName) -> void:
	if _player == null:
		_player = PLAYER_SCENE.instantiate()
		player_container.add_child(_player)
	var spawn := _find_spawn(spawn_id)
	_player.global_position = spawn
	_player.velocity = Vector2.ZERO
	if _player.has_node("Health") and _player.get_node("Health").is_dead:
		_player.call("respawn", spawn)


func _find_spawn(spawn_id: StringName) -> Vector2:
	if _current_map == null:
		return Vector2(480, 270)
	var spawn_root := _current_map.get_node_or_null("Spawns")
	if spawn_root == null:
		push_warning("Map has no Spawns node; using center fallback.")
		return Vector2(480, 270)
	var marker := spawn_root.get_node_or_null(String(spawn_id)) as Marker2D
	if marker == null:
		push_warning("Missing spawn %s; using player_spawn fallback." % spawn_id)
		marker = spawn_root.get_node_or_null("player_spawn") as Marker2D
	return marker.global_position if marker != null else Vector2(480, 270)


func _apply_camera_bounds() -> void:
	if _player == null or not _player.has_node("Camera2D") or _current_map == null:
		return
	var bounds_node := _current_map.get_node_or_null("CameraBounds") as ReferenceRect
	if bounds_node == null:
		return
	var rect := Rect2(bounds_node.global_position, bounds_node.size)
	var camera := _player.get_node("Camera2D") as Camera2D
	camera.limit_left = roundi(rect.position.x)
	camera.limit_top = roundi(rect.position.y)
	camera.limit_right = roundi(rect.end.x)
	camera.limit_bottom = roundi(rect.end.y)
	camera.make_current()


func _on_player_died() -> void:
	await get_tree().create_timer(0.8).timeout
	GameState.set_zone(&"town", &"town_respawn")
	load_zone(&"town", &"town_respawn")
	if _player != null:
		_player.call("respawn", _find_spawn(&"town_respawn"))
	SaveManager.save_game()
