class_name HealthComponent
extends Node

signal health_changed(current_hp: int, max_hp: int)
signal died

@export var max_health: int = 100:
	set(value):
		max_health = maxi(1, value)
		current_health = clampi(current_health, 0, max_health)
@export var current_health: int = 100

var is_dead := false


func reset_health() -> void:
	is_dead = false
	current_health = max_health
	health_changed.emit(current_health, max_health)


func take_damage(data: Dictionary) -> bool:
	if is_dead:
		return false
	var amount := maxi(0, int(data.get("amount", 0)))
	if amount <= 0:
		return false
	current_health = clampi(current_health - amount, 0, max_health)
	health_changed.emit(current_health, max_health)
	if current_health <= 0 and not is_dead:
		is_dead = true
		died.emit()
	return true


func heal(amount: int) -> bool:
	if is_dead or amount <= 0 or current_health >= max_health:
		return false
	current_health = clampi(current_health + amount, 0, max_health)
	health_changed.emit(current_health, max_health)
	return true
