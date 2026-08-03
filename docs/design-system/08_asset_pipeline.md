# LumaVale Asset Pipeline

**Document owner:** Technical Art / Build Engineering  
**Engine:** Godot 4.x  
**Primary target:** Desktop and Web  
**Renderer:** GL Compatibility  
**Visual target:** HD-capable, hand-painted 2D with modular characters and scalable UI

---

## 1. Pipeline Goals

The LumaVale asset pipeline converts approved source work into predictable, versioned Godot resources without sacrificing visual quality, runtime performance, or modular compatibility.

Every production asset must be:

- stored in the correct category;
- named by stable purpose rather than temporary status;
- exported with the approved canvas, pivot, color space, and alpha treatment;
- imported through a documented profile;
- referenced through a Godot resource or scene;
- tested in context on Desktop and Web; and
- reproducible from its source without manual repair.

An asset is not complete when the source file looks correct. It is complete when the imported resource renders correctly in the target scene and survives a clean reimport and release export.

---

## 2. Asset Lifecycle

```text
Brief
  → source template
  → authored master
  → art review
  → technical validation
  → deterministic export
  → Godot import profile
  → Resource/Scene binding
  → in-context validation
  → Web export validation
  → approved release asset
```

### Ownership gates

| Gate | Owner | Required result |
|---|---|---|
| Brief | Art Direction / Design | Purpose, target scene, dimensions, states |
| Art review | Art Lead | Style, silhouette, material, palette |
| Technical review | Technical Art | Naming, canvas, pivot, alpha, frame contract |
| Integration | Engineering / Technical UI | Resource paths, import profile, scene binding |
| Release validation | QA / Build | Desktop and Web output with no missing resources |

---

## 3. Folder Structure

The Godot project uses the following production structure:

```text
lumavale/
├── assets/
│   ├── art/
│   │   ├── environments/
│   │   ├── props/
│   │   ├── vegetation/
│   │   └── vfx/
│   ├── audio/
│   │   ├── music/
│   │   ├── ambience/
│   │   ├── sfx/
│   │   └── ui/
│   ├── characters/
│   │   ├── body/
│   │   ├── hair/
│   │   ├── eyes/
│   │   ├── tops/
│   │   ├── bottoms/
│   │   ├── shoes/
│   │   ├── accessories/
│   │   └── weapons/
│   ├── fonts/
│   ├── shaders/
│   └── ui/
│       ├── backgrounds/
│       ├── panels/
│       ├── buttons/
│       ├── icons/
│       └── role_icons/
├── resources/
│   ├── appearance/
│   ├── roles/
│   └── themes/
│       └── styles/
├── scenes/
│   ├── character/
│   └── ...
├── ui/
│   ├── components/
│   ├── screens/
│   └── theme/
├── scripts/
│   └── character/
└── docs/
    └── design-system/
```

### Folder rules

- `assets/` contains engine-ready source files such as PNG, SVG, OGG, WAV, font, and shader files.
- `resources/` contains Godot-authored `.tres` data that binds assets to game semantics.
- `scenes/` and `ui/` contain `.tscn` composition, never raw art masters.
- `.godot/imported/` is generated cache and must not be versioned.
- `.import` sidecars and `.uid` files associated with tracked source resources remain versioned.
- `builds/` contains generated deliverables, not source assets. `builds/web/.gdignore` prevents the editor from importing its own output.
- Empty or future categories may be retained with `.gitkeep` until real assets exist.

### Master source files

Layered painting, vector-authoring, and animation-master files should live in a controlled `source_assets/` area outside Godot's import scan. Add `.gdignore` before placing source masters inside the repository. Do not place large layered masters in `assets/` where the editor will attempt to import them.

---

## 4. Naming Standard

All paths use lowercase snake_case and ASCII characters.

### General format

```text
{domain}_{subject}_{variant}_{state}.{extension}
```

Use only the segments required to identify the asset unambiguously.

### Examples

```text
body_a.svg
hair_short.svg
top_forest.svg
weapon_sword.svg
character_selection_v2.svg
icon_role_warrior.svg
env_town_lantern_lit.png
sfx_ui_confirm_01.ogg
```

### Godot resources

