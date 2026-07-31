extends Node

signal theme_changed(theme_id: StringName, theme: Theme)
signal ui_scale_changed(scale_factor: float)
signal reduced_motion_changed(enabled: bool)

const DEFAULT_THEME_PATH := "res://ui/theme/luma_theme.tres"
const SUPPORTED_UI_SCALES: Array[float] = [1.0, 1.25, 1.5, 1.75, 2.0]
const Tokens := preload("res://ui/theme/theme_tokens.gd")

var current_theme_id: StringName = &"default"
var current_theme: Theme
var ui_scale: float = 1.0
var reduced_motion: bool = false
var _registered_themes: Dictionary = {&"default": DEFAULT_THEME_PATH}


func _ready() -> void:
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
	current_theme = loaded_theme
	theme_changed.emit(current_theme_id, current_theme)


func apply_theme(control: Control) -> void:
	if control == null:
		return
	if current_theme == null:
		set_theme(&"default")
	control.theme = current_theme


func set_ui_scale(requested_scale: float) -> void:
	var closest_scale := SUPPORTED_UI_SCALES[0]
	for supported_scale: float in SUPPORTED_UI_SCALES:
		if absf(supported_scale - requested_scale) < absf(closest_scale - requested_scale):
			closest_scale = supported_scale
	ui_scale = closest_scale
	get_tree().root.content_scale_factor = ui_scale
	ui_scale_changed.emit(ui_scale)


func set_reduced_motion(enabled: bool) -> void:
	reduced_motion = enabled
	reduced_motion_changed.emit(reduced_motion)


func get_token(token: StringName) -> Color:
	return Tokens.get_color(token)
