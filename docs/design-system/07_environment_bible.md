# LumaVale Environment Bible

**Document owner:** Environment Art Director / World Art  
**Visual target:** Cozy Fantasy · Anime-inspired · Hand-painted · Premium Indie RPG  
**Primary locations:** Town · Forest · Mine · Dungeon  
**Supported world states:** Morning · Sunset · Night · Rain · Snow · Fog

---

## 1. Environment Vision

LumaVale is a small, inhabited fantasy world shaped by daily life, nature, and gentle adventure. Environments must feel cared for rather than pristine: paths show use, buildings show maintenance, gardens show ownership, and natural growth softens constructed edges.

The player should understand where they can walk, what they can interact with, and where they are going before noticing surface decoration. Time and weather enrich the world without changing its fundamental readability.

### Visual promise

> Every location feels handcrafted, seasonally alive, and welcoming enough to become familiar.

### Core principles

1. **Navigation first.** Roads, landmarks, boundaries, exits, and interactables remain readable in every world state.
2. **Controlled detail.** Detail forms clusters around story and function, leaving deliberate areas of rest.
3. **Material honesty.** Wood, stone, soil, cloth, metal, foliage, and water are identifiable through form and value, not color alone.
4. **Nature in partnership.** Architecture follows terrain and uses local materials; vegetation reclaims seams and unused edges.
5. **Painterly atmosphere.** Lighting and weather support mood without pursuing photorealism.
6. **Stable composition.** Weather, particles, and animated surfaces never obscure critical gameplay information.

---

## 2. World Construction Standard

### Perspective

Gameplay environments use the approved three-quarter top-down projection. Ground, walls, roofs, roads, bridges, props, and water edges must share the same projection logic.

- Interactive footprints align closely with collision footprints.
- Vertical exaggeration is permitted for landmark and doorway readability.
- Roofs and tree canopies may overlap characters only when fade, cutaway, or foreground-occlusion behavior is defined.
- Do not mix isometric and top-down construction in the same playable space.

### Composition hierarchy

Each gameplay view should contain:

1. A readable navigation surface.
2. One primary landmark or directional anchor.
3. Medium forms that create depth and rhythm.
4. Small details concentrated around use, ownership, or story.
5. Quiet negative space around important interactions.

### Detail density

| Zone | Detail level | Purpose |
|---|---|---|
| Main path and interaction apron | Low–medium | Navigation and interaction clarity |
| Landmark | Medium–high | Identity and orientation |
| Building or biome edge | Medium | Framing and boundary explanation |
| Non-playable background | Medium–high with reduced contrast | Depth without competition |
| Foreground occluder | Low frequency, large shape | Depth framing only |

---

## 3. Environment Palette System

Environment color is organized by semantic role. Time and weather remap these roles; artists do not apply a single global color filter.

| Role | Purpose |
|---|---|
| `ENV_SKY` | Background atmosphere and distant ambient influence |
| `ENV_LIGHT_KEY` | Sun, moon, and dominant practical-light color |
| `ENV_AMBIENT` | General fill affecting local surfaces |
| `ENV_SHADOW` | Colored cast and form shadow family |
| `ENV_GROUND` | Primary walkable terrain |
| `ENV_FOLIAGE` | Dominant vegetation family |
| `ENV_WATER` | Base water body and depth family |
| `ENV_EMISSIVE` | Lanterns, windows, magic, and selected practical lights |

### Palette rules

- Use broad value groups before local texture color.
- Keep saturation controlled; the environment supports characters and UI rather than competing with them.
- Reserve the highest saturation for small focal accents, interactables, seasonal flowers, and narrative magic.
- Maintain warm/cool separation between key light and ambient shadow.
- Do not recolor skin, role markers, exits, hazards, or UI through uncontrolled full-screen grading.
- Verify every state in grayscale to preserve navigation and material separation.

---

## 4. Baseline Materials

### Wood

- Use warm local variation, directional grain, and softened handled edges.
- Large beams show broad plane changes before grain lines.
- Wet wood darkens and gains selective reflections; it does not become uniformly glossy.
- Snow accumulates on upward-facing planes and sheltered joints.

### Stone

