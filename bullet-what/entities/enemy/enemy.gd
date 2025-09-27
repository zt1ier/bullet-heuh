class_name Enemy
extends Entity


# idk why I'm not using this but ok
# problem for another day
enum States {
	IDLE,
	MOVING,
	CONTROLLED, # expand soon; stunned, immobilized, debuffed, DoT, etc.
}


@export var player: Player:
	get:
		if not player:
			player = get_tree().get_first_node_in_group("Player")
		return player


func _ready() -> void:
	if not is_in_group("Enemies"):
		add_to_group("Enemies")
	damage_source = self # --- if MeleeEnemy.


func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	move_and_slide()


func _handle_movement(delta: float) -> void:
	var direction := (player.global_position - global_position).normalized()
	velocity = velocity.lerp(direction * movement_speed, delta)
