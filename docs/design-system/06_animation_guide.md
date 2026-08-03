# LumaVale Animation Guide

**Document owner:** Animation Director / Technical Art  
**System:** Modular layered 2D character animation  
**Canonical logical frame:** 48 × 64 units  
**Direction order:** Down · Left · Right · Up  
**Scope:** Production specification only

---

## 1. Animation Vision

LumaVale animation should feel soft, readable, and responsive. Movement has a handcrafted anime-fantasy character without excessive bounce, rubber motion, or constant visual noise. Every action communicates intent before impact and settles cleanly afterward.

The character is assembled from modular layers. Body, hair, eyes, clothing, shoes, accessories, and weapons must behave as one animation. Timing, pivot, frame count, frame order, and loop settings are shared contracts, not per-item artistic choices.

### Animation priorities

1. Gameplay intent reads immediately.
2. Feet remain grounded and collision remains trustworthy.
3. All modular layers remain synchronized.
4. Poses remain readable at gameplay scale.
5. Motion returns to rest; no animation adds unnecessary continuous activity.

---

## 2. Prototype Versus Production

The current temporary modular assets validate layering only:

| Animation | Prototype frames | Prototype FPS | Loop |
|---|---:|---:|---|
| `idle_down` | 1 | 2 | Yes |
| `walk_down` | 2 | 6 | Yes |
| `attack_down` | 2 | 8 | No |

These values are not the final animation quality target. Production assets follow the foundation specification below unless an animation brief explicitly overrides it.

---

## 3. Production Frame Counts and FPS

### Foundation set

| Action | Frames per direction | Base FPS | Approximate duration | Loop | Priority |
|---|---:|---:|---:|---|---|
| `idle` | 8 | 4 | 2.5 seconds with weighted holds | Yes | Required |
| `walk` | 8 | 10 | 0.80 seconds | Yes | Required |
| `attack` | 8 | 12 | 0.67 seconds | No | Required |
| `hurt` | 4 | 10 | 0.40 seconds | No | Recommended with combat |
| `interact` | 6 | 8 | 0.75 seconds | No | Recommended |
| `celebrate` | 8 | 8 | 1.0 second | No | Optional |
| `faint` | 10 | 10 | 1.0 second | No | Future combat state |

Frame count is identical across all directions and every visible modular layer for the same animation key.

### FPS interpretation

Godot `SpriteFrames.speed` defines the base playback rate. Individual frame duration multipliers may extend a pose without duplicating artwork. All modular layers must use the same speed and duration multiplier for the corresponding frame.

Do not change FPS on Hair, Top, Weapon, or another cosmetic layer to make it “feel better.” Timing belongs to the animation, not to the appearance item.

### Allowed variation

An approved animation brief may use a different count or timing when:

- the action has a materially different gameplay duration;
- a heavy weapon needs stronger anticipation or recovery;
- a narrative animation requires longer acting beats; or
- an accessibility or performance mode requires a documented alternative.

Variation must remain synchronized across every modular layer assigned to that action.

---

## 4. Animation Naming

Godot animation keys use lowercase snake_case:

```text
{action}_{direction}
```

Required examples:

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

Additional examples:

```text
hurt_left
interact_up
celebrate_down
faint_right
```

Do not use spaces, hyphens, title case, direction-first names, or abbreviations such as `atk`, `dmg`, or `wk`.

### Source-frame naming

When exporting separate frames:

```text
chr_{item_id}_{layer}_{action}_{direction}_{frame_number}.png
```

Frame numbers are zero-based and use at least two digits:

```text
chr_body_a_body_walk_down_00.png
chr_hair_short_hair_walk_down_00.png
chr_weapon_sword_weapon_attack_left_03.png
```

The same frame number must represent the same pose and moment across all layers.

---

## 5. Direction Naming and Order

Canonical directions:

1. `down`
2. `left`
3. `right`
4. `up`

This order is used for source-file groups, atlas rows, review sheets, automated export, and test matrices.

### Direction rules

- Direction is captured from the character's last meaningful movement vector.
- Down is the safe runtime fallback while prototype directions are missing.
- Production-ready appearance sets must contain all required directions.
- Attack direction is locked when attack anticipation begins and remains stable through recovery.
- Direction changes during Walk preserve the gait phase where possible.
- Left/right mirroring is allowed only when body asymmetry, outfit detail, accessories, lighting, weapon grip, and symbols remain correct.

