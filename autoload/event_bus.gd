extends Node

signal player_health_changed(current_hp: int, max_hp: int)
signal player_died
signal item_picked_up(item_id: StringName, quantity: int)
signal monster_defeated(monster_id: StringName)
signal inventory_changed
signal quest_progress_changed(quest_id: StringName)
signal quest_completed(quest_id: StringName)
signal gold_changed(current_gold: int)
signal zone_changed(zone_id: StringName)
signal interaction_prompt_changed(message: String)
signal gameplay_input_locked_changed(locked: bool)
