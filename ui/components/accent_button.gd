class_name LumaAccentButton
extends LumaThemedButton

const T := preload("res://ui/theme/theme_tokens.gd")

@onready var importance_marker: ColorRect = $ImportanceMarker


func _ready() -> void:
	super()
	importance_marker.color = T.TEXT_ON_DARK