Direction names are never numeric in exported resources.

---

## 6. Pivot

Every frame uses the pivot defined in the Character Bible:

| Property | Value |
|---|---:|
| Logical canvas | 48 × 64 units |
| Source pivot | `(24, 32)` |
| Local runtime pivot | `(0, 0)` |
| Recommended foot baseline | source `y = 60`, local `y = 28` |

All `AnimatedSprite2D` layers remain centered and use the same full transparent canvas. Do not crop a frame or reposition an individual layer to repair alignment.

### Pivot stability rules

- Pivot does not move between frames.
- Foot baseline may compress or lift as part of a pose, but the canvas pivot remains fixed.
- Weapon and accessory frames inherit the body pivot, not their own visible-center pivot.
- Hair bounce never changes the hair canvas origin.
- Scaling from HD source art must preserve the normalized pivot exactly.

---

## 7. Root Position and Root Motion

The `Player` or gameplay entity owns world position. Character animation is visual and must not translate the gameplay root.

### Rules

- No animation frame changes the `CharacterBody2D.position`.
- No appearance layer animates its root `position` to simulate locomotion.
- Walk speed comes from movement physics, not sprite displacement.
- Attack lunges use gameplay movement or a reviewed state-machine impulse, not artwork drifting inside the canvas.
- Knockback is gameplay movement; Hurt artwork communicates reaction without replacing physics.
- Camera position is never embedded in character animation.

Visual motion inside the 48 × 64 canvas is permitted. The body may lean, crouch, rise, or extend while the shared pivot and world root remain stable.

### Foot contact

For grounded poses, at least one support foot remains visually consistent with the baseline. Sliding is evaluated against actual world movement at gameplay speed, not only in an isolated animation preview.

---

## 8. Timing Principles

### Pose hierarchy

Every action is built from four timing phases:

1. **Preparation:** communicates intent.
2. **Action:** performs the movement.
3. **Contact or peak:** contains the clearest result pose.
4. **Recovery:** returns control and silhouette toward locomotion or rest.

Not every loop has a combat contact, but every animation must have readable extremes and a controlled return.

### Timing rules

- Favor clear poses over uniformly smooth motion.
- Use brief holds on important anticipation and contact poses.
- Avoid equal spacing between every drawing when it makes motion mechanical.
- Motion arcs remain consistent across body, hair, equipment, and weapon layers.
- Secondary motion follows the body by a controlled amount without drifting a full gameplay frame behind.
- Frame duration changes must be identical across all modular resources.

### Frame duration

At 12 FPS, one standard frame lasts approximately **83 ms**. At 10 FPS it lasts **100 ms**. At 8 FPS it lasts **125 ms**. At 4 FPS it lasts **250 ms** before duration multipliers.

Gameplay event timing must use explicit state data. Do not infer damage or invulnerability solely from whatever texture happens to be visible.

---

## 9. Loop Rules

### Looping animations

`idle_*` and `walk_*` loop continuously while their state remains active.

- First and last poses must connect without a visible position jump.
- Do not duplicate the first frame as the final frame unless a deliberate hold is required.
- Looping hair, clothing, and accessories must complete on the same frame as Body.
- Foot cycle and world velocity must avoid visible sliding.
- Loop boundaries are reviewed at normal speed and frame-by-frame.

### Non-looping animations

`attack_*`, `hurt_*`, `interact_*`, `celebrate_*`, and `faint_*` do not loop.

- The animation state owns completion.
- The final frame may hold briefly while the state machine resolves.
- Attack returns to Walk when movement input and gameplay rules allow it; otherwise it returns to Idle.
- Hurt returns to the appropriate valid state after reaction and invulnerability handling.
- Faint holds its final frame until revive, respawn, or scene logic changes the state.

Never loop an attack or hit reaction merely because input remains held.

---

## 10. Transition Rules

Sprite animation uses pose-aware cuts rather than blurred crossfades. Crossfading layered transparent sprites is not part of the foundation architecture.

### State transition matrix

