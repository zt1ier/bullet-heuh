class_name Projectile
extends Entity


var direction: Vector2


func _physics_process(delta: float) -> void:
	velocity = direction * movement_speed
	move_and_slide()
