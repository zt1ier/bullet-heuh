class_name Enemy
extends Entity


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


func _physics_process(delta: float) -> void:
	_handle_movement() # override with children
	move_and_slide()


func _handle_movement() -> void:
	var direction := (player.global_position - global_position).normalized()
	velocity = direction * movement_speed
