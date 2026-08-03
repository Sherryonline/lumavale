class_name LumaNotification
extends PanelContainer

enum Variant {
	INFO,
	SUCCESS,
	WARNING,
	ERROR,
}

@export var variant: Variant = Variant.INFO:
	set(value):
		variant = value
		_refresh()
@export var title := "Notification":
	set(value):
		title = value
		_refresh()
@export_multiline var message := "Reusable message surface.":
	set(value):
		message = value
		_refresh()

@onready var title_label: Label = %Title
@onready var message_label: Label = %Message
@onready var marker_label: Label = %Marker


func _ready() -> void:
	_refresh()


func _refresh() -> void:
	if not is_node_ready():
		return
	title_label.text = title
	message_label.text = message
	match variant:
		Variant.SUCCESS:
			marker_label.text = "OK"
			theme_type_variation = &"SuccessNotification"
		Variant.WARNING:
			marker_label.text = "!"
			theme_type_variation = &"WarningNotification"
		Variant.ERROR:
			marker_label.text = "ERR"
			theme_type_variation = &"ErrorNotification"
		_:
			marker_label.text = "i"
			theme_type_variation = &"Notification"
