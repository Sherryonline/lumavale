# LumaVale Color Palette

**Document owner:** Art Direction / UI Design  
**Applies to:** Game UI, HUD, menus, overlays, notifications, web presentation  
**Visual target:** Elegant · Warm · Natural · Premium · Accessible

---

## 1. Palette Strategy

LumaVale uses semantic color tokens. A token describes purpose, not a single screen or asset. Components must reference tokens through the centralized theme rather than declaring local colors.

The palette is intentionally restrained. Forest greens communicate trust and life, muted gold communicates importance and craft, warm ivory surfaces keep screens welcoming, and charcoal text provides clarity without the severity of pure black.

### Core principles

- Use color to establish hierarchy, not decoration alone.
- Prefer warm, slightly desaturated colors over neon or fully saturated hues.
- Reserve gold for selection and one primary action per screen.
- Never communicate selected, warning, error, success, rarity, or locked state using color alone.
- Validate text contrast in the final component state, including hover, pressed, disabled, and dark mode.
- Do not create one-off colors when an existing semantic token expresses the intended role.

---

## 2. Accessibility Standard

The production target is WCAG 2.2 AA:

- Normal text: minimum contrast ratio **4.5:1**.
- Large text: minimum contrast ratio **3:1**.
- Focus indicators and meaningful non-text controls: minimum contrast ratio **3:1** against adjacent colors.
- Disabled controls are exempt from WCAG contrast minimums, but must remain understandable and must retain labels or icons.
- Success, warning, and error states must include an icon, label, shape, or message in addition to color.

`TEXT_PRIMARY` is used on light surfaces. Light text on dark or colored fills uses the companion token `TEXT_ON_DARK` (`#F4F0E8`, RGB `244, 240, 232`). Gold and warning fills use `TEXT_PRIMARY` rather than light text.

---

## 3. Semantic Tokens

### PRIMARY_FOREST

- **HEX:** `#355C4A`
- **RGB:** `53, 92, 74`
- **Usage:** Primary navigation, standard primary buttons, active tabs, major forest-aligned branding surfaces.
- **Accessibility:** Use `TEXT_ON_DARK`; contrast is approximately **6.64:1**. Add a visible focus ring and never rely on fill color alone for selection.
- **Hover:** `#426D59` — RGB `66, 109, 89`
- **Pressed:** `#29483A` — RGB `41, 72, 58`
- **Disabled:** `#A8B4AC` — RGB `168, 180, 172`
- **Dark mode compatibility:** Use `#70967F` on dark backgrounds, paired with `TEXT_PRIMARY`. Keep a border or elevation change between the control and dark surface.

### PRIMARY_EMERALD

- **HEX:** `#476F59`
- **RGB:** `71, 111, 89`
- **Usage:** Positive progression, secondary primary actions, active gameplay systems, energy and nature accents.
- **Accessibility:** Use `TEXT_ON_DARK`; contrast is approximately **5.01:1**. Do not place emerald body text directly on ivory backgrounds.
- **Hover:** `#4C755F` — RGB `76, 117, 95`
- **Pressed:** `#3A5C49` — RGB `58, 92, 73`
- **Disabled:** `#B1BDB5` — RGB `177, 189, 181`
- **Dark mode compatibility:** Use `#7EA68D` with `TEXT_PRIMARY`, or retain the base color with `TEXT_ON_DARK` when used as a self-contained button fill.

### ACCENT_GOLD

- **HEX:** `#C09345`
- **RGB:** `192, 147, 69`
- **Usage:** Confirm actions, selected borders, key rewards, premium details, important markers. Limit to one dominant gold action per screen.
- **Accessibility:** Use `TEXT_PRIMARY`, not cream or white. Gold selection must also include a check mark, border weight, or label.
- **Hover:** `#C99B4C` — RGB `201, 155, 76`
- **Pressed:** `#B8893C` — RGB `184, 137, 60`
- **Disabled:** `#C9C0AE` — RGB `201, 192, 174`
- **Dark mode compatibility:** Use `#D0AA61` for small accents. Avoid large bright gold panels; pair with dark charcoal text for filled controls.

### TEXT_PRIMARY

