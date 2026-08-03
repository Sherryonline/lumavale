class_name LumaAppearanceOption
extends Button

@export var option_icon: Texture2D:
	set(value):
		option_icon = value
		_update_content()
@export var option_name: String = "Option":
	set(value):
		option_name = value
		_update_content()
@export var tooltip: String = "":
	set(value):
		tooltip = value
		tooltip_text = tooltip
@export var selected: bool = false:
	set(value):
		selected = value
		_update_state()
@export var locked: bool = false:
	set(value):
		locked = value
		_update_state()

@onready var icon_rect: TextureRect = $Icon
@onready var name_label: Label = $Name
@onready var selected_indicator: Label = $SelectedIndicator
@onready var locked_indicator: Label = $LockedIndicator
@onready var lock_icon_rect: TextureRect = $LockIcon

var _base_minimum_size: Vector2


func _ready() -> void:
	_base_minimum_size = custom_minimum_size
	focus_mode = Control.FOCUS_ALL
	ThemeManager.ui_scale_changed.connect(_apply_ui_scale)
	_apply_ui_scale(ThemeManager.ui_scale)
	_update_content()
	_update_state()


func _update_content() -> void:
	if not is_node_ready():
		return
	icon_rect.texture = option_icon
	icon_rect.visible = option_icon != null
	name_label.text = option_name


func _update_state() -> void:
	if not is_node_ready():
		return
	disabled = locked
	if locked and tooltip_text.is_empty():
		tooltip_text = "%s is locked and unavailable." % option_name
	selected_indicator.visible = selected and not locked
	locked_indicator.visible = locked
	lock_icon_rect.visible = locked
	if locked:
		theme_type_variation = &"LockedAppearanceOption"
	elif selected:
		theme_type_variation = &"SelectedAppearanceOption"
	else:
		theme_type_variation = &"AppearanceOption"


func _apply_ui_scale(scale_factor: float) -> void:
	var base_size := Vector2(
		maxf(_base_minimum_size.x, 48.0),
		maxf(_base_minimum_size.y, 48.0)
	)
	custom_minimum_size = Vector2(
		roundf(base_size.x * scale_factor),
		roundf(base_size.y * scale_factor)
	)
