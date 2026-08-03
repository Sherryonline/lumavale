# LumaVale Prompt Library

**Purpose:** Reusable prompts for AI-assisted game development  
**Project:** LumaVale  
**Mandatory visual authority:** `docs/design-system/01_art_bible.md`  
**Usage:** Replace `{placeholder}` values before submitting a prompt

---

## 1. Usage Rules

This library accelerates exploration, documentation, implementation, and review. AI output is a draft until approved by the responsible artist, designer, or engineer.

### Mandatory rules

- Every prompt must explicitly reference the LumaVale Art Bible.
- Attach or paste the relevant design-system documents when the AI cannot read repository files.
- Use project-specific references before generic style language.
- Do not request imitation of a living artist or direct copying of another game.
- Do not accept invented project APIs, node paths, resources, or assets without repository verification.
- Keep stable IDs, canvas dimensions, pivots, naming, and resource paths unchanged unless migration is part of the request.
- Request transparent backgrounds only when the asset category requires them.
- Separate visual direction from technical export requirements.
- Preserve human review for licensing, originality, accessibility, gameplay clarity, and production readiness.

### Placeholder syntax

```text
{asset_name}       Value supplied for the current task
{location}         Town, Forest, Mine, Dungeon, or approved future location
{direction}        down, left, right, up
{state}            normal, hover, pressed, focused, selected, disabled, locked
{output_format}    Markdown, SVG specification, GDScript, JSON, review table, etc.
```

Do not leave unresolved placeholders in production output.

---

## 2. Character Design

### 2.1 Character concept brief

Use this prompt to turn a narrative role into an actionable character-art brief.

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md before producing any recommendations.

Also follow:
- docs/design-system/02_color_palette.md
- docs/design-system/05_character_bible.md
- docs/design-system/09_naming_convention.md

Act as a senior character art director for LumaVale.

Create a production concept brief for:
- Character or role: {character_name}
- Narrative function: {narrative_function}
- Gameplay role: {gameplay_role}
- Personality traits: {personality_traits}
- Cultural or regional context: {world_context}
- Required equipment: {required_equipment}

Define:
1. Core fantasy and emotional read.
2. Silhouette priorities at gameplay scale.
3. Body proportion notes within the modular character standard.
4. Shape language.
5. Material and costume hierarchy.
6. Restrained palette using semantic LumaVale color relationships.
7. Hair, face, accessory, and weapon considerations.
8. Front, side, and back-view requirements.
9. Modular layer ownership.
10. Risks, prohibited directions, and review checklist.

Do not imitate a named artist or reproduce an existing game character.
Do not create artwork. Output a concise production brief in Markdown.
```

### 2.2 Modular appearance item

Use this prompt for Hair, Top, Bottom, Shoes, Accessory, Body, Eyes, or Weapon items.

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also follow the Character Bible, Animation Guide, Asset Pipeline, and Naming
Convention in docs/design-system/.

Act as a LumaVale character artist and technical artist.

Prepare a modular appearance-item specification:
- Category: {category}
- Stable item ID: {item_id}
- Display name: {display_name}
- Design theme: {design_theme}
- Rarity or availability: {availability}
- Required animations: {required_animations}
- Required directions: down, left, right, up

The canonical logical frame is 48x64 with pivot (24, 32). HD source files may use
an approved exact integer multiple while preserving normalized alignment.

Provide:
1. Visual description and silhouette.
2. Layer ownership and front/back split if applicable.
3. Fit-zone requirements.
4. Material and color-treatment notes.
5. Animation-specific deformation notes.
6. Weapon, hair, and accessory collision/overlap risks.
7. Source and export naming.
8. Godot resource naming.
9. Combination test matrix.
10. Technical acceptance checklist.

Do not embed pixels belonging to another modular category.
Do not create binary assets. Output Markdown.
```

### 2.3 Character portrait direction

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also follow docs/design-system/05_character_bible.md and
docs/design-system/02_color_palette.md.

Act as the portrait art lead for LumaVale.

Create an art-direction brief for a character portrait:
- Character: {character_name}
- Role: {role}
- Emotion: {emotion}
- Narrative moment: {narrative_moment}
- Crop: {bust_half_body_or_full_body}
- Target dimensions: {dimensions}
- UI placement: {ui_context}

Specify pose, expression, gaze, silhouette, costume priorities, lighting,
background simplicity, safe crop, material rendering, palette relationship, and
readability at final UI size. Preserve identity with the modular gameplay design
while allowing appropriate portrait detail.

