class_name ItemCatalog
extends RefCounted

const SLIME_GEL := preload("res://resources/items/slime_gel.tres")
const HERB := preload("res://resources/items/herb.tres")
const WOOD := preload("res://resources/items/wood.tres")
const HEALTH_POTION := preload("res://resources/items/health_potion.tres")
const BASIC_SWORD := preload("res://resources/items/basic_sword.tres")


static func get_item(item_id: StringName) -> Resource:
	match item_id:
		&"slime_gel":
			return SLIME_GEL as Resource
		&"herb":
			return HERB as Resource
		&"wood":
			return WOOD as Resource
		&"health_potion":
			return HEALTH_POTION as Resource
		&"basic_sword":
			return BASIC_SWORD as Resource
		_:
			push_warning("Unknown item id: %s" % item_id)
			return null
