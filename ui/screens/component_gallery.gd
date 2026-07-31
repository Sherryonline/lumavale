class_name LumaComponentGallery
extends ColorRect

const T := preload("res://ui/theme/theme_tokens.gd")
const PRIMARY_BUTTON := preload("res://ui/components/primary_button.tscn")
const SECONDARY_BUTTON := preload("res://ui/components/secondary_button.tscn")
const ACCENT_BUTTON := preload("res://ui/components/accent_button.tscn")
const DANGER_BUTTON := preload("res://ui/components/danger_button.tscn")
const FANTASY_PANEL := preload("res://ui/components/fantasy_panel.tscn")
const ROLE_CARD := preload("res://ui/components/role_card.tscn")
const APPEARANCE_OPTION := preload("res://ui/components/appearance_option.tscn")
const ITEM_SLOT := preload("res://ui/components/item_slot.tscn")
const TOOLTIP_PANEL := preload("res://ui/components/tooltip_panel.tscn")
const STATUS_BAR := preload("res://ui/components/status_bar.tscn")
const TAB_BUTTON := preload("res://ui/components/tab_button.tscn")
const MODAL_BACKDROP := preload("res://ui/components/modal_backdrop.tscn")
const SECTION_HEADER := preload("res://ui/components/section_header.tscn")
const RoleCardScript := preload("res://ui/components/role_card.gd")
const StatusBarScript := preload("res://ui/components/status_bar.gd")
const ItemSlotScript := preload("res://ui/components/item_slot.gd")

var _first_focusable: Control


func _ready() -> void:
	color = T.BACKGROUND_WARM
	ThemeManager.apply_theme(self)
	_build_gallery()
	if _first_focusable != null:
		_first_focusable.call_deferred("grab_focus")


func _build_gallery() -> void:
	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)

	var margin := MarginContainer.new()
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_theme_constant_override(&"margin_left", T.SPACE_LG)
	margin.add_theme_constant_override(&"margin_top", T.SPACE_LG)
	margin.add_theme_constant_override(&"margin_right", T.SPACE_LG)
	margin.add_theme_constant_override(&"margin_bottom", T.SPACE_LG)
	scroll.add_child(margin)

	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override(&"separation", T.SPACE_LG)
	margin.add_child(content)

	var title := Label.new()
	title.theme_type_variation = &"TitleLabel"
	title.text = "LumaVale Component Gallery"
	content.add_child(title)

	var guidance := Label.new()
	guidance.theme_type_variation = &"SecondaryLabel"
	guidance.text = "Use Tab / Shift+Tab to inspect keyboard focus. Enter or Space activates controls."
	guidance.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(guidance)

	_build_buttons(content)
	_build_role_cards(content)
	_build_appearance_and_items(content)
	_build_feedback_components(content)
	_build_modal_sample(content)


func _build_buttons(parent: VBoxContainer) -> void:
	var panel := _new_panel("Buttons and tabs")
	parent.add_child(panel)
	var body := panel.get_node("Content/Body") as VBoxContainer
	var buttons := HFlowContainer.new()
	buttons.add_theme_constant_override(&"h_separation", T.SPACE_SM)
	buttons.add_theme_constant_override(&"v_separation", T.SPACE_SM)
	body.add_child(buttons)
	for scene: PackedScene in [PRIMARY_BUTTON, SECONDARY_BUTTON, ACCENT_BUTTON, DANGER_BUTTON]:
		var button := scene.instantiate() as Button
		buttons.add_child(button)
		_register_focusable(button)
	var disabled_button := PRIMARY_BUTTON.instantiate() as Button
	disabled_button.text = "Disabled"
	disabled_button.disabled = true
	buttons.add_child(disabled_button)

	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override(&"separation", T.SPACE_SM)
	body.add_child(tabs)
	for tab_name: String in ["Inventory", "Equipment", "Quests"]:
		var tab := TAB_BUTTON.instantiate() as LumaTabButton
		tab.text = tab_name
		tab.selected = tab_name == "Equipment"
		tabs.add_child(tab)
		_register_focusable(tab)


func _build_role_cards(parent: VBoxContainer) -> void:
	var panel := _new_panel("Role Card states")
	parent.add_child(panel)
	var body := panel.get_node("Content/Body") as VBoxContainer
	var cards := GridContainer.new()
	cards.columns = 3
	cards.add_theme_constant_override(&"h_separation", T.SPACE_MD)
	cards.add_theme_constant_override(&"v_separation", T.SPACE_MD)
	body.add_child(cards)
	var states: Array[int] = [
		RoleCardScript.CardState.NORMAL,
		RoleCardScript.CardState.HOVER,
		RoleCardScript.CardState.SELECTED,
		RoleCardScript.CardState.DISABLED,
		RoleCardScript.CardState.LOCKED,
	]
	var names: Array[String] = ["Normal", "Hover", "Selected", "Disabled", "Locked"]
	for index: int in states.size():
		var card := ROLE_CARD.instantiate() as LumaRoleCard
		card.role_name = names[index]
		card.description = "Reusable role card with non-color state markers."
		card.difficulty = "Balanced"
		card.card_state = states[index]
		cards.add_child(card)
		if not card.disabled:
			_register_focusable(card)


