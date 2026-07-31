class_name LumaThemedButton
extends Button

const HOVER_DURATION := 0.12
const HOVER_BRIGHTNESS := 1.06

var _hover_tween: Tween


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	focus_mode = Control.FOCUS_ALL


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
