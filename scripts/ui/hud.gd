extends Control

const QUEST := preload("res://resources/quests/slime_cleanup.tres")

@onready var hp_label: Label = $Margin/VBox/TopRow/HPLabel
@onready var gold_label: Label = $Margin/VBox/TopRow/GoldLabel
@onready var quest_label: Label = $Margin/VBox/QuestTracker
@onready var prompt_label: Label = $Margin/VBox/Prompt


func _ready() -> void:
	ThemeManager.apply_theme(self)
	EventBus.player_health_changed.connect(_on_health_changed)
	EventBus.gold_changed.connect(_on_gold_changed)
	EventBus.quest_progress_changed.connect(_on_quest_changed)
	EventBus.interaction_prompt_changed.connect(_on_prompt_changed)
	EventBus.inventory_changed.connect(_refresh_quest)
	_on_gold_changed(GameState.gold)
	_refresh_quest()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		var inventory := get_parent().get_node_or_null("InventoryScreen") as Control
		if inventory != null:
			inventory.visible = not inventory.visible
			GameState.set_input_locked(inventory.visible)


func _on_health_changed(current_hp: int, max_hp: int) -> void:
	hp_label.text = "HP: %d/%d" % [current_hp, max_hp]


func _on_gold_changed(current_gold: int) -> void:
	gold_label.text = "Gold: %d" % current_gold


func _on_quest_changed(_quest_id: StringName) -> void:
	_refresh_quest()


func _on_prompt_changed(message: String) -> void:
	prompt_label.text = message
	prompt_label.visible = not message.is_empty()


func _refresh_quest() -> void:
	var quest := QUEST as Resource
	var state := GameState.quests.get_state(quest.id)
	if state == 0:
		quest_label.text = "Quest: Visit the Town Quest Board"
		return
	quest_label.text = "%s\nSlimes defeated: %d/3\nSlime Gels collected: %d/3" % [
		quest.title,
		GameState.quests.get_progress(quest.id, &"slime"),
		GameState.quests.get_progress(quest.id, &"slime_gel"),
	]
