class_name CharacterSelectionV2
extends Control

signal appearance_option_selected(
	category: StringName,
	selection_id: StringName,
	item: AppearanceItem
)
signal role_option_selected(role: RoleData)

const T := preload("res://ui/theme/theme_tokens.gd")
const ROLE_CARD_SCENE := preload("res://ui/components/card/role_card.tscn")
const APPEARANCE_OPTION_SCENE := preload("res://ui/components/card/appearance_card.tscn")
const SECTION_HEADER_SCENE := preload("res://ui/components/navigation/section_header.tscn")
const STATUS_BAR_SCENE := preload("res://ui/components/progress/progress_bar.tscn")
const MAIN_SCENE_PATH := "res://scenes/main.tscn"
const BACK_SCENE_PATH := "res://archive/character_creation.tscn"
const TRANSITION_DURATION := 0.20
const BASE_SAFE_MARGIN := Vector2(14.0, 12.0)
const BASE_HEADER_HEIGHT := 80.0
const BASE_ROLE_WIDTH := 210.0
const BASE_PREVIEW_WIDTH := 300.0
const BASE_INFO_WIDTH := 280.0
const BASE_PREVIEW_HEIGHT := 215.0
const BASE_ROLE_SCROLL_HEIGHT := 250.0
const BASE_INFO_SCROLL_HEIGHT := 300.0
const BASE_INPUT_HEIGHT := 44.0
const BASE_FOOTER_HEIGHT := 48.0
const APPEARANCE_CATEGORY_ORDER: Array[StringName] = [
	&"body",
	&"skin_color",
	&"hair",
	&"hair_color",
	&"eyes",
	&"top",
	&"bottom",
	&"shoes",
	&"accessory",
]

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
@export var roles: Array[RoleData] = [
	WARRIOR as RoleData,
	RANGER as RoleData,
	ALCHEMIST as RoleData,
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
var selected_role: RoleData

var _option_cards: Dictionary = {}
var _role_cards: Dictionary = {}
var _random := RandomNumberGenerator.new()
var _transitioning: bool = false

@onready var background_overlay: ColorRect = _find_required_node(&"BackgroundOverlay") as ColorRect
@onready var safe_area: ScrollContainer = _find_required_node(&"SafeArea") as ScrollContainer
@onready var header: PanelContainer = _find_required_node(&"Header") as PanelContainer
@onready var role_section: VBoxContainer = _find_required_node(&"RoleSection") as VBoxContainer
@onready var role_scroll: ScrollContainer = _find_required_node(&"RoleScroll") as ScrollContainer
@onready var preview_section: VBoxContainer = _find_required_node(&"CharacterPreviewSection") as VBoxContainer
@onready var info_section: VBoxContainer = _find_required_node(&"CharacterInfoSection") as VBoxContainer
@onready var info_scroll: ScrollContainer = _find_required_node(&"InfoScroll") as ScrollContainer
@onready var preview_viewport_container: SubViewportContainer = _find_required_node(&"PreviewViewportContainer") as SubViewportContainer
@onready var idle_button: Button = _find_required_node(&"IdleButton") as Button
@onready var walk_button: Button = _find_required_node(&"WalkButton") as Button
@onready var attack_button: Button = _find_required_node(&"AttackButton") as Button
@onready var animation_buttons: Array[Button] = [idle_button, walk_button, attack_button]
@onready var preview_tint: ColorRect = _find_required_node(&"PreviewTint") as ColorRect
@onready var floor_shadow: Polygon2D = _find_required_node(&"FloorShadow") as Polygon2D
@onready var role_list: VBoxContainer = _find_required_node(&"RoleList") as VBoxContainer
@onready var preview_character: ModularCharacter = _find_required_node(&"PreviewCharacter") as ModularCharacter
@onready var character_name: LineEdit = _find_required_node(&"CharacterName") as LineEdit
@onready var name_validation_message: Label = _find_required_node(&"NameValidationMessage") as Label
@onready var appearance_list: VBoxContainer = _find_required_node(&"AppearanceList") as VBoxContainer
@onready var stats_container: VBoxContainer = _find_required_node(&"StatsContainer") as VBoxContainer
@onready var role_description: Label = _find_required_node(&"RoleDescription") as Label
@onready var selected_role_label: Label = _find_required_node(&"SelectedRole") as Label
@onready var role_strengths: Label = _find_required_node(&"RoleStrengths") as Label
@onready var randomize_button: Button = _find_required_node(&"RandomizeButton") as Button
@onready var confirm_button: Button = _find_required_node(&"ConfirmButton") as Button
@onready var back_button: Button = _find_required_node(&"BackButton") as Button
@onready var footer_actions: HFlowContainer = _find_required_node(&"FooterActions") as HFlowContainer
@onready var transition_layer: ColorRect = _find_required_node(&"TransitionLayer") as ColorRect


func _ready() -> void:
	if not _required_nodes_are_available():
		push_error("CharacterSelectionV2 initialization stopped because required UI nodes are missing.")
		return
	ThemeManager.apply_theme(self)
	_random.randomize()
	_apply_presentation_tokens()
	_initialize_selection_defaults()
	_connect_signals()
	populate_appearance_sections()
	_initialize_character_preview()
	populate_roles()
	_apply_ui_scale(ThemeManager.ui_scale)
	_configure_focus_navigation.call_deferred()
	validate_form()
	character_name.grab_focus.call_deferred()


func _find_required_node(node_name: StringName) -> Node:
	var found_node := find_child(String(node_name), true, false)
	if found_node == null:
		push_error("CharacterSelectionV2 missing required node: %s." % node_name)
	return found_node


func _required_nodes_are_available() -> bool:
	var required_nodes: Array[Node] = [
		background_overlay,
		safe_area,
		header,
		role_section,
		role_scroll,
		preview_section,
		info_section,
		info_scroll,
		preview_viewport_container,
		idle_button,
		walk_button,
		attack_button,
		preview_tint,
		floor_shadow,
		role_list,
		preview_character,
		character_name,
		name_validation_message,
		appearance_list,
		stats_container,
		role_description,
		selected_role_label,
		role_strengths,
		randomize_button,
		confirm_button,
		back_button,
		footer_actions,
		transition_layer,
	]
	for required_node: Node in required_nodes:
		if required_node == null:
			return false
	return true


func _apply_presentation_tokens() -> void:
	background_overlay.color = Color(T.BACKGROUND_DEEP, 0.12)
	preview_tint.color = Color(T.SURFACE_PRIMARY, 0.16)
	floor_shadow.color = T.SHADOW
	transition_layer.color = Color(T.BACKGROUND_DEEP, 0.0)
	name_validation_message.add_theme_color_override(&"font_color", T.DANGER)


func _connect_signals() -> void:
	appearance_option_selected.connect(select_appearance)
	role_option_selected.connect(select_role)
	randomize_button.pressed.connect(randomize_appearance)
	confirm_button.pressed.connect(_on_confirm_pressed)
	back_button.pressed.connect(_on_back_pressed)
	character_name.text_changed.connect(_on_character_name_changed)
	character_name.focus_exited.connect(_trim_character_name)
	ThemeManager.ui_scale_changed.connect(_apply_ui_scale)
	get_viewport().size_changed.connect(_on_viewport_size_changed)


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


func populate_roles() -> void:
	for child: Node in role_list.get_children():
		child.queue_free()
	_role_cards.clear()
	selected_role = null
	for role_data: RoleData in roles:
		if role_data == null:
			continue
		var card := build_role_card(role_data)
		role_list.add_child(card)
		_role_cards[role_data.id] = card
	var default_role := _default_available_role()
	if default_role != null:
		select_role(default_role)
	else:
		refresh_role_information()
		refresh_stats()
		refresh_starting_weapon()
		validate_form()
	_configure_focus_navigation.call_deferred()


func build_role_card(role_data: RoleData) -> LumaRoleCard:
	var card := ROLE_CARD_SCENE.instantiate() as LumaRoleCard
	card.custom_minimum_size = Vector2(0, 238)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.role_name = role_data.display_name
	card.description = (
		_card_description_for(role_data.id)
		if role_data.available
		else "Coming Soon"
	)
	card.difficulty = role_data.difficulty
	card.portrait = role_data.portrait if role_data.portrait != null else role_data.icon
	card.card_state = (
		LumaRoleCard.CardState.NORMAL
		if role_data.available
		else LumaRoleCard.CardState.LOCKED
	)
	card.tooltip_text = (
		role_data.description
		if role_data.available
		else "%s is unavailable. Coming Soon." % role_data.display_name
	)
	card.set_meta(&"role_id", role_data.id)
	card.set_meta(&"role_data", role_data)
	card.pressed.connect(_emit_role_selection.bind(role_data))
	return card


func select_role(role_data: RoleData) -> void:
	if role_data == null or not role_data.available:
		return
	selected_role = role_data
	for role_id_variant: Variant in _role_cards:
		var role_id := role_id_variant as StringName
		var card := _role_cards[role_id] as LumaRoleCard
		var registered_role := _find_role(role_id)
		if card == null or registered_role == null:
			continue
		if not registered_role.available:
			card.card_state = LumaRoleCard.CardState.LOCKED
		elif role_id == selected_role.id:
			card.card_state = LumaRoleCard.CardState.SELECTED
		else:
			card.card_state = LumaRoleCard.CardState.NORMAL
	refresh_role_information()
	refresh_stats()
	refresh_starting_weapon()
	validate_form()


func refresh_role_information() -> void:
	if selected_role == null:
		selected_role_label.text = "No role selected"
		role_description.text = "Choose an available role to continue."
		role_strengths.text = ""
		return
	selected_role_label.text = selected_role.display_name
	role_description.text = selected_role.description
	role_strengths.text = _strengths_for(selected_role.id)


func refresh_stats() -> void:
	for child: Node in stats_container.get_children():
		child.queue_free()
	if selected_role == null:
		return
	var stats: Array[Dictionary] = [
		{"name": "HP", "value": selected_role.hp, "max": 120.0, "variant": LumaStatusBar.Variant.HP},
		{"name": "Attack", "value": selected_role.attack, "max": 20.0, "variant": LumaStatusBar.Variant.EXP},
		{"name": "Defense", "value": selected_role.defense, "max": 20.0, "variant": LumaStatusBar.Variant.ENERGY},
		{"name": "Speed", "value": selected_role.speed, "max": 20.0, "variant": LumaStatusBar.Variant.EXP},
		{"name": "Energy", "value": selected_role.energy, "max": 120.0, "variant": LumaStatusBar.Variant.ENERGY},
	]
	for stat: Dictionary in stats:
		var bar := STATUS_BAR_SCENE.instantiate() as LumaStatusBar
		bar.label_text = stat["name"] as String
		bar.max_value = stat["max"] as float
		bar.value = stat["value"] as float
		bar.target_value = stat["value"] as float
		bar.variant = stat["variant"] as LumaStatusBar.Variant
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		stats_container.add_child(bar)


func refresh_starting_weapon() -> void:
	preview_character.set_weapon(
		selected_role.starting_weapon if selected_role != null else null
	)


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
	_configure_focus_navigation.call_deferred()


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
	selected_hair = _random_available_item(hair_options, selected_hair)
	selected_hair_color = _random_available_color_id(HAIR_COLORS, selected_hair_color)
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
	var role_is_valid := selected_role != null and selected_role.available
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
	var form_is_valid := name_is_valid and role_is_valid and appearance_is_valid
	confirm_button.disabled = not form_is_valid
	return form_is_valid


func build_character_data() -> Dictionary:
	if not validate_form():
		return {}
	return {
		"name": character_name.text.strip_edges(),
		"role": String(selected_role.id),
		"body": String(selected_body.id),
		"skin_color": String(selected_skin_color),
		"hair": String(selected_hair.id),
		"hair_color": String(selected_hair_color),
		"eyes": String(selected_eyes.id),
		"top": String(selected_top.id),
		"bottom": String(selected_bottom.id),
		"shoes": String(selected_shoes.id),
		"accessory": String(selected_accessory.id),
		"weapon": String(selected_role.starting_weapon.id),
		"stats": {
			"hp": selected_role.hp,
			"attack": selected_role.attack,
			"defense": selected_role.defense,
			"speed": selected_role.speed,
			"energy": selected_role.energy,
		},
	}


func _initialize_character_preview() -> void:
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
			(
				"%s is locked and unavailable." % item.display_name
				if item.locked
				else "%s - cosmetic preview" % item.display_name
			),
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
			(
				"%s color %s is locked and unavailable." % [title, entry_name]
				if locked
				else "%s color - %s" % [title, entry_name]
			),
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


func _emit_role_selection(role_data: RoleData) -> void:
	role_option_selected.emit(role_data)


func _on_character_name_changed(_new_text: String) -> void:
	validate_form()


func _on_confirm_pressed() -> void:
	if _transitioning:
		return
	_trim_character_name()
	var data := build_character_data()
	if data.is_empty():
		character_name.grab_focus()
		return
	GameState.start_new_character(data)
	SaveManager.save_game()
	_transition_to_scene(MAIN_SCENE_PATH)


func _on_back_pressed() -> void:
	if _transitioning:
		return
	_transition_to_scene(BACK_SCENE_PATH)


func _transition_to_scene(scene_path: String) -> void:
	_transitioning = true
	confirm_button.disabled = true
	back_button.disabled = true
	transition_layer.visible = true
	transition_layer.color = Color(T.BACKGROUND_DEEP, 0.0)

	if not ThemeManager.reduced_motion:
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_property(
			transition_layer,
			"color:a",
			1.0,
			TRANSITION_DURATION
		)
		await tween.finished
	else:
		transition_layer.color.a = 1.0
		await get_tree().process_frame

	var change_error := get_tree().change_scene_to_file(scene_path)
	if change_error != OK:
		push_error("Unable to change scene to %s (error %s)." % [scene_path, change_error])
		_transitioning = false
		transition_layer.visible = false
		back_button.disabled = false
		validate_form()


func _unhandled_key_input(event: InputEvent) -> void:
	var key_event := event as InputEventKey
	if (
		key_event != null
		and key_event.pressed
		and not key_event.echo
		and key_event.keycode == KEY_ESCAPE
	):
		get_viewport().set_input_as_handled()
		_on_back_pressed()


func _apply_ui_scale(scale_factor: float) -> void:
	var horizontal_margin := roundf(BASE_SAFE_MARGIN.x * scale_factor)
	var vertical_margin := roundf(BASE_SAFE_MARGIN.y * scale_factor)
	safe_area.offset_left = horizontal_margin
	safe_area.offset_top = vertical_margin
	safe_area.offset_right = -horizontal_margin
	safe_area.offset_bottom = -vertical_margin
	header.custom_minimum_size.y = roundf(BASE_HEADER_HEIGHT * scale_factor)
	role_section.custom_minimum_size.x = roundf(BASE_ROLE_WIDTH * scale_factor)
	preview_section.custom_minimum_size.x = roundf(BASE_PREVIEW_WIDTH * scale_factor)
	info_section.custom_minimum_size.x = roundf(BASE_INFO_WIDTH * scale_factor)
	preview_viewport_container.custom_minimum_size.y = roundf(
		BASE_PREVIEW_HEIGHT * scale_factor
	)
	if scale_factor > 1.0:
		role_scroll.custom_minimum_size.y = roundf(BASE_ROLE_SCROLL_HEIGHT * scale_factor)
		info_scroll.custom_minimum_size.y = roundf(BASE_INFO_SCROLL_HEIGHT * scale_factor)
	else:
		role_scroll.custom_minimum_size.y = 0.0
		info_scroll.custom_minimum_size.y = 0.0
	character_name.custom_minimum_size.y = roundf(BASE_INPUT_HEIGHT * scale_factor)
	footer_actions.custom_minimum_size.y = roundf(BASE_FOOTER_HEIGHT * scale_factor)
	_configure_focus_navigation.call_deferred()


func _on_viewport_size_changed() -> void:
	_apply_ui_scale(ThemeManager.ui_scale)


func _configure_focus_navigation() -> void:
	if not is_inside_tree():
		return
	var focus_controls: Array[Control] = []
	for role_data: RoleData in roles:
		if role_data == null or not role_data.available:
			continue
		var role_card := _role_cards.get(role_data.id) as Control
		if role_card != null:
			focus_controls.append(role_card)
	for animation_button: Button in animation_buttons:
		focus_controls.append(animation_button)
	focus_controls.append(character_name)
	for category: StringName in APPEARANCE_CATEGORY_ORDER:
		var cards: Array = _option_cards.get(category, [])
		for card_variant: Variant in cards:
			var option_card := card_variant as LumaAppearanceOption
			if option_card != null and not option_card.locked:
				focus_controls.append(option_card)
	focus_controls.append(back_button)
	focus_controls.append(randomize_button)
	focus_controls.append(confirm_button)
	if focus_controls.size() < 2:
		return
	for index: int in focus_controls.size():
		var control := focus_controls[index]
		var previous := focus_controls[(index - 1 + focus_controls.size()) % focus_controls.size()]
		var next := focus_controls[(index + 1) % focus_controls.size()]
		var previous_path := control.get_path_to(previous)
		var next_path := control.get_path_to(next)
		control.focus_previous = previous_path
		control.focus_next = next_path
		control.focus_neighbor_left = previous_path
		control.focus_neighbor_top = previous_path
		control.focus_neighbor_right = next_path
		control.focus_neighbor_bottom = next_path


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


func _strengths_for(role_id: StringName) -> String:
	match role_id:
		&"ranger":
			return "Strengths:\n- High Speed\n- Ranged\n- Precision"
		&"alchemist":
			return "Strengths:\n- High Energy\n- Support\n- Potions"
		_:
			return "Strengths:\n- High HP\n- High Defense\n- Melee"


func _default_available_role() -> RoleData:
	var warrior := _find_role(&"warrior")
	if warrior != null and warrior.available:
		return warrior
	for role_data: RoleData in roles:
		if role_data != null and role_data.available:
			return role_data
	return null


func _find_role(role_id: StringName) -> RoleData:
	for role_data: RoleData in roles:
		if role_data != null and role_data.id == role_id:
			return role_data
	return null


func _card_description_for(role_id: StringName) -> String:
	match role_id:
		&"ranger":
			return "Swift ranged fighter with precision and mobility."
		&"alchemist":
			return "Support specialist using potions and utility."
		_:
			return "Resilient melee fighter with high HP and defense."
