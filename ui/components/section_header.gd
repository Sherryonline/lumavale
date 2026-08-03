class_name LumaSectionHeader
extends VBoxContainer

@export var heading: String = "Section":
	set(value):
		heading = value
		_update_content()
@export var icon: Texture2D:
	set(value):
		icon = value
		_update_content()
@export var show_divider: bool = true:
	set(value):
		show_divider = value
		_update_content()

@onready var icon_rect: TextureRect = $HeadingRow/Icon
@onready var heading_label: Label = $HeadingRow/Heading
@onready var divider: HSeparator = $Divider

var _base_icon_size: Vector2


func _ready() -> void:
	_base_icon_size = icon_rect.custom_minimum_size
	ThemeManager.ui_scale_changed.connect(_apply_ui_scale)
	_apply_ui_scale(ThemeManager.ui_scale)
	_update_content()


func _update_content() -> void:
	if not is_node_ready():
		return
	heading_label.text = heading
	icon_rect.texture = icon
	icon_rect.visible = icon != null
	divider.visible = show_divider


func _apply_ui_scale(scale_factor: float) -> void:
	icon_rect.custom_minimum_size = Vector2(
		roundf(_base_icon_size.x * scale_factor),
		roundf(_base_icon_size.y * scale_factor)
	)
