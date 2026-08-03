# LumaVale Art Bible

**Document owner:** Art Director  
**Applies to:** Characters, creatures, environments, props, VFX, UI illustration, marketing art  
**Visual target:** Cozy Fantasy · Anime-inspired · Hand-painted · Relaxing · Premium Indie RPG  
**Status:** Production guideline

---

## 1. Vision

LumaVale presents a small fantasy world that feels welcoming, inhabited, and worth caring for. The visual language combines the clarity and emotional appeal of anime-inspired character design with the warmth, surface variation, and authored imperfections of hand-painted illustration.

The final image must feel polished without becoming sterile, charming without becoming childish, and magical without becoming visually exhausting. Every frame should support the fantasy that the player has found a peaceful home inside a living adventure.

LumaVale is not restricted to pixel art. Production assets may use high-resolution raster artwork, vector-based interface elements, skeletal animation, frame animation, shaders, or procedurally assisted workflows when they preserve the approved visual target. UI and presentation assets must remain sharp and readable across supported resolutions and scale settings.

### Visual promise

> A luminous, handcrafted fantasy world where nature, community, and gentle adventure coexist.

### Quality bar

- Silhouettes read immediately at gameplay scale.
- Important information is clear before decorative detail is noticed.
- Materials feel painted and tactile rather than photorealistic.
- Color, light, and motion guide attention without creating stress.
- Assets remain coherent when viewed beside work from another artist or vendor.

---

## 2. Artistic Pillars

### 2.1 Welcoming wonder

Magic should feel discoverable and benevolent. Use soft spectacle, natural motifs, restrained particles, and moments of luminous contrast. Avoid visual language associated with horror, cosmic dread, or oppressive dark fantasy unless a controlled narrative beat explicitly requires it.

### 2.2 Handcrafted harmony

Forms should show intentional simplification, gentle asymmetry, painted edge variation, and selective texture. Assets must feel authored by the same world, not assembled from unrelated libraries.

### 2.3 Anime clarity

Prioritize expressive silhouettes, readable poses, appealing proportions, clear value grouping, and economical facial features. Anime influence is a design principle, not a requirement for flat cel shading or exaggerated genre clichés.

### 2.4 Nature in partnership

Settlements and crafted objects should coexist with the landscape. Architecture follows terrain; plants reclaim edges; paths reflect use; and local materials connect structures to their biome.

### 2.5 Calm readability

Gameplay must remain legible during movement, weather, combat, and multiplayer overlap. Detail density, contrast, saturation, and motion are allocated according to gameplay importance.

---

## 3. Mood

The baseline mood is optimistic, restorative, and quietly adventurous. The world should suggest that daily life continues beyond the player: smoke rises from chimneys, gardens are maintained, lanterns are lit, and paths show repeated travel.

Use emotional contrast carefully. Mines and dungeons may feel mysterious or tense, but should remain part of the same inviting universe. Darkness is atmospheric rather than punishing; danger is readable rather than grotesque.

Mood targets:

- **Town:** safe, social, warm, gently busy.
- **Forest:** fresh, layered, curious, softly magical.
- **Mine:** cool, earthy, enclosed, materially rich.
- **Dungeon:** ancient, dramatic, readable, adventurous rather than horrific.

---

## 4. Lighting

Lighting is painterly and composition-led. It supports time of day, navigation, emotional tone, and focal hierarchy before physical accuracy.

- Use a broad key light with soft transitions and a restrained ambient fill.
- Reserve the brightest values for focal characters, interactables, exits, and narrative points.
- Allow local lights to tint nearby surfaces, but avoid uncontrolled saturation.
- Maintain readable midtones; large areas should not collapse into black.
- Use warm-versus-cool relationships to separate foreground, subject, and background.
- Bloom must be subtle and limited to emissive magic, sunlight glints, and selected practical lights.
- Avoid uniform rim lighting on every object. Rim light is a compositional tool, not a default material property.

Time-of-day lighting must preserve asset identity. Dawn, noon, dusk, and night may shift color and contrast, but must not invalidate navigation or character readability.

---

## 5. Camera