```text
resources/appearance/{item_id}.tres
resources/appearance/{item_id}_frames.tres
resources/roles/{role_id}.tres
```

### Animation frames

```text
chr_{item_id}_{layer}_{action}_{direction}_{frame_number}.png
```

Example:

```text
chr_weapon_sword_weapon_attack_left_03.png
```

### Prohibited naming

- Spaces, hyphens, uppercase letters, and non-ASCII punctuation.
- `final`, `final2`, `new`, `latest`, `fixed`, or artist initials as identity.
- Date stamps in runtime filenames.
- Numeric direction codes.
- Renaming stable item IDs after save data references them.

Detailed conventions are maintained in `09_naming_convention.md`.

---

## 5. Versioning

### Source control policy

- Text resources, scenes, scripts, SVG, configuration, and documentation use Git.
- Large binary masters and high-resolution audio use Git LFS when retained in the repository.
- Generated `.godot/` import cache is ignored.
- Godot `.import` metadata and `.uid` files are committed with their source asset.
- Web build files are committed only when release policy explicitly requires them.

### Revision policy

Version history belongs to source control, not filename suffixes.

```text
Correct:   env_town_fountain.png
Incorrect: env_town_fountain_final_v7_fixed.png
```

Use a filename version only when two revisions must coexist as distinct runtime contracts, such as `character_selection_v2.tscn`. In that case, the version is part of the feature identity and requires migration notes.

### Compatibility-critical assets

The following changes require coordinated migration:

- stable appearance or role IDs;
- character canvas, pivot, frame size, direction order, or animation keys;
- scene node paths consumed by scripts;
- Theme type variation names;
- resource paths stored in data or preload constants.

Do not delete or move a referenced resource until all paths are audited and the project passes a clean import.

---

## 6. Source Export Settings

### Color and alpha

- Author color artwork in sRGB unless an approved shader data texture requires linear values.
- Export transparent 2D art with straight alpha by default.
- Remove hidden matte colors that create light or dark edge halos.
- Preserve transparent padding required by canvas and pivot contracts.
- Do not flatten UI text into an image unless it is logo artwork.

### Raster export

| Asset class | Preferred format | Notes |
|---|---|---|
| Character layers | PNG or approved SVG | Lossless alpha; identical canvas for all layers |
| UI icons | SVG; PNG fallback | Convert text to paths; keep shapes simple |
| Panels and decorative UI | SVG or PNG | Preserve scalable edges; avoid embedded blur |
| Environment sprites | PNG or WebP | Lossless for small alpha assets; evaluate lossy for large opaque art |
| Full-screen backgrounds | PNG or high-quality WebP | Evaluate memory and Web download size |
| Masks/data textures | PNG | No lossy compression; document channel meaning |

### SVG export

- Use a correct `viewBox` and explicit dimensions.
- Convert font glyphs to paths for logo art.
- Expand unsupported effects or export a validated raster fallback.
- Avoid editor-specific filters, embedded external files, and unnecessary metadata.
- Verify Godot's SVG rasterizer produces the same silhouette and alpha edge as the source tool.

### Sprite sheets

- Frames use equal dimensions and deterministic ordering.
- Add 2–4 pixels of edge padding at the source scale when filtering or atlas bleeding requires it.
- Keep transparent canvas; never trim individual modular character frames.
- Use Down, Left, Right, Up direction order.
- Place frames left to right in chronological order.

Power-of-two dimensions are not mandatory for standard 2D textures. Use them only when atlas, shader, or target-platform constraints provide a measurable benefit.

---

## 7. Compression Profiles

Compression is selected by asset behavior, not file size alone.

### Profile A — Lossless 2D alpha

Use for:

- modular character layers;
- small UI icons;
- masks and data textures;
- small illustrated props with critical edges; and
- assets where compression artifacts damage outlines or transparency.

Godot import:

```text
Compress Mode: Lossless
Lossy Quality: not applicable
Fix Alpha Border: enabled for transparent color artwork
Premultiply Alpha: disabled unless the material and shader use premultiplied blending
```

### Profile B — Large hand-painted 2D

Use for large backgrounds or opaque environment plates after visual comparison.

```text
Compress Mode: Lossy or Lossless after review
Lossy Quality: start at 0.85–0.90
High Quality VRAM Compression: not relied upon in GL Compatibility
```