func _build_appearance_and_items(parent: VBoxContainer) -> void:
	var panel := _new_panel("Appearance options and item slots")
	parent.add_child(panel)
	var body := panel.get_node("Content/Body") as VBoxContainer
	var option_row := HFlowContainer.new()
	option_row.add_theme_constant_override(&"h_separation", T.SPACE_SM)
	option_row.add_theme_constant_override(&"v_separation", T.SPACE_SM)
	body.add_child(option_row)
	for option_data: Dictionary in [
		{"name": "Normal", "selected": false, "locked": false},
		{"name": "Selected", "selected": true, "locked": false},
		{"name": "Locked", "selected": false, "locked": true},
	]:
		var option := APPEARANCE_OPTION.instantiate() as LumaAppearanceOption
		option.option_name = option_data["name"]
		option.tooltip = "%s appearance option" % option_data["name"]
		option.selected = option_data["selected"]
		option.locked = option_data["locked"]
		option_row.add_child(option)
		if not option.disabled:
			_register_focusable(option)

	var slots := HFlowContainer.new()
	slots.add_theme_constant_override(&"h_separation", T.SPACE_SM)
	slots.add_theme_constant_override(&"v_separation", T.SPACE_SM)
	body.add_child(slots)
	var slot_data: Array[Dictionary] = [
		{"rarity": ItemSlotScript.Rarity.COMMON, "quantity": 1},
		{"rarity": ItemSlotScript.Rarity.RARE, "quantity": 12},
		{"rarity": ItemSlotScript.Rarity.EPIC, "selected": true},
		{"rarity": ItemSlotScript.Rarity.LEGENDARY, "equipped": true},
		{"rarity": ItemSlotScript.Rarity.UNCOMMON, "locked": true},
	]
	for data: Dictionary in slot_data:
		var slot := ITEM_SLOT.instantiate() as LumaItemSlot
		slot.text = ""
		slot.rarity = data["rarity"]
		slot.quantity = data.get("quantity", 0)
		slot.selected = data.get("selected", false)
		slot.equipped = data.get("equipped", false)
		slot.locked = data.get("locked", false)
		slots.add_child(slot)
		if not slot.disabled:
			_register_focusable(slot)


func _build_feedback_components(parent: VBoxContainer) -> void:
	var panel := _new_panel("Status, tooltip and section header")
	parent.add_child(panel)
	var body := panel.get_node("Content/Body") as VBoxContainer
	var header := SECTION_HEADER.instantiate() as LumaSectionHeader
	header.heading = "Adventurer status"
	body.add_child(header)

	for data: Dictionary in [
		{"variant": StatusBarScript.Variant.HP, "label": "HP", "value": 72.0},
		{"variant": StatusBarScript.Variant.ENERGY, "label": "Energy", "value": 48.0},
		{"variant": StatusBarScript.Variant.EXP, "label": "EXP", "value": 86.0},
	]:
		var bar := STATUS_BAR.instantiate() as LumaStatusBar
		bar.variant = data["variant"]
		bar.label_text = data["label"]
		bar.value = data["value"]
		body.add_child(bar)

	var tooltip := TOOLTIP_PANEL.instantiate() as PanelContainer
	body.add_child(tooltip)


func _build_modal_sample(parent: VBoxContainer) -> void:
	var panel := _new_panel("Modal backdrop")
	parent.add_child(panel)
	var body := panel.get_node("Content/Body") as VBoxContainer
	var preview := Control.new()
	preview.custom_minimum_size = Vector2(0, 180)
	preview.clip_contents = true
	body.add_child(preview)
	var backdrop := MODAL_BACKDROP.instantiate() as ColorRect
	preview.add_child(backdrop)
	var modal := FANTASY_PANEL.instantiate() as LumaFantasyPanel
	modal.title = "Confirm action"
	modal.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	modal.position = Vector2(240, 38)
	modal.size = Vector2(360, 120)
	preview.add_child(modal)
	var message := Label.new()
	message.text = "The backdrop blocks input without blur."
	modal.get_node("Content/Body").add_child(message)


func _new_panel(title_text: String) -> LumaFantasyPanel:
	var panel := FANTASY_PANEL.instantiate() as LumaFantasyPanel
	panel.title = title_text
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return panel


func _register_focusable(control: Control) -> void:
	if _first_focusable == null:
		_first_focusable = control
