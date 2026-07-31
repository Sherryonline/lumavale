class_name ModularCharacter
extends Node2D

@export var show_placeholder_when_empty := true:
	set(value):
		show_placeholder_when_empty = value
		_update_placeholder()

@onready var shadow: Polygon2D = $Shadow
@onready var accessory_back: AnimatedSprite2D = $AccessoryBack
@onready var body: AnimatedSprite2D = $Body
@onready var bottom: AnimatedSprite2D = $Bottom
@onready var shoes: AnimatedSprite2D = $Shoes
@onready var top: AnimatedSprite2D = $Top
@onready var eyes: AnimatedSprite2D = $Eyes
@onready var hair: AnimatedSprite2D = $Hair
@onready var weapon: AnimatedSprite2D = $Weapon
@onready var accessory_front: AnimatedSprite2D = $AccessoryFront
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_animation: StringName = &"idle_down"
var current_frame: int = 0

var _layers: Array[AnimatedSprite2D] = []
var _clock_layer: AnimatedSprite2D
var _fallback_clock: AnimatedSprite2D
var _is_playing: bool = false


func _ready() -> void:
	_layers = [
		accessory_back,
		body,
		bottom,
		shoes,
		top,
		eyes,
		hair,
		weapon,
		accessory_front,
	]
	body.frame_changed.connect(_on_body_frame_changed)
	_refresh_layers(false)


func _draw() -> void:
	if not _should_show_placeholder():
		return

	var outline := Color("4b3d54")
	var skin := Color("f2c6a0")
	var hair_color := Color("6b4b3e")
	var tunic := Color("79a86b")
	var boots := Color("59433c")

	draw_circle(Vector2(0.0, -10.0), 12.0, outline)
	draw_circle(Vector2(0.0, -10.0), 10.0, skin)
	draw_arc(Vector2(0.0, -12.0), 10.0, PI, TAU, 16, hair_color, 5.0)
	draw_circle(Vector2(-3.5, -9.0), 1.2, outline)
	draw_circle(Vector2(3.5, -9.0), 1.2, outline)
	draw_rect(Rect2(-9.0, 1.0, 18.0, 17.0), tunic, true)
	draw_rect(Rect2(-9.0, 1.0, 18.0, 17.0), outline, false, 2.0)
	draw_line(Vector2(-5.0, 18.0), Vector2(-5.0, 25.0), boots, 5.0)
	draw_line(Vector2(5.0, 18.0), Vector2(5.0, 25.0), boots, 5.0)


func play_animation(animation_name: StringName) -> void:
	if current_animation != animation_name:
		current_frame = 0
	current_animation = animation_name
	_refresh_layers(true)


func stop_animation() -> void:
	if is_instance_valid(_clock_layer):
		current_frame = _clock_layer.frame
	_clock_layer = null
	_is_playing = false
	_disconnect_fallback_clock()
	for layer: AnimatedSprite2D in _layers:
		layer.stop()
	_sync_visible_layers()


func set_body(item: AppearanceItem) -> void:
	_set_single_layer(body, item)


func set_hair(item: AppearanceItem) -> void:
	_set_single_layer(hair, item)


func set_eyes(item: AppearanceItem) -> void:
	_set_single_layer(eyes, item)


func set_top(item: AppearanceItem) -> void:
	_set_single_layer(top, item)


func set_bottom(item: AppearanceItem) -> void:
	_set_single_layer(bottom, item)


func set_shoes(item: AppearanceItem) -> void:
	_set_single_layer(shoes, item)


func set_weapon(item: AppearanceItem) -> void:
	_set_single_layer(weapon, item)


func set_accessory(item: AppearanceItem) -> void:
	var was_playing := _prepare_layer_change()
	_assign_sprite_frames(accessory_back, item.back_sprite_frames if item != null else null)
	_assign_sprite_frames(accessory_front, item.sprite_frames if item != null else null)
	_refresh_layers(was_playing)


func clear_layer(layer: AnimatedSprite2D) -> void:
	if layer == null:
		return
	var was_playing := _prepare_layer_change()
	_assign_sprite_frames(layer, null)
	_refresh_layers(was_playing)


