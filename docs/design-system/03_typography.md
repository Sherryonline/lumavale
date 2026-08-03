# LumaVale Typography Guideline

**Document owner:** UI Design / Technical UI  
**Target platforms:** Desktop and Web  
**Excluded target:** Mobile  
**Applies to:** Menus, HUD, dialogue, tooltips, forms, notifications, debug-disabled production UI

---

## 1. Typography Vision

LumaVale typography must feel elegant, warm, and crafted while remaining immediately readable during short desktop play sessions. Type supports the anime-inspired fantasy direction through proportion and hierarchy, not ornamental excess.

Readability takes priority over visual novelty. Decorative typography is reserved for large titles and branding. Every gameplay label, button, stat, description, and validation message uses a highly legible UI family.

This guideline is designed for mouse, keyboard, controller, desktop monitors, laptops, and browser canvas rendering. It does not include mobile breakpoints, touch sizing, narrow portrait layouts, or mobile font-performance compromises.

---

## 2. Recommended Font Families

### Production pairing

| Role | Preferred family | Approved alternatives | Use |
|---|---|---|---|
| UI and body | **Source Sans 3** | Noto Sans, Atkinson Hyperlegible | Buttons, labels, dialogue, forms, stats, tooltips |
| Display | **Lora** | Fraunces, Source Serif 4 | Logo support, screen titles, major section titles |
| CJK fallback | **Noto Sans CJK** | Platform-specific Noto Sans subset | Localized UI where the primary family lacks glyphs |
| Monospace | **JetBrains Mono** | Noto Sans Mono | Developer-only diagnostics; never standard player UI |

Use font files from the author or an approved type foundry and record their licenses. Prefer static Regular, Medium, Semibold, and Bold files when variable-font behavior has not been validated in Godot Web.

### Weight policy

- **Regular 400:** body text, descriptions, dialogue.
- **Medium 500:** metadata, tabs, compact labels.
- **Semibold 600:** buttons, card titles, panel headings.
- **Bold 700:** screen titles and critical numeric emphasis.
- Avoid Thin, ExtraLight, and Black weights in production UI.
- Do not simulate bold or italic when a real font face is available.

Until production fonts are bundled, Godot's default font is an acceptable development fallback. System fonts are not acceptable for final Web presentation because appearance and metrics vary by operating system.

---

## 3. Font Hierarchy

All sizes are logical UI pixels before an approved accessibility scale is applied.

| Token | Base size | Weight | Line height | Typical use |
|---|---:|---:|---:|---|
| `FONT_DISPLAY` | 40 px | 700 | 48 px / 1.20 | Brand title and rare hero messaging |
| `FONT_TITLE` | 34 px | 700 | 41 px / 1.20 | Screen title |
| `FONT_SCREEN_HEADING` | 28 px | 600–700 | 35 px / 1.25 | Main content heading |
| `FONT_PANEL_HEADING` | 20 px | 600 | 26 px / 1.30 | Panel and section title |
| `FONT_BODY_LARGE` | 18 px | 400 | 27 px / 1.50 | Introductory copy and prominent dialogue |
| `FONT_BODY` | 16 px | 400 | 24 px / 1.50 | Standard body and descriptions |
| `FONT_BUTTON` | 16 px | 600 | 20 px / 1.25 | Buttons, tabs, compact actions |
| `FONT_CAPTION` | 14 px | 400–500 | 19 px / 1.36 | Metadata and supporting labels |

### Minimum readable sizes

- **14 px is the absolute production minimum.**
- Body copy must be at least **16 px**.
- Form values, buttons, dialogue, and tooltips must be at least **16 px**.
- Text over environmental imagery should be at least **16 px** and placed on an opaque or strongly controlled surface.
- Do not use 12–13 px text to solve layout overflow. Add scrolling, wrapping, responsive reflow, or reduce content density instead.

The existing 13 px caption token should be migrated to 14 px when the production font is introduced.

---

## 4. Line Height

Line height is based on purpose rather than a universal multiplier.