List negative constraints and an approval checklist.
Do not imitate a living artist. Output Markdown only.
```

### 2.4 Character design review

```text
MANDATORY REFERENCE: Evaluate all work against the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also use docs/design-system/05_character_bible.md and
docs/design-system/06_animation_guide.md.

Act as a lead character-art reviewer.

Review the supplied {character_asset_type} for {item_id}.
Context: {context}
Known constraints: {constraints}

Score from 1 to 5:
- LumaVale visual fit
- Silhouette readability
- Modular compatibility
- Canvas and pivot compliance
- Layer ownership
- Direction consistency
- Animation readiness
- Material clarity
- Gameplay-scale readability
- Originality and production safety

For every score below 4, provide a specific correction and validation method.
Separate blocking issues from polish suggestions. Do not redesign unrelated parts.
Output a Markdown review table followed by an approval decision.
```

---

## 3. Environment Design

### 3.1 Location concept brief

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also follow docs/design-system/07_environment_bible.md and
docs/design-system/02_color_palette.md.

Act as a senior environment art director for LumaVale.

Create a production environment brief for:
- Location: {location}
- Player purpose: {player_purpose}
- Narrative function: {narrative_function}
- Primary landmark: {primary_landmark}
- Required routes: {required_routes}
- Interactions: {interactions}
- Time state: {morning_sunset_or_night}
- Weather state: {clear_rain_snow_or_fog}

Define:
1. Composition and navigation hierarchy.
2. Semantic environment palette.
3. Key, ambient, shadow, and practical lighting.
4. Architecture language and local materials.
5. Roads, boundaries, and exit readability.
6. Vegetation layers and clustering.
7. Props that communicate routine and ownership.
8. Water treatment where applicable.
9. Particle and animation budget.
10. Collision readability and quiet interaction zones.
11. Performance risks for Godot Web.
12. Review checklist.

Avoid photorealism, uniform scatter, heavy bloom, and full-screen color filters.
Output Markdown only.
```

### 3.2 Environment prop family

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also follow the Environment Bible, Asset Pipeline, and Naming Convention in
docs/design-system/.

Act as a LumaVale environment and prop lead.

Design a cohesive prop family:
- Biome/location: {location}
- Prop family: {prop_family}
- World function: {world_function}
- Material set: {materials}
- Required variants: {variant_count}
- Weather exposure: {weather_exposure}

Provide a table containing stable asset name, purpose, silhouette, dimensions,
materials, wear pattern, interaction state, collision expectation, pivot/ground
anchor, LOD need, and export format for each prop.

Explain how the family communicates use and ownership without evenly scattered
clutter. Include a combination sheet plan and acceptance checklist.
Do not create artwork or binary files. Output Markdown.
```

### 3.3 Time and weather conversion

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also follow docs/design-system/07_environment_bible.md.

Act as the LumaVale lighting and environment-state lead.

Convert {location} from {source_state} to {target_state}.
The target may combine Morning, Sunset, Night, Rain, Snow, or Fog.

Provide explicit changes for:
- semantic palette roles;
- key, ambient, shadow, and practical lighting;
- wood, stone, soil, metal, cloth, and water materials;
- props and NPC-life cues;
- vegetation;
- architecture;
- roads and navigation landmarks;
- water;
- particles and performance budget;
- readability safeguards.

Do not apply a single global tint. Preserve routes, exits, interactables, and
character readability. Output a before/after Markdown matrix.
```

### 3.4 Environment review

```text
MANDATORY REFERENCE: Evaluate the supplied environment against the LumaVale Art
Bible at docs/design-system/01_art_bible.md.

Also use docs/design-system/07_environment_bible.md.

Act as an environment-art review panel.

Review {location} in {time_state} and {weather_state}.
Evidence supplied: {screenshots_scene_tree_or_description}

Evaluate composition, navigation, palette, lighting, materials, props,
vegetation, architecture, roads, water, particles, collision readability, and
Web performance. Identify blocking issues, recommended corrections, and the
exact in-engine view needed to verify each correction.

Output a Markdown review with Pass, Revise, or Blocked status.
```

---

## 4. UI Design

### 4.1 Screen layout specification

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also follow:
- docs/design-system/02_color_palette.md
- docs/design-system/03_typography.md
- docs/design-system/04_ui_design_system.md

Act as a principal UI/UX designer for LumaVale.

