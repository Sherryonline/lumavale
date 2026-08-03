# LumaVale UI Design System

**Document owner:** UI Director / Technical UI  
**Style:** Elegant Anime Fantasy  
**Target platforms:** Desktop and Web  
**Implementation:** Godot 4 Theme, StyleBoxFlat, Containers, typed reusable Controls

---

## 1. Design Intent

LumaVale UI combines the warmth of an illustrated fantasy journal with the discipline of a premium desktop RPG interface. Panels are tactile and softly dimensional, typography is crisp, and ornament is used to reinforce hierarchy rather than fill empty space.

The interface must feel authored, calm, and responsive. Player attention belongs first to the character and world, then to the current decision, and finally to supporting information.

### Core principles

1. **Readability before decoration.** Text and interaction states must remain clear over every environment.
2. **One visual priority.** Each screen has one dominant action or focal component.
3. **Semantic styling.** Components consume centralized color, typography, spacing, and state tokens.
4. **Fantasy through detail, not noise.** Use restrained gold lines, leaf-like corner marks, and illustrated icons sparingly.
5. **Accessible state communication.** Selection and locking never rely on color alone.
6. **Stable motion.** No control scales above `1.0`; transitions are brief and disabled by reduced-motion settings.

### Explicit exclusions

- No glassmorphism, frosted glass, translucent reading panels, or background blur.
- No heavy bloom, continuous glow, neon edges, or large luminous gradients.
- No default Godot gray controls.
- No important text directly over detailed scenery.
- No text or icon scaling through parent `Control` transforms.

---

## 2. Foundation Measurements

All measurements are logical pixels at **100% UI scale**. At 125–200%, ThemeManager scales values and rounds results to whole pixels.

### Spacing scale

| Token | Value | Usage |
|---|---:|---|
| `SPACE_XXS` | 2 px | Hairline optical adjustment only |
| `SPACE_XS` | 4 px | Icon-to-label micro gap, title-to-subtitle |
| `SPACE_SM` | 8 px | Related elements, compact rows |
| `SPACE_12` | 12 px | Control groups and card internals |
| `SPACE_MD` | 16 px | Standard component gap and compact padding |
| `SPACE_LG` | 24 px | Section separation and panel padding |
| `SPACE_XL` | 32 px | Major screen regions |
| `SPACE_2XL` | 48 px | Large composition separation |

Use only this scale. A one-pixel exception is permitted for borders, dividers, and pressed-state displacement.

### Radius scale

| Token | Value | Usage |
|---|---:|---|
| `RADIUS_SM` | 8 px | Item slots, appearance options, status bars |
| `RADIUS_MD` | 10–11 px | Inputs, tabs, buttons |
| `RADIUS_LG` | 12 px | Tooltips and compact dark panels |
| `RADIUS_XL` | 14 px | Fantasy panels, role cards, major surfaces |

Do not mix radii inside one component family without a documented hierarchy reason.

### Borders

- Standard border: **2 px**.
- Selected or keyboard-focus border: **3 px**.
- Divider: **1 px**.
- Border color comes from semantic tokens; no component-local hex colors.
- Selected state uses gold border plus a check marker.

### Shadows

- Standard elevated shadow: `0 px 4 px`, size/softness approximately `10 px`, opacity **20–24%**.
- Modal content may use up to **28%** shadow opacity.
- Pressed and disabled controls remove the elevated shadow.
- Shadows use neutral charcoal, never saturated color.
- No glow or bloom is used as a standard interaction state.

### Typography

- Screen title: **28–34 px**, bold.
- Panel heading: **20 px**, semibold.
- Body and controls: **16 px** minimum.
- Caption and metadata: **14 px** minimum.
- Refer to `03_typography.md` for line height, scaling, and Godot rendering rules.

### Interaction dimensions

- Standard button height: **44 px minimum**.
- Standard button width: **132 px minimum** where actions share a row.
- Compact interactive card or slot: **48 × 48 px minimum**.
- Focus outline remains fully visible and must not be clipped by a parent container.