- Use irregular blocks, broad value shifts, and limited cracks.
- Path stone is smoother and lighter at repeated footfall zones.
- Wet stone has darkened pores and compact highlights.
- Avoid procedural speckle and identical repeated stones.

### Soil and roads

- Use packed centers, softer edges, shallow ruts, and clustered debris.
- Material transitions use overlap, erosion, plants, stones, or constructed borders.
- Avoid noisy texture over the entire walkable surface.

### Metal

- Highlights are compact and shape-based.
- Weathering appears at joints, handles, lower edges, and exposed fasteners.
- Do not use mirror-like reflections or chrome response.

### Cloth

- Awnings, flags, laundry, and canopies use broad folds and slow wind response.
- Cloth saturation decreases with age and exposure.
- Wet cloth darkens, gains weight, and moves less.

### Water

- Water uses readable depth bands, slow surface rhythm, controlled reflection, and clear collision edges.
- Shore and bridge contact points receive deliberate material transitions.
- No full-screen mirror reflection or high-frequency shimmer.

---

## 5. Baseline Props

Props communicate occupation, routine, season, and ownership.

### Town

Crates, baskets, planters, benches, signs, lanterns, tools, market cloth, barrels, drying herbs, farm implements, and small personal objects.

### Forest

Trail markers, cut stumps, fallen branches, mushroom clusters, shrine stones, gathering baskets, rope bridges, camps, and weathered signs.

### Mine

Support beams, carts, rails, lantern hooks, tool racks, ore piles, bracing, rope, buckets, warning signs, and drainage channels.

### Dungeon

Ancient markers, sealed doors, ritual fixtures, collapsed masonry, restrained magical artifacts, old storage, and directional floor motifs.

### Placement rules

- Place props in functional groups rather than evenly distributed scatter.
- Keep interaction aprons clear.
- Reuse prop families with controlled variation in wear, fill level, rotation, and local story.
- Do not use props as invisible collision excuses; boundaries must be visually credible.

---

## 6. Baseline Vegetation

Vegetation is composed in masses: canopy, shrub, ground cover, and accent growth.

- Cluster plants by moisture, shade, disturbance, and soil type.
- Keep major paths open with compressed or trimmed edge growth.
- Use hue and value variation between depth planes, not random per-leaf color.
- Animate vegetation by group with slight phase offsets; avoid every plant swaying identically.
- Reserve small flower accents for focal areas and seasonal storytelling.
- Plants near buildings reflect care: pruned, cultivated, harvested, or intentionally overgrown.
- Dense collision vegetation must read as physically impassable.

---

## 7. Baseline Architecture

Architecture is human-scale, warm, and regionally coherent.

### Town language

- Stone or timber lower structures with plaster, wood, and shingle upper forms.
- Soft roof pitches and slightly irregular silhouettes.
- Visible signs of care: repaired boards, clean thresholds, flower boxes, swept entries.
- Doors, shop fronts, and public buildings are readable at gameplay scale.

### Mine language

- Functional timber bracing, carved stone, rails, drainage, and repeated safety rhythm.
- Structure reveals excavation logic rather than arbitrary corridors.

### Dungeon language

- Older, larger, and more formal geometry than Town.
- Repeated motifs establish culture and navigation.
- Damage, roots, mineral deposits, and water intrusion show age without becoming horror decay.

### Rules

- Use local materials that connect structures to the biome.
- Break symmetry through believable use and repair.
- Avoid oversized decorative façades that hide playable entrances.
- Windows and doorways may provide warm focal light, but not every opening glows equally.

---

## 8. Baseline Roads and Paths

Roads are the primary navigation graphic.

- Main routes have the clearest value and edge continuity.
- Secondary routes are narrower and use softer material transitions.
- Intersections provide breathing room and a visible landmark.
- Path edges vary through erosion, plants, stones, curbs, fences, or drainage.
- Avoid perfectly straight repeated-width paths unless architecture justifies them.
- Do not place dense particles, high-contrast decals, or decorative clutter over exits.

Roads must remain readable in Morning, Sunset, Night, Rain, Snow, and Fog.

---

## 9. Baseline Water

