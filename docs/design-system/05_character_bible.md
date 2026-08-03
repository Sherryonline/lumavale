# LumaVale Character Bible

**Document owner:** Character Art Director / Technical Art  
**System:** Modular layered 2D character  
**Runtime scene:** `res://scenes/character/modular_character.tscn`  
**Canonical logical frame:** 48 × 64 units  
**Scope:** Production specification only — this document does not create or supply artwork

---

## 1. Character System Vision

LumaVale characters are assembled from independent visual layers that share one canvas, pivot, animation set, direction convention, and timing contract. A body, hairstyle, outfit, shoes, accessory, and weapon can be exchanged without redrawing unrelated layers.

The character target is cozy fantasy with anime-inspired clarity and slightly chibi proportions. Silhouette, facial readability, and customization identity take priority over anatomical detail.

Every interchangeable asset must align with every approved body and animation. An asset that looks correct only with its original outfit is not modular and cannot enter production.

### System guarantees

- Every layer uses the same logical frame dimensions.
- Every layer uses the same canvas origin and character pivot.
- Matching animations use identical frame counts, order, duration, and loop behavior.
- Empty layers are valid and must not cause errors.
- Missing animations fail safely without shifting another layer.
- Cosmetic changes do not change gameplay collision or movement origin.

---

## 2. Canonical Canvas

### Runtime canvas size

| Property | Specification |
|---|---:|
| Logical frame width | 48 units |
| Logical frame height | 64 units |
| Canvas center | `(24, 32)` |
| Horizontal character centerline | `x = 24` |
| Head center target, front view | approximately `(24, 17)` |
| Foot contact band | `y = 58–61` |
| Recommended production baseline | `y = 60` |
| Transparent safety margin | minimum 2 units at outer canvas edges |

The full canvas remains transparent except for the assigned layer artwork. Cropping each layer to its visible bounds is prohibited because it changes the center used by `AnimatedSprite2D` and causes visible jumps.

### HD source support

The 48 × 64 specification is a **logical alignment grid**, not a pixel-art-only restriction. Final artwork may be authored at an integer source multiple:

- 1×: 48 × 64 pixels — prototype/reference resolution.
- 2×: 96 × 128 pixels — HD source option.
- 4×: 192 × 256 pixels — high-resolution master option.

All layers within one runtime set must use the same source scale. Downsampling or runtime scale must be defined once for the complete character family. Do not mix 1× body art with 2× hair or 4× weapons.

If production changes the runtime frame dimensions, treat the change as a versioned migration of every character layer and animation resource. Do not silently introduce a second canvas standard.

---

## 3. Pivot and Grounding

All `AnimatedSprite2D` layers use `centered = true`. The source canvas center `(24, 32)` therefore maps to the local `ModularCharacter` origin `(0, 0)`.

### Required anchors

| Anchor | Source coordinate | Local coordinate | Purpose |
|---|---:|---:|---|
| Sprite pivot | `(24, 32)` | `(0, 0)` | Shared layer alignment |
| Foot baseline | `(24, 60)` | `(0, 28)` | Ground contact reference |
| Head center | `(24, 17)` | `(0, -15)` | Hair, eyes, hats, face alignment |
| Hand/weapon guide, right | approximately `(36, 38)` | approximately `(12, 6)` | Front-view weapon grip reference |
| Hand/weapon guide, left | approximately `(12, 38)` | approximately `(-12, 6)` | Mirrored/off-hand reference |

The gameplay root, collision, and camera belong to the `Player`, not to an appearance layer. Artwork must never compensate for collision by moving the body away from the shared pivot.

Y-sort should reference the foot baseline. If the engine scene requires a `y_sort_origin`, configure it once on the character root or Player; do not offset individual visual layers.

The shadow is a separate runtime element and is not baked into body, shoe, clothing, or accessory artwork.

---

## 4. Body Proportions

The base character is intentionally compact and readable from the gameplay camera.

### Proportion target

- Total visible height: approximately **54–57 logical units** within the 64-unit canvas.
- Overall height: approximately **2.6–2.8 heads**.
- Head height: approximately **20–22 units**.
- Head width: approximately **20–22 units** in the front view.
- Shoulder/body width: approximately **14–18 units**, excluding arms and equipment.
- Full neutral pose width: approximately **24–28 units**, excluding wide hair and weapons.
- Torso region: approximately `y = 27–49`.
- Hip/bottom transition: approximately `y = 45–52`.
- Shoe and foot region: approximately `y = 55–61`.