Create a layout specification for:
- Screen: {screen_name}
- Player goal: {player_goal}
- Required information: {required_information}
- Required actions: {required_actions}
- Existing reusable components: {available_components}
- Target resolutions: 1280x720, 1600x900, 1920x1080, and {desktop_16_10_size}
- UI scales: 100%, 125%, 150%, 175%, 200%

Provide:
1. Information hierarchy.
2. Container-based scene tree.
3. Responsive regions and minimum sizes.
4. Safe margins, spacing, padding, and scroll behavior.
5. Typography tokens.
6. Semantic color and surface assignments.
7. Component states and keyboard order.
8. Tooltip and validation behavior.
9. Reduced-motion behavior.
10. Acceptance matrix for clipping, focus, contrast, and sharpness.

Avoid fixed absolute layouts, glassmorphism, default gray controls, heavy bloom,
and parent scaling of text. Output Markdown only.
```

### 4.2 Reusable UI component

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also follow docs/design-system/04_ui_design_system.md,
docs/design-system/02_color_palette.md, and
docs/design-system/03_typography.md.

Act as a senior UI systems designer.

Specify a reusable LumaVale component:
- Component: {component_name}
- Purpose: {purpose}
- Content: {content_requirements}
- Interaction model: {interaction_model}
- Minimum size: {minimum_size}

Define anatomy, node tree, spacing, padding, radius, border, shadow, typography,
and the following states: Normal, Hover, Pressed, Focused, Selected, Disabled,
Locked. Include exact measurements at 100% scale and scaling behavior to 200%.

Selection must use color, border, and a marker. Locking must use desaturation,
lock icon, and explanation. Do not duplicate hardcoded theme colors.
Output a Markdown component contract.
```

### 4.3 UI accessibility audit

```text
MANDATORY REFERENCE: Evaluate the screen against the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also use the Color Palette, Typography Guideline, and UI Design System in
docs/design-system/.

Act as a desktop/Web game accessibility reviewer.

Audit {screen_or_component} using this evidence: {evidence}.

Check:
- text size, line height, contrast, and sharpness;
- keyboard order and visible focus;
- Enter, Space, and Escape behavior;
- selected, disabled, and locked communication;
- reduced-motion behavior;
- reflow and scrolling at 100–200% UI scale;
- clipping at target desktop resolutions;
- browser zoom at 100% and 125%;
- tooltip equivalence for pointer and keyboard users.

Return a Markdown issue table with severity, evidence, violated rule, correction,
and verification step. Do not change gameplay logic.
```

### 4.4 UI visual-direction review

```text
MANDATORY REFERENCE: Evaluate all visual decisions against the LumaVale Art Bible
at docs/design-system/01_art_bible.md.

Also follow docs/design-system/04_ui_design_system.md.

Act as the LumaVale UI art director.

Review {screen_name} for the Elegant Anime Fantasy direction.
Evidence: {screenshot_or_scene_description}

Assess focal hierarchy, character/world visibility, surfaces, ornament density,
semantic colors, typography, spacing rhythm, component consistency, focus,
selection, locking, and clarity at gameplay distance.

Explicitly flag glassmorphism, heavy bloom, uncontrolled transparency, default
Godot styling, blurry text, decorative noise, and excessive gold emphasis.
Output blocking issues first, then polish opportunities, then approval status.
```

---

## 5. Icon Design

### 5.1 UI icon family

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also follow docs/design-system/10_icon_guideline.md,
docs/design-system/02_color_palette.md, and
docs/design-system/09_naming_convention.md.

Act as a senior icon-system designer for LumaVale.

Define an icon family for {feature_or_screen}.
Required concepts: {icon_concepts}
Target sizes: {target_sizes}
Output format: {svg_or_raster_specification}

For each icon provide semantic name, player meaning, silhouette, stroke/fill
strategy, optical safe area, small-size simplification, state behavior,
accessibility backup, and export filename.

Icons must remain coherent, restrained, hand-crafted, and readable without bloom.
Do not encode state through color alone. Do not create artwork; output a Markdown
production specification.
```

### 5.2 Item icon brief

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also follow the Icon Guideline, Asset Pipeline, and Naming Convention in
docs/design-system/.

Act as the LumaVale item-icon art lead.

Create an icon brief for:
- Item ID: {item_id}
- Display name: {display_name}
- Item type: {item_type}
- Material: {material}
- Rarity: {rarity}
- Gameplay meaning: {gameplay_meaning}
- Target slot size: {slot_size}

Specify silhouette, orientation, crop, value grouping, restrained palette,
material cues, edge treatment, transparent safe area, rarity ornament ownership,
locked/disabled behavior, and filename.

The icon must read at final size and rarity must not rely on icon color alone.
Do not include text inside the icon. Output Markdown only.
```

