# LumaVale Naming Convention

**Document owner:** Technical Art / Engineering  
**Applies to:** Filesystem, Godot scenes, scripts, resources, nodes, assets, IDs, and exported content  
**Primary rule:** Names describe purpose, remain stable, and sort predictably

---

## 1. Naming Principles

LumaVale uses a small number of consistent naming styles:

| Context | Convention | Example |
|---|---|---|
| Folders and files | `snake_case` | `character_selection_v2.tscn` |
| Stable data IDs | `snake_case` | `weapon_sword` |
| Godot node names | `PascalCase` | `PreviewCharacter` |
| GDScript classes | `PascalCase` | `ModularCharacter` |
| Variables and functions | `snake_case` | `selected_role` |
| Constants | `SCREAMING_SNAKE_CASE` | `FRAME_WIDTH` |
| Signals | `snake_case`, past-tense event | `role_selected` |
| Animation keys | `{action}_{direction}` | `walk_down` |

### General rules

- Use English names throughout the production repository.
- Use ASCII letters, numbers, and underscores only.
- Make names specific enough to remain meaningful in search results.
- Prefer purpose over visual appearance when purpose is stable.
- Keep stable IDs independent from display names and localization.
- Use zero-padded numbers for ordered variants: `01`, `02`, `03`.
- Avoid abbreviations unless they are approved project-wide terms.
- Do not encode temporary status, dates, or artist names into runtime filenames.

### Prohibited patterns

```text
Final Sword.png
new-background-2.png
hairFinal_FINAL.svg
Scene 1.tscn
button_fix_sherry.gd
asset_2026_08_03.png
```

Use source control for revision history instead of filename suffixes such as `final`, `latest`, `fixed`, or `new`.

---

## 2. Folder Names

Folder names use lowercase `snake_case`, normally plural for collections and singular only for a domain root already established by the project.

### Correct

```text
assets/characters/
assets/characters/accessories/
assets/ui/role_icons/
resources/appearance/
resources/themes/styles/
scenes/character/
scripts/character/
ui/components/
ui/screens/
```

The existing `docs/design-system/` path is a retained compatibility exception. New production folders use underscores unless an established external convention requires otherwise.

### Rules

- Organize first by domain, then by asset category.
- Do not create folders named after an artist, sprint, ticket, or temporary milestone.
- Do not duplicate the same category at multiple roots without a technical reason.
- Keep generated output under `builds/`; never mix it with source assets.
- A folder move requires a reference audit before merge.

---

## 3. File Names

All filenames use lowercase `snake_case` followed by the correct extension.

### Pattern

```text
{domain}_{subject}_{variant}_{state}.{extension}
```

Only include segments required to distinguish the asset.

### Correct

```text
character_selection_v2.tscn
modular_character.gd
weapon_sword.tres
character_selection_v2.svg
env_town_lantern_lit.png
```

### Rules

- The filename must describe one responsibility.
- Keep matching scene and primary script names aligned where practical.
- Use a numeric version only when two runtime contracts intentionally coexist.
- Do not rename files referenced by saved data, preload constants, or exported resources without migration.
- Extension case is lowercase.

---

## 4. Scene Names

Scene files use `snake_case.tscn`. The root node uses the matching concept in `PascalCase`.

| Scene file | Root node |
|---|---|
| `main.tscn` | `Main` |
| `player.tscn` | `Player` |
| `modular_character.tscn` | `ModularCharacter` |
| `character_selection_v2.tscn` | `CharacterSelectionV2` |
| `component_gallery.tscn` | `ComponentGallery` |
| `theme_preview.tscn` | `ThemePreview` |

### Scene suffixes

- `_test.tscn` — focused development validation scene.
- `_preview.tscn` — visual preview without product flow.
- `_gallery.tscn` — component state gallery.
- `_v2.tscn` — versioned feature replacement during migration.

Do not use `_scene` in every filename; `.tscn` already communicates the type.

---

## 5. Script Names

GDScript files use `snake_case.gd` and normally match the scene, node, or resource class they control.

