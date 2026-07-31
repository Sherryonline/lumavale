class_name LumaModalBackdrop
extends ColorRect

const T := preload("res://ui/theme/theme_tokens.gd")


func _ready() -> void:
	color = T.MODAL_BACKDROP
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