| From | To | Rule |
|---|---|---|
| Idle | Walk | Begin immediately when movement passes the input threshold |
| Walk | Idle | Return when velocity settles; avoid one-frame input flicker |
| Walk direction A | Walk direction B | Preserve normalized gait phase when possible |
| Idle/Walk | Attack | Capture facing, begin at Attack frame 0, obey gameplay permission |
| Attack | Idle/Walk | Transition only after recovery or an explicit approved cancel window |
| Any interruptible state | Hurt | Gameplay-authorized interrupt; start Hurt frame 0 |
| Interact | Idle | Finish the authored interaction before returning unless canceled by gameplay |
| Any valid state | Faint | High-priority transition; do not resume the prior animation automatically |

### Transition quality rules

- Avoid a visible one-frame flash of Idle between Walk and Attack.
- Preserve current animation frame when changing only an appearance item.
- Reset to frame 0 when changing to a different action unless a documented phase mapping applies.
- Missing animations hide the affected layer safely; they never show a mismatched animation.
- Reduced motion does not remove required character-state animation, but may reduce nonessential UI preview transitions.

---

## 11. Idle Breathing

Idle breathing is subtle background life, not a repeated bounce.

### Production timing

- **Frame count:** 8.
- **Base speed:** 4 FPS.
- **Duration multipliers:** recommended `1, 1, 1, 2, 1, 1, 1, 2`.
- **Total loop:** approximately 2.5 seconds.
- **Loop:** Yes.

### Pose guidance

- Chest/shoulder rise: approximately **0.5–1 logical unit**.
- Head response: no more than **0.5 logical unit** unless the character has a deliberate personality variant.
- Foot baseline remains fixed.
- Hands settle with the torso; they do not swing independently.
- Hair and loose accessories follow with restrained secondary motion.
- Weapon remains controlled and does not visibly float in the grip.
- Avoid synchronized blinking on every breathing loop.

Breathing should be visible when observed but should not demand attention during ordinary play.

### Idle variation

Longer personality idles may play after a separate inactivity delay. They are non-looping inserts that return to `idle_{direction}` cleanly. Do not place large gestures inside the base breathing loop.

---

## 12. Walk Cycle

### Production timing

- **Frame count:** 8.
- **Speed:** 10 FPS.
- **Cycle duration:** 0.80 seconds.
- **Loop:** Yes.

### Frame structure

| Frame | Pose |
|---:|---|
| 0 | Left-foot contact |
| 1 | Down/recoil |
| 2 | Passing |
| 3 | Up/high point |
| 4 | Right-foot contact |
| 5 | Down/recoil |
| 6 | Passing |
| 7 | Up/high point |

The cycle is compact and cozy rather than athletic. Vertical motion is approximately 1–2 logical units. Head and carried equipment remain readable; excessive side-to-side sway is prohibited.

Walk playback may be adjusted proportionally to movement speed within an approved narrow range. Do not accelerate to the point that the silhouette flickers.

---

## 13. Attack Timing

The foundation melee attack uses eight frames at 12 FPS. Weapon-specific animation briefs may extend phases while preserving the same semantic structure.

| Frame | Time | Phase | Requirement |
|---:|---:|---|---|
| 0 | 0–83 ms | Anticipation | Readable preparation; direction locks |
| 1 | 83–167 ms | Anticipation hold | Weight gathers; weapon remains controlled |
| 2 | 167–250 ms | Acceleration | Fastest spacing begins |
| 3 | 250–333 ms | Contact | Clearest strike silhouette; gameplay hit window reference |
| 4 | 333–417 ms | Follow-through | Arc completes; no second implied hit |
| 5 | 417–500 ms | Follow-through settle | Momentum resolves |
| 6 | 500–583 ms | Recovery | Body returns toward locomotion stance |
| 7 | 583–667 ms | Recovery/end | Safe transition pose |

### Attack anticipation

- Minimum target: **2 frames / approximately 167 ms** for the foundation attack.
- Anticipation must communicate attack direction and weapon type.
- Silhouette change must be visible without relying on particles.
- Do not move the world root during visual anticipation.
- Hair and accessories react after the core body intent, but remain on the same frame index.
- Heavy weapons may use 200–350 ms anticipation; fast weapons may shorten it only with gameplay approval and sufficient readability.

### Contact

- Frame 3 is the visual contact reference for the foundation attack.
- The authoritative damage window belongs to gameplay data and is synchronized to the animation state.
- Impact VFX, sound, camera response, and hit pause must agree on the contact moment.
- Do not paint impact effects permanently into reusable body or clothing frames.

