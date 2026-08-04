class_name WorldItem
extends Area2D

@export var item: Resource
@export var quantity: int = 1
@export var auto_pickup := true

var _picked := false

@onready var label: Label = $Label


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_refresh()


func setup(new_item: Resource, new_quantity: int) -> void:
	item = new_item
	quantity = maxi(1, new_quantity)
	_refresh()


func _refresh() -> void:
	if not is_node_ready():
		return
	label.text = item.display_name if item != null else "Item"


func _on_body_entered(body: Node2D) -> void:
	if _picked or not auto_pickup or not (body is Player) or item == null:
		return
	var leftover := GameState.inventory.add_item(item, quantity)
	if leftover > 0:
		quantity = leftover
		return
	_picked = true
	EventBus.item_picked_up.emit(item.id, quantity)
	GameState.quests.record_item_quantity(item.id, GameState.inventory.get_quantity(item.id))
	SaveManager.save_game()
	queue_free()
