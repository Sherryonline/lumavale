class_name ResourceNode
extends Area2D

@export var item: Resource
@export var quantity: int = 1

var _player_inside := false
var _collected := false

@onready var label: Label = $Label


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	label.text = item.display_name if item != null else "Resource"


func _unhandled_input(event: InputEvent) -> void:
	if _player_inside and not _collected and event.is_action_pressed("interact") and item != null:
		var leftover := GameState.inventory.add_item(item, quantity)
		if leftover == 0:
			_collected = true
			visible = false
			EventBus.item_picked_up.emit(item.id, quantity)
			SaveManager.save_game()


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not _collected:
		_player_inside = true
		EventBus.interaction_prompt_changed.emit("Press E: Gather %s" % label.text)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		_player_inside = false
		EventBus.interaction_prompt_changed.emit("")
