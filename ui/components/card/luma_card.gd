class_name LumaCard
extends Button

enum CardState {
	NORMAL,
	HOVER,
	PRESSED,
	FOCUSED,
	SELECTED,
	DISABLED,
	LOCKED,
}

@export var title := "Card":
	set(value):
		title = value
		_refresh_content()
@export_multiline var description := "Reusable LumaVale card component.":
	set(value):
		description = value
		_refresh_content()
@export var metadata := "":
	set(value):
		metadata = value
		_refresh_content()
@export var state: CardState = CardState.NORMAL:
	set(value):
		state = value
		_refresh_state()

@onready var title_label: Label = %Title
@onready var description_label: Label = %Description
@onready var metadata_label: Label = %Metadata
@onready var selected_marker: Label = %SelectedMarker
@onready var locked_marker: Label = %LockedMarker


func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	_refresh_content()
	_refresh_state()


func _on_mouse_entered() -> void:
	if state == CardState.NORMAL:
		state = CardState.HOVER


func _on_mouse_exited() -> void:
	if state == CardState.HOVER:
		state = CardState.NORMAL


func _refresh_content() -> void:
	if not is_node_ready():
		return
	title_label.text = title
	description_label.text = description
	metadata_label.text = metadata
	metadata_label.visible = not metadata.is_empty()


func _refresh_state() -> void:
	if not is_node_ready():
		return
	disabled = state in [CardState.DISABLED, CardState.LOCKED]
	selected_marker.visible = state == CardState.SELECTED
	locked_marker.visible = state == CardState.LOCKED
	if state == CardState.SELECTED:
		theme_type_variation = &"SelectedContentCard"
	elif state == CardState.LOCKED:
		theme_type_variation = &"LockedContentCard"
	elif state == CardState.DISABLED:
		theme_type_variation = &"DisabledContentCard"
	elif state == CardState.HOVER:
		theme_type_variation = &"HoverContentCard"
	else:
		theme_type_variation = &"ContentCard"
	if state == CardState.LOCKED and tooltip_text.is_empty():
		tooltip_text = "Locked. Requirements are not met yet."
