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

const STATE_NORMAL := &"normal"
const STATE_HOVER := &"hover"
const STATE_PRESSED := &"pressed"
const STATE_FOCUSED := &"focused"
const STATE_SELECTED := &"selected"
const STATE_DISABLED := &"disabled"
const STATE_LOCKED := &"locked"

const TYPOGRAPHY_DISPLAY := 40
const TYPOGRAPHY_HEADING := 30
const TYPOGRAPHY_SECTION := 22
const TYPOGRAPHY_BODY := 16
const TYPOGRAPHY_CAPTION := 14

const FONT_SIZE_TITLE := 34
const FONT_SIZE_SCREEN_TITLE := 30
const FONT_SIZE_SCREEN_HEADING := 30
const FONT_SIZE_PANEL_HEADING := 22
const FONT_SIZE_BODY := 16
const FONT_SIZE_BUTTON := 16
const FONT_SIZE_CAPTION := 14

const SPACE_XXS := 2
const SPACE_XS := 4
const SPACE_SM := 8
const SPACE_12 := 12
const SPACE_MD := 16
const SPACE_LG := 24
const SPACE_XL := 32
const SPACE_2XL := 48

const RADIUS_SM := 8
const RADIUS_MD := 10
const RADIUS_BUTTON := 11
const RADIUS_LG := 12
const RADIUS_XL := 14

const BORDER_STANDARD := 2
const BORDER_FOCUS := 3

const ELEVATION_STANDARD_OPACITY := 0.24
const ELEVATION_MODAL_OPACITY := 0.28

const DURATION_HOVER := 0.12
const DURATION_PRESS := 0.08
const DURATION_TAB := 0.14
const DURATION_MODAL := 0.20
const DURATION_STATUS := 0.22

const INTERNAL_RESOLUTION := Vector2i(960, 540)
const TARGET_RESOLUTION := Vector2i(1280, 720)


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
