class_name Player
extends CharacterBody2D

const CATALOG := preload("res://scripts/character/character_catalog.gd")

@export var move_speed: float = 150.0
@export var attack_duration := 0.28
@export var attack_active_time := 0.14
@export var attack_cooldown := 0.45
@export var invulnerability_time := 0.4

enum State {
	IDLE,
	MOVE,
	ATTACK,
	HURT,
	DEAD,
}

var state: State = State.IDLE
var facing_direction := Vector2.DOWN
var character_name: String = "Adventurer"
var role_id: StringName = &"warrior"
var max_hp: int = 0
var hp: int = 0
var attack: int = 0
var defense: int = 0
var speed_stat: int = 0
var energy: int = 0
var _cooldown_remaining := 0.0
var _invulnerable := false
var _hit_targets: Array[Node] = []

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var modular_character: ModularCharacter = $ModularCharacter
@onready var camera: Camera2D = $Camera2D
@onready var health: Node = $Health
@onready var attack_area: Area2D = $AttackArea


func _ready() -> void:
	GameState.player = self
	var session_data := GameSession.get_character_data()
	if session_data.is_empty():
		session_data = CATALOG.default_character_data()
		if OS.is_debug_build():
			push_warning("GameSession is empty; using the default Warrior character.")
	apply_character_data(_with_defaults(session_data))
	attack_area.area_entered.connect(_on_attack_area_entered)
	attack_area.body_entered.connect(_on_attack_body_entered)
	health.health_changed.connect(_on_health_changed)
	health.died.connect(_on_died)
	modular_character.play_animation(&"idle_down")


func _physics_process(delta: float) -> void:
	_cooldown_remaining = maxf(0.0, _cooldown_remaining - delta)
	if state == State.DEAD:
		velocity = Vector2.ZERO
		return
	if GameState.input_locked:
		velocity = Vector2.ZERO
		_play_movement_animation(&"idle")
		return
	if Input.is_action_just_pressed("attack"):
		_start_attack()
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var speed_multiplier := 0.35 if state == State.ATTACK else 1.0
	velocity = input_direction * move_speed * speed_multiplier

	if input_direction != Vector2.ZERO:
		facing_direction = input_direction

	move_and_slide()
	if state != State.ATTACK and state != State.HURT:
		state = State.MOVE if input_direction != Vector2.ZERO else State.IDLE
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
	health.max_health = maxi(1, max_hp)
	health.current_health = clampi(int(stats.get("current_hp", max_hp)), 1, health.max_health)
	health.is_dead = false
	EventBus.player_health_changed.emit(health.current_health, health.max_health)


func receive_damage(data: Dictionary) -> void:
	if _invulnerable or state == State.DEAD:
		return
	var incoming := int(data.get("amount", 1))
	var final_damage := maxi(1, incoming - defense)
	if not health.take_damage({"amount": final_damage}):
		return
	if health.is_dead:
		return
	state = State.HURT
	_invulnerable = true
	var direction := data.get("hit_direction", Vector2.ZERO) as Vector2
	global_position += direction.normalized() * float(data.get("knockback_force", 12.0))
	_flash_invulnerable()
	await get_tree().create_timer(invulnerability_time).timeout
	_invulnerable = false
	modular_character.visible = true
	if state == State.HURT:
		state = State.IDLE


func heal(amount: int) -> bool:
	return health.heal(amount)


func respawn(spawn_position: Vector2) -> void:
	global_position = spawn_position
	health.reset_health()
	state = State.IDLE
	_invulnerable = false
	modular_character.visible = true
	collision_shape.disabled = false
	EventBus.player_health_changed.emit(health.current_health, health.max_health)


func _start_attack() -> void:
	if state == State.DEAD or _cooldown_remaining > 0.0:
		return
	state = State.ATTACK
	_cooldown_remaining = attack_cooldown
	_hit_targets.clear()
	_position_attack_area()
	attack_area.visible = true
	attack_area.monitoring = true
	_play_movement_animation(&"attack")
	await get_tree().create_timer(attack_active_time).timeout
	attack_area.monitoring = false
	await get_tree().create_timer(maxf(0.0, attack_duration - attack_active_time)).timeout
	attack_area.visible = false
	if state == State.ATTACK:
		state = State.IDLE


func _position_attack_area() -> void:
	var direction := facing_direction.normalized()
	if direction == Vector2.ZERO:
		direction = Vector2.DOWN
	attack_area.position = direction * 22.0
	attack_area.rotation = direction.angle()


func _on_attack_area_entered(area: Area2D) -> void:
	_try_hit(area.get_parent())


func _on_attack_body_entered(body: Node2D) -> void:
	_try_hit(body)


func _try_hit(target: Node) -> void:
	if target == null or _hit_targets.has(target):
		return
	if not target.has_method("receive_hit"):
		return
	_hit_targets.append(target)
	target.call("receive_hit", {
		"source_id": role_id,
		"amount": attack,
		"knockback_force": 20.0,
		"hit_direction": facing_direction,
		"damage_type": &"melee",
	})


func _on_health_changed(current_hp: int, new_max_hp: int) -> void:
	hp = current_hp
	max_hp = new_max_hp
	EventBus.player_health_changed.emit(current_hp, new_max_hp)


func _on_died() -> void:
	state = State.DEAD
	velocity = Vector2.ZERO
	collision_shape.disabled = true
	EventBus.player_died.emit()


func _flash_invulnerable() -> void:
	if ThemeManager.reduced_motion:
		return
	var blink_count := 4
	for index: int in blink_count:
		if not _invulnerable:
			return
		modular_character.visible = not modular_character.visible
		await get_tree().create_timer(invulnerability_time / float(blink_count)).timeout
	modular_character.visible = true


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
