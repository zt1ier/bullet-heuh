class_name Entity
extends CharacterBody2D


# --- BASE STATE ---
enum BaseState {
	IDLE,
	MOVING,
	KNOCKEDBACK,
}


# --- DEFAULT ---
@export var health: int = 10

# --- ATTACKING ---
@export var damage: int = 5
@export var fire_rate: float = 0.25
@export var knockback_force: float = 100.0

# --- MOVEMENT ---
@export var movement_speed: float = 300.0
@export var friction: float = 100.0


# --- DAMAGE REFERENCE (for Hitbox and Hurtbox) ---
var damage_source: Entity = null

# --- KNOCKBACK PARAMETERS ---
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0


func hit_by(source: Entity) -> void:
	take_damage(source.damage)
	if health > 0:
		apply_knockback(source)


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
