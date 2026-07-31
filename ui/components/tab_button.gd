class_name LumaTabButton
extends Button

const T := preload("res://ui/theme/theme_tokens.gd")

@export var selected: bool = false:
	set(value):
		selected = value
		button_pressed = selected
		_update_state()

@onready var indicator: ColorRect = $Indicator

var _indicator_tween: Tween


func _ready() -> void:
	toggle_mode = true
	focus_mode = Control.FOCUS_ALL
	toggled.connect(_on_toggled)
	indicator.color = T.BORDER_SELECTED
	indicator.pivot_offset = Vector2(indicator.size.x * 0.5, indicator.size.y * 0.5)
	_update_state()


func _on_toggled(value: bool) -> void:
	selected = value


func _update_state() -> void:
	if not is_node_ready():
		return
	theme_type_variation = &"SelectedTabButton" if selected else &"TabButton"
	var target_scale := Vector2.ONE if selected else Vector2(0.0, 1.0)
	if ThemeManager.reduced_motion:
		indicator.scale = target_scale
		return
	if _indicator_tween != null and _indicator_tween.is_valid():
		_indicator_tween.kill()
	_indicator_tween = create_tween()
	_indicator_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_indicator_tween.tween_property(indicator, "scale", target_scale, 0.12)
