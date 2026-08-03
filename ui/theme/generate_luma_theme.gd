extends SceneTree

const THEME_PATH := "res://ui/theme/luma_theme.tres"
const STYLE_DIRECTORY := "res://ui/theme/styles"
const T := preload("res://ui/theme/theme_tokens.gd")


func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(STYLE_DIRECTORY))
	var styles := {
		"panel": _style(T.SURFACE_PRIMARY, T.BORDER_DEFAULT, 14, Vector4(20, 18, 20, 18), true),
		"panel_selected": _style(T.SURFACE_PRIMARY, T.BORDER_SELECTED, 14, Vector4(20, 18, 20, 18), true, 3),
		"panel_dark": _style(T.BACKGROUND_DEEP, T.ACCENT_GOLD, 12, Vector4(18, 16, 18, 16), true),
		"button_primary": _style(T.PRIMARY, T.PRIMARY_PRESSED, 11, Vector4(18, 11, 18, 11), true),
		"button_primary_hover": _style(T.PRIMARY_HOVER, T.PRIMARY_PRESSED, 11, Vector4(18, 11, 18, 11), true),
		"button_primary_pressed": _style(T.PRIMARY_PRESSED, T.PRIMARY_PRESSED, 11, Vector4(18, 12, 18, 10)),
		"button_secondary": _style(T.SECONDARY, T.SECONDARY_BORDER, 11, Vector4(18, 11, 18, 11), true),
		"button_secondary_hover": _style(T.SECONDARY_HOVER, T.SECONDARY_BORDER, 11, Vector4(18, 11, 18, 11), true),
		"button_secondary_pressed": _style(T.SECONDARY_BORDER, T.SECONDARY_BORDER, 11, Vector4(18, 12, 18, 10)),
		"button_accent": _style(T.ACCENT_GOLD, T.GOLD_BORDER, 11, Vector4(18, 11, 18, 11), true),
		"button_accent_hover": _style(T.GOLD_HOVER, T.GOLD_BORDER, 11, Vector4(18, 11, 18, 11), true),
		"button_accent_pressed": _style(T.GOLD_BORDER, T.GOLD_BORDER, 11, Vector4(18, 12, 18, 10)),
		"button_danger": _style(T.ACCENT_BURGUNDY, T.BURGUNDY_BORDER, 11, Vector4(18, 11, 18, 11), true),
		"button_danger_hover": _style(T.DANGER, T.BURGUNDY_BORDER, 11, Vector4(18, 11, 18, 11), true),
		"button_danger_pressed": _style(T.BURGUNDY_BORDER, T.BURGUNDY_BORDER, 11, Vector4(18, 12, 18, 10)),
		"button_disabled": _style(T.DISABLED_SURFACE, T.BORDER_DEFAULT, 11, Vector4(18, 11, 18, 11)),
		"button_focus": _style(T.TRANSPARENT, T.BORDER_SELECTED, 11, Vector4(18, 11, 18, 11), false, 3),
		"tab": _style(T.SURFACE_SECONDARY, T.BORDER_DEFAULT, 9, Vector4(14, 9, 14, 9)),
		"tab_selected": _style(T.PRIMARY, T.BORDER_SELECTED, 9, Vector4(14, 9, 14, 9), false, 2),
		"item": _style(T.SURFACE_SECONDARY, T.BORDER_DEFAULT, 8, Vector4(5, 5, 5, 5)),
		"item_hover": _style(T.ITEM_HOVER, T.PRIMARY, 8, Vector4(5, 5, 5, 5)),
		"item_selected": _style(T.SURFACE_PRIMARY, T.BORDER_SELECTED, 8, Vector4(5, 5, 5, 5), false, 3),
		"item_locked": _style(T.DISABLED_SURFACE, T.BORDER_DEFAULT, 8, Vector4(5, 5, 5, 5)),
		"role_card": _style(T.SURFACE_PRIMARY, T.BORDER_DEFAULT, 14, Vector4(16, 16, 16, 16), true),
		"role_card_hover": _style(T.SURFACE_SECONDARY, T.PRIMARY, 14, Vector4(16, 16, 16, 16), true),
		"role_card_selected": _style(T.SURFACE_PRIMARY, T.BORDER_SELECTED, 14, Vector4(16, 16, 16, 16), true, 3),
		"role_card_disabled": _style(T.DISABLED_SURFACE, T.BORDER_DEFAULT, 14, Vector4(16, 16, 16, 16)),
		"role_card_locked": _style(T.DISABLED_SURFACE, T.BORDER_DEFAULT, 14, Vector4(16, 16, 16, 16), false, 2),
		"line_edit": _style(T.SURFACE_PRIMARY, T.BORDER_DEFAULT, 10, Vector4(12, 10, 12, 10)),
		"line_edit_focus": _style(T.SURFACE_PRIMARY, T.BORDER_SELECTED, 10, Vector4(12, 10, 12, 10), false, 2),
		"status_background": _style(T.STATUS_BACKGROUND, T.STATUS_BORDER, 8, Vector4(2, 2, 2, 2)),
		"status_hp": _style(T.ACCENT_BURGUNDY, T.ACCENT_BURGUNDY, 8, Vector4(2, 2, 2, 2)),
		"status_energy": _style(T.SUCCESS, T.SUCCESS, 8, Vector4(2, 2, 2, 2)),
		"status_mana": _style(T.PRIMARY, T.PRIMARY, 8, Vector4(2, 2, 2, 2)),
		"status_exp": _style(T.ACCENT_GOLD, T.ACCENT_GOLD, 8, Vector4(2, 2, 2, 2)),
		"divider": _style(T.BORDER_DEFAULT, T.BORDER_DEFAULT, 0, Vector4(0, 1, 0, 0), false, 0),
	}
	var saved := {}
	for style_name: String in styles:
		var path := "%s/%s.tres" % [STYLE_DIRECTORY, style_name]
		var error := ResourceSaver.save(styles[style_name], path)
		if error != OK:
			push_error("Failed to save %s: %s" % [path, error_string(error)])
			quit(1)
			return
		saved[style_name] = load(path)

	var theme := Theme.new()
	_configure_typography(theme)
	_configure_buttons(theme, saved)
	_configure_panels(theme, saved)
	_configure_inputs(theme, saved)
	_configure_items(theme, saved)
	_configure_status(theme, saved)
	_configure_component_states(theme, saved)
	var error := ResourceSaver.save(theme, THEME_PATH)
	if error != OK:
		push_error("Failed to save theme: %s" % error_string(error))
		quit(1)
		return
	print("LUMA_THEME_GENERATED")
	quit(0)


