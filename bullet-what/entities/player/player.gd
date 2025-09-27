class_name Player 
extends Entity


# --- PLAYER STATE ---
enum PlayerState {
	ATTACKING,
	ATTACKING_WHILE_MOVING,
}


# --- PROJECTILE ---
@export var projectile_scene: PackedScene


# --- MOVEMENT ---
var run_speed: float
var walk_speed: float

# --- FIRING ---
var time_since_attack: float

# --- STATE HANDLING ---
var current_state = BaseState.IDLE
var state: String = "" # debug, delete whenever you feel like it


func _ready() -> void:
	if not is_in_group("Player"):
		add_to_group("Player")
	_fill_variables()


func _physics_process(delta: float) -> void:
	# --- MOVEMENT INPUT ---
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

	# --- PROCESS STATES ---
	match current_state:
		BaseState.IDLE:
			state = "i"
			_process_idle(direction, delta)
		BaseState.MOVING:
			state = "m"
			_process_moving(direction, delta)
		PlayerState.ATTACKING:
			state = "a"
			_process_attacking()
		PlayerState.ATTACKING_WHILE_MOVING:
			state = "am"
			_process_attacking_while_moving(direction, delta)
		_:
			print("Praise God")

	time_since_attack += get_process_delta_time()

	print(state)

	# --- TRANSITION STATES ---
	if Input.is_action_pressed("attack"):
		if direction != Vector2.ZERO:
			current_state = PlayerState.ATTACKING_WHILE_MOVING
		elif direction == Vector2.ZERO:
			current_state = PlayerState.ATTACKING
	elif direction != Vector2.ZERO:
		current_state = BaseState.MOVING
	else:
		current_state = BaseState.IDLE

	move_and_slide()


func _process_idle(direction: Vector2, delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, friction)


func _process_moving(direction: Vector2, delta: float) -> void:
	velocity = velocity.move_toward(direction * run_speed, friction)


func _process_attacking() -> void:
	if time_since_attack >= fire_rate:
		_attack()


func _process_attacking_while_moving(direction: Vector2, delta: float) -> void:
	velocity = velocity.move_toward(direction * walk_speed, friction)

	if time_since_attack >= fire_rate: 
		_attack()


func _attack() -> void:
	var projectile := projectile_scene.instantiate() as PlayerProjectile
	projectile.direction = -(global_position - get_global_mouse_position()).normalized()
	projectile.global_position = global_position
	projectile.damage_source = self
	projectile.damage = damage
	add_sibling(projectile)

	time_since_attack = 0


func _fill_variables() -> void:
	run_speed = movement_speed
	walk_speed = movement_speed / 2