Gameplay uses a stable top-down three-quarter camera appropriate for a 2D living-world RPG. Camera behavior must prioritize comfort, spatial comprehension, and short-session accessibility.

- Maintain a consistent gameplay projection within each map family.
- Frame enough space ahead of movement to support navigation and encounters.
- Keep camera acceleration and deceleration smooth and restrained.
- Camera shake is brief, low amplitude, and reserved for meaningful impacts.
- Do not use continuous sway, breathing motion, or decorative drift during standard gameplay.
- Cinematic framing may temporarily break gameplay rules only when player control and exit conditions remain clear.
- Composition must work at all supported aspect ratios using safe zones rather than stretching artwork.

Parallax layers should reinforce depth without competing with the player or creating motion sickness.

---

## 6. Perspective

The world uses a consistent three-quarter top-down visual construction. Ground planes, walls, roofs, props, and characters must agree on horizon logic and visible surface ratios.

- Preserve consistent vertical-to-horizontal depth cues across modular assets.
- Ellipses, roof pitches, stairs, doors, and furniture must share the approved projection.
- Do not mix isometric, side-view, and top-down conventions within the same gameplay space.
- Vertical exaggeration is permitted when it improves silhouette or interaction readability.
- Collision footprint and visual footprint should align closely enough that player expectations remain reliable.

Background illustration may use atmospheric perspective, but interactive geometry must retain crisp positional clarity.

---

## 7. Character Rendering

Characters are the strongest emotional focal points. Rendering must favor personality, customization readability, and clean animation over anatomical complexity.

- Use appealing, slightly chibi proportions with a clear head, torso, hands, and feet at gameplay scale.
- Faces use economical features and controlled contrast; eyes carry expression without dominating the full design.
- Separate modular layers by silhouette and value, not outlines alone.
- Hair is designed in readable masses before individual strands.
- Clothing uses simplified folds that describe pose and material.
- Accessories and weapons must not obscure the face or break the core silhouette unnecessarily.
- Skin, hair, and outfit colors must remain identifiable under all approved lighting conditions.
- Highlights are selective and shape-based; avoid plastic shine across skin and cloth.

Portraits may contain finer rendering than gameplay sprites, but proportions, costume construction, palette relationships, and identity markers must remain consistent.

---

## 8. Environment Rendering

Environments are layered from large readable masses to selective storytelling detail.

1. Establish terrain, route, landmark, and playable boundary.
2. Separate navigation surfaces through value, hue, edge treatment, and material.
3. Place medium-scale forms to create rhythm and depth.
4. Add small detail only where it supports story, interaction, or focal hierarchy.

Buildings should feel maintained and inhabited. Props must imply use and ownership. Natural spaces should avoid evenly distributed noise; use clusters, clearings, overlaps, and deliberate areas of rest.

Interactive objects require stronger separation than decorative objects. Collision-only boundaries must have a believable visual explanation such as water, dense vegetation, elevation, fencing, or architecture.

---

## 9. Materials

Materials are stylized through shape language, value grouping, and painted texture rather than physically based realism.

- **Wood:** warm, directional grain; softened wear at handled edges; limited high-frequency lines.
- **Stone:** broad plane changes, irregular color variation, restrained cracks; avoid procedural speckle.
- **Metal:** compact, deliberate highlights and cool-to-warm reflection shifts; never mirror-like by default.
- **Cloth:** broad folds, soft value transitions, minimal specular response.
- **Leather:** firmer edges and warmer highlights than cloth, with wear at functional points.
- **Water:** readable depth zones, slow surface movement, controlled reflections, clear collision boundary.
- **Foliage:** grouped leaf masses, selective edge detail, hue variation by plane and depth.
- **Magic:** luminous cores, colored falloff, simple motif language, and disciplined particle counts.

Every material must remain recognizable without relying solely on color.

---

## 10. Texture Style

Textures should suggest brushwork and natural variation while remaining clean at gameplay scale.

