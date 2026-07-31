class_name CharacterSelectionV2
extends Control

signal appearance_option_selected(
	category: StringName,
	selection_id: StringName,
	item: AppearanceItem
)

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

const SKIN_ICON_PATH := "res://assets/ui/icons/skin_tone.svg"
const HAIR_COLOR_ICON_PATH := "res://assets/ui/icons/hair_color.svg"
const NONE_ICON_PATH := "res://assets/ui/icons/none.svg"

const SKIN_COLORS := [
	{"id": &"skin_light", "name": "Light", "hex": "#FFF2E5", "locked": false},
	{"id": &"skin_warm", "name": "Warm", "hex": "#E9B98F", "locked": false},
	{"id": &"skin_tan", "name": "Tan", "hex": "#C98D68", "locked": false},
	{"id": &"skin_deep", "name": "Deep", "hex": "#94634F", "locked": false},
]
const HAIR_COLORS := [
	{"id": &"hair_chestnut", "name": "Chestnut", "hex": "#FFFFFF", "locked": false},
	{"id": &"hair_ash", "name": "Ash", "hex": "#C4C0BC", "locked": false},
	{"id": &"hair_gold", "name": "Golden", "hex": "#E6BA72", "locked": false},
	{"id": &"hair_violet", "name": "Violet", "hex": "#B7A2CA", "locked": false},
]

@export var body_options: Array[AppearanceItem] = [
	BODY_A as AppearanceItem,
	BODY_B as AppearanceItem,
]
@export var hair_options: Array[AppearanceItem] = [
	HAIR_SHORT as AppearanceItem,
	HAIR_WAVE as AppearanceItem,
	HAIR_PONY as AppearanceItem,
	HAIR_CROP as AppearanceItem,
]
@export var eye_options: Array[AppearanceItem] = [
	EYES_HAZEL as AppearanceItem,
	EYES_BLUE as AppearanceItem,
]
@export var top_options: Array[AppearanceItem] = [
	TOP_FOREST as AppearanceItem,
	TOP_BLUE as AppearanceItem,
	TOP_EARTH as AppearanceItem,
	TOP_VIOLET as AppearanceItem,
]
@export var bottom_options: Array[AppearanceItem] = [
	BOTTOM_DARK as AppearanceItem,
	BOTTOM_BROWN as AppearanceItem,
]
@export var shoe_options: Array[AppearanceItem] = [
	SHOES_BOOTS as AppearanceItem,
	SHOES_LIGHT as AppearanceItem,
]
@export var accessory_options: Array[AppearanceItem] = [
	ACCESSORY_NONE as AppearanceItem,
	ACCESSORY_LEAF as AppearanceItem,
	ACCESSORY_BAG as AppearanceItem,
]

var selected_body: AppearanceItem
var selected_skin_color: StringName = &""
var selected_hair: AppearanceItem
var selected_hair_color: StringName = &""
var selected_eyes: AppearanceItem
var selected_top: AppearanceItem
var selected_bottom: AppearanceItem
var selected_shoes: AppearanceItem
var selected_accessory: AppearanceItem

var role_resources: Array[RoleData] = [
	WARRIOR as RoleData,
	RANGER as RoleData,
	ALCHEMIST as RoleData,
]
var _option_cards: Dictionary = {}
var _random := RandomNumberGenerator.new()

@onready var background_overlay: ColorRect = $BackgroundOverlay
@onready var preview_tint: ColorRect = %PreviewTint
@onready var floor_shadow: Polygon2D = %FloorShadow
@onready var role_list: VBoxContainer = %RoleList
@onready var preview_character: ModularCharacter = %PreviewCharacter
@onready var character_name: LineEdit = %CharacterName
@onready var name_validation_message: Label = %NameValidationMessage
@onready var appearance_list: VBoxContainer = %AppearanceList
@onready var stats_container: GridContainer = %StatsContainer
@onready var role_description: Label = %RoleDescription
@onready var selected_role_label: Label = %SelectedRole
@onready var role_strengths: Label = %RoleStrengths
@onready var randomize_button: Button = %RandomizeButton
@onready var confirm_button: Button = %ConfirmButton
@onready var transition_layer: ColorRect = $TransitionLayer


func _ready() -> void:
	ThemeManager.apply_theme(self)
	_random.randomize()
	_apply_presentation_tokens()
	_initialize_selection_defaults()
	_connect_signals()
	_populate_roles()
	populate_appearance_sections()
	_initialize_character_preview()
	_show_role_details(role_resources[0])
	validate_form()
	character_name.grab_focus.call_deferred()


