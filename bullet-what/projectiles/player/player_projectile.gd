class_name PlayerProjectile
extends Projectile


func _ready() -> void:
	if not is_in_group("PlayerProjectile"):
		add_to_group("PlayerProjectile")