- Shallow water is lighter, warmer, and reveals ground or edge detail.
- Deep water is darker and calmer, with reduced bottom visibility.
- Flow follows terrain and changes around rocks, banks, and structures.
- Reflections are simplified color masses, not literal scene duplication.
- Foam and ripples appear at contact and flow change, not uniformly everywhere.
- Water boundaries must communicate collision without requiring a debug outline.
- Particle and shader motion remains slow enough for a relaxing world tone.

---

## 10. Baseline Particles

Particles reinforce atmosphere and material response. They never replace modeled or painted environment structure.

- Use layered depth: background, gameplay plane, and sparse foreground.
- Foreground particles are larger but significantly less frequent.
- Keep a quiet central area around the player, dialogue, and interactions.
- Use pooled or engine-managed systems; avoid per-frame allocation from environment scripts.
- Remove or reduce particles under performance and reduced-motion settings.
- No continuous bloom or screen-filling magical dust.

### Baseline budget target

| Class | Recommended visible count |
|---|---:|
| Ambient motes, leaves, insects | 12–32 |
| Local material particles | 4–16 per active source |
| Weather field | 80–160, scaled by viewport and performance tier |
| Foreground occluding particles | 0–12 |

Counts are starting budgets, not targets to fill. Visual density and overdraw determine final approval.

---

## 11. Morning State

Morning is the default welcoming state: fresh, luminous, and gently active.

### Palette

| Role | HEX | RGB |
|---|---|---|
| `ENV_SKY` | `#BDD9D2` | 189, 217, 210 |
| `ENV_LIGHT_KEY` | `#F2D39A` | 242, 211, 154 |
| `ENV_AMBIENT` | `#D8E5D5` | 216, 229, 213 |
| `ENV_SHADOW` | `#748A80` | 116, 138, 128 |
| `ENV_GROUND` | `#B8A77E` | 184, 167, 126 |
| `ENV_FOLIAGE` | `#5F8066` | 95, 128, 102 |
| `ENV_WATER` | `#6F9E9B` | 111, 158, 155 |
| `ENV_EMISSIVE` | `#D8A85A` | 216, 168, 90 |

### Lighting

- Warm, low-to-medium key angle with soft cool-green ambient fill.
- Long shadows are softened and low contrast.
- Dew and water receive small selective highlights, not broad sparkle.

### Materials

- Dry materials retain warm local color.
- Dew appears only on upward foliage, grass tips, and selected roof edges.
- Stone and wood remain matte with gentle morning highlights.

### Props

- Open shutters, market setup, watering tools, baskets, breakfast smoke, and newly placed goods.
- Lanterns may remain faintly lit but do not compete with sunlight.

### Vegetation

- Fresh mid-green masses with cool shadow planes.
- Small dew response and restrained insect activity.
- Flower accents remain localized.

### Architecture

- Warm sun catches roof edges, upper walls, signs, and window frames.
- Entrances remain clearly readable through value separation.

### Roads

- Packed centers are warm and clear.
- Edge grass receives small cool shadows; no mist covers primary intersections.

### Water

- Pale sky reflection and readable shallow zones.
- Slow ripple highlights appear at banks and bridge supports.

### Particles

- Sparse pollen, tiny insects, chimney smoke, and occasional falling leaf.
- Motion is slow and uneven; no constant glitter field.

---

## 12. Sunset State

Sunset is warm, reflective, and slightly dramatic while preserving the cozy tone.

### Palette

| Role | HEX | RGB |
|---|---|---|
| `ENV_SKY` | `#D49A78` | 212, 154, 120 |
| `ENV_LIGHT_KEY` | `#E9BD75` | 233, 189, 117 |
| `ENV_AMBIENT` | `#A78689` | 167, 134, 137 |
| `ENV_SHADOW` | `#50576D` | 80, 87, 109 |
| `ENV_GROUND` | `#A77D63` | 167, 125, 99 |
| `ENV_FOLIAGE` | `#536657` | 83, 102, 87 |
| `ENV_WATER` | `#677D87` | 103, 125, 135 |
| `ENV_EMISSIVE` | `#D9A451` | 217, 164, 81 |

### Lighting

- Low warm key light and cool violet ambient shadow.
- Longer shadows frame routes but never cover exits completely.
- Practical lights begin to appear near doors and public spaces.

### Materials