func _apply_presentation_tokens() -> void:
	background_overlay.color = Color(T.BACKGROUND_DEEP, 0.12)
	preview_tint.color = Color(T.SURFACE_PRIMARY, 0.16)
	floor_shadow.color = T.SHADOW
	transition_layer.color = T.BACKGROUND_DEEP
	name_validation_message.add_theme_color_override(&"font_color", T.DANGER)


func _connect_signals() -> void:
	appearance_option_selected.connect(select_appearance)
	randomize_button.pressed.connect(randomize_appearance)
	character_name.text_changed.connect(_on_character_name_changed)
	character_name.focus_exited.connect(_trim_character_name)


func _initialize_selection_defaults() -> void:
	selected_body = _first_available_item(body_options)
	selected_skin_color = _first_available_color_id(SKIN_COLORS)
	selected_hair = _first_available_item(hair_options)
	selected_hair_color = _first_available_color_id(HAIR_COLORS)
	selected_eyes = _first_available_item(eye_options)
	selected_top = _first_available_item(top_options)
	selected_bottom = _first_available_item(bottom_options)
	selected_shoes = _first_available_item(shoe_options)
	selected_accessory = _find_available_item(accessory_options, &"accessory_none")
	if selected_accessory == null:
		selected_accessory = _first_available_item(accessory_options)


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
		card.tooltip_text = role_data.description
		role_list.add_child(card)


func populate_appearance_sections() -> void:
	for child: Node in appearance_list.get_children():
		child.queue_free()
	_option_cards.clear()

	_add_item_section(&"body", "Body", "Choose the character silhouette.", body_options)
	_add_color_section(
		&"skin_color", "Skin", "Select a warm foundation tone.",
		SKIN_COLORS, SKIN_ICON_PATH
	)
	_add_item_section(&"hair", "Hair", "Pick a hairstyle for the preview.", hair_options)
	_add_color_section(
		&"hair_color", "Hair Color", "Choose a stable hair palette.",
		HAIR_COLORS, HAIR_COLOR_ICON_PATH
	)
	_add_item_section(&"eyes", "Eyes", "Choose an expressive eye style.", eye_options)
	_add_item_section(&"top", "Top", "Select the adventurer's main outfit.", top_options)
	_add_item_section(
		&"bottom", "Bottom", "Coordinate a practical lower outfit.", bottom_options
	)
	_add_item_section(&"shoes", "Shoes", "Choose footwear for the journey.", shoe_options)
	_add_item_section(
		&"accessory", "Accessory", "Add one subtle finishing detail.", accessory_options
	)
	update_selected_states()


func build_option_card(
	category: StringName,
	selection_id: StringName,
	display_name: String,
	tooltip_text: String,
	thumbnail: Texture2D,
	locked: bool,
	item: AppearanceItem = null
) -> LumaAppearanceOption:
	var card := APPEARANCE_OPTION_SCENE.instantiate() as LumaAppearanceOption
	card.custom_minimum_size = Vector2(68, 68)
	card.option_name = display_name
	card.option_icon = thumbnail
	card.tooltip = tooltip_text
	card.locked = locked
	card.set_meta(&"appearance_category", category)
	card.set_meta(&"selection_id", selection_id)
	card.set_meta(&"appearance_item", item)
	card.pressed.connect(_emit_option_selection.bind(category, selection_id, item))
	if not _option_cards.has(category):
		_option_cards[category] = []
	var cards: Array = _option_cards[category]
	cards.append(card)
	_option_cards[category] = cards
	return card


func select_appearance(
	category: StringName,
	selection_id: StringName,
	item: AppearanceItem
) -> void:
	var card := _find_option_card(category, selection_id)
	if card == null or card.locked:
		return
	match category:
		&"body":
			selected_body = item
		&"skin_color":
			selected_skin_color = selection_id
		&"hair":
			selected_hair = item
		&"hair_color":
			selected_hair_color = selection_id
		&"eyes":
			selected_eyes = item
		&"top":
			selected_top = item
		&"bottom":
			selected_bottom = item
		&"shoes":
			selected_shoes = item
		&"accessory":
			selected_accessory = item
		_:
			return
	update_selected_states()
	update_preview(category)
	validate_form()