Review gradients, foliage, brush texture, textural edges, and banding in the exported Web build. Lossy compression reduces package size but not uncompressed video-memory use.

### Profile C — VRAM-sensitive large texture

VRAM Compressed or Basis Universal may be evaluated for large, noncritical textures when memory profiling justifies it. They are not default profiles for small 2D art because block artifacts are visible around outlines, alpha edges, and low-resolution details.

Use target-platform tests. The GL Compatibility/Web path may use different GPU compression formats than desktop, and visual approval must cover both.

### Compression rules

- Never apply lossy compression to masks, lookup data, normal maps, or crisp small icons.
- Do not accept haloing, ringing, block artifacts, or color shifts to save an unmeasured amount of space.
- Record changed import profiles in the asset review or pull request.
- Recheck PCK size and runtime memory after bulk compression changes.

---

## 8. Godot Import Settings

Godot import settings are applied through the Import dock or project import defaults. Do not hand-edit `.import` metadata as a routine workflow.

### Current project baseline

- Texture type: `Texture2D` / `CompressedTexture2D`.
- Current SVG placeholders: Lossless, mipmaps disabled, alpha-border fix enabled, SVG scale 1.0.
- Renderer: GL Compatibility.
- Project canvas texture default: Nearest.
- 2D transform and vertex snapping: enabled.
- Web preset: all resources, desktop VRAM texture compression enabled, thread support disabled.

These settings describe the current project; they are not a universal profile for future HD art.

### Import profile matrix

| Asset class | Compression | Mipmaps | Filter | Size limit |
|---|---|---|---|---:|
| Current 48×64 validation character | Lossless | Off | Nearest | 0 |
| HD hand-painted character | Lossless | Off at native scale; test On when downscaled | Linear or Linear with mipmaps | 0 |
| Small UI SVG/icon | Lossless | Off | Linear at intended size | 0 |
| Large UI background | Lossless/Lossy reviewed | On if downscaled | Linear with mipmaps | Target-specific review |
| Environment sprite at native scale | Lossless/Lossy reviewed | Off | Linear or Nearest per art treatment | 0 |
| Zoomed/downscaled environment | Reviewed | On | Linear with mipmaps | 0 |
| Data mask | Lossless | Off | Nearest unless shader requires interpolation | 0 |

### Import defaults

When a category has many assets with the same requirements, create an Import Defaults rule or multi-select/reimport workflow. Do not rely on artists remembering per-file exceptions.

After changing import settings:

1. Reimport the asset.
2. Inspect it in the FileSystem preview.
3. Inspect it in its target scene.
4. Test transparency and edge behavior over light and dark backgrounds.
5. Run the Web export when the setting affects compression, filtering, or package size.

---

## 9. Texture Filtering

In Godot 4, 2D texture filtering is controlled by CanvasItem/project settings rather than being solely an image-import decision.

### Nearest

Use for:

- current low-resolution validation character frames;
- deliberately pixel-aligned bitmap assets;
- data masks requiring exact texel boundaries; and
- assets displayed at exact integer scale when hard pixel edges are intentional.

### Linear

Use for:

- hand-painted HD character and environment art;
- scalable SVG-derived UI textures;
- images displayed at fractional or changing scale; and
- downsampled illustration where Nearest creates stair-stepping.

### Rules

- Do not force Nearest on every asset because the project began with low-resolution placeholders.
- Do not use Linear to hide a source-resolution problem.
- Character layers in one modular set use the same filtering mode.
- UI icons and text-bearing textures must be reviewed at 100%, 125%, and 200% UI scale.
- Shader `sampler2D` filter hints must match the approved asset profile.
- Changing the project default requires a complete review of sprites, UI, tilemaps, SubViewports, and fonts.

The asset's intended display scale must be documented before filter selection.

---

## 10. Mipmaps

Mipmaps store smaller prefiltered versions of a texture. They improve quality and sampling performance when an image is shown smaller than its source, but increase texture memory by roughly one third.

### Enable mipmaps when

- a large HD background is frequently downscaled;
- an environment asset appears at multiple camera zoom levels;
- a texture shows grain or shimmer when reduced;
- an illustration is authored for 4K but displayed at 1080p or lower; or
- profiling shows a benefit for repeated distant sampling.

