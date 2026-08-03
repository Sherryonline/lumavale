class_name LumaStatusBar
extends ProgressBar

enum Variant {
	HP,
	ENERGY,
	EXP,
}

@export var interpolation_speed: float = 8.0
@export var variant: Variant = Variant.HP:
	set(value):
		variant = value
		_update_variant()
@export var label_text: String = "HP":
	set(value):
		label_text = value
		_update_labels()
@export var show_label: bool = true:
	set(value):
		show_label = value
		_update_labels()
@export var show_numeric_value: bool = true:
	set(value):
		show_numeric_value = value
		_update_labels()
@export var low_hp_pulse_enabled: bool = false
@export_range(0.0, 1.0, 0.05) var low_hp_threshold: float = 0.25

@onready var name_label: Label = $Name
@onready var value_label: Label = $Value

var _pulse_time := 0.0
var _base_minimum_size: Vector2

var target_value: float:
	set(new_value):
		target_value = clampf(new_value, min_value, max_value)


func _ready() -> void:
	_base_minimum_size = custom_minimum_size
	show_percentage = false
	target_value = value
	ThemeManager.ui_scale_changed.connect(_apply_ui_scale)
	_apply_ui_scale(ThemeManager.ui_scale)
	_adopt_existing_variation()
	_update_labels()


func _process(delta: float) -> void:
	var previous_value := value
	if is_equal_approx(value, target_value):
		value = target_value
	elif ThemeManager.reduced_motion:
		value = target_value
	else:
		value = lerpf(value, target_value, 1.0 - exp(-interpolation_speed * delta))
	if not is_equal_approx(previous_value, value):
		_update_labels()
	_update_low_hp_pulse(delta)


func set_target_value(new_value: float) -> void:
	target_value = new_value


func _update_variant() -> void:
	if not is_node_ready():
		return
	match variant:
		Variant.ENERGY:
			theme_type_variation = &"EnergyBar"
		Variant.EXP:
			theme_type_variation = &"EXPBar"
		_:
			theme_type_variation = &"HPBar"


func _adopt_existing_variation() -> void:
	match theme_type_variation:
		&"EnergyBar":
			variant = Variant.ENERGY
		&"EXPBar":
			variant = Variant.EXP
		&"ManaBar":
			pass
		_:
			_update_variant()


func _update_labels() -> void:
	if not is_node_ready():
		return
	name_label.visible = show_label
	name_label.text = label_text
	value_label.visible = show_numeric_value
	value_label.text = "%d / %d" % [roundi(value), roundi(max_value)]


func _update_low_hp_pulse(delta: float) -> void:
	var range_size := max_value - min_value
	var ratio := (value - min_value) / range_size if range_size > 0.0 else 1.0
	var should_pulse: bool = (
		variant == Variant.HP
		and low_hp_pulse_enabled
		and ratio <= low_hp_threshold
		and not ThemeManager.reduced_motion
	)
	if not should_pulse:
		_pulse_time = 0.0
		self_modulate.a = 1.0
		return
	_pulse_time += delta
	self_modulate.a = lerpf(0.72, 1.0, (sin(_pulse_time * 2.0) + 1.0) * 0.5)


func _apply_ui_scale(scale_factor: float) -> void:
	custom_minimum_size = Vector2(
		roundf(_base_minimum_size.x * scale_factor),
		roundf(_base_minimum_size.y * scale_factor)
	)