- **HEX:** `#252B31`
- **RGB:** `37, 43, 49`
- **Usage:** Headings, body text, input values, important labels on light backgrounds.
- **Accessibility:** Approximately **11.71:1** on `BACKGROUND` and **12.71:1** on `SURFACE`. This is the default text token for light mode.
- **Hover:** `#1F262C` — RGB `31, 38, 44`; use only for interactive text.
- **Pressed:** `#171D22` — RGB `23, 29, 34`; use only for interactive text.
- **Disabled:** `#858783` — RGB `133, 135, 131`
- **Dark mode compatibility:** Replace with `#F4F0E8` — RGB `244, 240, 232`.

### TEXT_SECONDARY

- **HEX:** `#62676C`
- **RGB:** `98, 103, 108`
- **Usage:** Descriptions, metadata, captions, helper text, secondary values.
- **Accessibility:** Approximately **4.68:1** on `BACKGROUND` and **5.08:1** on `SURFACE`. Do not use below 14 px or over imagery.
- **Hover:** `#555C62` — RGB `85, 92, 98`; use only when the text itself is interactive.
- **Pressed:** `#454C52` — RGB `69, 76, 82`
- **Disabled:** `#9A9B96` — RGB `154, 155, 150`
- **Dark mode compatibility:** Replace with `#C8C1B5` — RGB `200, 193, 181`.

### BACKGROUND

- **HEX:** `#EDE8DE`
- **RGB:** `237, 232, 222`
- **Usage:** Primary light-mode screen background and quiet negative space.
- **Accessibility:** Supports both text tokens. Important text should still sit on a controlled surface when scenery or illustration is present.
- **Hover:** `#E8E2D8` — RGB `232, 226, 216`; only when the background participates in an interactive region.
- **Pressed:** `#DED7CB` — RGB `222, 215, 203`
- **Disabled:** `#E5E0D7` — RGB `229, 224, 215`
- **Dark mode compatibility:** Replace with `#17212B` — RGB `23, 33, 43`.

### SURFACE

- **HEX:** `#F6F1E8`
- **RGB:** `246, 241, 232`
- **Usage:** Cards, panels, menus, input backgrounds, tool windows, and readable content regions.
- **Accessibility:** Use `TEXT_PRIMARY` for body copy and `TEXT_SECONDARY` for supporting copy. Maintain a visible edge against `BACKGROUND` through border or elevation.
- **Hover:** `#EEE8DE` — RGB `238, 232, 222`
- **Pressed:** `#E4DDD2` — RGB `228, 221, 210`
- **Disabled:** `#DED9D0` — RGB `222, 217, 208`
- **Dark mode compatibility:** Replace with `#222F3A` — RGB `34, 47, 58`; use light text tokens.

### BORDER

- **HEX:** `#958878`
- **RGB:** `149, 136, 120`
- **Usage:** Standard panel edges, field outlines, separators, and inactive card borders.
- **Accessibility:** Approximately **3.07:1** against `SURFACE`, suitable for meaningful control boundaries. Focus and selection must use stronger dedicated treatments.
- **Hover:** `#7E7265` — RGB `126, 114, 101`
- **Pressed:** `#675D52` — RGB `103, 93, 82`
- **Disabled:** `#C7C0B5` — RGB `199, 192, 181`
- **Dark mode compatibility:** Replace with `#65717A` — RGB `101, 113, 122`.

### WARNING

- **HEX:** `#C8954A`
- **RGB:** `200, 149, 74`
- **Usage:** Recoverable risk, caution messages, inventory limits, and actions requiring attention but not failure.
- **Accessibility:** Use `TEXT_PRIMARY` on warning fills. Always add a warning icon and concise label. Do not use warning gold for ordinary decoration.
- **Hover:** `#D2A35C` — RGB `210, 163, 92`
- **Pressed:** `#B8893C` — RGB `184, 137, 60`
- **Disabled:** `#C9BEAB` — RGB `201, 190, 171`
- **Dark mode compatibility:** Use `#D8A457` — RGB `216, 164, 87`, paired with `TEXT_PRIMARY`.

### ERROR

