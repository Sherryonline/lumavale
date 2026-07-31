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


func _ready() -> void:
	_update_content()


func _update_content() -> void:
	if not is_node_ready():
		return
	heading_label.text = heading
	icon_rect.texture = icon
	icon_rect.visible = icon != null
	divider.visible = show_divider
