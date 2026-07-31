extends Control

const T := preload("res://ui/theme/theme_tokens.gd")

var selected_role := "Warrior"
var hair_index := 0
var skin_index := 0
var outfit_index := 0
var preview: Control
var role_detail: Label
var stats_label: Label
var name_input: LineEdit
var role_buttons: Dictionary = {}

var roles := {
	"Warrior": {"description": "Brave frontline fighter. High HP and defense.", "stats": "HP 120\nAttack 16\nDefense 14\nSpeed 95\nEnergy 100", "available": true},
	"Ranger": {"description": "Swift ranged fighter. Precise and mobile.", "stats": "HP 90\nAttack 18\nDefense 8\nSpeed 120\nEnergy 110", "available": true},
	"Alchemist": {"description": "Uses potions to heal, support and craft.", "stats": "HP 100\nAttack 10\nDefense 9\nSpeed 100\nEnergy 130", "available": true},
}


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ThemeManager.apply_theme(self)
	_build_ui()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = T.BACKGROUND_WARM
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var root_margin := MarginContainer.new()
	root_margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root_margin.add_theme_constant_override("margin_left", 16)
	root_margin.add_theme_constant_override("margin_right", 16)
	root_margin.add_theme_constant_override("margin_top", 10)
	root_margin.add_theme_constant_override("margin_bottom", 10)
	add_child(root_margin)

	var main_vbox := VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 12)
	root_margin.add_child(main_vbox)

	var title := Label.new()
	title.text = "LumaVale"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.theme_type_variation = &"TitleLabel"
	main_vbox.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "CREATE YOUR ADVENTURER  •  Appearance  →  Class  →  Confirm"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.text = "CREATE YOUR ADVENTURER  |  Appearance  >  Role  >  Confirm"
	subtitle.theme_type_variation = &"SecondaryLabel"
	main_vbox.add_child(subtitle)

	var columns := HBoxContainer.new()
	columns.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 14)
	var columns_scroll := ScrollContainer.new()
	columns_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	columns_scroll.add_child(columns)
	main_vbox.add_child(columns_scroll)

	columns.add_child(_build_appearance_panel())
	columns.add_child(_build_preview_panel())
	columns.add_child(_build_role_panel())

	var footer := Label.new()
	footer.text = "Appearance is cosmetic and does not affect gameplay."
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	footer.theme_type_variation = &"CaptionLabel"
	main_vbox.add_child(footer)


func _panel(title_text: String, width: float) -> VBoxContainer:
	var panel := VBoxContainer.new()
	panel.custom_minimum_size = Vector2(width, 0)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_constant_override("separation", 10)

	var holder := PanelContainer.new()
	holder.theme_type_variation = &"FantasyPanel"
	holder.add_child(panel)
	holder.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.set_meta("holder", holder)

	var heading := Label.new()
	heading.text = title_text
	heading.theme_type_variation = &"PanelHeading"
	panel.add_child(heading)
	return panel


func _build_appearance_panel() -> Control:
	var box := _panel("1  APPEARANCE", 220)
	_add_option_row(box, "Body", ["A", "B"], func(_i): pass)
	_add_option_row(box, "Skin", ["Light", "Warm", "Tan", "Deep"], func(i): skin_index = i; preview.queue_redraw())
	_add_option_row(box, "Hair", ["Short", "Wave", "Pony", "Crop"], func(i): hair_index = i; preview.queue_redraw())
	_add_option_row(box, "Outfit", ["Forest", "Blue", "Earth", "Violet"], func(i): outfit_index = i; preview.queue_redraw())
	_add_option_row(box, "Accessory", ["None", "Leaf", "Bag"], func(_i): pass)

	var name_label := Label.new()
	name_label.text = "Character Name"
	name_label.theme_type_variation = &"SecondaryLabel"
	box.add_child(name_label)

	name_input = LineEdit.new()
	name_input.placeholder_text = "Enter your hero's name"
	name_input.max_length = 16
	name_input.text = "Luma Adventurer"
	name_input.custom_minimum_size = Vector2(0, 44)
	box.add_child(name_input)
	return box.get_meta("holder")


func _add_option_row(parent: VBoxContainer, label_text: String, values: Array, callback: Callable) -> void:
	var label := Label.new()
	label.text = label_text
	label.theme_type_variation = &"SecondaryLabel"
	parent.add_child(label)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	parent.add_child(row)
	for i in values.size():
		var button := Button.new()
		button.text = str(values[i])
		button.custom_minimum_size = Vector2(58, 42)
		button.theme_type_variation = &"SelectedTabButton" if i == 0 else &"TabButton"
		button.pressed.connect(
			func():
				for sibling: Control in row.get_children():
					sibling.theme_type_variation = &"TabButton"
				button.theme_type_variation = &"SelectedTabButton"
				callback.call(i)
		)
		row.add_child(button)