---

## 3. State Language

Every interactive component implements the following state contract.

| State | Required treatment |
|---|---|
| Normal | Base semantic fill, standard border, readable label |
| Hover | Approved hover fill or border; 120 ms transition; no scale-up |
| Pressed | Approved pressed fill, shadow removed, content moves down 1 px |
| Focused | 3 px visible gold focus outline independent of hover |
| Selected | Gold border plus check, indicator, underline, or explicit label |
| Disabled | Muted fill and readable label; no pointer or keyboard activation |
| Locked | Disabled interaction plus desaturation, lock icon, and explanatory tooltip |

Focused state may coexist with Hover or Selected. Focus treatment is additive and may not replace the selected marker.

---

## 4. Primary Button

### Purpose

Executes the standard forward action for a section or workflow. Use forest/primary styling. A screen may contain several primary buttons only when they belong to clearly separate regions.

### Anatomy

Optional leading icon · centered label · optional trailing shortcut hint · focus outline.

### Measurements

- **Spacing:** 8 px icon-to-label; 16 px between adjacent buttons.
- **Padding:** 18 px left/right; 11 px top/bottom.
- **Minimum size:** 132 × 44 px.
- **Radius:** 11 px.
- **Border:** 2 px dark primary border; 3 px gold when focused.
- **Shadow:** 0/4, size 10, 20–24% opacity in Normal and Hover.
- **Typography:** 16 px semibold, `TEXT_ON_DARK`.

### States

- **Normal:** `PRIMARY_FOREST` fill; standard border and shadow.
- **Hover:** `PRIMARY_FOREST` hover token; 120 ms color transition.
- **Pressed:** pressed token; no shadow; vertical content padding becomes 12/10 px to create a 1 px downshift.
- **Focused:** 3 px gold outline; label and fill remain unchanged.
- **Selected:** Not used for momentary actions. If configured as a toggle, add a check marker and selected label.
- **Disabled:** disabled surface and text; no shadow or hover transition.
- **Locked:** Disabled treatment plus lock icon and reason tooltip; avoid locking routine navigation.

---

## 5. Secondary Button

### Purpose

Supports neutral alternatives such as Back, Cancel, Randomize, and secondary tools without competing with the main action.

### Anatomy

Optional leading icon · centered label · optional shortcut hint · focus outline.

### Measurements

- **Spacing:** 8 px icon-to-label; 12–16 px to neighboring actions.
- **Padding:** 18 px horizontal; 11 px vertical.
- **Minimum size:** 132 × 44 px.
- **Radius:** 11 px.
- **Border:** 2 px secondary border; 3 px gold focus outline.
- **Shadow:** Same as Primary Button; removed when pressed or disabled.
- **Typography:** 16 px semibold, high-contrast light text.

### States

- **Normal:** muted secondary green fill.
- **Hover:** approved secondary hover fill; no glow or scale.
- **Pressed:** dark secondary fill, 1 px content downshift.
- **Focused:** 3 px gold outline.
- **Selected:** Add check marker only when explicitly functioning as a toggle.
- **Disabled:** neutral disabled fill and readable text.
- **Locked:** Lock icon and tooltip; do not use color alone.

---

## 6. Accent Button

### Purpose

Represents the single highest-priority action on a screen, such as Confirm Character or Complete Crafting.

### Anatomy

Importance marker · optional leading icon · centered label · focus outline.

### Measurements

- **Spacing:** 8 px icon-to-label; at least 16 px separation from other action classes.
- **Padding:** 18 px horizontal; 11 px vertical.
- **Minimum size:** 132 × 44 px; prefer 160–220 px for final confirmation.
- **Radius:** 11 px.
- **Border:** 2 px dark-gold border; 3 px focus outline.
- **Shadow:** Standard neutral shadow only; never gold glow.
- **Typography:** 16 px semibold using dark `TEXT_PRIMARY` for contrast.

### States