### 5.3 Role icon brief

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also follow docs/design-system/10_icon_guideline.md and the Character Bible.

Act as a role-icon designer for LumaVale.

Create a production brief for the {role_name} role icon.
Role strengths: {role_strengths}
Starting weapon: {starting_weapon}
Required sizes: {required_sizes}

Define one primary symbol, supporting shape language, silhouette, negative space,
stroke weight, value structure, selected state, locked state, and optical
corrections. Ensure the icon remains distinct from Warrior, Ranger, and Alchemist
at the smallest approved size.

Do not create new gameplay roles. Output Markdown.
```

---

## 6. Animation

### 6.1 Character animation brief

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also follow docs/design-system/05_character_bible.md and
docs/design-system/06_animation_guide.md.

Act as the LumaVale animation director.

Create a production brief for:
- Action: {action}
- Direction: {direction}
- Character or weapon context: {context}
- Gameplay duration: {gameplay_duration}
- Required events: {required_events}

Define animation key, frame count, FPS, per-frame timing, loop rule, pivot, root
position rule, silhouette goals, anticipation, action/contact, follow-through,
recovery, secondary motion, transition entry/exit, and modular layer obligations.

Use the 48x64 logical canvas or an approved exact HD multiple. Root motion remains
owned by gameplay. Output a frame-by-frame Markdown table and acceptance checklist.
```

### 6.2 Modular animation QA

```text
MANDATORY REFERENCE: Evaluate animation against the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also use the Character Bible and Animation Guide in docs/design-system/.

Act as a technical animation reviewer.

Audit {animation_key} across these layers: {layers}.
Evidence: {spriteframes_data_screenshots_or_description}

Check animation name, direction, frame count, FPS, duration multipliers, loop flag,
pivot, canvas, foot baseline, grip attachment, layer ownership, frame sync, loop
boundary, transitions, anticipation, contact, and recovery.

Return a Markdown table showing expected value, observed value, status, and exact
correction for every layer. Mark any synchronization mismatch as blocking.
```

### 6.3 Idle animation variation

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also follow docs/design-system/06_animation_guide.md.

Act as a character animator for LumaVale.

Design a subtle non-looping personality idle for {character_or_role}.
Personality cue: {personality_cue}
Held equipment: {equipment}
Maximum duration: {maximum_duration}

The variation begins from and returns cleanly to `idle_{direction}`. Define frame
count, FPS, pose beats, holds, secondary motion, equipment behavior, blink timing,
and transition frames. Feet remain grounded and the world root does not move.

Avoid exaggerated bouncing, continuous motion, face obstruction, and animation
that competes with gameplay. Output Markdown only.
```

### 6.4 Environment animation brief

```text
MANDATORY REFERENCE: Read and follow the LumaVale Art Bible at
docs/design-system/01_art_bible.md.

Also follow docs/design-system/07_environment_bible.md and the Animation Guide.

Act as an environment animator and VFX technical artist.

Create an animation brief for {environment_element} in {location} during
{time_and_weather_state}.

Define purpose, loop duration, frame count or procedural method, motion amplitude,
phase variation, pivot/anchor, material response, particle count, visibility range,
reduced-motion behavior, offscreen behavior, and Web performance constraints.

The motion must settle visually, preserve navigation, and avoid synchronized
repetition, heavy bloom, or screen-filling particles. Output Markdown.
```

---

## 7. Godot Coding

### 7.1 Implement a scoped feature

```text
MANDATORY REFERENCE: Read and preserve the visual and experience rules in the
LumaVale Art Bible at docs/design-system/01_art_bible.md, even though this is a
coding task.

Also inspect all relevant project scenes, scripts, resources, tests, AGENTS.md,
and design-system documents before editing.

Act as a senior Godot 4.x developer working in LumaVale.

Implement: {feature_request}
Project root: {project_root}
In-scope files/systems: {scope}
Out-of-scope behavior: {non_goals}
Acceptance criteria: {acceptance_criteria}

Requirements:
- Use typed GDScript and Godot 4.x APIs only.
- Preserve existing gameplay logic and public node paths unless change is required.
- Use snake_case for files, variables, and functions.
- Reuse ThemeManager, centralized tokens, and reusable components where relevant.
- Do not hardcode visual colors inside component scripts or scenes.
- Do not add external plugins or unrequested binary assets.
- Do not modify generated builds unless explicitly requested.
- Fail safely with concise actionable errors.

