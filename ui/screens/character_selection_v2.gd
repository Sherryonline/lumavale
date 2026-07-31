class_name CharacterSelectionV2
extends Control

const T := preload("res://ui/theme/theme_tokens.gd")
const ROLE_CARD_SCENE := preload("res://ui/components/role_card.tscn")
const APPEARANCE_OPTION_SCENE := preload("res://ui/components/appearance_option.tscn")
const SECTION_HEADER_SCENE := preload("res://ui/components/section_header.tscn")

const WARRIOR := preload("res://resources/roles/warrior.tres")
const RANGER := preload("res://resources/roles/ranger.tres")
const ALCHEMIST := preload("res://resources/roles/alchemist.tres")

const BODY_A := preload("res://resources/appearance/body_a.tres")
const BODY_B := preload("res://resources/appearance/body_b.tres")
const HAIR_SHORT := preload("res://resources/appearance/hair_short.tres")
const HAIR_WAVE := preload("res://resources/appearance/hair_wave.tres")
const TOP_FOREST := preload("res://resources/appearance/top_forest.tres")
const TOP_BLUE := preload("res://resources/appearance/top_blue.tres")
const BOTTOM_DARK := preload("res://resources/appearance/bottom_dark.tres")
const BOTTOM_BROWN := preload("res://resources/appearance/bottom_brown.tres")
const SHOES_BOOTS := preload("res://resources/appearance/shoes_boots.tres")
const SHOES_LIGHT := preload("res://resources/appearance/shoes_light.tres")
const ACCESSORY_LEAF := preload("res://resources/appearance/accessory_leaf.tres")
const ACCESSORY_BAG := preload("res://resources/appearance/accessory_bag.tres")

const SKIN_ICON_PATH := "res://assets/ui/icons/skin_tone.svg"
const HAIR_COLOR_ICON_PATH := "res://assets/ui/icons/hair_color.svg"
const EYES_ICON_PATH := "res://assets/ui/icons/eyes.svg"

var role_resources: Array[RoleData] = [
	WARRIOR as RoleData,
	RANGER as RoleData,
	ALCHEMIST as RoleData,
]

@onready var background_overlay: ColorRect = $BackgroundOverlay
@onready var preview_tint: ColorRect = %PreviewTint
@onready var floor_shadow: Polygon2D = %FloorShadow
@onready var role_list: VBoxContainer = %RoleList
@onready var preview_character: ModularCharacter = %PreviewCharacter
@onready var character_name: LineEdit = %CharacterName
@onready var appearance_list: VBoxContainer = %AppearanceList
@onready var stats_container: GridContainer = %StatsContainer
@onready var role_description: Label = %RoleDescription
@onready var selected_role_label: Label = %SelectedRole
@onready var role_strengths: Label = %RoleStrengths
@onready var confirm_button: Button = %ConfirmButton
@onready var transition_layer: ColorRect = $TransitionLayer


func _ready() -> void:
	ThemeManager.apply_theme(self)
	_apply_presentation_tokens()
	_populate_roles()
	_populate_appearance_options()
	_initialize_character_preview()
	_show_role_details(role_resources[0])
	character_name.grab_focus.call_deferred()


func _apply_presentation_tokens() -> void:
	background_overlay.color = Color(T.BACKGROUND_DEEP, 0.12)
	preview_tint.color = Color(T.SURFACE_PRIMARY, 0.16)
	floor_shadow.color = T.SHADOW
	transition_layer.color = T.BACKGROUND_DEEP
	confirm_button.disabled = true


func _populate_roles() -> void:
	for child: Node in role_list.get_children():
		child.queue_free()

	for index: int in role_resources.size():
		var role_data := role_resources[index]
		var card := ROLE_CARD_SCENE.instantiate() as LumaRoleCard
		card.custom_minimum_size = Vector2(0, 238)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.role_name = role_data.display_name
		card.description = _card_description_for(role_data.id)
		card.difficulty = role_data.difficulty
		card.portrait = role_data.portrait if role_data.portrait != null else role_data.icon
		if not role_data.available:
			card.card_state = LumaRoleCard.CardState.LOCKED
		elif index == 0:
			card.card_state = LumaRoleCard.CardState.SELECTED
		else:
			card.card_state = LumaRoleCard.CardState.NORMAL
		card.tooltip_text = role_data.description
		role_list.add_child(card)


