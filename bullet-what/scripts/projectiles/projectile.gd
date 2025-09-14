class_name Projectile
extends CharacterBody2D


@export var proj_speed: float = 250.0


var speed: float
var direction: Vector2


func _ready() -> void:
	speed = proj_speed


func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