- **Display and titles:** 1.15–1.25 times font size.
- **Headings:** 1.25–1.35 times font size.
- **Body and dialogue:** 1.45–1.60 times font size.
- **Captions and metadata:** 1.30–1.40 times font size.
- **Buttons and single-line controls:** center vertically within the component; do not force paragraph line height.

For multiline Godot labels, use Theme constants and container separation to achieve the approved rhythm. Do not scale a label vertically to simulate leading.

Avoid lines longer than approximately 70 characters for continuous reading. Dialogue and tooltip descriptions should generally target 40–65 characters per line.

---

## 5. Letter Spacing

Letter spacing must remain restrained because excessive tracking weakens readability and changes localization behavior.

| Context | Tracking target |
|---|---:|
| Display title | `0` to `+1.0 px` |
| Uppercase eyebrow label | `+0.5` to `+1.0 px` |
| Heading | `0` to `+0.25 px` |
| Body text | `0 px` |
| Button label | `0` to `+0.25 px` |
| Numeric stats | `0 px`; use tabular figures when available |

Never use negative tracking to force text into a fixed width. Never apply wide tracking to paragraphs, dialogue, or localized strings.

---

## 6. Paragraph Spacing

- Space between paragraphs: **0.75–1.0 body line height**.
- Space between a label and its description: **8 px** at 100% UI scale.
- Space between related description blocks: **12–16 px**.
- Space between unrelated content groups: **24–32 px**.
- Do not create paragraph separation with repeated newline characters. Use Containers and theme spacing tokens.
- Do not indent the first line of UI paragraphs.

Rich text content must define spacing through theme or BBCode conventions shared by the entire content type.

---

## 7. Heading Spacing

- Screen title to subtitle: **4–8 px**.
- Heading to first content item: **12–16 px**.
- Previous section content to next heading: **24–32 px**.
- Panel heading to divider: **8 px**.
- Divider to panel content: **12 px**.

Headings must stay attached to the content they introduce. A heading must never appear alone at the bottom of a scroll viewport while its content starts outside the visible area.

Use one `FONT_TITLE` per screen. Do not skip hierarchy levels purely for visual size.

---

## 8. Accessibility

### Readability

- Meet WCAG 2.2 AA color contrast defined in the Color Palette documentation.
- Do not rely on font weight or color alone to communicate selection, errors, rarity, or locked state.
- Preserve readable text at **100%, 125%, 150%, 175%, and 200%** UI scale.
- Reflow content through Containers and ScrollContainers; never crop essential text.
- Use smart word wrapping for descriptions and dialogue.
- Use ellipsis only for compact, nonessential labels whose full value is available through a tooltip or adjacent detail view.

### Language support

- Test real localized strings, not repeated placeholder characters.
- Allow at least 30% expansion for translated interface copy.
- Verify glyph coverage, diacritics, punctuation, shaping, and fallback metrics before approving a font.
- Do not manually split words or insert line breaks that only work in English.

### Motion and focus

Text must never pulse, continuously glow, or animate solely to attract attention. Focused controls use a stable visible outline. Reduced-motion settings disable decorative text transitions without removing state feedback.

---

## 9. High-DPI Support

Godot should remain DPI-aware. Do not disable the project's HiDPI support to make the interface appear larger. Instead, use the centralized UI scale and integer theme font sizes.

### Required behavior

- Support 1× and 2× device pixel ratios on desktop and Web.
- Apply UI scale by rebuilding theme font sizes and spacing, not by transforming the root `Control`.
- Round scaled font sizes to whole integers.
- Test 1280×720, 1600×900, 1920×1080, and at least one 16:10 resolution.
- Inspect text at 100% screenshot scale; do not judge sharpness only while the image is zoomed in an editor.

For non-pixel-art desktop presentation, prefer a configuration that renders UI at the target resolution. Godot's `canvas_items` stretch mode renders directly at target resolution, while `viewport` mode first renders at the base viewport and then scales the completed image. A low-resolution viewport upscale can soften otherwise correct text.

Any change to the current stretch strategy must be tested against world rendering, pixel-aligned game assets, SubViewports, and all supported resolutions before it enters production.

---

## 10. Browser Rendering