- **Normal:** `ACCENT_GOLD` fill with a small persistent importance marker.
- **Hover:** approved gold hover token; 120 ms transition.
- **Pressed:** gold pressed token, shadow removed, content down 1 px.
- **Focused:** 3 px high-contrast outline outside the standard border.
- **Selected:** Gold alone is insufficient; add check marker or “Selected” label if toggle behavior is required.
- **Disabled:** neutral disabled surface; marker is muted but label remains readable.
- **Locked:** Use sparingly; lock icon and unmet requirement message are mandatory.

---

## 7. Danger Button

### Purpose

Executes destructive or irreversible actions. It is never used merely to attract attention.

### Anatomy

Optional warning icon · explicit action label · optional consequence hint · focus outline.

### Measurements

- **Spacing:** 8 px icon-to-label; 24 px from the safe/default action where possible.
- **Padding:** 18 px horizontal; 11 px vertical.
- **Minimum size:** 132 × 44 px.
- **Radius:** 11 px.
- **Border:** 2 px dark burgundy; 3 px gold focus outline.
- **Shadow:** Standard neutral shadow; removed in Pressed and Disabled states.
- **Typography:** 16 px semibold, light high-contrast text.

### States

- **Normal:** restrained burgundy fill, never saturated red.
- **Hover:** approved error/danger hover token.
- **Pressed:** dark burgundy, 1 px downshift, no shadow.
- **Focused:** visible gold outline; do not replace the danger identity.
- **Selected:** Not applicable to momentary destructive actions.
- **Disabled:** neutral disabled styling; explain why the action is unavailable when necessary.
- **Locked:** Avoid. If required, show lock icon and requirements rather than presenting a misleading danger action.

---

## 8. Fantasy Panel

### Purpose

Creates a protected reading and grouping surface over the environment. It is the standard container for forms, lists, role selection, and character information.

### Anatomy

Optional title row · optional divider · body slot · optional footer/action slot.

### Measurements

- **Spacing:** 8 px title-to-divider; 12 px divider-to-body; 16 px between body groups.
- **Padding:** 20 px left/right; 18 px top/bottom. Use 24 px for large feature panels.
- **Radius:** 14 px.
- **Border:** 2 px default border; 3 px gold when selected.
- **Shadow:** 0/4, size 10, 20–24% neutral opacity.
- **Typography:** 20 px semibold title; 16 px body; 14 px metadata.

### States

- **Normal:** Opaque warm ivory surface and standard border.
- **Hover:** No panel-wide hover unless the entire panel is interactive; interactive panels use a subtle border change.
- **Pressed:** Not applicable for noninteractive panels.
- **Focused:** Focus belongs to contained controls. An interactive panel uses a 3 px external outline.
- **Selected:** 3 px gold border and explicit selected marker.
- **Disabled:** Muted opaque surface; child controls disabled individually.
- **Locked:** Desaturated content, lock icon, and explanation; never blur the background.

---

## 9. Role Card

### Purpose

Presents and selects a playable role while communicating identity, description, difficulty, and availability.

### Anatomy

Portrait/icon · role name · short description · difficulty · selected indicator · lock overlay and icon.

### Measurements

- **Spacing:** 8 px between text rows; 12 px portrait-to-name; 16 px between cards.
- **Padding:** 16 px on all sides.
- **Minimum size:** 220 × 238 px; responsive lists may widen cards but must preserve content order.
- **Portrait:** 80 × 80 px minimum.
- **Radius:** 14 px.
- **Border:** 2 px standard; 3 px gold selected/focused treatment.
- **Shadow:** Standard card shadow in Normal/Hover/Selected; none when Disabled/Locked.
- **Typography:** 20 px semibold role name; 16 px description; 14 px difficulty.

### States

- **Normal:** Ivory surface, standard border, full-color portrait.
- **Hover:** Secondary warm surface and primary border; no card enlargement.
- **Pressed:** Brief pressed surface and 1 px content downshift.
- **Focused:** 3 px visible focus outline; keyboard focus remains distinct from selection.
- **Selected:** Gold 3 px border plus check marker; role name remains visible.
- **Disabled:** Muted surface and content; unavailable interaction.
- **Locked:** Desaturated portrait, lock icon, “Coming Soon” or reason text, and tooltip. Locked cards may receive focus only when the explanation is intentionally accessible.