These values are alignment standards, not requirements for identical silhouettes. Body variants may adjust shoulder width, torso taper, face shape, and limb weight while preserving the shared anchors and equipment fit zones.

### Silhouette rules

- The head remains the dominant shape.
- Hands and feet remain readable at gameplay scale.
- The neck is minimal or visually absorbed into the head/torso transition.
- Limbs use simplified, soft forms rather than realistic muscle definition.
- Body variants may not change overall height enough to detach shoes, hair, or held equipment.
- Pose asymmetry is encouraged when it does not break layer interchangeability.

---

## 5. Head Ratio and Face Placement

### Head ratio

The head occupies approximately **36–40%** of the visible character height. The front-view head center remains near `(24, 17)` with the chin transitioning into clothing near `y = 27–29`.

Hair volume may extend above and beside the base head, but must remain inside the canvas safety margin. Hair silhouette should not redefine the body pivot.

### Eye position

For the front/down direction:

- Eye center line: approximately `y = 17`.
- Left eye center: approximately `x = 20.5`.
- Right eye center: approximately `x = 27.5`.
- Center-to-center separation: approximately **7 units**.
- Individual eye height target: approximately **4–6 units**, depending on style and expression.

For side directions, the visible eye shifts toward the face-facing edge while preserving head volume. For the up direction, eyes are normally hidden unless a specific animation requires a readable profile turn.

Eye assets contain only the eye treatment and approved facial micro-details. Skin, head shape, hair, and accessories must not be painted into the Eyes layer.

---

## 6. Modular Fit Zones

All artists must use the same fit-zone overlay in their source file.

| Zone | Approximate logical bounds | Primary consumers |
|---|---|---|
| Head and face | `x 13–35`, `y 5–28` | Body, Eyes, Hair, head accessories |
| Shoulder and torso | `x 13–35`, `y 27–49` | Body, Top, straps, necklaces |
| Hip and legs | `x 16–32`, `y 45–58` | Body, Bottom |
| Feet | `x 13–35`, `y 55–61` | Shoes |
| Left equipment space | `x 2–15`, `y 20–61` | Accessories and direction-dependent equipment |
| Right equipment space | `x 33–46`, `y 20–61` | Weapons and direction-dependent equipment |

Bounds are guides, not clipping masks. Wide silhouettes are allowed when they remain inside the canvas, avoid the face, and pass combination testing.

---

## 7. Hair Layer

### Current runtime contract

`Hair` is an `AnimatedSprite2D` at `z_index = 5`, above Eyes and clothing. It uses the `sprite_frames` field of an `AppearanceItem` in the Hair category.

### Production rules

- Align the scalp to the base head, not to a specific body outline color.
- Build hair as large readable masses before strands or highlight marks.
- Preserve face readability in down and side directions.
- Hair may overlap ears, shoulders, and upper clothing intentionally.
- Do not include skin, eyes, hats, clothing, or accessory art in Hair.
- Hair color customization may use `self_modulate`; source art must be suitable for approved tinting.
- Tint masks must preserve value separation and must not unintentionally tint outlines or embedded accessories.

### Back hair limitation

The current scene has one Hair layer and no dedicated `HairBack`. Hairstyles requiring body-behind occlusion must be reviewed before production. Do not misuse `AccessoryBack` as permanent hair architecture. If long hairstyles require independent rear rendering, add a dedicated `HairBack` layer through a versioned scene and resource migration before authoring the full set.

---

## 8. Equipment Layers

Equipment is divided by dressing order, not by asset ownership.

### Bottom

- Runtime layer: `Bottom`, `z_index = 1`.
- Covers hips and upper legs.
- Must fit beneath Top and above Body.
- Must not include shoes, torso clothing, weapons, or body skin.

### Shoes

- Runtime layer: `Shoes`, `z_index = 2`.
- Aligns to the shared foot baseline at `y = 58–61`.
- May overlap the lower edge of Bottom to prevent seams.
- Must not alter ground contact height between frames.

### Top

