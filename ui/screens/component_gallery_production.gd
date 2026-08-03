class_name LumaProductionComponentGallery
extends ColorRect

const T := preload("res://ui/theme/theme_tokens.gd")
const PRIMARY_BUTTON := preload("res://ui/components/button/primary_button.tscn")
const SECONDARY_BUTTON := preload("res://ui/components/button/secondary_button.tscn")
const ACCENT_BUTTON := preload("res://ui/components/button/accent_button.tscn")
const GHOST_BUTTON := preload("res://ui/components/button/ghost_button.tscn")
const DANGER_BUTTON := preload("res://ui/components/button/danger_button.tscn")
const ICON_BUTTON := preload("res://ui/components/button/icon_button.tscn")
const FANTASY_PANEL := preload("res://ui/components/panel/fantasy_panel.tscn")
const INVENTORY_PANEL := preload("res://ui/components/panel/inventory_panel.tscn")
const MODAL_PANEL := preload("res://ui/components/panel/modal_panel.tscn")
const SCROLL_PANEL := preload("res://ui/components/panel/scroll_panel.tscn")
const ROLE_CARD := preload("res://ui/components/card/role_card.tscn")
const ITEM_CARD := preload("res://ui/components/card/item_card.tscn")
const INVENTORY_CARD := preload("res://ui/components/card/inventory_card.tscn")
const NPC_CARD := preload("res://ui/components/card/npc_card.tscn")
const QUEST_CARD := preload("res://ui/components/card/quest_card.tscn")
const CHARACTER_CARD := preload("res://ui/components/card/character_card.tscn")
const TEXTBOX := preload("res://ui/components/input/textbox.tscn")
const DROPDOWN := preload("res://ui/components/dropdown/dropdown.tscn")
const CHECKBOX := preload("res://ui/components/input/checkbox.tscn")
const RADIO := preload("res://ui/components/input/radio.tscn")
const TOGGLE := preload("res://ui/components/input/toggle.tscn")
const SEARCH := preload("res://ui/components/input/search.tscn")
const SLIDER := preload("res://ui/components/input/slider.tscn")
const TOOLTIP := preload("res://ui/components/tooltip/tooltip.tscn")
const BADGE := preload("res://ui/components/badge/badge.tscn")
const AVATAR := preload("res://ui/components/avatar/avatar.tscn")
const PROGRESS := preload("res://ui/components/progress/progress_bar.tscn")
const INVENTORY_SLOT := preload("res://ui/components/inventory/inventory_slot.tscn")
const TAB := preload("res://ui/components/tabs/tab.tscn")
const SECTION_HEADER := preload("res://ui/components/navigation/section_header.tscn")
const MODAL_BACKDROP := preload("res://ui/components/modal/modal_backdrop.tscn")
const LIST_ITEM := preload("res://ui/components/list/list_item.tscn")
const NOTIFICATION := preload("res://ui/components/notifications/notification.tscn")
const TOAST := preload("res://ui/components/notifications/toast.tscn")

const ButtonScript := preload("res://ui/components/button/luma_button.gd")
const CardScript := preload("res://ui/components/card/luma_card.gd")

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
	for side: StringName in [&"margin_left", &"margin_top", &"margin_right", &"margin_bottom"]:
		margin.add_theme_constant_override(side, T.SPACE_LG)
	scroll.add_child(margin)

	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override(&"separation", T.SPACE_LG)
	margin.add_child(content)

	_add_title(content)
	_add_color_tokens(content)
	_add_typography(content)
	_add_buttons(content)
	_add_panels(content)
	_add_cards(content)
	_add_inputs(content)
	_add_other_components(content)


func _add_title(parent: VBoxContainer) -> void:
	var title := Label.new()
	title.theme_type_variation = &"TitleLabel"
	title.text = "LumaVale Production Component Gallery"
	parent.add_child(title)
	var subtitle := Label.new()
	subtitle.theme_type_variation = &"SecondaryLabel"
	subtitle.text = "Reusable components, theme tokens, states, spacing, and keyboard focus."
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(subtitle)


func _add_color_tokens(parent: VBoxContainer) -> void:
	var panel := _new_panel("Semantic Color Tokens")
	parent.add_child(panel)
	var row := HFlowContainer.new()
	row.add_theme_constant_override(&"h_separation", T.SPACE_SM)
	row.add_theme_constant_override(&"v_separation", T.SPACE_SM)
	_get_panel_body(panel).add_child(row)
	for token_name: StringName in [
		&"background_warm",
		&"surface_primary",
		&"primary",
		&"secondary",
		&"accent_gold",
		&"danger",
		&"success",
		&"warning",
	]:
		var swatch := ColorRect.new()
		swatch.custom_minimum_size = Vector2(132, 52)
		swatch.color = ThemeManager.get_token(token_name)
		row.add_child(swatch)
		var label := Label.new()
		label.theme_type_variation = &"CaptionLabel"
		label.text = String(token_name).to_upper()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		swatch.add_child(label)
		label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func _add_typography(parent: VBoxContainer) -> void:
	var panel := _new_panel("Typography")
	parent.add_child(panel)
	for data: Dictionary in [
		{"variation": &"TitleLabel", "text": "Display 40 / Title 34"},
		{"variation": &"ScreenHeading", "text": "Heading 30"},
		{"variation": &"PanelHeading", "text": "Section 22"},
		{"variation": &"Label", "text": "Body 16"},
		{"variation": &"CaptionLabel", "text": "Caption 14"},
	]:
		var label := Label.new()
		label.theme_type_variation = data["variation"]
		label.text = data["text"]
		_get_panel_body(panel).add_child(label)


