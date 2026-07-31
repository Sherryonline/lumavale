class_name LumaFantasyPanel
extends PanelContainer

@export var title: String = "":
	set(value):
		title = value
		_update_title()

@onready var title_label: Label = $Content/Title


func _ready() -> void:
	_update_title()


func _update_title() -> void:
	if not is_node_ready():
		return
	title_label.text = title
	title_label.visible = not title.is_empty()
