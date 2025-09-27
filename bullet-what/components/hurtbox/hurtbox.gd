class_name Hurtbox
extends Area2D


@export var actor: Entity:
	get:
		if not actor:
			actor = get_parent()
		return actor


func _ready() -> void:
	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))


func _on_area_entered(hitbox: Hitbox) -> void:
	if actor == hitbox.actor.damage_source:
		return
	actor.hit_by(hitbox.actor)