---

## 10. Appearance Option

### Purpose

Selects one cosmetic choice within a named appearance category.

### Anatomy

Thumbnail/icon · compact option name · selected check · lock icon/label · tooltip target.

### Measurements

- **Spacing:** 8 px grid gap at compact density; 12 px in spacious layouts.
- **Padding:** 5 px internal style padding; maintain 4 px icon-to-edge clearance.
- **Minimum size:** 48 × 48 px; standard presentation is 72 × 72 px.
- **Radius:** 8 px.
- **Border:** 2 px standard; 3 px gold selected or focused.
- **Shadow:** None by default; selection relies on border and check mark.
- **Typography:** 14 px caption; names may use ellipsis only when full text appears in tooltip.

### States

- **Normal:** Secondary surface and standard border.
- **Hover:** Approved item hover surface and primary border.
- **Pressed:** Selected-preview feedback without changing unrelated categories.
- **Focused:** 3 px visible focus outline.
- **Selected:** Gold 3 px border and check mark in the top-right safe area.
- **Disabled:** Muted surface and icon; no activation.
- **Locked:** Desaturated thumbnail, lock icon, `LOCKED` label where space permits, and explanatory tooltip.

---

## 11. Item Slot

### Purpose

Displays an inventory or equipment item with quantity, rarity, equipped state, selection, and locking.

### Anatomy

Item icon · rarity marker/ornament · quantity label · equipped marker · selected check · lock icon.

### Measurements

- **Spacing:** 8 px between slots; 12 px between slot groups.
- **Padding:** 5 px internal padding.
- **Minimum size:** 48 × 48 px; standard size is 56 × 56 px.
- **Radius:** 8 px.
- **Border:** 2 px standard; 3 px gold when selected.
- **Shadow:** None; small slots remain visually stable.
- **Typography:** 14 px quantity and state labels; bottom-right quantity uses a controlled opaque backing when required.

### States

- **Normal:** Secondary surface, standard border, full item icon.
- **Hover:** Hover surface and primary border; tooltip may open after a short delay.
- **Pressed:** Pressed/selected-preview state; no scale animation.
- **Focused:** 3 px focus outline not hidden by rarity border.
- **Selected:** Gold border and check marker.
- **Disabled:** Muted icon and surface; quantity remains legible.
- **Locked:** Desaturation, lock icon, and reason tooltip. Rarity remains represented by ornament shape, not color alone.

Equipped state is independent of selection and uses an `E`, equipment icon, or explicit marker.

---

## 12. Tooltip Panel

### Purpose

Provides contextual detail without forcing navigation away from the current task.

### Anatomy

Title · type · rarity · description · stats · requirements · value. Empty sections collapse without leaving gaps.

### Measurements

- **Spacing:** 4 px metadata rows; 8 px section groups; 12 px before stats or requirements.
- **Padding:** 18 px horizontal; 16 px vertical.
- **Minimum width:** 280 px.
- **Maximum width:** 360 px for standard tooltips; long content wraps or uses a detail panel.
- **Radius:** 12 px.
- **Border:** 2 px muted gold.
- **Shadow:** 0/4, size 10, up to 28% opacity.
- **Typography:** 20 px semibold title; 16 px body; 14 px metadata. Use high-contrast light text.

### States

- **Normal:** Opaque dark charcoal surface; never translucent.
- **Hover:** Not applicable; tooltip must not react to pointer crossing if it ignores mouse input.
- **Pressed:** Not applicable.
- **Focused:** Appears from the focused source control using the same content as hover.
- **Selected:** Not applicable; persistent detail views use Fantasy Panel instead.
- **Disabled:** Source controls may still expose an explanatory tooltip.
- **Locked:** Requirements section explains the lock; lock icon may accompany the title.

