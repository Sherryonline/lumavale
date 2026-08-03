extends Node

signal theme_changed(theme_id: StringName, theme: Theme)
signal ui_scale_changed(scale_factor: float)
signal reduced_motion_changed(enabled: bool)
signal high_contrast_changed(enabled: bool)

const DEFAULT_THEME_PATH := "res://ui/themes/lumavale_theme.tres"
const SUPPORTED_UI_SCALES: Array[float] = [1.0, 1.25, 1.5, 1.75, 2.0]
const Tokens := preload("res://ui/theme/theme_tokens.gd")

var current_theme_id: StringName = &"default"
var current_theme: Theme
var ui_scale: float = 1.0
var reduced_motion: bool = false
var high_contrast: bool = false
var _registered_themes: Dictionary = {&"default": DEFAULT_THEME_PATH}
var _base_theme: Theme
var _themed_controls: Array[WeakRef] = []


func _ready() -> void:
	get_tree().root.content_scale_factor = 1.0
	set_theme(&"default")


func register_theme(theme_id: StringName, resource_path: String) -> void:
	_registered_themes[theme_id] = resource_path


func set_theme(theme_id: StringName) -> void:
	if not _registered_themes.has(theme_id):
		push_warning("ThemeManager has no registered theme named %s." % theme_id)
		return
	var loaded_theme := load(_registered_themes[theme_id]) as Theme
	if loaded_theme == null:
		push_error("ThemeManager could not load %s." % _registered_themes[theme_id])
		return
	current_theme_id = theme_id
	_base_theme = loaded_theme
	_rebuild_scaled_theme()


func apply_theme(control: Control) -> void:
	if control == null:
		return
	if current_theme == null:
		set_theme(&"default")
	control.theme = current_theme
	_register_themed_control(control)


func set_ui_scale(requested_scale: float) -> void:
	var closest_scale := SUPPORTED_UI_SCALES[0]
	for supported_scale: float in SUPPORTED_UI_SCALES:
		if absf(supported_scale - requested_scale) < absf(closest_scale - requested_scale):
			closest_scale = supported_scale
	if is_equal_approx(ui_scale, closest_scale):
		return
	ui_scale = closest_scale
	get_tree().root.content_scale_factor = 1.0
	_rebuild_scaled_theme()
	ui_scale_changed.emit(ui_scale)


func set_reduced_motion(enabled: bool) -> void:
	reduced_motion = enabled
	reduced_motion_changed.emit(reduced_motion)


func set_high_contrast(enabled: bool) -> void:
	if high_contrast == enabled:
		return
	high_contrast = enabled
	high_contrast_changed.emit(high_contrast)


func get_token(token: StringName) -> Color:
	return Tokens.get_color(token)


func scaled_size(base_size: Vector2) -> Vector2:
	return Vector2(
		roundf(base_size.x * ui_scale),
		roundf(base_size.y * ui_scale)
	)


func scaled_value(base_value: float) -> float:
	return roundf(base_value * ui_scale)


func _rebuild_scaled_theme() -> void:
	if _base_theme == null:
		return
	current_theme = _base_theme.duplicate(true) as Theme
	current_theme.default_base_scale = ui_scale
	_scale_theme_font_sizes()
	_apply_theme_to_registered_controls()
	theme_changed.emit(current_theme_id, current_theme)


func _scale_theme_font_sizes() -> void:
	for theme_type: StringName in _base_theme.get_type_list():
		for font_size_name: StringName in _base_theme.get_font_size_list(theme_type):
			var base_size := _base_theme.get_font_size(font_size_name, theme_type)
			current_theme.set_font_size(
				font_size_name,
				theme_type,
				maxi(1, roundi(float(base_size) * ui_scale))
			)


func _register_themed_control(control: Control) -> void:
	for reference: WeakRef in _themed_controls:
		if reference.get_ref() == control:
			return
	_themed_controls.append(weakref(control))


func _apply_theme_to_registered_controls() -> void:
	var valid_controls: Array[WeakRef] = []
	for reference: WeakRef in _themed_controls:
		var control := reference.get_ref() as Control
		if control == null:
			continue
		control.theme = current_theme
		valid_controls.append(reference)
	_themed_controls = valid_controls