func update_selected_states() -> void:
	for category_variant: Variant in _option_cards:
		var category := category_variant as StringName
		var selected_id := _selected_id_for(category)
		var cards: Array = _option_cards[category]
		for card_variant: Variant in cards:
			var card := card_variant as LumaAppearanceOption
			if card == null:
				continue
			var card_id := card.get_meta(&"selection_id", &"") as StringName
			card.selected = not card.locked and card_id == selected_id


func update_preview(category: StringName = &"all") -> void:
	if preview_character == null:
		return
	match category:
		&"body":
			preview_character.set_body(selected_body)
		&"hair":
			preview_character.set_hair(selected_hair)
		&"eyes":
			preview_character.set_eyes(selected_eyes)
		&"top":
			preview_character.set_top(selected_top)
		&"bottom":
			preview_character.set_bottom(selected_bottom)
		&"shoes":
			preview_character.set_shoes(selected_shoes)
		&"accessory":
			preview_character.set_accessory(selected_accessory)
		&"all":
			preview_character.set_body(selected_body)
			preview_character.set_hair(selected_hair)
			preview_character.set_eyes(selected_eyes)
			preview_character.set_top(selected_top)
			preview_character.set_bottom(selected_bottom)
			preview_character.set_shoes(selected_shoes)
			preview_character.set_accessory(selected_accessory)
	_apply_preview_colors()


func randomize_appearance() -> void:
	selected_body = _random_available_item(body_options, selected_body)
	selected_skin_color = _random_available_color_id(SKIN_COLORS, selected_skin_color)
	selected_hair = _random_available_item(hair_options, selected_hair)
	selected_hair_color = _random_available_color_id(HAIR_COLORS, selected_hair_color)
	selected_eyes = _random_available_item(eye_options, selected_eyes)
	selected_top = _random_available_item(top_options, selected_top)
	selected_bottom = _random_available_item(bottom_options, selected_bottom)
	selected_shoes = _random_available_item(shoe_options, selected_shoes)
	selected_accessory = _random_available_item(accessory_options, selected_accessory)
	update_selected_states()
	update_preview(&"all")
	validate_form()


func validate_name() -> bool:
	var trimmed_name := character_name.text.strip_edges()
	var error_message := ""
	if trimmed_name.is_empty():
		error_message = "Character name is required."
	elif trimmed_name.length() < 2:
		error_message = "Use at least 2 characters."
	elif trimmed_name.length() > 16:
		error_message = "Use no more than 16 characters."
	name_validation_message.text = error_message
	name_validation_message.visible = not error_message.is_empty()
	return error_message.is_empty()


func validate_form() -> bool:
	var name_is_valid := validate_name()
	var appearance_is_valid := (
		selected_body != null
		and not selected_skin_color.is_empty()
		and selected_hair != null
		and not selected_hair_color.is_empty()
		and selected_eyes != null
		and selected_top != null
		and selected_bottom != null
		and selected_shoes != null
		and selected_accessory != null
	)
	var form_is_valid := name_is_valid and appearance_is_valid
	confirm_button.disabled = not form_is_valid
	return form_is_valid


func _initialize_character_preview() -> void:
	preview_character.set_weapon(WARRIOR.starting_weapon)
	update_preview(&"all")
	preview_character.play_animation(&"idle_down")


func _add_item_section(
	category: StringName,
	title: String,
	description_text: String,
	items: Array[AppearanceItem]
) -> void:
	var options := _add_section_shell(title, description_text)
	for item: AppearanceItem in items:
		if item == null:
			continue
		var card := build_option_card(
			category,
			item.id,
			item.display_name,
			"%s - cosmetic preview" % item.display_name,
			_thumbnail_for_item(item),
			item.locked,
			item
		)
		options.add_child(card)


func _add_color_section(
	category: StringName,
	title: String,
	description_text: String,
	palette: Array,
	icon_path: String
) -> void:
	var options := _add_section_shell(title, description_text)
	var icon := load(icon_path) as Texture2D
	for entry_variant: Variant in palette:
		var entry := entry_variant as Dictionary
		var entry_id := entry["id"] as StringName
		var entry_name := entry["name"] as String
		var locked := entry["locked"] as bool
		var card := build_option_card(
			category,
			entry_id,
			entry_name,
			"%s color - %s" % [title, entry_name],
			icon,
			locked
		)
		options.add_child(card)


