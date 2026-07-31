extends SceneTree

const FRAME_WIDTH := 48
const FRAME_HEIGHT := 64
const FRAME_COUNT := 5

const ITEMS := [
	{
		"id": "body_a",
		"file": "body_a",
		"display_name": "Body A",
		"category": 0,
		"folder": "body",
		"kind": "body",
		"color": "#f1c6a4",
		"variant": "a",
	},
	{
		"id": "body_b",
		"file": "body_b",
		"display_name": "Body B",
		"category": 0,
		"folder": "body",
		"kind": "body",
		"color": "#b97852",
		"variant": "b",
	},
	{
		"id": "hair_short",
		"file": "hair_short",
		"display_name": "Short Hair",
		"category": 1,
		"folder": "hair",
		"kind": "hair",
		"color": "#5a3d32",
		"variant": "short",
	},
	{
		"id": "hair_wave",
		"file": "hair_wave",
		"display_name": "Wavy Hair",
		"category": 1,
		"folder": "hair",
		"kind": "hair",
		"color": "#d29a45",
		"variant": "wave",
	},
	{
		"id": "hair_pony",
		"file": "hair_pony",
		"display_name": "Ponytail",
		"category": 1,
		"folder": "hair",
		"kind": "hair",
		"color": "#8c523b",
		"variant": "pony",
	},
	{
		"id": "hair_crop",
		"file": "hair_crop",
		"display_name": "Cropped Hair",
		"category": 1,
		"folder": "hair",
		"kind": "hair",
		"color": "#3d4856",
		"variant": "crop",
	},
	{
		"id": "top_forest",
		"file": "top_forest",
		"display_name": "Forest Tunic",
		"category": 3,
		"folder": "tops",
		"kind": "top",
		"color": "#66895a",
		"variant": "forest",
	},
	{
		"id": "top_blue",
		"file": "top_blue",
		"display_name": "Blue Tunic",
		"category": 3,
		"folder": "tops",
		"kind": "top",
		"color": "#527fa8",
		"variant": "blue",
	},
	{
		"id": "top_earth",
		"file": "top_earth",
		"display_name": "Earth Tunic",
		"category": 3,
		"folder": "tops",
		"kind": "top",
		"color": "#98704d",
		"variant": "earth",
	},
	{
		"id": "top_violet",
		"file": "top_violet",
		"display_name": "Violet Tunic",
		"category": 3,
		"folder": "tops",
		"kind": "top",
		"color": "#80619b",
		"variant": "violet",
	},
	{
		"id": "bottom_dark",
		"file": "bottom_dark",
		"display_name": "Dark Trousers",
		"category": 4,
		"folder": "bottoms",
		"kind": "bottom",
		"color": "#3d3b48",
		"variant": "dark",
	},
	{
		"id": "bottom_brown",
		"file": "bottom_brown",
		"display_name": "Brown Trousers",
		"category": 4,
		"folder": "bottoms",
		"kind": "bottom",
		"color": "#6d4d3b",
		"variant": "brown",
	},
	{
		"id": "shoes_boots",
		"file": "shoes_boots",
		"display_name": "Travel Boots",
		"category": 5,
		"folder": "shoes",
		"kind": "shoes",
		"color": "#4c352e",
		"variant": "boots",
	},
	{
		"id": "shoes_light",
		"file": "shoes_light",
		"display_name": "Light Shoes",
		"category": 5,
		"folder": "shoes",
		"kind": "shoes",
		"color": "#c3a56f",
		"variant": "light",
	},
	{
		"id": "accessory_none",
		"file": "accessory_none",
		"display_name": "No Accessory",
		"category": 6,
		"folder": "accessories",
		"kind": "none",
		"color": "#000000",
		"variant": "none",
		"empty": true,
	},
	{
		"id": "accessory_leaf",
		"file": "accessory_leaf",
		"display_name": "Leaf Pin",
		"category": 6,
		"folder": "accessories",
		"kind": "accessory",
		"color": "#78a85f",
		"variant": "leaf",
		"layer_mode": "front",
	},
	{
		"id": "accessory_bag",
		"file": "accessory_bag",
		"display_name": "Travel Bag",
		"category": 6,
		"folder": "accessories",
		"kind": "accessory",
		"color": "#9b704b",
		"variant": "bag",
		"layer_mode": "back",
	},
	{
		"id": "weapon_sword",
		"file": "weapon_sword",
		"asset_file": "sword",
		"display_name": "Woodland Sword",
		"category": 7,
		"folder": "weapons",
		"kind": "weapon",
		"color": "#d8dce0",
		"variant": "sword",
	},
	{
		"id": "weapon_bow",
		"file": "weapon_bow",
		"asset_file": "bow",
		"display_name": "Hunter Bow",
		"category": 7,
		"folder": "weapons",
		"kind": "weapon",
		"color": "#9d6a3f",
		"variant": "bow",
	},
	{
		"id": "weapon_flask",
		"file": "weapon_flask",
		"asset_file": "flask",
		"display_name": "Alchemist Flask",
		"category": 7,
		"folder": "weapons",
		"kind": "weapon",
		"color": "#75c5b5",
		"variant": "flask",
	},
]