Godot Web renders the game UI inside its canvas. Typography is therefore controlled by Godot font resources and the exported project package, not by the surrounding page's CSS font stack.

- Bundle approved font files in the project and verify they are included in the Web export.
- Do not depend on a font installed on the player's computer.
- Verify the browser console contains no missing font or resource errors.
- Test Chromium, Firefox, and Safari-compatible Web builds when those browsers enter the support matrix.
- Test browser zoom at 100% and 125% and verify text remains sharp and layouts reflow without clipping.
- Test operating-system display scaling at 100%, 125%, and 200% where available.
- Avoid fractional canvas dimensions introduced by custom HTML or CSS wrappers.
- Keep the canvas resize policy consistent with the project resolution strategy.

Browser antialiasing may differ slightly by graphics backend and operating system. Approval is based on readability and stability, not pixel-identical glyph rasterization across platforms.

---

## 11. Godot Theme Usage

Typography belongs in the centralized `Theme` resource and named theme type variations. Individual component scenes must not duplicate font files, colors, or arbitrary font sizes.

### Theme responsibilities

- Define the default UI font.
- Define integer font sizes for `Label`, `Button`, `LineEdit`, `RichTextLabel`, and component-specific type variations.
- Define text colors, outline colors, outline sizes, and control spacing.
- Provide variations such as `TitleLabel`, `PanelHeading`, `CaptionLabel`, and `SecondaryLabel`.
- Rebuild derived sizes when the player changes UI scale.

### Typed GDScript example

```gdscript
const MINIMUM_FONT_SIZE := 14


func scaled_font_size(base_size: int, ui_scale: float) -> int:
	return maxi(MINIMUM_FONT_SIZE, roundi(float(base_size) * ui_scale))


func apply_typography(theme: Theme, ui_scale: float) -> void:
	theme.set_font_size(
		&"font_size",
		&"Label",
		scaled_font_size(16, ui_scale)
	)
	theme.set_font_size(
		&"font_size",
		&"Button",
		scaled_font_size(16, ui_scale)
	)
	theme.set_font_size(
		&"font_size",
		&"TitleLabel",
		scaled_font_size(34, ui_scale)
	)
```

Use local theme overrides only for a documented semantic exception. Repeated overrides indicate that a theme type variation or token is missing.

---

## 12. Avoiding Blurry Text in Godot

This section is a production gate. A screen with blurred text cannot be approved.

### 12.1 Never transform text controls

Keep every `Control` containing text at `scale = Vector2.ONE`. Do not animate or resize text by changing node scale. Do not scale a parent `Control`, `CanvasLayer`, or container that contains labels.

To make text larger or smaller, change the integer font size through the Theme. To animate emphasis, change color, border, underline, or content position without scaling the glyphs.

### 12.2 Avoid low-resolution UI upscaling

Do not render production UI inside a low-resolution `SubViewport` and enlarge it. Keep text outside character-preview and world-render SubViewports.

`viewport` stretch mode renders the complete frame at the base viewport before scaling it to the window. This is appropriate for strict pixel-art presentation but can soften HD typography at fractional or non-native scale factors. For the HD desktop/Web direction, evaluate `canvas_items` or a native-resolution UI layer.

### 12.3 Use integer sizes and stable positions

- Font sizes must be whole integers.
- Theme-scaled sizes must use `roundi()` or an equivalent deterministic rule.
- Avoid fractional scale transforms and continuously moving labels.
- Prefer Container-driven layout and integer spacing tokens.
- Pixel snapping for sprites does not replace correct font configuration.

### 12.4 Choose the correct font rendering mode

For standard 14–20 px UI text, traditional rasterized fonts with appropriate hinting often provide the clearest small-size result. Use Light or Full hinting based on visual testing; enable the autohinter only when the font lacks usable hinting data.

Use MSDF for fonts that must render across many large sizes, zoom levels, or display-title treatments. MSDF stays crisp at large sizes but can be less clear than hinted raster text at small sizes. Do not enable MSDF globally without comparing body text at 14, 16, and 18 px.