---

## 13. Status Bar

### Purpose

Communicates current and maximum HP, Energy, Mana, or EXP with optional label and numeric value.

### Anatomy

Opaque track · semantic fill · left label · right numeric value · optional low-state indicator.

### Measurements

- **Spacing:** 8 px between stacked bars; 12–16 px between bar groups.
- **Padding:** 2 px internal track padding.
- **Minimum size:** 220 × 22 px.
- **Radius:** 8 px.
- **Border:** 2 px dark neutral border.
- **Shadow:** None.
- **Typography:** 14 px semibold, high-contrast light text.

### States

- **Normal:** Semantic fill over dark opaque track; label and numeric value visible.
- **Hover:** Optional detail tooltip; bar visuals do not brighten continuously.
- **Pressed:** Not applicable unless the bar is explicitly a button.
- **Focused:** Not focusable unless interactive; an interactive bar uses a 3 px focus outline.
- **Selected:** Optional parent-row selection, not a fill-color change.
- **Disabled:** Muted fill and readable value.
- **Locked:** Lock icon and requirement label replace unavailable progression detail.

Value interpolation uses approximately 180–250 ms and stops when complete. Reduced motion snaps to the value. Optional low-HP pulse is slow, at least 1.5 seconds per cycle, and uses opacity/shape restraint rather than bloom.

---

## 14. Tab Button

### Purpose

Switches between sibling content views without changing the larger navigation context.

### Anatomy

Optional icon · label · selected indicator line/marker · focus outline.

### Measurements

- **Spacing:** 4–8 px between tabs; 8 px icon-to-label.
- **Padding:** 14 px horizontal; 9 px vertical.
- **Minimum size:** 112 × 44 px.
- **Radius:** 9 px.
- **Border:** 2 px standard; selected uses gold accent border/indicator.
- **Shadow:** None.
- **Typography:** 16 px semibold.

### States

- **Normal:** Secondary surface and dark text.
- **Hover:** Subtle surface change and visible border.
- **Pressed:** Immediate content feedback; no scale.
- **Focused:** 3 px focus outline with keyboard-visible indicator.
- **Selected:** Primary fill plus gold indicator and persistent selected semantics.
- **Disabled:** Muted text and surface; skipped by activation.
- **Locked:** Lock icon and tooltip; use only when showing future/unavailable sections is valuable.

Indicator movement lasts 120–160 ms and is disabled under reduced motion.

---

## 15. Modal Backdrop

### Purpose

Separates a modal task from the underlying screen and blocks all pointer and keyboard interaction behind it.

### Anatomy

Full-screen input blocker · dark overlay · centered modal content slot managed by the parent screen.

### Measurements

- **Spacing:** Modal content remains at least 32 px from viewport safe edges.
- **Padding:** Backdrop has none; modal content uses its own Fantasy Panel padding.
- **Radius:** 0 px for backdrop.
- **Border:** None.
- **Shadow:** None on backdrop; modal panel may use up to 28% opacity shadow.
- **Typography:** None directly on backdrop.
- **Color:** Dark semi-opaque neutral, approximately 72% opacity. No blur.

### States

- **Normal:** Hidden when no modal is active.
- **Hover:** No visual change.
- **Pressed:** Optional outside-click dismissal only for non-destructive, reversible modals.
- **Focused:** Focus is trapped inside modal content, never on the backdrop.
- **Selected:** Visible/active state blocks all underlying input.
- **Disabled:** Not applicable; remove or hide the backdrop.
- **Locked:** Not applicable.

---

## 16. Section Header

### Purpose

Introduces a content group and provides consistent rhythm within panels and scroll areas.

### Anatomy

Optional 22 × 22 px icon · heading · optional subtle divider.

### Measurements

- **Spacing:** 8 px icon-to-heading; 8 px heading-row-to-divider; 12 px divider-to-content.
- **Padding:** 0 px internal; parent container owns section margins.
- **Radius:** Not applicable.
- **Border:** Optional 1 px divider using semantic border token.
- **Shadow:** None.
- **Typography:** 20 px semibold panel heading.

