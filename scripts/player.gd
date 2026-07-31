class_name Player
extends CharacterBody2D

@export var move_speed: float = 150.0

var _facing_direction := Vector2.DOWN


func _ready() -> void:
	queue_redraw()


func _physics_process(_delta: float) -> void:
	var input_direction := _get_input_direction()
	velocity = input_direction * move_speed

	if input_direction != Vector2.ZERO:
		_facing_direction = input_direction

	move_and_slide()
	queue_redraw()


func _get_input_direction() -> Vector2:
	var direction := Vector2.ZERO

	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1.0

	return direction.normalized()


func _draw() -> void:
	# Temporary procedural character art for the Phase 1 prototype.
	var shadow_color := Color(0.02, 0.03, 0.03, 0.35)
	draw_ellipse(Vector2(0, 10), Vector2(11, 5), shadow_color)

	draw_circle(Vector2(0, -4), 10.0, Color("e6b87a"))
	draw_rect(Rect2(-9, 5, 18, 18), Color("4f8f70"), true)
	draw_rect(Rect2(-8, 20, 6, 8), Color("35475e"), true)
	draw_rect(Rect2(2, 20, 6, 8), Color("35475e"), true)

	var eye_offset := _facing_direction.normalized() * 2.0
	draw_circle(Vector2(-3, -5) + eye_offset, 1.2, Color("1d2523"))
	draw_circle(Vector2(3, -5) + eye_offset, 1.2, Color("1d2523"))


func draw_ellipse(center: Vector2, radius: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for index in range(24):
		var angle := TAU * float(index) / 24.0
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	draw_colored_polygon(points, color)
