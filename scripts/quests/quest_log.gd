extends RefCounted

signal changed(quest_id: StringName)

enum QuestState {
	AVAILABLE,
	ACTIVE,
	READY_TO_CLAIM,
	COMPLETED,
}

const SLIME_CLEANUP := preload("res://resources/quests/slime_cleanup.tres")

var states: Dictionary = {}


func get_state(quest_id: StringName) -> QuestState:
	return states.get(quest_id, {"state": QuestState.AVAILABLE})["state"]


func accept_quest(quest: Resource) -> bool:
	if quest == null or get_state(quest.id) != QuestState.AVAILABLE:
		return false
	states[quest.id] = {
		"state": QuestState.ACTIVE,
		"progress": {},
		"reward_claimed": false,
	}
	changed.emit(quest.id)
	return true


func record_monster_defeated(monster_id: StringName) -> void:
	_record_progress(0, monster_id, 1)


func record_item_quantity(item_id: StringName, quantity: int) -> void:
	_set_progress(1, item_id, quantity)


func can_claim(quest: Resource) -> bool:
	return quest != null and get_state(quest.id) == QuestState.READY_TO_CLAIM


func claim(quest: Resource) -> bool:
	if not can_claim(quest):
		return false
	var state := states[quest.id] as Dictionary
	state["state"] = QuestState.COMPLETED
	state["reward_claimed"] = true
	changed.emit(quest.id)
	EventBus.quest_completed.emit(quest.id)
	return true


func get_progress(quest_id: StringName, target_id: StringName) -> int:
	var state := states.get(quest_id, {}) as Dictionary
	var progress := state.get("progress", {}) as Dictionary
	return int(progress.get(target_id, 0))


func get_active_quest() -> Resource:
	return SLIME_CLEANUP as Resource


func to_save_data() -> Dictionary:
	return states.duplicate(true)


func from_save_data(data: Variant) -> void:
	states = data.duplicate(true) if data is Dictionary else {}
	for quest_id: Variant in states.keys():
		changed.emit(StringName(str(quest_id)))


func _record_progress(type: int, target_id: StringName, amount: int) -> void:
	var quest := SLIME_CLEANUP as Resource
	if get_state(quest.id) != QuestState.ACTIVE:
		return
	var state := states[quest.id] as Dictionary
	var progress := state["progress"] as Dictionary
	for objective: Resource in quest.objectives:
		if objective.objective_type == type and objective.target_id == target_id:
			progress[target_id] = mini(objective.required_quantity, int(progress.get(target_id, 0)) + amount)
	state["progress"] = progress
	_update_ready_state(quest)
	changed.emit(quest.id)


func _set_progress(type: int, target_id: StringName, quantity: int) -> void:
	var quest := SLIME_CLEANUP as Resource
	if get_state(quest.id) != QuestState.ACTIVE:
		return
	var state := states[quest.id] as Dictionary
	var progress := state["progress"] as Dictionary
	for objective: Resource in quest.objectives:
		if objective.objective_type == type and objective.target_id == target_id:
			progress[target_id] = mini(objective.required_quantity, quantity)
	state["progress"] = progress
	_update_ready_state(quest)
	changed.emit(quest.id)


func _update_ready_state(quest: Resource) -> void:
	var state := states[quest.id] as Dictionary
	var progress := state["progress"] as Dictionary
	for objective: Resource in quest.objectives:
		if int(progress.get(objective.target_id, 0)) < objective.required_quantity:
			return
	state["state"] = QuestState.READY_TO_CLAIM