func _configure_typography(theme: Theme) -> void:
	theme.set_color(&"font_color", &"Label", T.TEXT_PRIMARY)
	theme.set_color(&"font_outline_color", &"Label", T.SURFACE_PRIMARY)
	theme.set_constant(&"outline_size", &"Label", 1)
	theme.set_font_size(&"font_size", &"Label", T.FONT_SIZE_BODY)
	_variation(theme, &"TitleLabel", &"Label", T.FONT_SIZE_TITLE, T.TEXT_PRIMARY)
	_variation(theme, &"ScreenHeading", &"Label", T.FONT_SIZE_SCREEN_HEADING, T.TEXT_PRIMARY)
	_variation(theme, &"PanelHeading", &"Label", T.FONT_SIZE_PANEL_HEADING, T.TEXT_PRIMARY)
	_variation(theme, &"SecondaryLabel", &"Label", T.FONT_SIZE_BODY, T.TEXT_SECONDARY)
	_variation(theme, &"CaptionLabel", &"Label", T.FONT_SIZE_CAPTION, T.TEXT_SECONDARY)
	_variation(theme, &"DarkLabel", &"Label", T.FONT_SIZE_BODY, T.TEXT_ON_DARK)
	_variation(theme, &"DarkTitleLabel", &"Label", T.FONT_SIZE_SCREEN_TITLE, T.TEXT_ON_DARK)
	_variation(theme, &"DarkPanelHeading", &"Label", T.FONT_SIZE_PANEL_HEADING, T.TEXT_ON_DARK)
	_variation(theme, &"GoldDarkLabel", &"Label", T.FONT_SIZE_BODY, T.BORDER_SELECTED)
	_variation(theme, &"StatusLabel", &"Label", 14, T.TEXT_ON_DARK)
	_variation(theme, &"SelectedMarker", &"Label", 16, T.BORDER_SELECTED)
	_variation(theme, &"LockedMarker", &"Label", T.FONT_SIZE_CAPTION, T.TEXT_PRIMARY)
	_variation(theme, &"EquippedMarker", &"Label", T.FONT_SIZE_CAPTION, T.PRIMARY)
	theme.set_color(&"default_color", &"RichTextLabel", T.TEXT_PRIMARY)
	theme.set_font_size(&"normal_font_size", &"RichTextLabel", T.FONT_SIZE_BODY)
	theme.set_font_size(&"bold_font_size", &"RichTextLabel", 17)
	theme.set_type_variation(&"DarkRichText", &"RichTextLabel")
	theme.set_color(&"default_color", &"DarkRichText", T.TEXT_ON_DARK)