func apply_character_data(data: Dictionary) -> void:
	var was_playing := _prepare_layer_change()
	var accessory_item := _get_item(data, &"accessory")

	_assign_sprite_frames(body, _get_item_frames(data, &"body"))
	_assign_sprite_frames(hair, _get_item_frames(data, &"hair"))
	_assign_sprite_frames(eyes, _get_item_frames(data, &"eyes"))
	_assign_sprite_frames(top, _get_item_frames(data, &"top"))
	_assign_sprite_frames(bottom, _get_item_frames(data, &"bottom"))
	_assign_sprite_frames(shoes, _get_item_frames(data, &"shoes"))
	_assign_sprite_frames(weapon, _get_item_frames(data, &"weapon"))
	_assign_sprite_frames(
		accessory_back,
		accessory_item.back_sprite_frames if accessory_item != null else null
	)
	_assign_sprite_frames(
		accessory_front,
		accessory_item.sprite_frames if accessory_item != null else null
	)
	_refresh_layers(was_playing)


func _set_single_layer(layer: AnimatedSprite2D, item: AppearanceItem) -> void:
	var was_playing := _prepare_layer_change()
	_assign_sprite_frames(layer, item.sprite_frames if item != null else null)
	_refresh_layers(was_playing)


func _prepare_layer_change() -> bool:
	if is_instance_valid(_clock_layer):
		current_frame = _clock_layer.frame
	return _is_playing


func _assign_sprite_frames(layer: AnimatedSprite2D, frames: SpriteFrames) -> void:
	layer.stop()
	layer.sprite_frames = frames
	layer.visible = false


func _refresh_layers(should_play: bool) -> void:
	_disconnect_fallback_clock()
	_clock_layer = null

	for layer: AnimatedSprite2D in _layers:
		layer.stop()
		layer.visible = _has_current_animation(layer)
		if layer.visible:
			layer.animation = current_animation
			layer.frame = _safe_frame_for(layer)

	_clock_layer = _find_clock_layer()
	_is_playing = should_play and is_instance_valid(_clock_layer)

	if _is_playing:
		if _clock_layer != body:
			_fallback_clock = _clock_layer
			_fallback_clock.frame_changed.connect(_on_fallback_frame_changed)
		_clock_layer.play(current_animation)
		_clock_layer.frame = _safe_frame_for(_clock_layer)

	_sync_visible_layers()
	_update_placeholder()


func _find_clock_layer() -> AnimatedSprite2D:
	if _has_current_animation(body):
		return body
	for layer: AnimatedSprite2D in _layers:
		if layer != body and _has_current_animation(layer):
			return layer
	return null


func _has_current_animation(layer: AnimatedSprite2D) -> bool:
	return (
		layer.sprite_frames != null
		and layer.sprite_frames.has_animation(current_animation)
		and layer.sprite_frames.get_frame_count(current_animation) > 0
	)


func _safe_frame_for(layer: AnimatedSprite2D) -> int:
	if not _has_current_animation(layer):
		return 0
	return mini(current_frame, layer.sprite_frames.get_frame_count(current_animation) - 1)


func _sync_visible_layers() -> void:
	for layer: AnimatedSprite2D in _layers:
		if layer == _clock_layer or not layer.visible:
			continue
		layer.animation = current_animation
		layer.frame = _safe_frame_for(layer)


func _on_body_frame_changed() -> void:
	if body != _clock_layer:
		return
	current_frame = body.frame
	_sync_visible_layers()


func _on_fallback_frame_changed() -> void:
	if not is_instance_valid(_fallback_clock) or _fallback_clock != _clock_layer:
		return
	current_frame = _fallback_clock.frame
	_sync_visible_layers()


func _disconnect_fallback_clock() -> void:
	if (
		is_instance_valid(_fallback_clock)
		and _fallback_clock.frame_changed.is_connected(_on_fallback_frame_changed)
	):
		_fallback_clock.frame_changed.disconnect(_on_fallback_frame_changed)
	_fallback_clock = null


func _get_item(data: Dictionary, key: StringName) -> AppearanceItem:
	var value: Variant = data.get(key)
	if value is AppearanceItem:
		return value as AppearanceItem
	return null


func _get_item_frames(data: Dictionary, key: StringName) -> SpriteFrames:
	var item := _get_item(data, key)
	return item.sprite_frames if item != null else null


func _should_show_placeholder() -> bool:
	return (
		show_placeholder_when_empty
		and is_instance_valid(body)
		and body.sprite_frames == null
	)


func _update_placeholder() -> void:
	if not is_node_ready():
		return
	shadow.visible = _should_show_placeholder()
	queue_redraw()
