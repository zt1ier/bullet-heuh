class_name Player 
extends Entity


enum States {
	IDLE,
	MOVING,
	ATTACKING,
	ATTACKING_WHILE_MOVING,
}


@export var projectile_scene: PackedScene


var run_speed: float
var walk_speed: float

var attack_speed: float
var time_since_attack: float

var current_state = States.IDLE


func _ready() -> void:
	if not is_in_group("Player"):
		add_to_group("Player")

	_fill_variables()


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

	# --- PROCESS STATES ---
	match current_state:
		States.IDLE: pass
		States.MOVING: _process_moving(direction)
		States.ATTACKING: _process_attacking()
		States.ATTACKING_WHILE_MOVING: _process_attacking_while_moving(direction)

	time_since_attack += get_process_delta_time()

	# --- TRANSITION STATES ---
	if Input.is_action_pressed("attack"):
		if direction != Vector2.ZERO:
			current_state = States.ATTACKING_WHILE_MOVING
		elif direction == Vector2.ZERO:
			current_state = States.ATTACKING
	elif direction != Vector2.ZERO:
		current_state = States.MOVING
	else:
		current_state = States.IDLE

	move_and_slide()


func _process_moving(direction: Vector2) -> void:
	velocity = direction * run_speed


func _process_attacking() -> void:
	if time_since_attack >= attack_speed:
		_attack()


func _process_attacking_while_moving(direction: Vector2) -> void:
	velocity = direction * walk_speed

	if time_since_attack >= attack_speed: 
		_attack()


func _attack() -> void:
	var projectile := projectile_scene.instantiate() as PlayerProjectile
	projectile.direction = -(global_position - get_global_mouse_position()).normalized()
	projectile.global_position = global_position
	projectile.damage = damage
	projectile.damage_source = self
	add_sibling(projectile)

	time_since_attack = 0


func _fill_variables() -> void:
	run_speed = movement_speed
	walk_speed = movement_speed / 2
	attack_speed = fire_rate
