class_name LumaPanel
extends PanelContainer

enum PanelVariant {
	FANTASY,
	INVENTORY,
	MODAL,
	SCROLL,
}

@export var variant: PanelVariant = PanelVariant.FANTASY:
	set(value):
		variant = value
		_refresh()
@export var title := "":
	set(value):
		title = value
		_refresh()
@export var selected := false:
	set(value):
		selected = value
		_refresh()
@export var locked := false:
	set(value):
		locked = value
		_refresh()

@onready var title_label: Label = %Title
@onready var body: VBoxContainer = %Body
@onready var lock_label: Label = %LockLabel


func _ready() -> void:
	_refresh()


func _refresh() -> void:
	if not is_node_ready():
		return
	title_label.text = title
	title_label.visible = not title.is_empty()
	lock_label.visible = locked
	if locked:
		theme_type_variation = &"LockedPanel"
	elif selected:
		theme_type_variation = &"SelectedPanel"
	else:
		match variant:
			PanelVariant.INVENTORY:
				theme_type_variation = &"InventoryPanel"
			PanelVariant.MODAL:
				theme_type_variation = &"ModalPanel"
			PanelVariant.SCROLL:
				theme_type_variation = &"ScrollPanel"
			_:
				theme_type_variation = &"FantasyPanel"