### Recovery

- Foundation recovery: **2 frames / approximately 167 ms**, following two follow-through frames.
- Recovery clearly communicates when locomotion or another action can resume.
- The final frame must connect cleanly to both Idle and Walk.
- Do not snap directly from maximum weapon extension to neutral pose.
- Cancel windows, if introduced, are gameplay rules and must be documented per action.

---

## 14. Secondary Motion

Hair, clothing, accessories, and weapons support the body action without becoming independent animation clocks.

- Body establishes timing and direction.
- Hair tips, ribbons, and loose cloth may trail by pose, but never by unsynchronized playback.
- Heavy equipment shows reduced follow-through.
- Small accessories may settle one pose after the body peak while remaining on the same numbered frame.
- Repeated secondary bounce must decay or resolve before the animation returns to rest.
- Face-obscuring motion requires Art Direction approval.

Secondary motion must remain inside the shared canvas and preserve modular compatibility.

---

## 15. Preview and Gameplay Playback

Character creation preview uses the same animation keys as gameplay:

- Idle preview: `idle_down`.
- Walk preview: `walk_down`.
- Attack preview: `attack_down`.

Preview playback must not use separate timing that hides synchronization defects. It may restart a selected animation on explicit user input, but appearance changes preserve the current animation and frame where possible.

Gameplay selects `{state}_{direction}` and may safely fall back to the Down version while prototype directions are incomplete.

---

## 16. Modular Synchronization

Body is the preferred animation clock. If Body does not contain the requested animation, another valid visible layer may become the safe fallback clock.

For every modular resource:

- Animation name matches exactly.
- Frame count matches exactly.
- Base FPS matches exactly.
- Per-frame duration multipliers match exactly.
- Loop flag matches exactly.
- Frame 0 begins at the same action phase.
- Pivot and transparent canvas match exactly.

A layer with an invalid animation is hidden. It must not continue playing an old action or display a frame from another direction.

---

## 17. Timing Events

Animation reviews use the following semantic event vocabulary:

| Event | Meaning |
|---|---|
| `animation_started` | State and direction have been accepted |
| `anticipation_started` | Player intent becomes visually readable |
| `contact` | Visual hit or interaction peak |
| `recovery_started` | Action begins returning control |
| `animation_finished` | Non-looping visual sequence ends |

These names describe the production timing contract. Gameplay remains authoritative for damage, movement permission, invulnerability, and action cancellation.

Do not attach critical logic only to a cosmetic layer's `frame_changed` signal. Modular layers may be absent.

---

## 18. Review Procedure

Every animation is reviewed:

1. As Body only.
2. With all default modular layers.
3. With the widest hair, clothing, accessory, and weapon combination.
4. In all four directions.
5. At frame-by-frame speed.
6. At intended gameplay speed.
7. While the Player moves at production velocity.
8. In the character creation preview.
9. At target desktop and Web resolutions.

### Rejection conditions

- Pivot or foot baseline drifts unintentionally.
- A modular layer lags, skips, or uses a different frame count.
- Loop boundary pops.
- Weapon separates from the grip.
- Attack has no readable anticipation or recovery.
- Idle breathing resembles hopping or floating.
- Root motion is embedded in artwork.
- Direction naming or order is inconsistent.
- Missing animation displays the wrong pose instead of failing safely.

---

## 19. Production Acceptance Checklist

- Animation uses `{action}_{direction}` naming.
- Direction order is Down, Left, Right, Up.
- Frame count and FPS match the approved table or action brief.
- Loop flag is correct.
- Frame durations match across all layers.
- Pivot is `(24, 32)` on the logical 48 × 64 canvas.
- Root world position is not animated.
- Foot contact is stable.
- Transition into and out of the action is readable.
- Attack anticipation, contact, follow-through, and recovery are identifiable.
- Idle breathing is subtle and feet remain fixed.
- Hair, clothing, weapon, and accessories remain synchronized.
- Gameplay-scale and Web-export playback are visually approved.

---

## 20. Change Control

Animation names, direction names, pivot, frame order, and modular timing are compatibility-critical. Changes require Animation, Technical Art, and Engineering approval and must update every affected `SpriteFrames` resource together.

Do not fix an isolated asset by breaking the shared animation contract.
