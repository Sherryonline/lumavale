class_name Slime
extends CharacterBody2D

enum State {
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	HURT,
	DEAD,
}

const WORLD_ITEM_SCENE := preload("res://scenes/items/world_item.tscn")

@export var data: Resource
@export var spawn_radius := 90.0

var state: State = State.IDLE
var spawn_position := Vector2.ZERO
var _target: Player
var _state_time := 0.0
var _attack_timer := 0.0
var _loot_dropped := false

@onready var health: Node = $HealthComponent
@onready var body_shape: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label


func _ready() -> void:
	spawn_position = global_position
	if data == null:
		data = load("res://resources/monsters/slime_data.tres") as Resource
	health.max_health = data.max_hp
	health.reset_health()
	health.died.connect(_on_died)
	health.health_changed.connect(_on_health_changed)
	label.text = "%s %d/%d" % [data.display_name, health.current_health, health.max_health]
	_pick_idle()


func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return
	_attack_timer = maxf(0.0, _attack_timer - delta)
	_state_time -= delta
	_find_target()
	match state:
		State.IDLE:
			velocity = Vector2.ZERO
			if _target != null:
				state = State.CHASE
			elif _state_time <= 0.0:
				_pick_wander()
		State.WANDER:
			if _target != null:
				state = State.CHASE
			elif _state_time <= 0.0 or global_position.distance_to(spawn_position) > spawn_radius:
				_pick_idle()
		State.CHASE:
			_chase_target()
		State.ATTACK:
			velocity = Vector2.ZERO
	move_and_slide()


func receive_hit(data_packet: Dictionary) -> void:
	if state == State.DEAD:
		return
	var incoming := int(data_packet.get("amount", 1))
	var final_damage := maxi(1, incoming - data.defense)
	health.take_damage({"amount": final_damage})
	var knockback := data_packet.get("hit_direction", Vector2.ZERO) as Vector2
	global_position += knockback.normalized() * 5.0


func _find_target() -> void:
	var player := GameState.player
	if player == null or player.health == null or player.health.is_dead:
		_target = null
		return
	var distance := global_position.distance_to(player.global_position)
	_target = player if distance <= data.detection_range and distance <= spawn_radius * 2.2 else null


func _chase_target() -> void:
	if _target == null:
		_pick_idle()
		return
	var direction := global_position.direction_to(_target.global_position)
	var distance := global_position.distance_to(_target.global_position)
	if distance <= data.attack_range:
		_try_attack(direction)
		return
	velocity = direction * data.move_speed


func _try_attack(direction: Vector2) -> void:
	if _attack_timer > 0.0:
		return
	_attack_timer = data.attack_cooldown
	state = State.ATTACK
	await get_tree().create_timer(0.18).timeout
	if state == State.DEAD or _target == null:
		return
	if global_position.distance_to(_target.global_position) <= data.attack_range + 8.0:
		_target.receive_damage({
			"source_id": data.id,
			"amount": data.attack,
			"knockback_force": 20.0,
			"hit_direction": direction,
			"damage_type": &"contact",
		})
	state = State.CHASE


func _pick_idle() -> void:
	state = State.IDLE
	velocity = Vector2.ZERO
	_state_time = randf_range(0.6, 1.4)


func _pick_wander() -> void:
	state = State.WANDER
	var direction := Vector2.RIGHT.rotated(randf() * TAU)
	velocity = direction * data.move_speed * 0.45
	_state_time = randf_range(0.7, 1.3)


func _on_health_changed(current_hp: int, max_hp: int) -> void:
	label.text = "%s %d/%d" % [data.display_name, current_hp, max_hp]


func _on_died() -> void:
	if state == State.DEAD:
		return
	state = State.DEAD
	velocity = Vector2.ZERO
	body_shape.disabled = true
	EventBus.monster_defeated.emit(data.id)
	GameState.quests.record_monster_defeated(data.id)
	_drop_loot_once()
	await get_tree().create_timer(0.45).timeout
	queue_free()


func _drop_loot_once() -> void:
	if _loot_dropped or data == null or data.loot_table == null:
		return
	_loot_dropped = true
	for drop: Dictionary in data.loot_table.roll():
		var item := drop.get("item") as Resource
		if item == null:
			continue
		var world_item := WORLD_ITEM_SCENE.instantiate()
		world_item.setup(item, int(drop.get("quantity", 1)))
		world_item.global_position = global_position + Vector2(randf_range(-12, 12), randf_range(-10, 10))
		get_tree().current_scene.add_child(world_item)