### Disable mipmaps when

- the asset always renders at native size;
- the asset is a current low-resolution modular frame;
- a small UI icon must retain exact crisp boundaries;
- the asset is a mask requiring exact sampling; or
- the additional memory has no visible benefit.

### Rules

- Mipmaps are not a repair for an undersized source asset.
- Inspect the smallest expected display size for blur.
- Do not apply a global negative mipmap bias without cross-category review.
- Use the same mipmap profile across synchronized modular character layers.
- Validate Web memory and download impact after enabling mipmaps in bulk.

---

## 11. Pixel Snapping

The project currently enables:

```text
rendering/2d/snap/snap_2d_transforms_to_pixel = true
rendering/2d/snap/snap_2d_vertices_to_pixel = true
```

This supports crisp low-resolution prototype assets, but may reduce movement smoothness, particularly with camera smoothing and HD art.

### Rules

- UI Controls rely on Godot's control pixel snapping and integer Theme measurements.
- Pixel snapping does not replace correct canvas, pivot, or import settings.
- Do not manually round each modular layer independently; the character root owns transform alignment.
- Do not enable and disable snapping per frame.
- Review camera motion at gameplay speed after changing snap settings.
- HD pipeline migration must compare crispness, subpixel motion, camera smoothing, and Web rendering before changing the project-wide setting.

Use pixel snapping as a rendering policy, not as a repair for misaligned source artwork.

---

## 12. Pivot Standard

### Modular characters

| Property | Value |
|---|---:|
| Logical canvas | 48 × 64 units |
| Source pivot | `(24, 32)` |
| Local Godot pivot | `(0, 0)` with centered sprites |
| Recommended foot baseline | source `y = 60` |

Every Body, Hair, Eyes, Top, Bottom, Shoes, Weapon, AccessoryBack, and AccessoryFront frame shares this pivot.

### Environment and props

- Grounded props use the center of their ground-contact footprint as the world/y-sort anchor.
- Wall-mounted props use a documented attachment anchor.
- Doors and gates use their hinge or authored motion pivot.
- Trees use the trunk-ground contact, not canopy center.
- Water and ground tiles use grid-aligned origins defined by map production.

### UI

- UI layout uses Containers and anchors rather than manually authored texture pivots.
- Rotating decorative UI elements define a clear visual center in the source.
- Nine-patch or StyleBox assets preserve corner and content margins.

Never change a pivot to compensate for an incorrect node position in one scene.

---

## 13. Canvas Standard

### Character canvas

- Canonical logical frame: 48 × 64.
- HD sources may use exact 2× or 4× multiples.
- Transparent canvas is identical across every layer and frame.
- Individual frames are never trimmed to visible bounds.
- Direction and frame order follow the Character Bible and Animation Guide.

### UI canvas

- SVG uses an explicit `viewBox` matching its design coordinate system.
- Icons use a consistent optical safe area, documented in `10_icon_guideline.md`.
- Backgrounds include safe crop allowance for supported 16:9 and 16:10 layouts.
- Text is not embedded unless it is brand/logo art.

### Environment canvas

- Tile, prop, and landmark source files include grid and ground-contact guides.
- Foreground overlap allowance is documented.
- Collision silhouette is reviewed beside visual bounds.
- Oversized environment sheets are split when they create waste, import delay, or Web memory risk.

---

## 14. LOD Policy

LumaVale uses restrained 2D level-of-detail management. The fixed gameplay camera means many assets do not require manual LOD variants.

### LOD tiers

| Tier | Use | Treatment |
|---|---|---|
| `lod0` | Gameplay foreground, characters, interactables | Full approved detail and animation |
| `lod1` | Mid-distance environment and large background props | Reduced internal detail and animation frequency |
| `lod2` | Distant silhouettes and backdrop layers | Broad color masses, minimal animation, no small texture noise |

### Rules

- Player characters, interactive items, UI, and gameplay-critical icons do not change to a lower semantic-detail tier.
- Prefer mipmaps and authored atmospheric depth before creating duplicate raster assets.
- Manual LOD variants are justified by measurable memory, overdraw, animation, or readability benefit.
- LOD switching must not pop near the player or change collision.
- Distant animation may reduce frequency or stop when offscreen.
- Particle systems use performance tiers before environment artwork is visibly degraded.
- Web testing determines whether large background textures need lower-resolution release variants.