func _populate_appearance_options() -> void:
	for child: Node in appearance_list.get_children():
		child.queue_free()

	var categories: Array[Dictionary] = [
		_category(
			"Body",
			"Choose the character silhouette.",
			[_item_option(BODY_A, "body_a"), _item_option(BODY_B, "body_b")]
		),
		_category(
			"Skin",
			"Select a warm foundation tone.",
			[
				_visual_option("Light", SKIN_ICON_PATH),
				_visual_option("Warm", SKIN_ICON_PATH),
			]
		),
		_category(
			"Hair",
			"Pick a hairstyle for the preview.",
			[
				_item_option(HAIR_SHORT, "hair_short"),
				_item_option(HAIR_WAVE, "hair_wave"),
			]
		),
		_category(
			"Hair Color",
			"Preview the intended hair palette.",
			[
				_visual_option("Chestnut", HAIR_COLOR_ICON_PATH),
				_visual_option("Ash", HAIR_COLOR_ICON_PATH),
			]
		),
		_category(
			"Eyes",
			"Choose an expressive eye style.",
			[
				_visual_option("Hazel", EYES_ICON_PATH),
				_visual_option("Blue", EYES_ICON_PATH),
			]
		),
		_category(
			"Top",
			"Select the adventurer's main outfit.",
			[
				_item_option(TOP_FOREST, "top_forest"),
				_item_option(TOP_BLUE, "top_blue"),
			]
		),
		_category(
			"Bottom",
			"Coordinate a practical lower outfit.",
			[
				_item_option(BOTTOM_DARK, "bottom_dark"),
				_item_option(BOTTOM_BROWN, "bottom_brown"),
			]
		),
		_category(
			"Shoes",
			"Choose footwear for the journey.",
			[
				_item_option(SHOES_BOOTS, "shoes_boots"),
				_item_option(SHOES_LIGHT, "shoes_light"),
			]
		),
		_category(
			"Accessory",
			"Add one subtle finishing detail.",
			[
				_item_option(ACCESSORY_LEAF, "accessory_leaf"),
				_item_option(ACCESSORY_BAG, "accessory_bag"),
			]
		),
	]

	for category_data: Dictionary in categories:
		var header := SECTION_HEADER_SCENE.instantiate() as LumaSectionHeader
		header.heading = category_data["title"]
		header.show_divider = true
		appearance_list.add_child(header)

		var description := Label.new()
		description.theme_type_variation = &"CaptionLabel"
		description.text = category_data["description"]
		description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		appearance_list.add_child(description)

		var options := HFlowContainer.new()
		options.add_theme_constant_override(&"h_separation", T.SPACE_SM)
		options.add_theme_constant_override(&"v_separation", T.SPACE_SM)
		appearance_list.add_child(options)

		var option_entries: Array = category_data["options"]
		for option_index: int in option_entries.size():
			var option_data: Dictionary = option_entries[option_index]
			var option := APPEARANCE_OPTION_SCENE.instantiate() as LumaAppearanceOption
			option.custom_minimum_size = Vector2(68, 68)
			option.option_name = option_data["name"]
			option.option_icon = option_data["icon"]
			option.tooltip = option_data["tooltip"]
			option.selected = option_index == 0
			option.locked = option_data["locked"]
			options.add_child(option)


func _initialize_character_preview() -> void:
	preview_character.set_body(BODY_A as AppearanceItem)
	preview_character.set_hair(HAIR_SHORT as AppearanceItem)
	preview_character.set_top(TOP_FOREST as AppearanceItem)
	preview_character.set_bottom(BOTTOM_DARK as AppearanceItem)
	preview_character.set_shoes(SHOES_BOOTS as AppearanceItem)
	preview_character.set_accessory(ACCESSORY_LEAF as AppearanceItem)
	preview_character.set_weapon(WARRIOR.starting_weapon)
	preview_character.play_animation(&"idle_down")


func _show_role_details(role_data: RoleData) -> void:
	selected_role_label.text = role_data.display_name
	role_description.text = role_data.description
	role_strengths.text = "Strengths: %s" % _strengths_for(role_data.id)
	_fill_stats(role_data)


func _fill_stats(role_data: RoleData) -> void:
	for child: Node in stats_container.get_children():
		child.queue_free()
	var values := {
		"HP": role_data.hp,
		"Attack": role_data.attack,
		"Defense": role_data.defense,
		"Speed": role_data.speed,
		"Energy": role_data.energy,
	}
	for stat_name: String in values:
		var name_label := Label.new()
		name_label.theme_type_variation = &"SecondaryLabel"
		name_label.text = stat_name
		stats_container.add_child(name_label)
		var value_label := Label.new()
		value_label.text = str(values[stat_name])
		value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		stats_container.add_child(value_label)


func _strengths_for(role_id: StringName) -> String:
	match role_id:
		&"ranger":
			return "Precision, mobility, ranged pressure"
		&"alchemist":
			return "Energy, support, utility"
		_:
			return "Vitality, defense, melee reliability"


func _card_description_for(role_id: StringName) -> String:
	match role_id:
		&"ranger":
			return "Swift ranged fighter with precision and mobility."
		&"alchemist":
			return "Support specialist using potions and utility."
		_:
			return "Resilient melee fighter with high HP and defense."


func _category(title: String, description: String, options: Array) -> Dictionary:
	return {
		"title": title,
		"description": description,
		"options": options,
	}


func _item_option(item: AppearanceItem, asset_name: String) -> Dictionary:
	var folder := _asset_folder_for(item.category)
	var icon := _atlas_icon(
		"res://assets/characters/%s/%s.svg" % [folder, asset_name]
	)
	return {
		"name": item.display_name,
		"icon": icon,
		"tooltip": "%s — cosmetic preview" % item.display_name,
		"locked": item.locked,
		"item": item,
	}


func _visual_option(display_name: String, icon_path: String) -> Dictionary:
	return {
		"name": display_name,
		"icon": load(icon_path) as Texture2D,
		"tooltip": "%s visual preview" % display_name,
		"locked": false,
	}


func _atlas_icon(texture_path: String) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = load(texture_path) as Texture2D
	atlas.region = Rect2(0, 0, 48, 64)
	return atlas


func _asset_folder_for(category: AppearanceItem.Category) -> String:
	match category:
		AppearanceItem.Category.BODY:
			return "body"
		AppearanceItem.Category.HAIR:
			return "hair"
		AppearanceItem.Category.TOP:
			return "tops"
		AppearanceItem.Category.BOTTOM:
			return "bottoms"
		AppearanceItem.Category.SHOES:
			return "shoes"
		AppearanceItem.Category.ACCESSORY:
			return "accessories"
		AppearanceItem.Category.WEAPON:
			return "weapons"
		_:
			return "body"