- Runtime layer: `Top`, `z_index = 3`.
- Covers torso and approved arm regions.
- May overlap the upper edge of Bottom.
- Neckline must align with every approved body.
- Gloves integral to an outfit require an approved ownership rule; do not duplicate hands across Body and Top.

Equipment pieces must be tested in cross-category combinations, including the widest body, longest hair, largest top, and both bottom variants.

---

## 9. Weapon Layers

### Current runtime contract

`Weapon` is one `AnimatedSprite2D` at `z_index = 6`, above Hair and below `AccessoryFront`. It consumes the weapon `AppearanceItem.sprite_frames` resource.

### Placement rules

- Use the shared hand/grip guide for every frame.
- The grip point must follow the animated hand without lag or drift.
- Weapons must not cover the face in idle presentation.
- Blade, bow, flask, or tool silhouettes remain inside the canvas unless a documented oversized-weapon exception is approved.
- Weapon frames contain only the weapon and any inseparable hand-held effect.
- Cosmetic skin and hair colors must never modulate the Weapon layer.
- Attack anticipation, contact, and recovery frames use the same canvas and pivot as idle and walk.

### Front/back occlusion

The current architecture provides a front weapon layer only. Do not paint rear weapon fragments into Body, Hair, or AccessoryBack. If an animation needs the weapon to pass behind the character, introduce explicit `WeaponBack` and `WeaponFront` layers through an approved technical migration. Both layers must share one `AppearanceItem` ownership model and remain frame-synchronized.

---

## 10. Accessory Layers

Accessories support two synchronized visual resources:

- `AccessoryBack` uses `AppearanceItem.back_sprite_frames` at `z_index = -2`.
- `AccessoryFront` uses `AppearanceItem.sprite_frames` at `z_index = 7`.

### Ownership rules

- Rear elements such as backpack bodies, capes, rear straps, or behind-head ornaments belong in `AccessoryBack`.
- Front straps, badges, necklaces, foreground leaves, and visible clasps belong in `AccessoryFront`.
- Both halves use the same item ID and animation contract.
- Either half may be empty.
- `accessory_none` is a valid empty selection and clears both layers safely.
- Do not duplicate the same opaque pixels in front and back resources.
- Accessories must not include hair, body, clothing, or weapon artwork.

Large accessories require combination tests with every hair silhouette and starting weapon.

---

## 11. Canonical Layer Order

The render order is fixed unless a reviewed architecture change updates the scene and this document together.

| Order | Node | `z_index` | Responsibility |
|---:|---|---:|---|
| 1 | `Shadow` | -10 | Grounding shadow; separate from appearance assets |
| 2 | `AccessoryBack` | -2 | Rear accessory elements |
| 3 | `Body` | 0 | Skin, head, base limbs, base torso |
| 4 | `Bottom` | 1 | Hip and leg clothing |
| 5 | `Shoes` | 2 | Footwear |
| 6 | `Top` | 3 | Torso and approved arm clothing |
| 7 | `Eyes` | 4 | Eye treatment and approved facial micro-details |
| 8 | `Hair` | 5 | Current unified hair layer |
| 9 | `Weapon` | 6 | Current front-held weapon layer |
| 10 | `AccessoryFront` | 7 | Foreground accessory elements |

Do not solve occlusion problems by changing `z_index` on individual item resources. Add an explicit shared layer when the production need is systemic.

---

## 12. Animation Frame Size

Every current `AtlasTexture` region is exactly **48 × 64 logical units**. Each frame begins on a 48-unit horizontal boundary in the temporary validation atlas.

Current validation strip:

| Atlas X | Region | Animation frame |
|---:|---|---|
| 0 | `Rect2(0, 0, 48, 64)` | `idle_down`, frame 0 |
| 48 | `Rect2(48, 0, 48, 64)` | `walk_down`, frame 0 |
| 96 | `Rect2(96, 0, 48, 64)` | `walk_down`, frame 1 |
| 144 | `Rect2(144, 0, 48, 64)` | `attack_down`, frame 0 |
| 192 | `Rect2(192, 0, 48, 64)` | `attack_down`, frame 1 |

This five-frame strip is temporary validation infrastructure, not the final production frame-count target. Production animation frame counts are defined in `06_animation_guide.md`, but every modular layer must match the approved count for a given animation.

---

## 13. Animation and Frame Naming

