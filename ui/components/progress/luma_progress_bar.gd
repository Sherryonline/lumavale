class_name LumaProgressBar
extends ProgressBar

enum Variant {
	HP,
	ENERGY,
	EXP,
	NEUTRAL,
}

@export var variant: Variant = Variant.NEUTRAL:
	set(value):
		variant = value
		_refresh_variant()
@export var label_text := "Progress":
	set(value):
		label_text = value
		_refresh_labels()

@onready var name_label: Label = %Name
@onready var value_label: Label = %Value


func _ready() -> void:
	show_percentage = false
	_refresh_variant()
	_refresh_labels()


func _refresh_variant() -> void:
	if not is_node_ready():
		return
	match variant:
		Variant.HP:
			theme_type_variation = &"HPBar"
		Variant.ENERGY:
			theme_type_variation = &"EnergyBar"
		Variant.EXP:
			theme_type_variation = &"EXPBar"
		_:
			theme_type_variation = &"ProgressBar"


func _refresh_labels() -> void:
	if not is_node_ready():
		return
	name_label.text = label_text
	value_label.text = "%d / %d" % [roundi(value), roundi(max_value)]
