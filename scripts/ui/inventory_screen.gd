extends Control

const ItemCatalog := preload("res://scripts/inventory/item_catalog.gd")

var _selected_item: StringName = &""

@onready var slot_grid: GridContainer = $Panel/Margin/VBox/Slots
@onready var detail_label: Label = $Panel/Margin/VBox/Detail
@onready var use_button: Button = $Panel/Margin/VBox/Actions/UseButton
@onready var close_button: Button = $Panel/Margin/VBox/Actions/CloseButton


func _ready() -> void:
	ThemeManager.apply_theme(self)
	use_button.pressed.connect(_on_use_pressed)
	close_button.pressed.connect(_close)
	EventBus.inventory_changed.connect(_refresh)
	_refresh()


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("pause"):
		_close()


func _refresh() -> void:
	for child: Node in slot_grid.get_children():
		child.queue_free()
	for index: int in GameState.inventory.slots.size():
		var slot := GameState.inventory.slots[index]
		var button := Button.new()
		button.custom_minimum_size = Vector2(84, 48)
		button.theme_type_variation = &"ItemSlot"
		var item_id := StringName(slot["item_id"])
		var quantity := int(slot["quantity"])
		button.text = "%s\nx%d" % [String(item_id), quantity] if not item_id.is_empty() else "Empty"
		button.disabled = item_id.is_empty()
		button.pressed.connect(_select_item.bind(item_id))
		slot_grid.add_child(button)
	_update_detail()


func _select_item(item_id: StringName) -> void:
	_selected_item = item_id
	_update_detail()


func _update_detail() -> void:
	var item := ItemCatalog.get_item(_selected_item) if not _selected_item.is_empty() else null
	if item == null:
		detail_label.text = "Select an item."
		use_button.disabled = true
		return
	detail_label.text = "%s\n%s\nType: %s\nQuantity: %d" % [
		item.display_name,
		item.description,
		["Material", "Consumable", "Equipment"][int(item.item_type)],
		GameState.inventory.get_quantity(item.id),
	]
	use_button.disabled = int(item.item_type) != 1


func _on_use_pressed() -> void:
	var item := ItemCatalog.get_item(_selected_item)
	if item == null or int(item.item_type) != 1 or GameState.player == null:
		return
	if item.heal_amount > 0 and GameState.player.heal(item.heal_amount):
		GameState.inventory.remove_item(item.id, 1)
		SaveManager.save_game()


func _close() -> void:
	visible = false
	GameState.set_input_locked(false)
