extends Node2D

var _body_items: Array[AppearanceItem] = [
	preload("res://resources/appearance/body_a.tres") as AppearanceItem,
	preload("res://resources/appearance/body_b.tres") as AppearanceItem,
]
var _hair_items: Array[AppearanceItem] = [
	preload("res://resources/appearance/hair_short.tres") as AppearanceItem,
	preload("res://resources/appearance/hair_wave.tres") as AppearanceItem,
	preload("res://resources/appearance/hair_pony.tres") as AppearanceItem,
	preload("res://resources/appearance/hair_crop.tres") as AppearanceItem,
]
var _top_items: Array[AppearanceItem] = [
	preload("res://resources/appearance/top_forest.tres") as AppearanceItem,
	preload("res://resources/appearance/top_blue.tres") as AppearanceItem,
	preload("res://resources/appearance/top_earth.tres") as AppearanceItem,
	preload("res://resources/appearance/top_violet.tres") as AppearanceItem,
]
var _weapon_items: Array[AppearanceItem] = [
	preload("res://resources/appearance/weapon_sword.tres") as AppearanceItem,
	preload("res://resources/appearance/weapon_bow.tres") as AppearanceItem,
	preload("res://resources/appearance/weapon_flask.tres") as AppearanceItem,
]

@onready var modular_character: ModularCharacter = $ModularCharacter
@onready var body_label: Label = $CanvasLayer/UI/Panel/Margin/Content/BodyLabel
@onready var hair_label: Label = $CanvasLayer/UI/Panel/Margin/Content/HairLabel
@onready var top_label: Label = $CanvasLayer/UI/Panel/Margin/Content/TopLabel
@onready var weapon_label: Label = $CanvasLayer/UI/Panel/Margin/Content/WeaponLabel
@onready var body_button: Button = $CanvasLayer/UI/Panel/Margin/Content/BodyButton
@onready var hair_button: Button = $CanvasLayer/UI/Panel/Margin/Content/HairButton
@onready var top_button: Button = $CanvasLayer/UI/Panel/Margin/Content/TopButton
@onready var weapon_button: Button = $CanvasLayer/UI/Panel/Margin/Content/WeaponButton

var _body_index: int = 0
var _hair_index: int = 0
var _top_index: int = 0
var _weapon_index: int = 0
var _bottom: AppearanceItem = preload(
	"res://resources/appearance/bottom_dark.tres"
) as AppearanceItem
var _shoes: AppearanceItem = preload(
	"res://resources/appearance/shoes_boots.tres"
) as AppearanceItem
var _accessory_none: AppearanceItem = preload(
	"res://resources/appearance/accessory_none.tres"
) as AppearanceItem
var _accessory_leaf: AppearanceItem = preload(
	"res://resources/appearance/accessory_leaf.tres"
) as AppearanceItem
var _accessory_bag: AppearanceItem = preload(
	"res://resources/appearance/accessory_bag.tres"
) as AppearanceItem
var _validation_failures := PackedStringArray()


func _ready() -> void:
	body_button.pressed.connect(_cycle_body)
	hair_button.pressed.connect(_cycle_hair)
	top_button.pressed.connect(_cycle_top)
	weapon_button.pressed.connect(_cycle_weapon)

	modular_character.set_body(_body_items[_body_index])
	modular_character.set_hair(_hair_items[_hair_index])
	modular_character.set_top(_top_items[_top_index])
	modular_character.set_bottom(_bottom)
	modular_character.set_shoes(_shoes)
	modular_character.set_weapon(_weapon_items[_weapon_index])
	modular_character.play_animation(&"idle_down")
	_refresh_labels()
	_store_selection()

	if OS.get_cmdline_user_args().has("--validate-milestone-3"):
		_run_command_line_validation.call_deferred()


func _unhandled_key_input(event: InputEvent) -> void:
	var key_event := event as InputEventKey
	if key_event == null or not key_event.pressed or key_event.echo:
		return

	match key_event.keycode:
		KEY_B:
			_cycle_body()
		KEY_H:
			_cycle_hair()
		KEY_T:
			_cycle_top()
		KEY_W:
			_cycle_weapon()


func _cycle_body() -> void:
	_body_index = wrapi(_body_index + 1, 0, _body_items.size())
	modular_character.set_body(_body_items[_body_index])
	_refresh_labels()
	_store_selection()


func _cycle_hair() -> void:
	_hair_index = wrapi(_hair_index + 1, 0, _hair_items.size())
	modular_character.set_hair(_hair_items[_hair_index])
	_refresh_labels()
	_store_selection()


func _cycle_top() -> void:
	_top_index = wrapi(_top_index + 1, 0, _top_items.size())
	modular_character.set_top(_top_items[_top_index])
	_refresh_labels()
	_store_selection()


func _cycle_weapon() -> void:
	_weapon_index = wrapi(_weapon_index + 1, 0, _weapon_items.size())
	modular_character.set_weapon(_weapon_items[_weapon_index])
	_refresh_labels()
	_store_selection()


