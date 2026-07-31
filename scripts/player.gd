class_name Player
extends CharacterBody2D

@export var move_speed: float = 150.0

var facing_direction := Vector2.DOWN


func _ready() -> void:
	queue_redraw()


func _physics_process(_delta: float) -> void:
	var input_direction := Vector2.ZERO

	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		input_direction.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		input_direction.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		input_direction.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		input_direction.y += 1.0

	input_direction = input_direction.normalized()
	velocity = input_direction * move_speed

	if input_direction != Vector2.ZERO:
		facing_direction = input_direction

	move_and_slide()
	queue_redraw()


func _draw() -> void:
	_draw_ellipse(Vector2(0, 13), Vector2(12, 5), Color(0.02, 0.03, 0.03, 0.28))
	draw_rect(Rect2(-9, 3, 18, 20), Color("4f8f70"), true)
	draw_rect(Rect2(-8, 20, 6, 9), Color("35475e"), true)
	draw_rect(Rect2(2, 20, 6, 9), Color("35475e"), true)
	draw_circle(Vector2.ZERO, 11.0, Color("e6b87a"))
	draw_arc(Vector2(0, -2), 11.0, PI, TAU, 18, Color("5b3a29"), 5.0)

	var eye_offset := facing_direction.normalized() * 2.0
	draw_circle(Vector2(-3, 0) + eye_offset, 1.3, Color("1d2523"))
	draw_circle(Vector2(3, 0) + eye_offset, 1.3, Color("1d2523"))


func _draw_ellipse(center: Vector2, radius: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for index in range(24):
		var angle := TAU * float(index) / 24.0
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	draw_colored_polygon(points, color)