func _configure_buttons(theme: Theme, s: Dictionary) -> void:
	for color_name: StringName in [&"font_color", &"font_hover_color", &"font_pressed_color", &"font_focus_color"]:
		theme.set_color(color_name, &"Button", T.TEXT_ON_DARK)
	theme.set_color(&"font_disabled_color", &"Button", T.DISABLED_TEXT)
	theme.set_font_size(&"font_size", &"Button", T.FONT_SIZE_BUTTON)
	theme.set_stylebox(&"normal", &"Button", s["button_primary"])
	theme.set_stylebox(&"hover", &"Button", s["button_primary_hover"])
	theme.set_stylebox(&"pressed", &"Button", s["button_primary_pressed"])
	theme.set_stylebox(&"disabled", &"Button", s["button_disabled"])
	theme.set_stylebox(&"focus", &"Button", s["button_focus"])
	theme.set_type_variation(&"PrimaryButton", &"Button")
	_button_variation(
		theme, s, &"SecondaryButton",
		"button_secondary", "button_secondary_hover", "button_secondary_pressed"
	)
	_button_variation(
		theme, s, &"AccentButton",
		"button_accent", "button_accent_hover", "button_accent_pressed"
	)
	for color_name: StringName in [&"font_color", &"font_hover_color", &"font_pressed_color", &"font_focus_color"]:
		theme.set_color(color_name, &"AccentButton", T.TEXT_PRIMARY)
	_button_variation(
		theme, s, &"DangerButton",
		"button_danger", "button_danger_hover", "button_danger_pressed"
	)
	_button_variation(theme, s, &"TabButton", "tab", "tab_selected", "tab_selected")
	theme.set_color(&"font_color", &"TabButton", T.TEXT_PRIMARY)
	theme.set_color(&"font_hover_color", &"TabButton", T.TEXT_PRIMARY)
	theme.set_type_variation(&"SelectedTabButton", &"TabButton")
	theme.set_stylebox(&"normal", &"SelectedTabButton", s["tab_selected"])
	theme.set_color(&"font_color", &"SelectedTabButton", T.TEXT_ON_DARK)


func _configure_panels(theme: Theme, s: Dictionary) -> void:
	theme.set_stylebox(&"panel", &"PanelContainer", s["panel"])
	theme.set_type_variation(&"FantasyPanel", &"PanelContainer")
	theme.set_type_variation(&"SelectedPanel", &"PanelContainer")
	theme.set_stylebox(&"panel", &"SelectedPanel", s["panel_selected"])
	theme.set_type_variation(&"DarkPanel", &"PanelContainer")
	theme.set_stylebox(&"panel", &"DarkPanel", s["panel_dark"])
	theme.set_type_variation(&"TooltipPanel", &"DarkPanel")


func _configure_inputs(theme: Theme, s: Dictionary) -> void:
	theme.set_color(&"font_color", &"LineEdit", T.TEXT_PRIMARY)
	theme.set_color(&"font_placeholder_color", &"LineEdit", T.TEXT_SECONDARY)
	theme.set_color(&"caret_color", &"LineEdit", T.ACCENT_GOLD)
	theme.set_font_size(&"font_size", &"LineEdit", T.FONT_SIZE_BODY)
	theme.set_stylebox(&"normal", &"LineEdit", s["line_edit"])
	theme.set_stylebox(&"focus", &"LineEdit", s["line_edit_focus"])