| Script file | Optional `class_name` |
|---|---|
| `modular_character.gd` | `ModularCharacter` |
| `appearance_item.gd` | `AppearanceItem` |
| `role_data.gd` | `RoleData` |
| `player.gd` | `Player` |
| `theme_manager.gd` | No global class; Autoload name is `ThemeManager` |

### Script rules

- One primary class responsibility per script.
- `class_name` uses `PascalCase` and matches the public concept.
- Private helpers begin with one underscore: `_refresh_layers()`.
- Callback names describe the signal source and event: `_on_confirm_button_pressed()`.
- Boolean variables begin with `is_`, `has_`, `can_`, `should_`, or a clear state adjective.
- Do not add type suffixes such as `_bool`, `_int`, or `_node`.
- Editor-only generation scripts use a clear verb: `generate_luma_theme.gd`.
- Temporary validation scripts begin with `_` and must be removed before delivery unless intentionally retained.

---

## 6. Resource Names

Godot `.tres` files use stable lowercase IDs. The filename and exported `id` should match unless the resource is an implementation companion.

### Appearance resources

```text
resources/appearance/body_a.tres
resources/appearance/body_a_frames.tres
resources/appearance/hair_short.tres
resources/appearance/hair_short_frames.tres
resources/appearance/weapon_sword.tres
resources/appearance/weapon_sword_frames.tres
```

Rules:

- Appearance item ID: `{category}_{variant}` when category is not already unambiguous.
- Companion SpriteFrames resource: `{item_id}_frames.tres`.
- Empty selection uses `{category}_none`, for example `accessory_none`.
- Display names are human-readable and localizable; IDs remain technical and stable.

### Role resources

```text
resources/roles/warrior.tres
resources/roles/ranger.tres
resources/roles/alchemist.tres
```

Role IDs use the simple stable role name: `warrior`, `ranger`, `alchemist`.

### Theme resources

```text
resources/themes/lumavale_theme.tres
resources/themes/styles/button_primary.tres
resources/themes/styles/role_card_selected.tres
```

Style resources describe semantic component and state, not a raw color such as `blue_button.tres`.

### Stability

Resource IDs stored in `GameSession`, saves, configuration, or player data are compatibility-critical. Changing the display name does not authorize changing the ID.

---

## 7. Texture Names

Texture names identify domain, subject, optional variant, and optional state.

### Character textures

```text
body_a.svg
hair_short.svg
eyes_hazel.svg
top_forest.svg
bottom_dark.svg
shoes_boots.svg
accessory_leaf.svg
weapon_sword.svg
```

Category folders already provide context, so avoid repeating `character_` unless the file is exported outside that folder.

### Environment textures

```text
env_town_ground_grass.png
env_town_building_blacksmith.png
env_forest_tree_ancient.png
env_mine_rock_wall_01.png
env_dungeon_door_sealed.png
```

### UI textures

```text
character_selection_v2.svg
panel_fantasy_corner.svg
button_accent_marker.svg
```

### Texture states

Approved suffixes include:

```text
_normal
_hover
_pressed
_selected
_disabled
_locked
_lit
_unlit
```

Do not add a state suffix when the state is generated by Theme or shader rather than a distinct texture.

### Texture sets

Use explicit technical suffixes only when the project adds the corresponding channel workflow:

```text
_albedo
_normal
_mask
_emission
```

Do not use `_diff`, `_nrm`, or `_spec` abbreviations.

---

## 8. Animation Names

Godot SpriteFrames animation keys use:

```text
{action}_{direction}
```

### Required foundation

```text
idle_down
idle_left
idle_right
idle_up
walk_down
walk_left
walk_right
walk_up
attack_down
attack_left
attack_right
attack_up
```

### Source-frame files

```text
chr_{item_id}_{layer}_{action}_{direction}_{frame_number}.png
```

Examples:

```text
chr_body_a_body_walk_down_00.png
chr_top_forest_top_walk_down_00.png
chr_weapon_sword_weapon_attack_left_03.png
```

### Rules

