extends RefCounted

const BACKGROUND_DEEP := Color("#17212B")
const BACKGROUND_WARM := Color("#EDE8DE")
const SURFACE_PRIMARY := Color("#F6F1E8")
const SURFACE_SECONDARY := Color("#DDD5C7")
const PRIMARY := Color("#356A96")
const PRIMARY_HOVER := Color("#427FAC")
const PRIMARY_PRESSED := Color("#294F72")
const SECONDARY := Color("#466B59")
const SECONDARY_HOVER := Color("#567D68")
const ACCENT_GOLD := Color("#B8893C")
const ACCENT_BURGUNDY := Color("#8E4545")
const TEXT_PRIMARY := Color("#252B31")
const TEXT_SECONDARY := Color("#62676C")
const TEXT_ON_DARK := Color("#F4F0E8")
const BORDER_DEFAULT := Color("#958878")
const BORDER_SELECTED := Color("#C69B4B")
const DANGER := Color("#A64C4C")
const SUCCESS := Color("#4F765F")
const WARNING := Color("#B47B32")

const DISABLED_SURFACE := Color("#C7C0B5")
const DISABLED_TEXT := Color("#5F6264")
const ITEM_HOVER := Color("#CBD5DE")
const EPIC := Color("#725B83")
const SECONDARY_BORDER := Color("#304B3E")
const GOLD_BORDER := Color("#765724")
const GOLD_HOVER := Color("#C99B4C")
const BURGUNDY_BORDER := Color("#603030")
const STATUS_BACKGROUND := Color("#303A43")
const STATUS_BORDER := Color("#111820")
const TRANSPARENT := Color(0.0, 0.0, 0.0, 0.0)
const SHADOW := Color(0.07, 0.09, 0.11, 0.24)
const MODAL_BACKDROP := Color(0.05, 0.07, 0.09, 0.72)

const FONT_SIZE_TITLE := 34
const FONT_SIZE_SCREEN_HEADING := 26
const FONT_SIZE_PANEL_HEADING := 20
const FONT_SIZE_BODY := 16
const FONT_SIZE_BUTTON := 16
const FONT_SIZE_CAPTION := 13

const SPACE_XS := 4
const SPACE_SM := 8
const SPACE_MD := 16
const SPACE_LG := 24
const SPACE_XL := 32


static func get_color(token: StringName) -> Color:
	var tokens := {
		&"background_deep": BACKGROUND_DEEP,
		&"background_warm": BACKGROUND_WARM,
		&"surface_primary": SURFACE_PRIMARY,
		&"surface_secondary": SURFACE_SECONDARY,
		&"primary": PRIMARY,
		&"secondary": SECONDARY,
		&"accent_gold": ACCENT_GOLD,
		&"accent_burgundy": ACCENT_BURGUNDY,
		&"text_primary": TEXT_PRIMARY,
		&"text_secondary": TEXT_SECONDARY,
		&"text_on_dark": TEXT_ON_DARK,
		&"border_default": BORDER_DEFAULT,
		&"border_selected": BORDER_SELECTED,
		&"danger": DANGER,
		&"success": SUCCESS,
		&"warning": WARNING,
		&"item_hover": ITEM_HOVER,
		&"epic": EPIC,
	}
	return tokens.get(token, TEXT_PRIMARY)
