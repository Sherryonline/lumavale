extends Control

const T := preload("res://ui/theme/theme_tokens.gd")
const ITEM_SLOT := preload("res://ui/components/item_slot.tscn")
const STATUS_BAR := preload("res://ui/components/status_bar.tscn")

var _content: VBoxContainer


func _ready() -> void:
	ThemeManager.apply_theme(self)
	_build()


func _build() -> void:
	var background := ColorRect.new()
	background.color = T.BACKGROUND_WARM
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", T.SPACE_LG)
	margin.add_theme_constant_override("margin_top", T.SPACE_MD)
	margin.add_theme_constant_override("margin_right", T.SPACE_LG)
	margin.add_theme_constant_override("margin_bottom", T.SPACE_MD)
	add_child(margin)

	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", T.SPACE_MD)
	margin.add_child(page)
	page.add_child(_label("LumaVale Interface Codex", &"TitleLabel"))
	page.add_child(
		_label(
			"Elegant anime fantasy • centralized styles • gameplay-neutral previews",
			&"SecondaryLabel"
		)
	)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	page.add_child(scroll)
	_content = VBoxContainer.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.add_theme_constant_override("separation", T.SPACE_MD)
	scroll.add_child(_content)

	_build_components()
	_build_hud()
	_build_inventory()
	_build_quest_and_dialogue()
	_build_menu_and_settings()


func _build_components() -> void:
	var card := _card("Reusable Components")
	var buttons := HBoxContainer.new()
	buttons.add_theme_constant_override("separation", T.SPACE_SM)
	card.add_child(buttons)
	buttons.add_child(_button("Primary", &"PrimaryButton"))
	buttons.add_child(_button("Secondary", &"SecondaryButton"))
	buttons.add_child(_button("Confirm", &"AccentButton"))
	buttons.add_child(_button("Delete", &"DangerButton"))
	var disabled := _button("Unavailable", &"PrimaryButton")
	disabled.disabled = true
	buttons.add_child(disabled)
	var input := LineEdit.new()
	input.custom_minimum_size = Vector2(0, 44)
	input.placeholder_text = "Readable body text and clear focus state"
	card.add_child(input)


func _build_hud() -> void:
	var card := _card("Compact HUD Preview")
	var hud := PanelContainer.new()
	hud.theme_type_variation = &"DarkPanel"
	card.add_child(hud)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", T.SPACE_MD)
	hud.add_child(row)
	var identity := VBoxContainer.new()
	identity.custom_minimum_size = Vector2(270, 0)
	row.add_child(identity)
	identity.add_child(_dark_label("Luma Adventurer  •  Lv. 4"))
	identity.add_child(_status(&"HPBar", 82, "HP 82 / 100"))
	identity.add_child(_status(&"EnergyBar", 64, "Energy 64 / 100"))
	identity.add_child(_status(&"EXPBar", 45, "EXP 225 / 500"))
	var quest := VBoxContainer.new()
	quest.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(quest)
	quest.add_child(_dark_label("ACTIVE QUEST"))
	quest.add_child(_dark_label("A Warm Welcome"))
	quest.add_child(_dark_label("Meet Mira near the town fountain • 250m"))


func _build_inventory() -> void:
	var card := _card("Inventory & Equipment Preview")
	var layout := HBoxContainer.new()
	layout.add_theme_constant_override("separation", T.SPACE_MD)
	card.add_child(layout)
	var tabs := VBoxContainer.new()
	layout.add_child(tabs)
	for tab_name: String in ["All Items", "Equipment", "Materials", "Quest"]:
		var tab := _button(tab_name, &"SelectedTabButton" if tab_name == "All Items" else &"TabButton")
		tab.custom_minimum_size = Vector2(130, 40)
		tabs.add_child(tab)
	var grid := GridContainer.new()
	grid.columns = 4
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	layout.add_child(grid)
	for index: int in 12:
		var slot := ITEM_SLOT.instantiate() as LumaItemSlot
		slot.text = ["Sword", "Potion", "Apple", "Wood", "Crystal", "Coin"][index % 6]
		slot.quantity = index + 1
		slot.rarity = index % 5
		slot.selected = index == 2
		grid.add_child(slot)
	var detail := PanelContainer.new()
	detail.custom_minimum_size = Vector2(250, 0)
	detail.theme_type_variation = &"DarkPanel"
	layout.add_child(detail)
	var detail_text := VBoxContainer.new()
	detail.add_child(detail_text)
	detail_text.add_child(_dark_label("Sky Crystal"))
	detail_text.add_child(_dark_label("Rare • Crafting Material"))
	detail_text.add_child(_dark_label("A cool crystal humming with wind magic.\nSell value: 85"))