- Warm planes increase in hue, not uniform saturation.
- Metal and water receive narrow amber accents.
- Shadowed plaster and stone shift cool rather than simply darkening.

### Props

- Closing market cloth, stacked goods, lit lanterns, evening meal cues, and returned farm tools.
- Long prop shadows must not resemble hazards.

### Vegetation

- Canopy edges catch warm light; inner masses remain muted green-violet.
- Flowers and berries lose saturation outside focal light.

### Architecture

- Upper roof planes and west-facing façades carry the warmest light.
- Windows and lanterns create selective signs of life.

### Roads

- Preserve a continuous mid-value path against cooler shadows.
- Use warm edge accents to lead toward Town and shelter.

### Water

- Reflect broad amber and violet bands.
- Avoid full orange mirror surfaces; depth remains visible at shorelines.

### Particles

- Sparse drifting dust, insects around selected lights, chimney smoke, and falling leaves.
- Light-attracted particles remain local to practical lights.

---

## 13. Night State

Night is safe, mysterious, and navigable. It is not a black or horror-state version of the world.

### Palette

| Role | HEX | RGB |
|---|---|---|
| `ENV_SKY` | `#1D2A3B` | 29, 42, 59 |
| `ENV_LIGHT_KEY` | `#C5D5D3` | 197, 213, 211 |
| `ENV_AMBIENT` | `#44556B` | 68, 85, 107 |
| `ENV_SHADOW` | `#171D29` | 23, 29, 41 |
| `ENV_GROUND` | `#4B4D50` | 75, 77, 80 |
| `ENV_FOLIAGE` | `#31483E` | 49, 72, 62 |
| `ENV_WATER` | `#314F61` | 49, 79, 97 |
| `ENV_EMISSIVE` | `#D9AF61` | 217, 175, 97 |

### Lighting

- Cool ambient fill keeps midtones readable.
- Moonlight is broad and subtle; warm lantern pools provide navigation hierarchy.
- Never crush large playable regions to black.
- Bloom is restrained to small emissive cores.

### Materials

- Local material identity remains visible through value and edge response.
- Metal highlights become compact and cool.
- Warm wood near lanterns retains color; unlit wood shifts muted blue-green.

### Props

- Lit windows, lantern posts, closed stalls, resting tools, evening seating, and guarded entrances.
- Emissive props are placed at decisions, paths, and social points rather than evenly spaced decoration.

### Vegetation

- Foliage becomes larger, quieter masses with selected moonlit edges.
- Fireflies are rare focal accents, not a continuous field.

### Architecture

- Silhouettes and doors remain clear against the sky and ground.
- Warm windows suggest occupancy but do not turn every building into a lantern.

### Roads

- Main roads remain one value step clearer than adjacent ground.
- Lantern rhythm reinforces route continuity.

### Water

- Darker depth bands with restrained moon streaks and warm local reflections.
- Shore collision remains visible through edge value and sparse ripple accents.

### Particles

- Occasional fireflies, moths near lamps, chimney smoke, and sparse atmospheric motes.
- Avoid dense stars, glitter, or pulsing magic across the entire screen.

---

## 14. Rain State

Rain feels restorative and tactile. It changes material response and activity without making the screen gray and unreadable.

### Palette

| Role | HEX | RGB |
|---|---|---|
| `ENV_SKY` | `#71818A` | 113, 129, 138 |
| `ENV_LIGHT_KEY` | `#B3C1BC` | 179, 193, 188 |
| `ENV_AMBIENT` | `#8FA09E` | 143, 160, 158 |
| `ENV_SHADOW` | `#3D4B51` | 61, 75, 81 |
| `ENV_GROUND` | `#77776B` | 119, 119, 107 |
| `ENV_FOLIAGE` | `#466854` | 70, 104, 84 |
| `ENV_WATER` | `#567A82` | 86, 122, 130 |
| `ENV_EMISSIVE` | `#D3A15A` | 211, 161, 90 |

### Lighting

- Broad overcast key with soft, low-contrast shadows.
- Warm practical lights gain importance but remain localized.
- Lightning is excluded from ordinary rain; storms require a separate accessibility-reviewed state.

### Materials

