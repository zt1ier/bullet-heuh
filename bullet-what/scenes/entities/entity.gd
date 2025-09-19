class_name Entity
extends CharacterBody2D


@export var health: int
@export var movement_speed: float = 300.0
@export var fire_rate: float = 0.25
@export var damage: int


func _handle_movement() -> void:
	pass


func take_damage(amount: int) -> void:
	print("%s health: %d -> %d" % [name, health, health - amount])
	health -= amount
	if health <= 0:
		die()


func die() -> void:
	set_physics_process(false)
	print("%s died" % [name])
