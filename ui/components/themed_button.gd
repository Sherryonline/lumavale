class_name LumaThemedButton
extends Button

const HOVER_DURATION := 0.12
const HOVER_BRIGHTNESS := 1.06

var _hover_tween: Tween
var _base_minimum_size: Vector2


func _ready() -> void:
	_base_minimum_size = custom_minimum_size
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	focus_mode = Control.FOCUS_ALL
	ThemeManager.ui_scale_changed.connect(_apply_ui_scale)
	_apply_ui_scale(ThemeManager.ui_scale)


func _on_mouse_entered() -> void:
	if disabled:
		return
	_tween_brightness(HOVER_BRIGHTNESS)


func _on_mouse_exited() -> void:
	_tween_brightness(1.0)


func _tween_brightness(brightness: float) -> void:
	if ThemeManager.reduced_motion:
		self_modulate = Color(brightness, brightness, brightness, 1.0)
		return
	if _hover_tween != null and _hover_tween.is_valid():
		_hover_tween.kill()
	_hover_tween = create_tween()
	_hover_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_hover_tween.tween_property(
		self,
		"self_modulate",
		Color(brightness, brightness, brightness, 1.0),
		HOVER_DURATION
	)


func _apply_ui_scale(scale_factor: float) -> void:
	custom_minimum_size = Vector2(
		roundf(_base_minimum_size.x * scale_factor),
		roundf(maxf(_base_minimum_size.y, 44.0) * scale_factor)
	)
