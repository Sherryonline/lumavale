class_name LumaItemSlot
extends Button

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY,
}

@export var rarity: Rarity = Rarity.COMMON:
	set(value):
		rarity = value
		_update_state()
@export var selected: bool = false:
	set(value):
		selected = value
		_update_state()
@export var equipped: bool = false:
	set(value):
		equipped = value
		_update_markers()
@export var locked: bool = false:
	set(value):
		locked = value
		_update_state()
@export var quantity: int = 0:
	set(value):
		quantity = maxi(value, 0)
		_update_markers()
@export var item_icon: Texture2D:
	set(value):
		item_icon = value
		_update_markers()

@onready var icon_rect: TextureRect = $Icon
@onready var rarity_marker: ColorRect = $RarityMarker
@onready var rarity_ornament: Label = $RarityOrnament
@onready var quantity_label: Label = $Quantity
@onready var equipped_label: Label = $Equipped
@onready var selected_label: Label = $Selected
@onready var locked_label: Label = $Locked
@onready var lock_icon_rect: TextureRect = $LockIcon

const T := preload("res://ui/theme/theme_tokens.gd")

var _base_minimum_size: Vector2


func _ready() -> void:
	_base_minimum_size = custom_minimum_size
	focus_mode = Control.FOCUS_ALL
	ThemeManager.ui_scale_changed.connect(_apply_ui_scale)
	_apply_ui_scale(ThemeManager.ui_scale)
	_update_state()
	_update_markers()


func _update_state() -> void:
	if not is_node_ready():
		return
	disabled = locked
	if locked and tooltip_text.is_empty():
		tooltip_text = "This item is locked and unavailable."
	if locked:
		theme_type_variation = &"LockedItemSlot"
	elif selected:
		theme_type_variation = &"SelectedItemSlot"
	else:
		theme_type_variation = &"ItemSlot"
	rarity_marker.color = _rarity_color()
	rarity_ornament.text = _rarity_marker_text()
	selected_label.visible = selected and not locked
	locked_label.visible = locked
	lock_icon_rect.visible = locked


func _update_markers() -> void:
	if not is_node_ready():
		return
	quantity_label.text = str(quantity) if quantity > 1 else ""
	equipped_label.visible = equipped
	icon_rect.texture = item_icon
	icon_rect.visible = item_icon != null


func _rarity_color() -> Color:
	match rarity:
		Rarity.UNCOMMON:
			return T.SUCCESS
		Rarity.RARE:
			return T.PRIMARY
		Rarity.EPIC:
			return T.EPIC
		Rarity.LEGENDARY:
			return T.ACCENT_GOLD
		_:
			return T.BORDER_DEFAULT


func _rarity_marker_text() -> String:
	match rarity:
		Rarity.UNCOMMON:
			return "II"
		Rarity.RARE:
			return "III"
		Rarity.EPIC:
			return "IV"
		Rarity.LEGENDARY:
			return "V"
		_:
			return "I"


func _apply_ui_scale(scale_factor: float) -> void:
	var base_size := Vector2(
		maxf(_base_minimum_size.x, 48.0),
		maxf(_base_minimum_size.y, 48.0)
	)
	custom_minimum_size = Vector2(
		roundf(base_size.x * scale_factor),
		roundf(base_size.y * scale_factor)
	)