func _init() -> void:
	var generated_count := 0
	for item: Dictionary in ITEMS:
		var asset_file: String = item.get("asset_file", item["file"])
		var svg_path := "res://assets/characters/%s/%s.svg" % [item["folder"], asset_file]
		_write_text(svg_path, _build_svg(item))
		generated_count += 1

		var frames_path := "res://resources/appearance/%s_frames.tres" % item["file"]
		_write_text(frames_path, _build_sprite_frames_resource(svg_path))
		generated_count += 1

		var appearance_path := "res://resources/appearance/%s.tres" % item["file"]
		_write_text(appearance_path, _build_appearance_resource(item))
		generated_count += 1

	print("Generated %d text placeholder files." % generated_count)
	quit(0)


func _build_svg(item: Dictionary) -> String:
	var shape := _build_shape(item)
	var groups := PackedStringArray()
	for frame_index: int in FRAME_COUNT:
		groups.append(
			'<g transform="translate(%d 0)">%s</g>' % [frame_index * FRAME_WIDTH, shape]
		)

	return (
		'<svg xmlns="http://www.w3.org/2000/svg" width="240" height="64" '
		+ 'viewBox="0 0 240 64">\n%s\n</svg>\n' % "\n".join(groups)
	)


func _build_shape(item: Dictionary) -> String:
	var kind: String = item["kind"]
	var color: String = item["color"]
	var variant: String = item["variant"]

	match kind:
		"body":
			return (
				'<circle cx="24" cy="17" r="10.5" fill="%s" stroke="#493b43" '
				+ 'stroke-width="1.5"/>'
				+ '<rect x="17" y="27" width="14" height="23" rx="6" fill="%s" '
				+ 'stroke="#493b43" stroke-width="1.5"/>'
				+ '<path d="M17 31 L12 43 M31 31 L36 43 M21 48 L20 58 M27 48 L28 58" '
				+ 'fill="none" stroke="%s" stroke-width="5" stroke-linecap="round"/>'
			) % [color, color, color]
		"hair":
			return _build_hair_shape(variant, color)
		"top":
			return (
				'<path d="M17 28 L13 33 L16 38 L17 48 L31 48 L32 38 L35 33 '
				+ 'L31 28 L27 31 L21 31 Z" fill="%s" stroke="#3f3a46" '
				+ 'stroke-width="1.5"/>'
				+ '<path d="M21 31 Q24 35 27 31" fill="none" stroke="#ead9b4" '
				+ 'stroke-width="1.5"/>'
			) % color
		"bottom":
			return (
				'<path d="M17 46 L31 46 L30 54 L27 58 L24 52 L21 58 L18 54 Z" '
				+ 'fill="%s" stroke="#35323c" stroke-width="1.5"/>'
			) % color
		"shoes":
			return (
				'<path d="M16 56 L23 56 L23 61 L14 61 Q13 58 16 56 Z M25 56 '
				+ 'L32 56 Q35 58 34 61 L25 61 Z" fill="%s" stroke="#342e32" '
				+ 'stroke-width="1.5"/>'
			) % color
		"accessory":
			if variant == "leaf":
				return (
					'<path d="M32 8 Q40 8 39 16 Q32 16 32 8 Z" fill="%s" '
					+ 'stroke="#38543a" stroke-width="1.2"/>'
					+ '<path d="M33 15 L38 10" stroke="#38543a" stroke-width="1"/>'
				) % color
			return (
				'<path d="M10 28 Q24 33 29 48" fill="none" stroke="#644631" '
				+ 'stroke-width="2"/>'
				+ '<rect x="7" y="36" width="11" height="14" rx="3" fill="%s" '
				+ 'stroke="#543b2c" stroke-width="1.5"/>'
			) % color
		"weapon":
			return _build_weapon_shape(variant, color)
		_:
			return ""


func _build_hair_shape(variant: String, color: String) -> String:
	match variant:
		"wave":
			return (
				'<path d="M13 19 Q12 5 24 5 Q37 5 36 20 L35 31 Q30 34 30 25 '
				+ 'Q24 29 18 24 Q18 34 12 30 Z" fill="%s" stroke="#45343a" '
				+ 'stroke-width="1.5"/>'
			) % color
		"pony":
			return (
				'<circle cx="38" cy="20" r="7" fill="%s" stroke="#45343a" '
				+ 'stroke-width="1.5"/>'
				+ '<path d="M13 18 Q13 5 24 5 Q36 5 35 20 Q29 16 24 10 '
				+ 'Q20 17 13 18 Z" fill="%s" stroke="#45343a" stroke-width="1.5"/>'
			) % [color, color]
		"crop":
			return (
				'<path d="M14 17 Q14 6 24 6 Q34 6 35 17 L30 14 L27 17 '
				+ 'L23 13 L19 17 Z" fill="%s" stroke="#303641" stroke-width="1.5"/>'
			) % color
		_:
			return (
				'<path d="M13 19 Q13 5 24 5 Q36 5 35 19 L31 15 L28 18 '
				+ 'L24 12 L20 18 L17 15 Z" fill="%s" stroke="#45343a" '
				+ 'stroke-width="1.5"/>'
			) % color


