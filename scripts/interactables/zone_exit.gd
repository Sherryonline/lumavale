class_name ZoneExit
extends Area2D

@export var target_zone_id: StringName = &"forest"
@export var target_spawn_id: StringName = &"from_town"
@export var requires_interaction := false

var _player_inside := false
var _transition_locked := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _unhandled_input(event: InputEvent) -> void:
	if requires_interaction and _player_inside and event.is_action_pressed("interact"):
		_trigger()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_player_inside = true
		EventBus.interaction_prompt_changed.emit("Press E to travel")
		if not requires_interaction:
			_trigger()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		_player_inside = false
		EventBus.interaction_prompt_changed.emit("")


func _trigger() -> void:
	if _transition_locked:
		return
	_transition_locked = true
	EventBus.interaction_prompt_changed.emit("")
	SceneRouter.change_zone(target_zone_id, target_spawn_id)
	await get_tree().create_timer(0.6).timeout
	_transition_locked = false