func _configure_items(theme: Theme, s: Dictionary) -> void:
	theme.set_type_variation(&"ItemSlot", &"Button")
	theme.set_stylebox(&"normal", &"ItemSlot", s["item"])
	theme.set_stylebox(&"hover", &"ItemSlot", s["item_hover"])
	theme.set_stylebox(&"pressed", &"ItemSlot", s["item_selected"])
	theme.set_color(&"font_color", &"ItemSlot", T.TEXT_PRIMARY)
	theme.set_color(&"font_hover_color", &"ItemSlot", T.TEXT_PRIMARY)
	theme.set_type_variation(&"SelectedItemSlot", &"ItemSlot")
	theme.set_stylebox(&"normal", &"SelectedItemSlot", s["item_selected"])
	theme.set_type_variation(&"LockedItemSlot", &"ItemSlot")
	theme.set_stylebox(&"normal", &"LockedItemSlot", s["item_locked"])


func _configure_status(theme: Theme, s: Dictionary) -> void:
	theme.set_stylebox(&"background", &"ProgressBar", s["status_background"])
	theme.set_stylebox(&"fill", &"ProgressBar", s["status_hp"])
	theme.set_color(&"font_color", &"ProgressBar", T.TEXT_ON_DARK)
	theme.set_font_size(&"font_size", &"ProgressBar", 14)
	for entry: Array in [
		[&"HPBar", "status_hp"],
		[&"EnergyBar", "status_energy"],
		[&"ManaBar", "status_mana"],
		[&"EXPBar", "status_exp"],
	]:
		theme.set_type_variation(entry[0], &"ProgressBar")
		theme.set_stylebox(&"fill", entry[0], s[entry[1]])


func _configure_component_states(theme: Theme, s: Dictionary) -> void:
	for entry: Array in [
		[&"RoleCard", "role_card"],
		[&"HoverRoleCard", "role_card_hover"],
		[&"SelectedRoleCard", "role_card_selected"],
		[&"DisabledRoleCard", "role_card_disabled"],
		[&"LockedRoleCard", "role_card_locked"],
	]:
		theme.set_type_variation(entry[0], &"Button")
		theme.set_stylebox(&"normal", entry[0], s[entry[1]])
		theme.set_stylebox(&"hover", entry[0], s[entry[1]])
		theme.set_stylebox(&"pressed", entry[0], s[entry[1]])
		theme.set_stylebox(&"disabled", entry[0], s[entry[1]])
		theme.set_color(&"font_color", entry[0], T.TEXT_PRIMARY)
	theme.set_type_variation(&"AppearanceOption", &"ItemSlot")
	theme.set_type_variation(&"SelectedAppearanceOption", &"AppearanceOption")
	theme.set_stylebox(&"normal", &"SelectedAppearanceOption", s["item_selected"])
	theme.set_type_variation(&"LockedAppearanceOption", &"AppearanceOption")
	theme.set_stylebox(&"normal", &"LockedAppearanceOption", s["item_locked"])
	theme.set_stylebox(&"disabled", &"LockedAppearanceOption", s["item_locked"])
	theme.set_stylebox(&"separator", &"HSeparator", s["divider"])


func _variation(theme: Theme, name: StringName, base: StringName, size: int, color: Color) -> void:
	theme.set_type_variation(name, base)
	theme.set_font_size(&"font_size", name, size)
	theme.set_color(&"font_color", name, color)


func _button_variation(
	theme: Theme,
	s: Dictionary,
	name: StringName,
	normal: String,
	hover: String,
	pressed: String = "button_primary_pressed"
) -> void:
	theme.set_type_variation(name, &"Button")
	theme.set_stylebox(&"normal", name, s[normal])
	theme.set_stylebox(&"hover", name, s[hover])
	theme.set_stylebox(&"pressed", name, s[pressed])


func _style(
	background: Color,
	border: Color,
	radius: int,
	margins: Vector4,
	shadow: bool = false,
	border_width: int = 2
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.content_margin_left = margins.x
	style.content_margin_top = margins.y
	style.content_margin_right = margins.z
	style.content_margin_bottom = margins.w
	style.anti_aliasing = true
	if shadow:
		style.shadow_color = T.SHADOW
		style.shadow_size = 10
		style.shadow_offset = Vector2(0, 4)
	return style