For rasterized fonts, oversampling can improve quality when the project scale requires it. MSDF ignores traditional oversampling. If a font is ever downscaled, test mipmaps; the preferred solution remains rendering at the intended font size rather than shrinking a text node.

If an MSDF font uses an outline, configure sufficient MSDF pixel range for that outline and inspect corners, counters, and thin strokes for artifacts.

### 12.5 Filtering is not one-size-fits-all

Nearest-neighbor filtering is appropriate for pixel-art bitmap fonts rendered at exact integer multiples. It is not the default solution for HD vector fonts. Do not force a smooth HD font through pixel-art-only filtering rules.

### 12.6 Verify the final path

Check sharpness in the exported Web build, not only in the Godot editor. Inspect:

1. Native desktop window.
2. Web export at browser zoom 100%.
3. Web export at browser zoom 125%.
4. UI scale 100% and 200%.
5. Light text on dark fills and dark text on light surfaces.
6. Static labels, scrolling content, inputs, and animated panels.

If text is sharp in the editor but blurry in Web, inspect canvas CSS dimensions versus backing resolution, browser zoom, viewport stretch, parent transforms, and font import settings in that order.

---

## 13. Do and Don't

| Do | Don't |
|---|---|
| Set sizes through centralized Theme tokens. | Scale a Label or its parent to change text size. |
| Use 16 px or larger for body and controls. | Reduce copy to 12 px to make a panel fit. |
| Round every scaled font size to an integer. | Produce fractional font sizes or transform scales. |
| Use Source Sans 3 or another approved readable UI family. | Use a decorative serif for body text or stats. |
| Use real font weights. | Simulate bold or stretch glyphs horizontally. |
| Wrap descriptions and provide scroll overflow. | Clip essential copy or hard-code English line breaks. |
| Bundle and license production fonts. | Depend on the user's system font in the Web build. |
| Test hinting, MSDF, and oversampling at actual sizes. | Assume MSDF or nearest filtering fixes every font. |
| Render UI at an appropriate target resolution. | Upscale low-resolution UI for an HD presentation. |
| Test browser zoom and OS display scale. | Approve typography from editor screenshots alone. |

---

## 14. Examples

### Correct hierarchy

```text
LumaVale                         34 px / Bold
Create Your Adventurer          28 px / Semibold
Choose Your Role                20 px / Semibold
Rangers excel at speed...       16 px / Regular, 24 px line height
Difficulty: Moderate            14 px / Medium, secondary color
CONFIRM CHARACTER               16 px / Semibold
```

### Correct responsive scaling

```text
Base body size: 16 px
100% UI scale: 16 px
125% UI scale: 20 px
150% UI scale: 24 px
175% UI scale: 28 px
200% UI scale: 32 px
```

Every result is an integer Theme font size. The `Label` remains at `scale = (1, 1)`.

### Incorrect scaling

```gdscript
# DON'T: fractional transforms blur glyphs and distort layout metrics.
label.scale = Vector2(1.25, 1.25)
panel.scale = Vector2.ONE * ui_scale
```

### Correct scaling

```gdscript
# DO: update the semantic font size and let Containers reflow.
var size := maxi(14, roundi(16.0 * ui_scale))
label.add_theme_font_size_override(&"font_size", size)
```

The local override above is suitable for a focused prototype or exceptional runtime case. Production components should receive the same value from the centralized Theme or ThemeManager.

---

## 15. Approval Checklist

- Font family and license are approved.
- Glyph coverage is verified for supported languages.
- No production text is below 14 px.
- Body, buttons, inputs, and tooltips are at least 16 px.
- Contrast passes in every interaction state.
- No parent transform scales text.
- Font sizes remain integers at every UI scale.
- Text reflows without clipping at target resolutions.
- HiDPI rendering is sharp at 1× and 2× device scale.
- Web rendering is checked at 100% and 125% browser zoom.
- No missing-font or glyph warnings appear in the browser console.

---

## References

- [Godot: Using Fonts](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_fonts.html)
- [Godot: Multiple Resolutions](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html)
- [Godot: Theme API](https://docs.godotengine.org/en/stable/classes/class_theme.html)