- **HEX:** `#A64C4C`
- **RGB:** `166, 76, 76`
- **Usage:** Validation errors, failed actions, unavailable destructive operations, and critical negative status.
- **Accessibility:** Use `TEXT_ON_DARK`; contrast is approximately **4.91:1**. Include an error icon and actionable text. Error must not be represented by a red border alone.
- **Hover:** `#9A4545` — RGB `154, 69, 69`
- **Pressed:** `#7E3434` — RGB `126, 52, 52`
- **Disabled:** `#C7ADAA` — RGB `199, 173, 170`
- **Dark mode compatibility:** Use `#D47770` — RGB `212, 119, 112`, normally as text/icon on dark surfaces rather than a large fill.

### SUCCESS

- **HEX:** `#4F765F`
- **RGB:** `79, 118, 95`
- **Usage:** Completed actions, valid form states, successful crafting, connection confirmation, and positive status.
- **Accessibility:** Use `TEXT_ON_DARK`; contrast is approximately **4.52:1**. Include a check mark or success label.
- **Hover:** `#466A55` — RGB `70, 106, 85`
- **Pressed:** `#385545` — RGB `56, 85, 69`
- **Disabled:** `#B0BCB4` — RGB `176, 188, 180`
- **Dark mode compatibility:** Use `#7FA58A` — RGB `127, 165, 138`, primarily for icons, borders, and short status text.

---

## 4. Color Usage Rules

### 4.1 Hierarchy

1. `BACKGROUND` establishes the page field.
2. `SURFACE` groups content and protects text from detailed scenery.
3. `PRIMARY_FOREST` identifies standard primary interaction.
4. `PRIMARY_EMERALD` communicates progression and positive gameplay systems.
5. `ACCENT_GOLD` identifies the single most important action or selected state.

Do not place forest, emerald, and gold buttons at equal visual strength in the same action group.

### 4.2 Interaction states

- Every interactive component must implement normal, hover, pressed, focus, and disabled states.
- Hover and pressed colors must come from the token definition, not runtime lightening or darkening.
- Pressed state also uses a 1 px content offset or equivalent physical response.
- Focus uses a dedicated high-contrast outline and must remain visible independently of hover.
- Disabled state removes interaction emphasis but preserves the control label.

### 4.3 Text

- Use `TEXT_PRIMARY` for essential reading and `TEXT_SECONDARY` only for supporting information.
- Never lower opacity on text to create hierarchy; use the correct semantic token.
- Never place body text directly over detailed environment artwork.
- Do not use gold, green, warning, or error colors for paragraphs.
- Links and interactive text require underline, icon, or another non-color affordance.

### 4.4 Status and validation

- `SUCCESS`, `WARNING`, and `ERROR` are state colors, not brand decoration.
- Pair status colors with a consistent icon family and explicit language.
- Validation messages appear near the affected field and remain available to keyboard and assistive navigation.
- Destructive confirmation uses `ERROR`; cancellation remains neutral.

### 4.5 Selected and locked states

- Selected state uses gold border, check marker, and text label where space permits.
- Locked state uses reduced saturation, lock icon, and explanatory tooltip.
- Neither state may rely exclusively on hue.

### 4.6 Dark mode

- Dark mode is a semantic remap, not an inversion filter.
- Preserve relative hierarchy: background remains darker than surfaces; text remains brighter than supporting text.
- Revalidate every foreground/background pairing after remapping.
- Reduce the area of bright gold, warning, error, and success colors on dark screens.
- Environment art behind dark UI still requires a controlled overlay.

### 4.7 Prohibited usage

- No pure black (`#000000`) or pure white (`#FFFFFF`) as standard UI colors.
- No neon green, electric blue, or fully saturated red for routine interface states.
- No ad hoc alpha variations in place of semantic state tokens.
- No automatic hue shifts that change the meaning of status colors.
- No more than one gold-emphasis call to action in the same visual region.

---

## 5. Implementation Contract

Token names are the stable interface between design and code. Godot themes, reusable components, SVG icons, and generated UI assets must consume the centralized token source. If a new visual need cannot be expressed by this palette, request a token review; do not introduce a local hex value inside a component scene or script.

Any palette update requires:

1. Light- and dark-mode contrast review.
2. Component gallery review across all interaction states.
3. Gameplay HUD review over representative environments.
4. Verification at supported UI scales and target resolutions.