Avoid automatic filename suffixes unless distinct LOD files truly exist:

```text
env_forest_tree_ancient_lod0.png
env_forest_tree_ancient_lod1.png
env_forest_tree_ancient_lod2.png
```

---

## 15. Audio and Font Import Summary

### Audio

- Music and long ambience: OGG Vorbis with reviewed loop points and quality.
- Short latency-sensitive effects: WAV or imported sample profile after memory review.
- Mono is acceptable for spatial point effects; stereo is reserved for music, ambience beds, and intentional UI presentation.
- Normalize through the audio pipeline, not independently per imported file.

### Fonts

- Bundle approved font files for deterministic Desktop/Web rendering.
- Keep license files with source documentation.
- Configure hinting, oversampling, MSDF, and mipmaps according to `03_typography.md`.
- Do not depend on fonts installed on the player's operating system.

---

## 16. Web Export Settings

The current Web preset exports to:

```text
builds/web/index.html
```

Current relevant settings:

- Export filter: all project resources.
- GL Compatibility renderer.
- Thread support: disabled.
- Desktop VRAM texture compression: enabled.
- Canvas resize policy: enabled for responsive browser presentation.

### Release requirements

- `builds/web/.gdignore` remains present so generated output is not reimported into the project.
- Source masters, references, and unused prototypes are excluded from release resources when they become material to package size.
- Export output must include `index.html`, `index.js`, `index.wasm`, and `index.pck`.
- Browser console must contain no missing texture, font, audio, or resource errors.
- Validate 100% and 125% browser zoom.
- Record PCK and total download size after major asset additions.

“Export all resources” is convenient during development but can package unused approved resources. Before content scale grows, review dependency-based or explicit exclusion strategies.

---

## 17. Reimport and Clean-Build Procedure

1. Confirm the source asset and `.import` metadata are tracked.
2. Close any external process locking the file.
3. Apply the correct Import profile in Godot.
4. Reimport and inspect editor output for warnings.
5. Open the resource and its target scene.
6. Test over light and dark backgrounds where transparency applies.
7. Test all animation frames and modular combinations where applicable.
8. Run the project startup scene.
9. Export the Web preset.
10. Verify generated artifacts and browser resource loading.

Deleting `.godot/imported/` is a troubleshooting step, not a routine production action. A clean import must be reproducible without hand-editing generated cache files.

---

## 18. Asset Validation Checklist

### Source

- Correct category, naming, and stable ID.
- Approved source scale, color space, and alpha.
- Guides and hidden references are excluded from export.
- Master is versioned appropriately.

### Export

- Dimensions and canvas are exact.
- Pivot and ground contact match specification.
- Transparent edges contain no matte halo.
- Sprite-sheet order and frame count are correct.
- File format matches the asset profile.

### Import

- Compression profile is correct.
- Filter is correct for display behavior.
- Mipmaps are enabled only with a documented benefit.
- Size limit is intentional.
- `.import` metadata and UID are stable.

### Runtime

- Asset renders correctly in context.
- No clipping, bleeding, pivot drift, or filtering mismatch.
- Pixel snapping and camera movement behave as intended.
- LOD or particle tier changes are unobtrusive.
- Desktop and Web results are approved.

### Build

- No missing-resource warnings.
- No unintended source masters in the PCK.
- Package and texture-memory changes are understood.
- Required Web artifacts exist.

---

## 19. Change Control

Pipeline-wide changes require Technical Art and Engineering approval. This includes import defaults, project texture filtering, pixel snapping, compression profiles, atlas layout, character canvas/pivot, LOD conventions, or export filtering.

Test one representative asset from each affected category before bulk reimport. Bulk changes without a before/after visual and memory comparison are not production-ready.

---

## References

- [Godot: Asset Pipeline](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/)
- [Godot: Importing Images](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html)
- [Godot: Exporting Projects](https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html)
- [Godot: Project Settings](https://docs.godotengine.org/en/stable/tutorials/editor/project_settings.html)
