class_name CharacterCatalog
extends RefCounted

const BODY_A := preload("res://resources/appearance/body_a.tres")
const BODY_B := preload("res://resources/appearance/body_b.tres")
const HAIR_SHORT := preload("res://resources/appearance/hair_short.tres")
const HAIR_WAVE := preload("res://resources/appearance/hair_wave.tres")
const HAIR_PONY := preload("res://resources/appearance/hair_pony.tres")
const HAIR_CROP := preload("res://resources/appearance/hair_crop.tres")
const EYES_HAZEL := preload("res://resources/appearance/eyes_hazel.tres")
const EYES_BLUE := preload("res://resources/appearance/eyes_blue.tres")
const TOP_FOREST := preload("res://resources/appearance/top_forest.tres")
const TOP_BLUE := preload("res://resources/appearance/top_blue.tres")
const TOP_EARTH := preload("res://resources/appearance/top_earth.tres")
const TOP_VIOLET := preload("res://resources/appearance/top_violet.tres")
const BOTTOM_DARK := preload("res://resources/appearance/bottom_dark.tres")
const BOTTOM_BROWN := preload("res://resources/appearance/bottom_brown.tres")
const SHOES_BOOTS := preload("res://resources/appearance/shoes_boots.tres")
const SHOES_LIGHT := preload("res://resources/appearance/shoes_light.tres")
const ACCESSORY_NONE := preload("res://resources/appearance/accessory_none.tres")
const ACCESSORY_LEAF := preload("res://resources/appearance/accessory_leaf.tres")
const ACCESSORY_BAG := preload("res://resources/appearance/accessory_bag.tres")
const WEAPON_SWORD := preload("res://resources/appearance/weapon_sword.tres")
const WEAPON_BOW := preload("res://resources/appearance/weapon_bow.tres")
const WEAPON_FLASK := preload("res://resources/appearance/weapon_flask.tres")
const WARRIOR := preload("res://resources/roles/warrior.tres")


static func resolve_appearance(item_id: StringName) -> AppearanceItem:
	match item_id:
		&"body_a":
			return BODY_A as AppearanceItem
		&"body_b":
			return BODY_B as AppearanceItem
		&"hair_short":
			return HAIR_SHORT as AppearanceItem
		&"hair_wave":
			return HAIR_WAVE as AppearanceItem
		&"hair_pony":
			return HAIR_PONY as AppearanceItem
		&"hair_crop":
			return HAIR_CROP as AppearanceItem
		&"eyes_hazel":
			return EYES_HAZEL as AppearanceItem
		&"eyes_blue":
			return EYES_BLUE as AppearanceItem
		&"top_forest":
			return TOP_FOREST as AppearanceItem
		&"top_blue":
			return TOP_BLUE as AppearanceItem
		&"top_earth":
			return TOP_EARTH as AppearanceItem
		&"top_violet":
			return TOP_VIOLET as AppearanceItem
		&"bottom_dark":
			return BOTTOM_DARK as AppearanceItem
		&"bottom_brown":
			return BOTTOM_BROWN as AppearanceItem
		&"shoes_boots":
			return SHOES_BOOTS as AppearanceItem
		&"shoes_light":
			return SHOES_LIGHT as AppearanceItem
		&"accessory_none":
			return ACCESSORY_NONE as AppearanceItem
		&"accessory_leaf":
			return ACCESSORY_LEAF as AppearanceItem
		&"accessory_bag":
			return ACCESSORY_BAG as AppearanceItem
		&"weapon_sword":
			return WEAPON_SWORD as AppearanceItem
		&"weapon_bow":
			return WEAPON_BOW as AppearanceItem
		&"weapon_flask":
			return WEAPON_FLASK as AppearanceItem
		_:
			return null


static func resolve_skin_color(color_id: StringName) -> Color:
	match color_id:
		&"skin_warm":
			return Color("e9b98f")
		&"skin_tan":
			return Color("c98d68")
		&"skin_deep":
			return Color("94634f")
		_:
			return Color("fff2e5")


static func resolve_hair_color(color_id: StringName) -> Color:
	match color_id:
		&"hair_ash":
			return Color("c4c0bc")
		&"hair_gold":
			return Color("e6ba72")
		&"hair_violet":
			return Color("b7a2ca")
		_:
			return Color.WHITE


static func default_character_data() -> Dictionary:
	var warrior := WARRIOR as RoleData
	return {
		"name": "Adventurer",
		"role": String(warrior.id),
		"body": "body_a",
		"skin_color": "skin_light",
		"hair": "hair_short",
		"hair_color": "hair_chestnut",
		"eyes": "eyes_hazel",
		"top": "top_forest",
		"bottom": "bottom_dark",
		"shoes": "shoes_boots",
		"accessory": "accessory_none",
		"weapon": String(warrior.starting_weapon.id),
		"stats": {
			"hp": warrior.hp,
			"attack": warrior.attack,
			"defense": warrior.defense,
			"speed": warrior.speed,
			"energy": warrior.energy,
		},
	}
