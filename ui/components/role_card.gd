class_name LumaRoleCard
extends Button

enum CardState {
	NORMAL,
	HOVER,
	SELECTED,
	DISABLED,
	LOCKED,
}

@export var role_name: String = "Role":
	set(value):
		role_name = value
		_update_content()
@export_multiline var description: String = "A dependable adventurer.":
	set(value):
		description = value
		_update_content()
@export var difficulty: String = "Balanced":
	set(value):
		difficulty = value
		_update_content()
@export var portrait: Texture2D:
	set(value):
		portrait = value
		_update_content()
@export var lock_icon: Texture2D:
	set(value):
		lock_icon = value
		_update_content()
@export var card_state: CardState = CardState.NORMAL:
	set(value):
		card_state = value
		_update_state()

@onready var portrait_rect: TextureRect = $Margin/Content/Portrait
@onready var role_name_label: Label = $Margin/Content/RoleName
@onready var description_label: Label = $Margin/Content/Description
@onready var difficulty_label: Label = $Margin/Content/Difficulty
@onready var lock_indicator: Control = $LockIndicator
@onready var lock_icon_rect: TextureRect = $LockIndicator/LockRow/LockIcon
@onready var selected_indicator: Label = $SelectedIndicator

const T := preload("res://ui/theme/theme_tokens.gd")

var _base_minimum_size: Vector2


func _ready() -> void:
	_base_minimum_size = custom_minimum_size
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	focus_mode = Control.FOCUS_ALL
	ThemeManager.ui_scale_changed.connect(_apply_ui_scale)
	_apply_ui_scale(ThemeManager.ui_scale)
	_update_content()
	_update_state()


func set_selected(value: bool) -> void:
	card_state = CardState.SELECTED if value else CardState.NORMAL


func set_locked(value: bool) -> void:
	card_state = CardState.LOCKED if value else CardState.NORMAL


func _update_content() -> void:
	if not is_node_ready():
		return
	role_name_label.text = role_name
	description_label.text = description
	difficulty_label.text = "Difficulty: %s" % difficulty
	portrait_rect.texture = portrait
	portrait_rect.visible = portrait != null
	lock_icon_rect.texture = lock_icon
	lock_icon_rect.visible = lock_icon != null
	lock_icon_rect.self_modulate = T.TEXT_ON_DARK


func _update_state() -> void:
	if not is_node_ready():
		return
	disabled = card_state in [CardState.DISABLED, CardState.LOCKED]
	lock_indicator.visible = card_state == CardState.LOCKED
	selected_indicator.visible = card_state == CardState.SELECTED
	if card_state == CardState.SELECTED:
		theme_type_variation = &"SelectedRoleCard"
	elif card_state == CardState.LOCKED:
		theme_type_variation = &"LockedRoleCard"
	elif card_state == CardState.DISABLED:
		theme_type_variation = &"DisabledRoleCard"
	elif card_state == CardState.HOVER:
		theme_type_variation = &"HoverRoleCard"
	else:
		theme_type_variation = &"RoleCard"
	var content_tint := T.DISABLED_TEXT if disabled else Color.WHITE
	$Margin.self_modulate = content_tint


func _on_mouse_entered() -> void:
	if card_state == CardState.NORMAL:
		card_state = CardState.HOVER


func _on_mouse_exited() -> void:
	if card_state == CardState.HOVER:
		card_state = CardState.NORMAL


func _apply_ui_scale(scale_factor: float) -> void:
	custom_minimum_size = Vector2(
		roundf(_base_minimum_size.x * scale_factor),
		roundf(_base_minimum_size.y * scale_factor)
	)