func _refresh_labels() -> void:
	body_label.text = "Body: %s" % _body_items[_body_index].display_name
	hair_label.text = "Hair: %s" % _hair_items[_hair_index].display_name
	top_label.text = "Top: %s" % _top_items[_top_index].display_name
	weapon_label.text = "Weapon: %s" % _weapon_items[_weapon_index].display_name


func _store_selection() -> void:
	GameSession.set_character_data(
		{
			&"body": _body_items[_body_index],
			&"hair": _hair_items[_hair_index],
			&"top": _top_items[_top_index],
			&"bottom": _bottom,
			&"shoes": _shoes,
			&"weapon": _weapon_items[_weapon_index],
		}
	)


func _run_command_line_validation() -> void:
	var character_instance_id := modular_character.get_instance_id()
	var layers: Array[AnimatedSprite2D] = [
		modular_character.accessory_back,
		modular_character.body,
		modular_character.bottom,
		modular_character.shoes,
		modular_character.top,
		modular_character.eyes,
		modular_character.hair,
		modular_character.weapon,
		modular_character.accessory_front,
	]
	var original_positions: Dictionary = {}
	for layer: AnimatedSprite2D in layers:
		original_positions[layer.name] = layer.position

	for index: int in _body_items.size():
		body_button.pressed.emit()
	for index: int in _hair_items.size():
		hair_button.pressed.emit()
	for index: int in _top_items.size():
		top_button.pressed.emit()
	for index: int in _weapon_items.size():
		weapon_button.pressed.emit()

	_expect(
		modular_character.get_instance_id() == character_instance_id,
		"Switching a layer replaced the ModularCharacter instance."
	)
	_expect(modular_character.current_animation == &"idle_down", "Animation was not preserved.")
	_expect(body_label.text.contains("Body A"), "Body label did not update.")
	_expect(hair_label.text.contains("Short Hair"), "Hair label did not update.")
	_expect(top_label.text.contains("Forest Tunic"), "Top label did not update.")
	_expect(weapon_label.text.contains("Woodland Sword"), "Weapon label did not update.")

	for layer: AnimatedSprite2D in layers:
		_expect(
			layer.position == original_positions[layer.name],
			"%s jumped from its aligned origin." % layer.name
		)

	for item: AppearanceItem in _all_non_empty_items():
		_validate_sprite_frames(item)

	modular_character.set_accessory(_accessory_leaf)
	_expect(
		modular_character.accessory_front.sprite_frames != null,
		"Leaf accessory did not populate the front layer."
	)
	modular_character.set_accessory(_accessory_bag)
	_expect(
		modular_character.accessory_back.sprite_frames != null,
		"Bag accessory did not populate the back layer."
	)
	modular_character.set_accessory(_accessory_none)
	_expect(
		modular_character.accessory_back.sprite_frames == null
		and modular_character.accessory_front.sprite_frames == null,
		"No Accessory did not clear both accessory layers."
	)

	if _validation_failures.is_empty():
		print("MILESTONE_3_VALIDATION_OK")
		get_tree().quit(42)
		return

	for failure: String in _validation_failures:
		push_error(failure)
	get_tree().quit(1)


func _all_non_empty_items() -> Array[AppearanceItem]:
	var items: Array[AppearanceItem] = []
	items.append_array(_body_items)
	items.append_array(_hair_items)
	items.append_array(_top_items)
	items.append_array(_weapon_items)
	items.append(_bottom)
	items.append(_shoes)
	items.append(_accessory_leaf)
	items.append(_accessory_bag)
	items.append(
		load("res://resources/appearance/bottom_brown.tres") as AppearanceItem
	)
	items.append(
		load("res://resources/appearance/shoes_light.tres") as AppearanceItem
	)
	return items


func _validate_sprite_frames(item: AppearanceItem) -> void:
	var frames := (
		item.back_sprite_frames
		if item.back_sprite_frames != null
		else item.sprite_frames
	)
	_expect(frames != null, "%s has no SpriteFrames." % item.display_name)
	if frames == null:
		return

	var expected_counts := {
		&"idle_down": 1,
		&"walk_down": 2,
		&"attack_down": 2,
	}
	for animation_name: StringName in expected_counts:
		_expect(
			frames.has_animation(animation_name),
			"%s is missing %s." % [item.display_name, animation_name]
		)
		if not frames.has_animation(animation_name):
			continue
		var expected_count: int = expected_counts[animation_name]
		_expect(
			frames.get_frame_count(animation_name) == expected_count,
			"%s has the wrong frame count for %s." % [item.display_name, animation_name]
		)
		for frame_index: int in frames.get_frame_count(animation_name):
			var atlas := frames.get_frame_texture(animation_name, frame_index) as AtlasTexture
			_expect(
				atlas != null and atlas.region.size == Vector2(48, 64),
				"%s uses a frame outside the 48x64 canvas." % item.display_name
			)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_validation_failures.append(message)
