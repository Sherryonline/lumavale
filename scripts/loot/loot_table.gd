class_name LootTable
extends Resource

@export var entries: Array[Dictionary] = []


func roll() -> Array[Dictionary]:
	var drops: Array[Dictionary] = []
	for entry: Dictionary in entries:
		var chance := float(entry.get("chance", 1.0))
		if randf() > chance:
			continue
		drops.append({
			"item": entry.get("item"),
			"quantity": maxi(1, int(entry.get("quantity", 1))),
		})
	return drops
