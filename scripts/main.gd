extends Node

@onready var world_container: Node2D = $WorldContainer
@onready var ui_root: Control = $CanvasLayer/UI
@onready var scene_transition: CanvasLayer = $SceneTransition
@onready var debug_overlay: CanvasLayer = $DebugOverlay


func _ready() -> void:
	get_viewport().canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	_validate_main_scene()


func _validate_main_scene() -> void:
	if world_container == null:
		push_error("Main scene is missing WorldContainer.")
	if ui_root == null:
		push_error("Main scene is missing CanvasLayer/UI.")
	if scene_transition == null:
		push_error("Main scene is missing SceneTransition.")
	if debug_overlay == null:
		push_error("Main scene is missing DebugOverlay.")
