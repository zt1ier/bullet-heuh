class_name Hurtbox
extends Area2D


@export var actor: Entity:
	get:
		if not actor:
			actor = get_parent()
		return actor


func _ready() -> void:
	if not is_connected("area_entered", Callable(self, "")):
		connect("area_entered", Callable(self, ""))


func _on_area_entered(hitbox: Hitbox) -> void:
	pass
