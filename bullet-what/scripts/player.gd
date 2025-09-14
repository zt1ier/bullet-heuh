class_name Player 
extends CharacterBody2D


enum States {
	IDLE,
	MOVING,
	ATTACKING,
	ATTACKING_WHILE_MOVING,
}

var state_name: String = ""


@export var projectile_scene: PackedScene
@export var movement_speed: float = 300.0
@export var fire_rate: float = 1.0


var run_speed: float
var walk_speed: float

var current_state = States.IDLE


@onready var attack_timer: Timer = $AttackTimer


func _ready() -> void:
	if not is_in_group("Player"):
		add_to_group("Player")

	run_speed = movement_speed
	walk_speed = movement_speed / 2
	attack_timer.wait_time = fire_rate

	if attack_timer.one_shot == false:
		attack_timer.one_shot = true


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

	# --- PROCESS STATES ---
	match current_state:
		States.IDLE:
			state_name = "idle"
		States.MOVING:
			_process_moving(direction)
			state_name = "move"
		States.ATTACKING:
			_process_attacking()
			state_name = "attack"
		States.ATTACKING_WHILE_MOVING:
			_process_attacking_while_moving(direction)
			state_name = "attack while move"

	# --- TRANSITION STATES ---
	if Input.is_action_pressed("attack"):
		if direction != Vector2.ZERO and can_attack():
			current_state = States.ATTACKING_WHILE_MOVING
		else:
			current_state = States.ATTACKING
	elif direction != Vector2.ZERO:
		current_state = States.MOVING
	else:
		current_state = States.IDLE

	print(state_name)

	move_and_slide()


func _process_moving(direction: Vector2) -> void:
	velocity = direction * run_speed


func _process_attacking() -> void:
	_attack()


func _process_attacking_while_moving(direction: Vector2) -> void:
	velocity = direction * walk_speed
	_attack()


func _attack() -> void:
	attack_timer.start()

	var projectile := projectile_scene.instantiate() as Projectile
	projectile.direction = -(global_position - get_global_mouse_position()).normalized()
	projectile.global_position = global_position
	add_sibling(projectile)


func can_attack() -> bool:
	return attack_timer.is_stopped()
