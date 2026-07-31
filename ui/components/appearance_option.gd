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


func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
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
	selected_indicator.visible = selected and not locked
	locked_indicator.visible = locked
	if locked:
		theme_type_variation = &"LockedAppearanceOption"
	elif selected:
		theme_type_variation = &"SelectedAppearanceOption"
	else:
		theme_type_variation = &"AppearanceOption"