- Build broad value and hue variation first; add surface marks last.
- Use soft-edged painted transitions alongside selected crisp accents.
- Keep texture frequency proportional to screen size and camera distance.
- Avoid photographic overlays unless fully repainted and integrated.
- Avoid uniform noise, excessive grain, and texture that causes shimmer during movement.
- Preserve transparent edge quality for HD sprites; eliminate halos and unintended matte colors.
- Author source files at sufficient resolution for target displays and downsample with an approved filtering method.

Texture density must be consistent within an asset category. Higher detail is allowed in portraits, key art, and close-up UI illustrations, not indiscriminately across gameplay assets.

---

## 11. Outline Style

Outlines are selective, colored, and subordinate to form.

- Prefer dark local-color outlines over pure black.
- Use stronger outer contours and lighter or broken internal lines.
- Reduce outlines on brightly lit edges and increase them where forms overlap.
- Avoid identical line weight around every element.
- Environment outlines should generally be softer and less prominent than character outlines.
- UI icons may use firmer contours to maintain legibility at small sizes.

Outlines must not become the only method of separating modular character layers or interactive objects.

---

## 12. Shadow Style

Shadows are soft, readable, and intentionally simplified.

- Character contact shadows anchor feet and communicate elevation.
- Cast shadows follow the primary light direction but may be adjusted for clarity.
- Use colored shadow values related to ambient light; avoid neutral black overlays.
- Keep penumbra broad in calm outdoor scenes and slightly firmer in enclosed dramatic spaces.
- Ambient occlusion is restrained and concentrated at contact points.
- Do not stack multiple darkening methods until forms appear dirty or crushed.

Dynamic shadows must remain stable during camera movement and must not flicker at sprite edges.

---

## 13. Weather Style

Weather enriches atmosphere and world state without reducing usability.

- Rain uses layered depth, varied streak timing, localized splashes, and subtle surface darkening.
- Snow uses slow, readable flakes with limited foreground occlusion and gentle accumulation cues.
- Fog is depth-separated and preserves interaction contrast.
- Wind is communicated through foliage, cloth, particles, and audio rather than aggressive camera movement.
- Storm effects use controlled flashes and must respect accessibility settings.

Weather intensity must be scalable. Reduce or disable nonessential particles, flashes, and motion when reduced-motion or performance settings require it.

---

## 14. Seasonal Variation

Seasonal changes should feel systemic, not like a global color filter.

- Shift foliage species, ground cover, crops, props, sky behavior, and local storytelling details.
- Preserve biome identity and navigation landmarks across every season.
- Adjust lighting and atmospheric color alongside asset variation.
- Keep interactable and hazard readability consistent.
- Reuse base geometry where practical, but author season-specific breakup to avoid obvious palette swaps.

Seasonal palettes must be reviewed beside characters and UI overlays. No season may make skin tones, role colors, exits, or selection indicators difficult to read.

---

## 15. Things to Avoid

The following are outside the LumaVale visual target unless explicitly approved by the Art Director:

- Pixel-art-only constraints that prevent HD assets, scalable UI, or modern display support.
- Photorealistic materials, photographic textures, or physically harsh lighting.
- Generic mobile-game gloss, excessive gradients, plastic surfaces, and indiscriminate glow.
- Heavy black outlines of uniform width around every object.
- Muddy values, crushed blacks, clipped highlights, or low-contrast interaction states.
- Excessive bloom, chromatic aberration, film grain, vignette, or screen-space distortion.
- Over-detailed backgrounds that compete with characters and interactables.
- Uniformly scattered props, foliage, texture noise, or particles.
- Extreme anime proportions or fan-service styling that conflicts with the cozy all-ages world tone.
- Horror gore, grotesque anatomy, oppressive decay, or cynical visual humor.
- Inconsistent perspective, lighting direction, texture density, or material response between asset sets.
- UI embedded directly into detailed scenery without a controlled readability layer.
- Decorative animation that never rests or cannot be disabled for accessibility.
- Unlicensed references, copied designs, recognizable third-party characters, or direct style imitation of living artists.

---

## Art Review Standard

All production art is reviewed at three levels: isolated asset, gameplay context, and target-device presentation. Approval requires correct visual language, technical compliance, gameplay readability, and consistency with adjacent assets. An asset is not final because it looks polished in isolation; it is final when it strengthens the complete LumaVale experience.
