class_name Entity
extends CharacterBody2D


@export var health: int
@export var damage: int
@export var fire_rate: float = 0.25
@export var movement_speed: float = 300.0
@export var knockback_force: float = 100.0


var damage_source: Entity


func _physics_process(delta: float) -> void:
	_handle_movement()
	move_and_slide()


func _handle_movement() -> void:
	pass


func take_damage(amount: int) -> void:
	print("%s health: %d -> %d" % [name, health, health - amount])
	health -= amount
	if health <= 0:
		die()


func apply_knockback(source: Entity) -> void:
	var knockback_direction := (source.global_position - global_position).normalized()
	global_position -= knockback_direction * knockback_force


func die() -> void:
	set_physics_process(false)
	print("%s died" % [name])
	#queue_free()