func _build_preview_panel() -> Control:
	var box := _panel("LIVE PREVIEW", 260)
	preview = Control.new()
	preview.custom_minimum_size = Vector2(0, 330)
	preview.draw.connect(_draw_preview)
	box.add_child(preview)

	role_detail = Label.new()
	role_detail.text = roles[selected_role].description
	role_detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	role_detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	role_detail.theme_type_variation = &"SecondaryLabel"
	box.add_child(role_detail)

	var enter_button := Button.new()
	enter_button.text = "CONFIRM CHARACTER"
	enter_button.custom_minimum_size = Vector2(0, 50)
	enter_button.theme_type_variation = &"AccentButton"
	enter_button.pressed.connect(_confirm_character)
	box.add_child(enter_button)
	return box.get_meta("holder")


func _build_role_panel() -> Control:
	var box := _panel("2  CHOOSE YOUR ROLE", 240)
	var grid := GridContainer.new()
	grid.columns = 1
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	box.add_child(grid)

	for role_name in roles.keys():
		var button := Button.new()
		button.text = role_name if roles[role_name].available else role_name + "\nLOCKED"
		button.custom_minimum_size = Vector2(0, 52)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.disabled = not roles[role_name].available
		button.theme_type_variation = (
			&"SelectedTabButton" if role_name == selected_role else &"TabButton"
		)
		button.pressed.connect(func(): _select_role(role_name))
		role_buttons[role_name] = button
		grid.add_child(button)

	var stat_heading := Label.new()
	stat_heading.text = "STARTING STATS"
	stat_heading.theme_type_variation = &"PanelHeading"
	box.add_child(stat_heading)

	stats_label = Label.new()
	stats_label.text = roles[selected_role].stats
	box.add_child(stats_label)

	var note := Label.new()
	note.text = "Warrior: easy melee\nRanger: mobile ranged\nAlchemist: support and crafting"
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.theme_type_variation = &"SecondaryLabel"
	box.add_child(note)
	return box.get_meta("holder")


func _select_role(role_name: String) -> void:
	selected_role = role_name
	for button_role: String in role_buttons:
		var role_button := role_buttons[button_role] as Button
		role_button.theme_type_variation = (
			&"SelectedTabButton" if button_role == selected_role else &"TabButton"
		)
	role_detail.text = roles[role_name].description
	stats_label.text = roles[role_name].stats
	preview.queue_redraw()


func _draw_preview() -> void:
	var center := Vector2(preview.size.x * 0.5, 155)
	preview.draw_circle(center + Vector2(0, 66), 72, T.SURFACE_SECONDARY)
	preview.draw_arc(center + Vector2(0, 66), 72, 0.0, TAU, 40, T.BORDER_DEFAULT, 2.0)
	preview.draw_circle(center + Vector2(0, 20), 31, _skin_color())
	preview.draw_rect(Rect2(center.x - 28, center.y + 48, 56, 72), _outfit_color(), true)
	preview.draw_rect(Rect2(center.x - 23, center.y + 112, 16, 35), T.BACKGROUND_DEEP, true)
	preview.draw_rect(Rect2(center.x + 7, center.y + 112, 16, 35), T.BACKGROUND_DEEP, true)
	_draw_hair(center)
	preview.draw_circle(center + Vector2(-10, 20), 3.2, T.TEXT_PRIMARY)
	preview.draw_circle(center + Vector2(10, 20), 3.2, T.TEXT_PRIMARY)
	_draw_weapon(center)


func _draw_hair(center: Vector2) -> void:
	var colors := [Color("553726"), Color("312f35"), Color("c58a42"), Color("d7d1c7")]
	var hair_color: Color = colors[hair_index % colors.size()]
	preview.draw_arc(center + Vector2(0, 12), 32, PI, TAU, 20, hair_color, 12)
	if hair_index == 1:
		preview.draw_circle(center + Vector2(-28, 20), 8, hair_color)
		preview.draw_circle(center + Vector2(28, 20), 8, hair_color)
	elif hair_index == 2:
		preview.draw_circle(center + Vector2(28, 0), 11, hair_color)


func _draw_weapon(center: Vector2) -> void:
	if selected_role == "Warrior":
		preview.draw_line(center + Vector2(35, 75), center + Vector2(72, 35), Color("d8d8d8"), 6)
	elif selected_role == "Ranger":
		preview.draw_arc(center + Vector2(46, 72), 30, -1.2, 1.2, 20, Color("9b6a3b"), 5)
	elif selected_role == "Alchemist":
		preview.draw_circle(center + Vector2(50, 78), 12, Color("65d6a0"))


func _skin_color() -> Color:
	var colors := [Color("f2c38f"), Color("e4aa73"), Color("c78955"), Color("8a593d")]
	return colors[skin_index % colors.size()]


func _outfit_color() -> Color:
	var colors := [Color("4f8f70"), Color("456f9c"), Color("8c6239"), Color("72528c")]
	return colors[outfit_index % colors.size()]


func _confirm_character() -> void:
	var hero_name := name_input.text.strip_edges()
	if hero_name.is_empty():
		name_input.placeholder_text = "Name is required"
		return
	print("Character created: %s [%s]" % [hero_name, selected_role])
	get_tree().change_scene_to_file("res://scenes/main.tscn")