### Godot animation key

Use lowercase snake_case:

```text
{action}_{direction}
```

Required foundation keys:

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

Do not use spaces, title case, hyphens, abbreviations such as `atk`, or direction-first naming.

### Source frame naming

When frames are exported individually, use:

```text
chr_{item_id}_{layer}_{action}_{direction}_{frame_number}.png
```

Example syntax only:

```text
chr_hair_short_hair_walk_down_00.png
chr_top_forest_top_attack_left_03.png
chr_weapon_sword_weapon_idle_up_00.png
```

Frame numbers are zero-based and use at least two digits. This document defines naming syntax only; it does not create those files.

### Resource naming

```text
resources/appearance/{item_id}.tres
resources/appearance/{item_id}_frames.tres
```

Stable item IDs must not change after save data begins referencing them.

---

## 14. Direction Order

The canonical direction order is:

1. `down`
2. `left`
3. `right`
4. `up`

This order applies to source-file groups, review sheets, atlas rows, test matrices, and export automation.

Within each direction, frames progress left to right in chronological order. If a production atlas uses rows, row 0 is Down, row 1 is Left, row 2 is Right, and row 3 is Up.

Do not assume Left can always be generated by mirroring Right. Asymmetrical hair, clothing, accessories, hand dominance, weapon grips, text-like symbols, and lighting may require authored directions. Mirroring is permitted only when the complete modular combination remains correct.

The current prototype assets implement Down only. Missing directions use the safe `*_down` fallback in movement code until authored resources are approved.

---

## 15. Frame Synchronization Contract

`Body` is the preferred animation clock. If Body lacks the requested animation, the first available visible layer may act as a safe fallback clock.

For every animation key:

- All assigned layers use the same frame count.
- All assigned layers use the same per-frame duration.
- All assigned layers use the same loop setting.
- Frame 0 describes the same pose and timing instant on every layer.
- Contact, passing, recoil, and recovery poses occur on the same frame index.
- Changing one appearance layer preserves the current animation and frame where possible.

A layer missing the requested animation is hidden safely. It must not display frame 0 from a different animation.

---

## 16. Body and Appearance Compatibility

Every new appearance item must be reviewed against:

- Every production body variant.
- Every required direction.
- Every required animation.
- Minimum and maximum hair silhouettes.
- All starting weapons.
- Both empty and full accessory configurations.
- Skin and hair color modulation extremes.

Approval failures include visible seams, clipping at rest, layer drift, changing foot baseline, face obstruction, weapon-hand separation, inconsistent outline ownership, and canvas cropping.

---

## 17. Production Source Template

The approved source template must contain non-exporting guides for:

- 48 × 64 logical canvas or approved integer multiple.
- Canvas center and sprite pivot.
- Foot baseline.
- Head center and eye line.
- Left and right hand/grip guides.
- Body fit zones.
- Canvas safety margin.
- Layer ownership labels.
- Animation name, direction, and frame index.

Guides, notes, checkerboards, reference mannequins, and onion-skin frames must never appear in exported textures.

---

## 18. Technical Acceptance Checklist

- Canvas and frame dimensions match the approved scale.
- Background is fully transparent.
- Pivot is `(24, 32)` in the logical 48 × 64 frame.
- Foot contact stays within `y = 58–61` and does not drift unintentionally.
- Layer contains only its assigned visual responsibility.
- Animation key follows `{action}_{direction}`.
- Direction order is Down, Left, Right, Up.
- Frame count and duration match every modular layer.
- No frame is cropped to visible bounds.
- Hair aligns to the head and preserves face readability.
- Top, Bottom, and Shoes align without gaps across body variants.
- Weapon grip remains attached and does not cover the face in idle.
- Front and back accessory frames synchronize.
- Empty accessory selection clears safely.
- Asset is tested in the independent ModularCharacter test scene.
- No artwork is considered approved from an isolated source-file view alone; gameplay-scale review is mandatory.

---

## 19. Change Control

Canvas size, pivot, layer order, animation keys, and stable appearance IDs are compatibility-critical. Changing any of them requires Technical Art and Engineering approval, migration notes, regenerated validation resources, and a complete combination test.

Production artists must not work around an architectural limitation by embedding pixels into the wrong layer. Raise the limitation before full asset production begins.
