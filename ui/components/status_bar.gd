class_name LumaStatusBar
extends ProgressBar

@export var interpolation_speed: float = 8.0

var target_value: float:
	set(new_value):
		target_value = clampf(new_value, min_value, max_value)


func _ready() -> void:
	target_value = value


func _process(delta: float) -> void:
	if is_equal_approx(value, target_value):
		value = target_value
		return
	if ThemeManager.reduced_motion:
		value = target_value
	else:
		value = lerpf(value, target_value, 1.0 - exp(-interpolation_speed * delta))
