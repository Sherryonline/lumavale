extends Node

const InventoryModel := preload("res://scripts/inventory/inventory_model.gd")
const QuestLog := preload("res://scripts/quests/quest_log.gd")
const CharacterCatalog := preload("res://scripts/character/character_catalog.gd")

var current_zone: StringName = &"town"
var current_spawn: StringName = &"player_spawn"
var gold: int = 0
var inventory: InventoryModel = InventoryModel.new()
var quests: QuestLog = QuestLog.new()
var player: Node
var input_locked: bool = false


func _ready() -> void:
	inventory.changed.connect(_on_inventory_changed)
	quests.changed.connect(_on_quest_changed)


func start_new_character(character_data: Dictionary) -> void:
	GameSession.set_character_data(character_data)
	current_zone = &"town"
	current_spawn = &"player_spawn"
	gold = 0
	inventory = InventoryModel.new()
	inventory.changed.connect(_on_inventory_changed)
	quests = QuestLog.new()
	quests.changed.connect(_on_quest_changed)
	var potion := load("res://resources/items/health_potion.tres") as Resource
	if potion != null:
		inventory.add_item(potion, 2)
	EventBus.gold_changed.emit(gold)


func ensure_runtime_defaults() -> void:
	if GameSession.get_character_data().is_empty():
		GameSession.set_character_data(CharacterCatalog.default_character_data())


func set_zone(zone_id: StringName, spawn_id: StringName) -> void:
	current_zone = zone_id
	current_spawn = spawn_id
	EventBus.zone_changed.emit(current_zone)


func add_gold(amount: int) -> void:
	gold = maxi(0, gold + amount)
	EventBus.gold_changed.emit(gold)


func set_input_locked(locked: bool) -> void:
	if input_locked == locked:
		return
	input_locked = locked
	EventBus.gameplay_input_locked_changed.emit(input_locked)


func to_save_data() -> Dictionary:
	return {
		"save_version": 1,
		"character": GameSession.get_character_data(),
		"player": {
			"gold": gold,
			"current_hp": player.get_node("Health").current_health if player != null and player.has_node("Health") else 0,
			"max_hp": player.get_node("Health").max_health if player != null and player.has_node("Health") else 0,
		},
		"inventory": inventory.to_save_data(),
		"quests": quests.to_save_data(),
		"world": {
			"current_zone": String(current_zone),
			"spawn_point": String(current_spawn),
		},
	}


func apply_save_data(data: Dictionary) -> void:
	if int(data.get("save_version", 0)) != 1:
		push_warning("Unsupported save version. Starting with defaults.")
		return
	var character: Variant = data.get("character", {})
	if character is Dictionary:
		GameSession.set_character_data(character as Dictionary)
	var world: Dictionary = data.get("world", {}) as Dictionary
	current_zone = StringName(str(world.get("current_zone", "town")))
	current_spawn = StringName(str(world.get("spawn_point", "player_spawn")))
	var player_data := data.get("player", {}) as Dictionary
	gold = maxi(0, int(player_data.get("gold", 0)))
	inventory.from_save_data(data.get("inventory", []))
	quests.from_save_data(data.get("quests", {}))
	EventBus.gold_changed.emit(gold)
	EventBus.inventory_changed.emit()
	EventBus.zone_changed.emit(current_zone)


func _on_inventory_changed() -> void:
	EventBus.inventory_changed.emit()


func _on_quest_changed(quest_id: StringName) -> void:
	EventBus.quest_progress_changed.emit(quest_id)