- Wood, soil, stone, and cloth darken selectively according to exposure.
- Wet highlights appear on upward planes and worn surfaces.
- Puddles form in believable depressions; avoid uniform gloss.

### Props

- Awnings, covered goods, buckets, drainage, umbrellas where culturally appropriate, closed shutters, and sheltered NPC activity.
- Loose props show weight and reduced wind movement when wet.

### Vegetation

- Foliage deepens in color and moves with occasional weighted gusts.
- Droplet accents stay sparse and scale-appropriate.

### Architecture

- Roof runoff, gutters, eaves, and shelter become readable functional details.
- Wall bases and exposed timber show localized darkening.

### Roads

- Packed centers darken; shallow puddles collect at edges and ruts.
- Main route value remains distinct from grass and deep water.

### Water

- Surface ripples use varied timing and scale.
- Streams gain subtle speed and turbulence at constrictions.
- Rain response does not erase depth bands or shore boundaries.

### Particles

- Use background, gameplay-plane, and sparse foreground rain layers.
- Add localized splashes and roof runoff; do not spawn splash effects uniformly.
- Foreground streaks remain below the level that obscures the player or text.

---

## 15. Snow State

Snow creates quiet seasonal transformation while retaining landmarks, routes, and material identity.

### Palette

| Role | HEX | RGB |
|---|---|---|
| `ENV_SKY` | `#A8BBC2` | 168, 187, 194 |
| `ENV_LIGHT_KEY` | `#E5E0CF` | 229, 224, 207 |
| `ENV_AMBIENT` | `#C5D0D0` | 197, 208, 208 |
| `ENV_SHADOW` | `#91A8B8` | 145, 168, 184 |
| `ENV_GROUND` | `#E7E5DC` | 231, 229, 220 |
| `ENV_FOLIAGE` | `#455D54` | 69, 93, 84 |
| `ENV_WATER` | `#7899A6` | 120, 153, 166 |
| `ENV_EMISSIVE` | `#D6A45B` | 214, 164, 91 |

### Lighting

- Soft high ambient light with cool blue-gray shadows.
- Snow bounce raises fill without flattening forms.
- Warm lanterns and windows remain controlled focal anchors.

### Materials

- Snow accumulates on upward-facing and sheltered surfaces.
- Wood, stone, metal, and cloth remain visible at edges and high-use areas.
- Avoid covering every material with one flat white mask.

### Props

- Cleared thresholds, stacked firewood, covered market goods, snow tools, footprints, and sheltered supplies.
- Footprints are directional story accents, not repeated noise across all paths.

### Vegetation

- Evergreen masses hold selective snow weight.
- Dormant plants reduce density and saturation.
- Branch bend is subtle and consistent with accumulation.

### Architecture

- Roof accumulation follows pitch, eaves, heat loss, and recent clearing.
- Doorways and active public areas are visibly maintained.

### Roads

- Primary paths are compressed, partially cleared, or marked by repeated travel.
- Use blue-gray shadow and exposed ground to preserve route boundaries.

### Water

- Open water is cooler and darker against snow.
- Ice appears only where world logic permits and must clearly communicate walkability or collision.
- Do not use visual ice without matching gameplay behavior.

### Particles

- Use slow flakes at multiple depths with very sparse large foreground flakes.
- Avoid blizzard density in the standard cozy snow state.
- Accumulation is handled by authored state assets or controlled shaders, not particle persistence alone.

---

## 16. Fog State

Fog creates intimacy and discovery by reducing distance, not by hiding immediate gameplay.

### Palette

| Role | HEX | RGB |
|---|---|---|
| `ENV_SKY` | `#C5CEC4` | 197, 206, 196 |
| `ENV_LIGHT_KEY` | `#D8D7C3` | 216, 215, 195 |
| `ENV_AMBIENT` | `#879991` | 135, 153, 145 |
| `ENV_SHADOW` | `#56645F` | 86, 100, 95 |
| `ENV_GROUND` | `#8D8E7E` | 141, 142, 126 |
| `ENV_FOLIAGE` | `#526B5C` | 82, 107, 92 |
| `ENV_WATER` | `#708C8C` | 112, 140, 140 |
| `ENV_EMISSIVE` | `#CFA25C` | 207, 162, 92 |

