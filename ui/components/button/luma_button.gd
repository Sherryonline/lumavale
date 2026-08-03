class_name LumaButton
extends Button

enum Variant {
	PRIMARY,
	SECONDARY,
	ACCENT,
	GHOST,
	DANGER,
	ICON,
}

@export var variant: Variant = Variant.PRIMARY:
	set(value):
		variant = value
		_apply_component_state()
@export var selected := false:
	set(value):
		selected = value
		_apply_component_state()
@export var locked := false:
	set(value):
		locked = value
		_apply_component_state()
@export var locked_tooltip := "This option is locked.":
	set(value):
		locked_tooltip = value
		if locked:
			tooltip_text = locked_tooltip

var _base_minimum_size := Vector2.ZERO
var _base_position_y := 0.0
var _hover_tween: Tween


func _ready() -> void:
	_base_minimum_size = custom_minimum_size
	_base_position_y = position.y
	focus_mode = Control.FOCUS_ALL
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	ThemeManager.ui_scale_changed.connect(_apply_ui_scale)
	_apply_ui_scale(ThemeManager.ui_scale)
	_apply_component_state()


func _on_mouse_entered() -> void:
	if disabled:
		return
	_tween_modulate(Color(1.06, 1.06, 1.06, 1.0))


func _on_mouse_exited() -> void:
	_tween_modulate(Color.WHITE)


func _on_button_down() -> void:
	if disabled:
		return
	position.y = _base_position_y + 1.0


func _on_button_up() -> void:
	position.y = _base_position_y


func _tween_modulate(target: Color) -> void:
	if ThemeManager.reduced_motion:
		self_modulate = target
		return
	if _hover_tween != null and _hover_tween.is_valid():
		_hover_tween.kill()
	_hover_tween = create_tween()
	_hover_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_hover_tween.tween_property(self, "self_modulate", target, 0.12)


func _apply_component_state() -> void:
	if not is_node_ready():
		return
	disabled = locked
	if locked:
		tooltip_text = locked_tooltip
		theme_type_variation = &"LockedActionButton"
		return
	if selected:
		theme_type_variation = &"SelectedActionButton"
		return
	match variant:
		Variant.SECONDARY:
			theme_type_variation = &"SecondaryButton"
		Variant.ACCENT:
			theme_type_variation = &"AccentButton"
		Variant.GHOST:
			theme_type_variation = &"GhostButton"
		Variant.DANGER:
			theme_type_variation = &"DangerButton"
		Variant.ICON:
			theme_type_variation = &"IconButton"
		_:
			theme_type_variation = &"PrimaryButton"


func _apply_ui_scale(scale_factor: float) -> void:
	var base_height := 44.0
	if variant == Variant.ICON:
		base_height = 48.0
	var base_size := Vector2(
		maxf(_base_minimum_size.x, base_height),
		maxf(_base_minimum_size.y, base_height)
	)
	custom_minimum_size = Vector2(
		roundf(base_size.x * scale_factor),
		roundf(base_size.y * scale_factor)
	)
