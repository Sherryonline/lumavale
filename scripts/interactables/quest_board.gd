class_name QuestBoard
extends Area2D

const QUEST := preload("res://resources/quests/slime_cleanup.tres")
const QuestLogScript := preload("res://scripts/quests/quest_log.gd")

var _player_inside := false

@onready var panel: PanelContainer = $QuestPanel
@onready var text_label: Label = $QuestPanel/Margin/VBox/Text
@onready var action_button: Button = $QuestPanel/Margin/VBox/ActionButton


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	action_button.pressed.connect(_on_action_pressed)
	panel.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if _player_inside and event.is_action_pressed("interact"):
		panel.visible = not panel.visible
		GameState.set_input_locked(panel.visible)
		_refresh()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_player_inside = true
		EventBus.interaction_prompt_changed.emit("Press E: Quest Board")


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		_player_inside = false
		panel.visible = false
		GameState.set_input_locked(false)
		EventBus.interaction_prompt_changed.emit("")


func _on_action_pressed() -> void:
	var quest := QUEST as Resource
	match GameState.quests.get_state(quest.id):
		QuestLogScript.QuestState.AVAILABLE:
			GameState.quests.accept_quest(quest)
			SaveManager.save_game()
		QuestLogScript.QuestState.READY_TO_CLAIM:
			_claim_reward(quest)
	_refresh()


func _claim_reward(quest: Resource) -> void:
	for reward: Resource in quest.reward_items:
		if reward == null or reward.item == null:
			continue
		var leftover := GameState.inventory.add_item(reward.item, reward.quantity)
		if leftover > 0:
			push_warning("Inventory full; claim reward blocked until there is room.")
			return
	GameState.add_gold(quest.reward_gold)
	GameState.quests.claim(quest)
	SaveManager.save_game()


func _refresh() -> void:
	var quest := QUEST as Resource
	var state := GameState.quests.get_state(quest.id)
	var slime_kills := GameState.quests.get_progress(quest.id, &"slime")
	var gel_count := GameState.quests.get_progress(quest.id, &"slime_gel")
	text_label.text = "%s\n%s\nSlimes defeated: %d/3\nSlime Gels collected: %d/3\nReward: 50 Gold, Health Potion" % [
		quest.title,
		quest.description,
		slime_kills,
		gel_count,
	]
	match state:
		QuestLogScript.QuestState.AVAILABLE:
			action_button.text = "Accept Quest"
			action_button.disabled = false
		QuestLogScript.QuestState.ACTIVE:
			action_button.text = "In Progress"
			action_button.disabled = true
		QuestLogScript.QuestState.READY_TO_CLAIM:
			action_button.text = "Claim Reward"
			action_button.disabled = false
		_:
			action_button.text = "Completed"
			action_button.disabled = true