### States

- **Normal:** Primary text with optional icon/divider.
- **Hover:** Not applicable unless the header expands/collapses content.
- **Pressed:** Collapsible variants use a 1 px indicator shift, not heading movement.
- **Focused:** Collapsible variants show a visible focus outline around the full header row.
- **Selected:** Optional expanded indicator and explicit state icon.
- **Disabled:** Muted heading only when the entire section is unavailable.
- **Locked:** Lock icon and explanatory caption; do not use a disabled color alone.

---

## 17. Line Edit

### Purpose

Accepts short player text such as character names and search/filter values.

### Anatomy

Optional label · input surface · value or placeholder · caret · optional validation icon/message · optional character count.

### Measurements

- **Spacing:** 8 px label-to-field; 4–8 px field-to-validation message.
- **Padding:** 12 px horizontal; 10 px vertical.
- **Minimum height:** 44 px.
- **Radius:** 10 px.
- **Border:** 2 px standard; 2–3 px gold focus border; error uses icon and message in addition to border.
- **Shadow:** None by default.
- **Typography:** 16 px regular value/placeholder; 14 px validation and count.

### States

- **Normal:** Ivory opaque surface, standard border, primary text.
- **Hover:** Slight border emphasis; caret remains hidden until focused.
- **Pressed:** Places caret; no surface displacement.
- **Focused:** Gold border and gold caret; focus remains visible during typing.
- **Selected:** Selected text uses an accessible selection background; this is distinct from component selection.
- **Disabled:** Muted surface and readable existing value; no caret.
- **Locked:** Read-only styling plus lock icon and explanation. Use read-only rather than disabled when users must copy the value.

---

## 18. Responsive and Accessibility Rules

- Components use Containers and minimum sizes, not fragile absolute placement.
- At 200% UI scale, content reflows or scrolls; text never scales through transforms.
- Keyboard order follows visual order from top-left to bottom-right.
- Enter and Space activate buttons; Escape closes the top modal or returns safely.
- Every interactive element has visible focus feedback.
- Tooltip information available on hover must also be available from keyboard focus.
- Selected state always combines border, marker, and color.
- Locked state always combines desaturation, lock icon, and explanation.
- Icon-only controls require accessible names and tooltips.
- Content must remain sharp at 1280×720, 1600×900, 1920×1080, and a supported 16:10 resolution.

---

## 19. Motion Rules

| Interaction | Duration | Easing | Reduced motion |
|---|---:|---|---|
| Hover color | 120 ms | ease-out | Instant |
| Press feedback | 80–100 ms | ease-out | Instant |
| Tab indicator | 120–160 ms | ease-in-out | Instant |
| Modal fade | 180–220 ms | ease-out | Instant |
| Status interpolation | 180–250 ms | linear/ease-out | Snap to value |

No component continuously animates unless communicating live state. No UI animation scales a text-bearing parent above `1.0`.

---

## 20. Implementation Contract

- Colors come from centralized semantic tokens.
- Typography and spacing come from ThemeManager and the shared Theme resource.
- Reusable components expose data and state; screens do not reach into child indices.
- StyleBoxFlat resources are reused instead of duplicated in scenes.
- Component scripts emit signals and never poll every frame for UI state.
- Visual state changes do not alter gameplay data directly.
- Local style overrides require review and must represent a genuine semantic exception.

### Component acceptance checklist

- Purpose and hierarchy are clear at first glance.
- Anatomy remains intact with long labels and missing optional content.
- Measurements follow the shared scales.
- Normal, Hover, Pressed, Focused, Selected, Disabled, and Locked states are defined.
- Focus and selection remain distinguishable when combined.
- Text meets size and contrast requirements.
- No default Godot styling is visible.
- No glassmorphism, background blur, heavy bloom, or continuous glow is present.
- Component remains sharp and usable at 100–200% UI scale.
