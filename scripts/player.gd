class_name Player
extends CharacterBody2D

const CATALOG := preload("res://scripts/character/character_catalog.gd")

@export var move_speed: float = 150.0

var facing_direction := Vector2.DOWN
var character_name: String = "Adventurer"
var role_id: StringName = &"warrior"
var max_hp: int = 0
var hp: int = 0
var attack: int = 0
var defense: int = 0
var speed_stat: int = 0
var energy: int = 0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var modular_character: ModularCharacter = $ModularCharacter
@onready var camera: Camera2D = $Camera2D


func _ready() -> void:
	var session_data := GameSession.get_character_data()
	if session_data.is_empty():
		session_data = CATALOG.default_character_data()
		if OS.is_debug_build():
			push_warning("GameSession is empty; using the default Warrior character.")
	apply_character_data(_with_defaults(session_data))
	modular_character.play_animation(&"idle_down")


func _physics_process(_delta: float) -> void:
	var input_direction := Vector2.ZERO

	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		input_direction.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		input_direction.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		input_direction.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		input_direction.y += 1.0

	input_direction = input_direction.normalized()
	velocity = input_direction * move_speed

	if input_direction != Vector2.ZERO:
		facing_direction = input_direction

	move_and_slide()
	_play_movement_animation(&"walk" if input_direction != Vector2.ZERO else &"idle")


func apply_character_data(data: Dictionary) -> void:
	character_name = str(data.get("name", "Adventurer"))
	role_id = StringName(str(data.get("role", "warrior")))

	modular_character.set_body(_resolve_or_default(data, &"body", &"body_a"))
	modular_character.set_hair(_resolve_or_default(data, &"hair", &"hair_short"))
	modular_character.set_eyes(_resolve_or_default(data, &"eyes", &"eyes_hazel"))
	modular_character.set_top(_resolve_or_default(data, &"top", &"top_forest"))
	modular_character.set_bottom(_resolve_or_default(data, &"bottom", &"bottom_dark"))
	modular_character.set_shoes(_resolve_or_default(data, &"shoes", &"shoes_boots"))
	modular_character.set_accessory(
		_resolve_or_default(data, &"accessory", &"accessory_none")
	)
	modular_character.set_weapon(_resolve_or_default(data, &"weapon", &"weapon_sword"))
	modular_character.body.self_modulate = CATALOG.resolve_skin_color(
		StringName(str(data.get("skin_color", "skin_light")))
	)
	modular_character.hair.self_modulate = CATALOG.resolve_hair_color(
		StringName(str(data.get("hair_color", "hair_chestnut")))
	)

	var stats_value: Variant = data.get("stats", {})
	var stats: Dictionary = stats_value as Dictionary if stats_value is Dictionary else {}
	max_hp = int(stats.get("hp", 0))
	hp = max_hp
	attack = int(stats.get("attack", 0))
	defense = int(stats.get("defense", 0))
	speed_stat = int(stats.get("speed", 0))
	energy = int(stats.get("energy", 0))


func _with_defaults(data: Dictionary) -> Dictionary:
	var result: Dictionary = CATALOG.default_character_data()
	var default_stats := result["stats"] as Dictionary
	for key: Variant in data:
		if key == "stats":
			continue
		result[key] = data[key]
	var stats_value: Variant = data.get("stats", {})
	if stats_value is Dictionary:
		default_stats.merge(stats_value as Dictionary, true)
	result["stats"] = default_stats
	return result


func _resolve_or_default(
	data: Dictionary,
	key: StringName,
	fallback_id: StringName
) -> AppearanceItem:
	var item_id := StringName(str(data.get(String(key), String(fallback_id))))
	var item: AppearanceItem = CATALOG.resolve_appearance(item_id)
	if item != null:
		return item
	return CATALOG.resolve_appearance(fallback_id)


func _play_movement_animation(state: StringName) -> void:
	var direction_name := _direction_name(facing_direction)
	var requested := StringName("%s_%s" % [state, direction_name])
	var fallback := StringName("%s_down" % state)
	var animation := requested
	if not modular_character.has_animation(animation):
		animation = fallback
	if not modular_character.has_animation(animation):
		animation = &"idle_down"
	if modular_character.current_animation != animation:
		modular_character.play_animation(animation)


func _direction_name(direction: Vector2) -> String:
	if absf(direction.x) > absf(direction.y):
		return "right" if direction.x > 0.0 else "left"
	return "down" if direction.y >= 0.0 else "up"
