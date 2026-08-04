extends RefCounted

signal changed

const SLOT_COUNT := 24

var slots: Array[Dictionary] = []


func _init() -> void:
	for index: int in SLOT_COUNT:
		slots.append({"item_id": &"", "quantity": 0})


func add_item(item: Resource, quantity: int) -> int:
	if item == null or quantity <= 0:
		return quantity
	var remaining := quantity
	for slot: Dictionary in slots:
		if StringName(slot["item_id"]) != item.id:
			continue
		var space := maxi(0, item.max_stack - int(slot["quantity"]))
		var added := mini(space, remaining)
		slot["quantity"] = int(slot["quantity"]) + added
		remaining -= added
		if remaining <= 0:
			changed.emit()
			return 0
	for slot: Dictionary in slots:
		if not StringName(slot["item_id"]).is_empty():
			continue
		var added := mini(item.max_stack, remaining)
		slot["item_id"] = item.id
		slot["quantity"] = added
		remaining -= added
		if remaining <= 0:
			changed.emit()
			return 0
	if remaining != quantity:
		changed.emit()
	return remaining


func remove_item(item_id: StringName, quantity: int) -> bool:
	if quantity <= 0 or get_quantity(item_id) < quantity:
		return false
	var remaining := quantity
	for slot: Dictionary in slots:
		if StringName(slot["item_id"]) != item_id:
			continue
		var removed := mini(int(slot["quantity"]), remaining)
		slot["quantity"] = int(slot["quantity"]) - removed
		remaining -= removed
		if int(slot["quantity"]) <= 0:
			slot["item_id"] = &""
			slot["quantity"] = 0
		if remaining <= 0:
			changed.emit()
			return true
	return false


func get_quantity(item_id: StringName) -> int:
	var total := 0
	for slot: Dictionary in slots:
		if StringName(slot["item_id"]) == item_id:
			total += int(slot["quantity"])
	return total


func has_item(item_id: StringName, quantity: int) -> bool:
	return get_quantity(item_id) >= quantity


func to_save_data() -> Array:
	var data: Array = []
	for index: int in slots.size():
		var slot := slots[index]
		if StringName(slot["item_id"]).is_empty():
			continue
		data.append({
			"slot": index,
			"item_id": String(slot["item_id"]),
			"quantity": int(slot["quantity"]),
		})
	return data


func from_save_data(data: Variant) -> void:
	for slot: Dictionary in slots:
		slot["item_id"] = &""
		slot["quantity"] = 0
	if not (data is Array):
		return
	for entry_variant: Variant in data as Array:
		if not (entry_variant is Dictionary):
			continue
		var entry := entry_variant as Dictionary
		var slot_index := int(entry.get("slot", -1))
		if slot_index < 0 or slot_index >= slots.size():
			continue
		slots[slot_index] = {
			"item_id": StringName(str(entry.get("item_id", ""))),
			"quantity": maxi(0, int(entry.get("quantity", 0))),
		}
	changed.emit()