func _build_weapon_shape(variant: String, color: String) -> String:
	match variant:
		"bow":
			return (
				'<path d="M39 30 Q47 43 39 58" fill="none" stroke="%s" '
				+ 'stroke-width="3"/>'
				+ '<path d="M39 30 L39 58" stroke="#dfd5bd" stroke-width="1"/>'
			) % color
		"flask":
			return (
				'<path d="M38 35 L42 35 L42 41 Q47 48 42 54 L38 54 '
				+ 'Q33 48 38 41 Z" fill="%s" stroke="#385d61" stroke-width="1.5"/>'
				+ '<rect x="38" y="32" width="4" height="5" fill="#d5d4c5"/>'
			) % color
		_:
			return (
				'<path d="M39 29 L43 33 L39 52 L36 49 Z" fill="%s" '
				+ 'stroke="#555967" stroke-width="1.5"/>'
				+ '<path d="M35 49 L42 52 M38 51 L35 58" stroke="#765037" '
				+ 'stroke-width="2.5" stroke-linecap="round"/>'
			) % color


func _build_sprite_frames_resource(svg_path: String) -> String:
	return """[gd_resource type="SpriteFrames" load_steps=7 format=3]

[ext_resource type="Texture2D" path="%s" id="1_texture"]

[sub_resource type="AtlasTexture" id="AtlasTexture_idle_down"]
atlas = ExtResource("1_texture")
region = Rect2(0, 0, 48, 64)

[sub_resource type="AtlasTexture" id="AtlasTexture_walk_down_1"]
atlas = ExtResource("1_texture")
region = Rect2(48, 0, 48, 64)

[sub_resource type="AtlasTexture" id="AtlasTexture_walk_down_2"]
atlas = ExtResource("1_texture")
region = Rect2(96, 0, 48, 64)

[sub_resource type="AtlasTexture" id="AtlasTexture_attack_down_1"]
atlas = ExtResource("1_texture")
region = Rect2(144, 0, 48, 64)

[sub_resource type="AtlasTexture" id="AtlasTexture_attack_down_2"]
atlas = ExtResource("1_texture")
region = Rect2(192, 0, 48, 64)

[resource]
animations = [{
"frames": [{
"duration": 1.0,
"texture": SubResource("AtlasTexture_attack_down_1")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_attack_down_2")
}],
"loop": false,
"name": &"attack_down",
"speed": 8.0
}, {
"frames": [{
"duration": 1.0,
"texture": SubResource("AtlasTexture_idle_down")
}],
"loop": true,
"name": &"idle_down",
"speed": 2.0
}, {
"frames": [{
"duration": 1.0,
"texture": SubResource("AtlasTexture_walk_down_1")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_walk_down_2")
}],
"loop": true,
"name": &"walk_down",
"speed": 6.0
}]
""" % svg_path


func _build_appearance_resource(item: Dictionary) -> String:
	var is_empty: bool = item.get("empty", false)
	var load_steps := 2 if is_empty else 3
	var header := (
		'[gd_resource type="Resource" script_class="AppearanceItem" '
		+ 'load_steps=%d format=3]\n\n' % load_steps
		+ '[ext_resource type="Script" path="res://scripts/character/appearance_item.gd" '
		+ 'id="1_script"]\n'
	)
	var frames_reference := ""
	var frames_property := ""

	if not is_empty:
		frames_reference = (
			'\n[ext_resource type="SpriteFrames" '
			+ 'path="res://resources/appearance/%s_frames.tres" id="2_frames"]\n'
		) % item["file"]
		if item.get("layer_mode", "front") == "back":
			frames_property = "back_sprite_frames = ExtResource(\"2_frames\")\n"
		else:
			frames_property = "sprite_frames = ExtResource(\"2_frames\")\n"

	return (
		header
		+ frames_reference
		+ "\n[resource]\n"
		+ 'script = ExtResource("1_script")\n'
		+ 'id = &"%s"\n' % item["id"]
		+ 'display_name = "%s"\n' % item["display_name"]
		+ "category = %d\n" % item["category"]
		+ frames_property
		+ "locked = false\n"
	)


func _write_text(resource_path: String, content: String) -> void:
	var absolute_path := ProjectSettings.globalize_path(resource_path)
	var error := DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	if error != OK:
		push_error("Could not create directory for %s: %s" % [resource_path, error_string(error)])
		quit(1)
		return

	var file := FileAccess.open(absolute_path, FileAccess.WRITE)
	if file == null:
		push_error("Could not write %s: %s" % [resource_path, FileAccess.get_open_error()])
		quit(1)
		return
	file.store_string(content)