func _add_buttons(parent: VBoxContainer) -> void:
	var panel := _new_panel("Buttons")
	parent.add_child(panel)
	var row := HFlowContainer.new()
	row.add_theme_constant_override(&"h_separation", T.SPACE_SM)
	row.add_theme_constant_override(&"v_separation", T.SPACE_SM)
	_get_panel_body(panel).add_child(row)
	for scene: PackedScene in [PRIMARY_BUTTON, SECONDARY_BUTTON, ACCENT_BUTTON, GHOST_BUTTON, DANGER_BUTTON, ICON_BUTTON]:
		var button := scene.instantiate() as Button
		row.add_child(button)
		_register_focusable(button)
	var selected_button := PRIMARY_BUTTON.instantiate() as Button
	selected_button.text = "Selected"
	selected_button.set("selected", true)
	row.add_child(selected_button)
	var locked_button := PRIMARY_BUTTON.instantiate() as Button
	locked_button.text = "Locked"
	locked_button.set("locked", true)
	row.add_child(locked_button)
	var disabled_button := SECONDARY_BUTTON.instantiate() as Button
	disabled_button.text = "Disabled"
	disabled_button.disabled = true
	row.add_child(disabled_button)


func _add_panels(parent: VBoxContainer) -> void:
	var panel := _new_panel("Panels")
	parent.add_child(panel)
	var row := HFlowContainer.new()
	row.add_theme_constant_override(&"h_separation", T.SPACE_MD)
	row.add_theme_constant_override(&"v_separation", T.SPACE_MD)
	_get_panel_body(panel).add_child(row)
	for scene: PackedScene in [FANTASY_PANEL, INVENTORY_PANEL, MODAL_PANEL, SCROLL_PANEL]:
		var sample := scene.instantiate() as PanelContainer
		sample.custom_minimum_size = Vector2(240, 112)
		if String(sample.get("title")).is_empty():
			sample.set("title", sample.name)
		var label := Label.new()
		label.text = "Reusable panel content"
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_get_panel_body(sample).add_child(label)
		row.add_child(sample)


func _add_cards(parent: VBoxContainer) -> void:
	var panel := _new_panel("Cards")
	parent.add_child(panel)
	var row := HFlowContainer.new()
	row.add_theme_constant_override(&"h_separation", T.SPACE_MD)
	row.add_theme_constant_override(&"v_separation", T.SPACE_MD)
	_get_panel_body(panel).add_child(row)
	for scene: PackedScene in [ROLE_CARD, ITEM_CARD, INVENTORY_CARD, NPC_CARD, QUEST_CARD, CHARACTER_CARD, LIST_ITEM]:
		var card := scene.instantiate() as Control
		row.add_child(card)
		_register_focusable(card)
	var selected_card := ITEM_CARD.instantiate() as Button
	selected_card.set("title", "Selected")
	selected_card.set("state", CardScript.CardState.SELECTED)
	row.add_child(selected_card)
	var locked_card := QUEST_CARD.instantiate() as Button
	locked_card.set("title", "Locked")
	locked_card.set("state", CardScript.CardState.LOCKED)
	row.add_child(locked_card)


func _add_inputs(parent: VBoxContainer) -> void:
	var panel := _new_panel("Inputs")
	parent.add_child(panel)
	var row := HFlowContainer.new()
	row.add_theme_constant_override(&"h_separation", T.SPACE_SM)
	row.add_theme_constant_override(&"v_separation", T.SPACE_SM)
	_get_panel_body(panel).add_child(row)
	for scene: PackedScene in [TEXTBOX, DROPDOWN, CHECKBOX, RADIO, TOGGLE, SEARCH, SLIDER]:
		var control := scene.instantiate() as Control
		row.add_child(control)
		_register_focusable(control)
		if control is OptionButton:
			(control as OptionButton).selected = 0


func _add_other_components(parent: VBoxContainer) -> void:
	var panel := _new_panel("Other Components")
	parent.add_child(panel)
	var row := HFlowContainer.new()
	row.add_theme_constant_override(&"h_separation", T.SPACE_MD)
	row.add_theme_constant_override(&"v_separation", T.SPACE_MD)
	_get_panel_body(panel).add_child(row)
	for scene: PackedScene in [TOOLTIP, BADGE, AVATAR, PROGRESS, INVENTORY_SLOT, TAB, SECTION_HEADER, NOTIFICATION, TOAST]:
		var control := scene.instantiate() as Control
		row.add_child(control)
		_register_focusable(control)
	var backdrop_preview := Control.new()
	backdrop_preview.custom_minimum_size = Vector2(320, 120)
	backdrop_preview.clip_contents = true
	row.add_child(backdrop_preview)
	var backdrop := MODAL_BACKDROP.instantiate() as Control
	backdrop_preview.add_child(backdrop)
	var modal := MODAL_PANEL.instantiate() as PanelContainer
	modal.set("title", "Modal")
	modal.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	modal.size = Vector2(220, 80)
	backdrop_preview.add_child(modal)


func _new_panel(title: String) -> PanelContainer:
	var panel := FANTASY_PANEL.instantiate() as PanelContainer
	panel.set("title", title)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return panel


func _get_panel_body(panel: Node) -> VBoxContainer:
	return panel.get_node("%Body") as VBoxContainer


func _register_focusable(control: Control) -> void:
	if _first_focusable == null and control.focus_mode != Control.FOCUS_NONE:
		_first_focusable = control