### Lighting

- Diffuse key with compressed distant contrast.
- Near gameplay surfaces retain normal readable value separation.
- Practical lights gain soft local falloff without oversized halos.

### Materials

- Near materials retain texture and local color.
- Distance reduces contrast, saturation, and edge detail in controlled layers.
- Surfaces may appear damp, but fog does not automatically make everything wet or glossy.

### Props

- Foreground signs, posts, lanterns, fences, and route markers gain navigational importance.
- Distant decorative props simplify or disappear before critical landmarks do.

### Vegetation

- Canopy and shrubs separate into depth masses.
- Near silhouettes stay clear; distant layers soften progressively.
- Avoid high-contrast leaf detail floating inside fog.

### Architecture

- Doorways and local façades remain clear within interaction range.
- Distant rooflines simplify into readable silhouettes.
- Landmark disappearance distance is authored, not accidental.

### Roads

- Path edges and route markers remain visible through the immediate navigation radius.
- Do not place dense ground fog over exits, hazards, or interaction prompts.

### Water

- Reflection contrast reduces with distance.
- Shoreline and collision edge remain clear near the player.
- Water fog and atmospheric fog share depth logic.

### Particles

- Use broad, slow fog layers rather than many small opaque particles.
- Local wisps remain below waist height and avoid the player's face.
- Reduced-motion mode minimizes drifting decorative layers while preserving depth readability.

---

## 17. State Combination Rules

Time and weather may combine, but their effects are composed by role rather than stacked as filters.

### Priority order

1. Gameplay readability and interaction contrast.
2. Time-of-day key light and ambient relationship.
3. Weather material response.
4. Seasonal asset variation.
5. Particles and decorative atmosphere.

Examples:

- **Night + Rain:** retain night navigation lights; add wet material response and rain particles without crushing unlit areas.
- **Morning + Fog:** retain warm near-field key light; reduce distant contrast without making the foreground gray.
- **Sunset + Snow:** preserve cool snow shadows and warm low-angle highlights; avoid full-scene orange grading.

Do not combine maximum intensity values from two states. Use authored combination presets.

---

## 18. Location-Specific Application

### Town

Emphasize routine, shelter, practical lighting, maintained roads, gardens, and seasonally changing social props.

### Forest

Emphasize layered vegetation, landmark trees, controlled clearings, gatherable clusters, and atmospheric depth. Paths remain readable in every state.

### Mine

Weather affects entrances and carried moisture more than deep interiors. Practical lights, drainage, material strata, and structural rhythm own the mood.

### Dungeon

Exterior weather may influence entrances, leaks, fog, or reflected ambient color. Interior state changes remain subtle unless the dungeon has an explicit world-event response.

---

## 19. Particle and Performance Validation

- Test particle density at 1280×720 and 1920×1080.
- Verify Web GL Compatibility rendering and overdraw.
- Confirm particles do not allocate or rebuild systems every frame.
- Confirm weather stops and cleans up without orphan particles.
- Confirm foreground particles never cover UI or dialogue.
- Confirm reduced-motion and lower-performance settings reduce nonessential layers.
- Confirm Rain, Snow, and Fog can run during character animation without visible frame pacing instability.

---

## 20. Environment Acceptance Checklist

- Palette follows semantic environment roles.
- Lighting preserves navigation and character readability.
- Material identity remains visible under the active state.
- Props communicate function, routine, season, or ownership.
- Vegetation forms intentional clusters and respects paths.
- Architecture uses coherent local materials and projection.
- Roads remain continuous and readable.
- Water depth, shore, flow, and collision are understandable.
- Particles support atmosphere without obscuring gameplay.
- Morning, Sunset, Night, Rain, Snow, and Fog have been reviewed.
- Combined states use authored presets rather than stacked filters.
- No glassy wet-everything treatment, heavy bloom, uniform noise, or full-screen color wash is present.

---

## 21. Change Control

Palette roles, navigation values, weather intensity tiers, architecture projection, and material standards are shared production contracts. Changes require Environment Art, Lighting, Game Design, and Technical Art review.

An environment state is not approved because it is attractive in a still image. It is approved when the player can navigate, recognize materials, locate interactions, and read the character comfortably during live gameplay.