func _add_section_shell(title: String, description_text: String) -> HFlowContainer:
	var header := SECTION_HEADER_SCENE.instantiate() as LumaSectionHeader
	header.heading = title
	header.show_divider = true
	appearance_list.add_child(header)
	var description := Label.new()
	description.theme_type_variation = &"CaptionLabel"
	description.text = description_text
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	appearance_list.add_child(description)
	var options := HFlowContainer.new()
	options.add_theme_constant_override(&"h_separation", T.SPACE_SM)
	options.add_theme_constant_override(&"v_separation", T.SPACE_SM)
	appearance_list.add_child(options)
	return options


func _emit_option_selection(
	category: StringName,
	selection_id: StringName,
	item: AppearanceItem
) -> void:
	appearance_option_selected.emit(category, selection_id, item)


func _on_character_name_changed(_new_text: String) -> void:
	validate_form()


func _trim_character_name() -> void:
	var trimmed_name := character_name.text.strip_edges()
	if character_name.text != trimmed_name:
		character_name.text = trimmed_name
		character_name.caret_column = trimmed_name.length()
	validate_form()


func _apply_preview_colors() -> void:
	preview_character.body.self_modulate = _color_for_id(SKIN_COLORS, selected_skin_color)
	preview_character.hair.self_modulate = _color_for_id(HAIR_COLORS, selected_hair_color)


func _selected_id_for(category: StringName) -> StringName:
	match category:
		&"body":
			return selected_body.id if selected_body != null else &""
		&"skin_color":
			return selected_skin_color
		&"hair":
			return selected_hair.id if selected_hair != null else &""
		&"hair_color":
			return selected_hair_color
		&"eyes":
			return selected_eyes.id if selected_eyes != null else &""
		&"top":
			return selected_top.id if selected_top != null else &""
		&"bottom":
			return selected_bottom.id if selected_bottom != null else &""
		&"shoes":
			return selected_shoes.id if selected_shoes != null else &""
		&"accessory":
			return selected_accessory.id if selected_accessory != null else &""
		_:
			return &""


func _find_option_card(category: StringName, selection_id: StringName) -> LumaAppearanceOption:
	var cards: Array = _option_cards.get(category, [])
	for card_variant: Variant in cards:
		var card := card_variant as LumaAppearanceOption
		if card != null and card.get_meta(&"selection_id", &"") == selection_id:
			return card
	return null


func _first_available_item(options: Array[AppearanceItem]) -> AppearanceItem:
	for item: AppearanceItem in options:
		if item != null and not item.locked:
			return item
	return null


func _find_available_item(
	options: Array[AppearanceItem],
	item_id: StringName
) -> AppearanceItem:
	for item: AppearanceItem in options:
		if item != null and item.id == item_id and not item.locked:
			return item
	return null


func _random_available_item(
	options: Array[AppearanceItem],
	fallback: AppearanceItem
) -> AppearanceItem:
	var unlocked: Array[AppearanceItem] = []
	for item: AppearanceItem in options:
		if item != null and not item.locked:
			unlocked.append(item)
	if unlocked.is_empty():
		return fallback
	return unlocked[_random.randi_range(0, unlocked.size() - 1)]


func _first_available_color_id(palette: Array) -> StringName:
	for entry_variant: Variant in palette:
		var entry := entry_variant as Dictionary
		if not (entry["locked"] as bool):
			return entry["id"] as StringName
	return &""


func _random_available_color_id(palette: Array, fallback: StringName) -> StringName:
	var unlocked_ids: Array[StringName] = []
	for entry_variant: Variant in palette:
		var entry := entry_variant as Dictionary
		if not (entry["locked"] as bool):
			unlocked_ids.append(entry["id"] as StringName)
	if unlocked_ids.is_empty():
		return fallback
	return unlocked_ids[_random.randi_range(0, unlocked_ids.size() - 1)]


func _color_for_id(palette: Array, color_id: StringName) -> Color:
	for entry_variant: Variant in palette:
		var entry := entry_variant as Dictionary
		if entry["id"] as StringName == color_id:
			return Color.from_string(entry["hex"] as String, Color.WHITE)
	return Color.WHITE


func _thumbnail_for_item(item: AppearanceItem) -> Texture2D:
	if item.icon != null:
		return item.icon
	if item.id == &"accessory_none":
		return load(NONE_ICON_PATH) as Texture2D
	var folder := _asset_folder_for(item.category)
	return _atlas_icon("res://assets/characters/%s/%s.svg" % [folder, item.id])


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
		AppearanceItem.Category.EYES:
			return "eyes"
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