Before coding, report current behavior, proposed changes, files affected, risks,
and validation plan. After coding, run proportional Godot validation and report
changed files, test results, assumptions, and limitations.
```

### 7.2 Diagnose a Godot issue

```text
MANDATORY REFERENCE: Preserve the LumaVale Art Bible at
docs/design-system/01_art_bible.md while diagnosing this issue.

Act as a senior Godot 4.x debugging engineer.

Diagnose only; do not implement a fix unless explicitly authorized.

Issue: {issue_description}
Expected behavior: {expected_behavior}
Observed behavior: {observed_behavior}
Relevant scene/script/resource: {relevant_paths}
Logs or reproduction steps: {evidence}

Inspect the repository and determine:
1. Reproduction status.
2. Most likely root cause with file/line evidence.
3. Why current safeguards did not prevent it.
4. Minimal fix options and tradeoffs.
5. Regression risks.
6. Exact validation steps.

Do not invent logs, APIs, or missing repository context. Output an evidence-backed
Markdown diagnosis.
```

### 7.3 Refactor without behavior change

```text
MANDATORY REFERENCE: Preserve all visual constraints from the LumaVale Art Bible
at docs/design-system/01_art_bible.md.

Act as a senior Godot systems architect.

Refactor: {refactor_target}
Goal: {goal}
Behavior that must remain unchanged: {preserved_behavior}
Public paths/signals/resources to preserve: {public_contracts}

Use typed GDScript and Godot 4.x APIs. Keep architecture appropriate for a solo
developer. Remove duplication only when the replacement is simpler and testable.
Do not redesign gameplay, rename stable IDs, or move resources without an explicit
migration plan.

Before editing, map dependencies and identify existing uncommitted work. After
editing, validate parsing, startup, affected scenes, direct-load fallbacks, and
resource paths. Output a concise change report in Markdown.
```

### 7.4 Create a validation plan

```text
MANDATORY REFERENCE: Include visual acceptance criteria from the LumaVale Art
Bible at docs/design-system/01_art_bible.md.

Act as a Godot QA lead and technical test architect.

Create a validation plan for {feature_or_milestone}.
Acceptance criteria: {acceptance_criteria}
Target scenes: {target_scenes}
Target platforms: Desktop and Web
Target resolutions: {target_resolutions}

Include:
- parse and resource audit;
- automated unit/integration checks where practical;
- scene startup and direct-load tests;
- input and keyboard navigation;
- save/session fallback behavior;
- visual comparison against the LumaVale Art Bible;
- UI scale and browser zoom matrix where applicable;
- Web export artifact and console checks;
- performance observations;
- regression matrix;
- evidence required before completion may be reported.

Separate automated, manual, and browser-only checks. Output Markdown.
```

### 7.5 Review Godot code

```text
MANDATORY REFERENCE: Evaluate any player-facing visual behavior against the
LumaVale Art Bible at docs/design-system/01_art_bible.md.

Act as a senior Godot 4.x code reviewer.

Review: {files_or_diff}
Feature intent: {feature_intent}

Prioritize findings by severity. Check correctness, null safety, typed GDScript,
Godot lifecycle, signal duplication, scene ownership, resource loading, stable
node paths, per-frame allocations, input handling, accessibility, reduced motion,
ThemeManager usage, error quality, and test coverage.

For each finding provide file/line, impact, evidence, and smallest safe correction.
Do not report stylistic preference as a defect. If no actionable defects are
found, state that clearly and identify remaining test gaps. Output Markdown.
```

---

## 8. Prompt Quality Checklist

Before using any template:

- The prompt explicitly references `docs/design-system/01_art_bible.md`.
- Every placeholder has been replaced.
- The requested role matches the task.
- Input paths and stable IDs are accurate.
- Scope and non-goals are explicit.
- Output format is defined.
- Acceptance criteria are testable.
- The prompt prohibits unrequested systems, assets, or migrations.
- Relevant supporting design-system documents are referenced.
- Human approval responsibility remains clear.

---

## 9. Adding New Prompts

New templates must:

1. Begin with an explicit mandatory reference to the LumaVale Art Bible.
2. Use `{snake_case_placeholders}`.
3. Define the AI role and task scope.
4. Reference relevant supporting project documents.
5. State required output format.
6. Include constraints and acceptance criteria.
7. Avoid named-artist imitation and third-party design copying.
8. Remain reusable across more than one asset or feature.

Prompts that only solve one immediate ticket belong in task history, not in this library.
