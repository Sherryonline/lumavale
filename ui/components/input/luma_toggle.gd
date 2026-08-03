class_name LumaToggle
extends Button

enum ToggleKind {
	CHECKBOX,
	RADIO,
	TOGGLE,
}

@export var kind: ToggleKind = ToggleKind.CHECKBOX:
	set(value):
		kind = value
		_refresh()
@export var label := "Option":
	set(value):
		label = value
		_refresh()
@export var locked := false:
	set(value):
		locked = value
		_refresh()


func _ready() -> void:
	toggle_mode = true
	focus_mode = Control.FOCUS_ALL
	toggled.connect(_on_toggled)
	_refresh()


func _on_toggled(_value: bool) -> void:
	_refresh()


func _refresh() -> void:
	if not is_node_ready():
		return
	disabled = locked
	var marker := "[x]" if button_pressed else "[ ]"
	if kind == ToggleKind.RADIO:
		marker = "(o)" if button_pressed else "( )"
	elif kind == ToggleKind.TOGGLE:
		marker = "ON" if button_pressed else "OFF"
	text = "%s  %s" % [marker, label]
	if locked:
		text = "LOCK  %s" % label
		theme_type_variation = &"LockedActionButton"
	elif button_pressed:
		theme_type_variation = &"SelectedActionButton"
	else:
		theme_type_variation = &"GhostButton"
