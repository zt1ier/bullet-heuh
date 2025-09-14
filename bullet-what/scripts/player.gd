class_name Player 
extends CharacterBody2D


enum States {
	IDLE,
	WALKING, # attacking while moving, move speed is 
	RUNNING, # normal movement
	ATTACKING, # attacking while not moving
}

var state_name: String = ""


@export var movement_speed: float = 300.0
@export var fire_rate: float = 1.0


var run_speed: float
var walk_speed: float
var attack_speed: float

var current_state = States.IDLE


func _ready() -> void:
	if not is_in_group("Player"):
		add_to_group("Player")

	run_speed = movement_speed
	walk_speed = movement_speed / 2
	attack_speed = fire_rate


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

	# --- PROCESS STATES ---
	match current_state:
		States.IDLE:
			state_name = "idle"
		States.WALKING:
			_process_walking(direction)
			state_name = "walk"
		States.RUNNING:
			_process_running(direction)
			state_name = "run"
		States.ATTACKING:
			_process_attacking()
			state_name = "attack"

	# --- TRANSITION STATES ---
	if Input.is_action_pressed("attack"):
		if direction != Vector2.ZERO:
			current_state = States.WALKING
		else:
			current_state = States.ATTACKING
	elif direction != Vector2.ZERO:
		current_state = States.RUNNING
	else:
		current_state = States.IDLE

	print(state_name)

	move_and_slide()


func _process_walking(direction: Vector2) -> void:
	velocity = direction * walk_speed


func _process_running(direction: Vector2) -> void:
	velocity = direction * run_speed


func _process_attacking() -> void:
	pass