- Action comes before direction.
- Directions are `down`, `left`, `right`, `up` in that order.
- Frame numbers are zero-based and at least two digits.
- Use complete actions such as `attack`, not `atk`.
- AnimationPlayer library names use semantic snake_case such as `panel_enter` or `modal_exit`.
- Do not include FPS or frame count in the animation name.

---

## 9. Font Names

Font files preserve the family name in lowercase snake_case followed by weight and optional style.

### Pattern

```text
{family}_{weight}_{style}.{extension}
```

### Examples

```text
source_sans_3_regular.ttf
source_sans_3_semibold.ttf
source_sans_3_bold.ttf
lora_bold.ttf
lora_regular_italic.ttf
noto_sans_cjk_regular.otf
```

### Rules

- Use full weight names: `regular`, `medium`, `semibold`, `bold`.
- Omit `_normal` style when the file is upright.
- Use `_italic` only for a real italic face.
- Do not use foundry download filenames in production.
- Store licenses using `{family}_license.txt` in source documentation, not as a runtime font name.
- Theme token names remain semantic: `FONT_BODY`, `FONT_PANEL_HEADING`, not family-specific.

---

## 10. Icon Names

Icons use a consistent `icon_` prefix when introduced into the production naming standard.

### Pattern

```text
icon_{domain}_{concept}_{state}.{extension}
```

### Examples

```text
icon_ui_lock.svg
icon_ui_check.svg
icon_ui_close.svg
icon_role_warrior.svg
icon_role_ranger.svg
icon_role_alchemist.svg
icon_item_weapon.svg
icon_status_warning.svg
```

Optional state examples:

```text
icon_ui_star_normal.svg
icon_ui_star_selected.svg
icon_ui_slot_locked.svg
```

### Rules

- Name the meaning, not the silhouette: `icon_ui_confirm`, not `icon_green_tick`.
- Do not encode color unless color is intrinsic to the icon's identity.
- Do not create separate hover files when Theme tinting provides the state.
- Directional icons append the full direction: `_left`, `_right`, `_up`, `_down`.
- Existing legacy names such as `lock.svg` may remain until a coordinated reference-safe migration.

---

## 11. Audio Names

Audio uses a type prefix followed by domain, event, optional material/context, and zero-padded variant.

### Prefixes

| Prefix | Type |
|---|---|
| `mus_` | Music |
| `amb_` | Environmental ambience |
| `sfx_` | Gameplay and UI sound effect |
| `vo_` | Voice or vocalization |

### Pattern

```text
{type}_{domain}_{event}_{context}_{variant}.{extension}
```

### Examples

```text
mus_town_morning.ogg
mus_forest_exploration.ogg
amb_town_rain_loop.ogg
amb_forest_night_loop.ogg
sfx_ui_confirm_01.ogg
sfx_ui_back_01.ogg
sfx_player_footstep_grass_01.wav
sfx_player_attack_sword_01.wav
sfx_world_slime_hit_02.wav
vo_npc_merchant_greeting_01.ogg
```

### Rules

- Looping ambience and music append `_loop` only when loop behavior is not already inherent to the asset category or metadata.
- Variants use `01`, `02`, `03`; do not use `a`, `b`, `c`.
- Name events from the listener/gameplay perspective.
- Do not include sample rate, bit depth, loudness, or codec settings in the filename.
- Audio bus names use `PascalCase`: `Master`, `Music`, `Ambience`, `SFX`, `UI`, `Voice`.

---

## 12. Godot Node Names

Godot nodes use `PascalCase` and describe semantic responsibility.

### Correct

```text
CharacterSelectionV2
EnvironmentBackground
SafeArea
MainVBox
RoleSection
RoleList
PreviewCharacter
CharacterName
StatsContainer
ConfirmButton
TransitionLayer
```

### Rules