func _build_quest_and_dialogue() -> void:
	var card := _card("Quest Journal & Dialogue Preview")
	var journal := HBoxContainer.new()
	journal.add_theme_constant_override("separation", T.SPACE_SM)
	card.add_child(journal)
	for column_text: String in [
		"MAIN QUEST\nSide Quest\nDaily Quest\nCompleted",
		"A Warm Welcome\nForest Remedies\nThe Old Mine",
		"A Warm Welcome\n\nMeet Mira at the fountain.\n\nReward: 250 EXP • 80 Gold",
	]:
		var column := PanelContainer.new()
		column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		column.theme_type_variation = &"SelectedPanel" if column_text.begins_with("A Warm") else &"FantasyPanel"
		journal.add_child(column)
		column.add_child(_label(column_text))

	var dialogue := PanelContainer.new()
	dialogue.theme_type_variation = &"DarkPanel"
	card.add_child(dialogue)
	var dialogue_row := HBoxContainer.new()
	dialogue.add_child(dialogue_row)
	var portrait := _dark_label("MIRA\nPortrait")
	portrait.custom_minimum_size = Vector2(120, 90)
	portrait.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dialogue_row.add_child(portrait)
	var dialogue_copy := VBoxContainer.new()
	dialogue_copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dialogue_row.add_child(dialogue_copy)
	dialogue_copy.add_child(_dark_label("Mira"))
	dialogue_copy.add_child(
		_dark_label("The morning breeze carried your name all the way to LumaVale.")
	)
	var choices := HBoxContainer.new()
	dialogue_copy.add_child(choices)
	choices.add_child(_button("Continue", &"PrimaryButton"))
	choices.add_child(_button("Skip", &"SecondaryButton"))


func _build_menu_and_settings() -> void:
	var card := _card("Main Menu & Settings Preview")
	var columns := HBoxContainer.new()
	columns.add_theme_constant_override("separation", T.SPACE_MD)
	card.add_child(columns)
	var menu := VBoxContainer.new()
	menu.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.add_child(menu)
	menu.add_child(_label("Return to LumaVale", &"ScreenHeading"))
	menu.add_child(_button("Continue", &"AccentButton"))
	menu.add_child(_button("New Game", &"PrimaryButton"))
	menu.add_child(_button("Settings", &"SecondaryButton"))
	var settings := VBoxContainer.new()
	settings.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.add_child(settings)
	settings.add_child(_label("Accessibility", &"ScreenHeading"))
	var tabs := HBoxContainer.new()
	settings.add_child(tabs)
	for tab_name: String in ["Display", "Audio", "Controls", "Gameplay", "Accessibility"]:
		tabs.add_child(_button(tab_name, &"TabButton"))
	settings.add_child(_label("UI Scale", &"SecondaryLabel"))
	var scales := HBoxContainer.new()
	settings.add_child(scales)
	for scale_value: float in ThemeManager.SUPPORTED_UI_SCALES:
		var button := _button("%d%%" % int(scale_value * 100), &"TabButton")
		button.pressed.connect(ThemeManager.set_ui_scale.bind(scale_value))
		scales.add_child(button)
	settings.add_child(_button("Reduced Motion: Off", &"SecondaryButton"))
	settings.add_child(_button("High Contrast: Off", &"SecondaryButton"))


func _card(title: String) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.theme_type_variation = &"FantasyPanel"
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", T.SPACE_SM)
	panel.add_child(content)
	content.add_child(_label(title, &"PanelHeading"))
	return content


func _label(text: String, variation: StringName = &"") -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if not variation.is_empty():
		label.theme_type_variation = variation
	return label


func _dark_label(text: String) -> Label:
	return _label(text, &"DarkLabel")


func _button(text: String, variation: StringName) -> Button:
	var button := Button.new()
	button.text = text
	button.theme_type_variation = variation
	button.custom_minimum_size = Vector2(120, 44)
	return button


func _status(variation: StringName, current_value: float, tooltip: String) -> LumaStatusBar:
	var bar := STATUS_BAR.instantiate() as LumaStatusBar
	bar.theme_type_variation = variation
	bar.value = current_value
	bar.target_value = current_value
	bar.tooltip_text = tooltip
	return bar