- Root node matches the scene concept.
- Child names describe responsibility, not position: `RoleSection`, not `LeftPanel`.
- A type suffix is appropriate when it clarifies a unique public path: `ConfirmButton`, `NameLineEdit`, `RoleList`.
- Do not name nodes `Node2D`, `Control2`, `VBox1`, `Label3`, or `NewNode`.
- Repeated generated children use stable IDs or metadata rather than relying on child index.
- Public `%UniqueName` nodes use stable semantic names and are treated as API.
- Avoid renaming nodes referenced by `$Path`, `%UniqueName`, animation tracks, or tests without updating every consumer.

### Approved acronyms

Recognized acronyms may remain uppercase inside node names:

```text
UI
HUD
NPC
HPBar
EXPBar
```

Do not invent project-local acronyms when a readable full word fits.

---

## 13. GDScript Identifier Names

Although this document focuses on assets and nodes, code identifiers must match the same semantic model.

### Variables and functions

```gdscript
var selected_role: RoleData
var current_animation: StringName = &"idle_down"

func populate_appearance_sections() -> void:
	pass
```

### Constants

```gdscript
const FRAME_WIDTH := 48
const MAIN_SCENE_PATH := "res://scenes/main.tscn"
```

### Signals

```gdscript
signal role_selected(role: RoleData)
signal appearance_option_selected(category: StringName, item: AppearanceItem)
signal ui_scale_changed(scale_factor: float)
```

### Autoloads

Autoload names use `PascalCase`:

```text
GameSession
ThemeManager
```

Input actions and node groups use lowercase snake_case:

```text
move_left
move_right
interact
player
damageable
```

---

## 14. State and Variant Vocabulary

Use the same approved terms across textures, styles, scene state, and documentation.

### UI states

```text
normal
hover
pressed
focused
selected
disabled
locked
equipped
```

### Directions

```text
down
left
right
up
```

### Environment states

```text
morning
sunset
night
rain
snow
fog
lit
unlit
wet
dry
```

Do not create synonyms such as `inactive`, `unavailable`, and `blocked` for the same Locked or Disabled visual state without a distinct behavioral definition.

---

## 15. Stable IDs and Display Names

Stable IDs are technical contracts. Display names are player-facing content.

| Stable ID | Display name |
|---|---|
| `body_a` | Body A |
| `hair_short` | Short Hair |
| `top_forest` | Forest Top |
| `weapon_sword` | Sword |
| `warrior` | Warrior |

Rules:

- Stable IDs use lowercase snake_case and are never localized.
- Display names use title casing appropriate to the language and may be localized.
- Save/session dictionaries store stable IDs, not display names or file paths.
- Renaming an ID requires a data migration and backward-compatibility mapping.

---

## 16. Version and Migration Names

Version suffixes are permitted only when old and new contracts coexist during a deliberate migration.

```text
character_selection_v2.tscn
character_selection_v2.gd
```

Rules:

- Use `_v2`, `_v3`; never `_new` or `_latest`.
- Scene and script version suffixes match.
- Archive/deprecation notes identify the replacement path.
- Remove the suffix only through an intentional project-wide migration.
- Do not version ordinary asset revisions in filenames.

---

## 17. Naming Review Checklist

- Folder uses the approved domain/category and lowercase naming.
- File uses lowercase snake_case and the correct extension.
- Scene root matches the scene concept in PascalCase.
- Script and optional `class_name` describe the same responsibility.
- Resource filename and stable ID agree.
- Texture name communicates domain, subject, variant, and necessary state.
- Animation uses `{action}_{direction}`.
- Font includes family, weight, and optional style.
- Icon describes semantic meaning rather than color or shape.
- Audio uses the approved type prefix and zero-padded variants.
- Godot node name is semantic and stable.
- No `final`, `new`, date, artist name, or ticket number appears in runtime paths.
- No compatibility-critical ID or path changed without migration.

---

## 18. Change Control

This naming convention is a production API. New prefixes, categories, animation actions, state terms, or stable-ID formats require Technical Art and Engineering review.

Do not perform broad renames without a reference audit covering `.tscn`, `.tres`, `.gd`, `project.godot`, export presets, animation tracks, saved data, and Web export. A naming cleanup is complete only when the project imports and runs without broken references.
