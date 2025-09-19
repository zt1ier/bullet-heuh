class_name Hitbox
extends Area2D


@export var actor: Entity:
	get:
		if not actor:
			actor = get_parent()
		return actor


func _ready() -> void:
	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))

	if is_connected("area_entered", Callable(self, "_on_area_entered")):
		print("%s hitbox init" % actor.name)


func _on_area_entered(hurtbox: Hurtbox) -> void:
	actor.call_deferred("queue_free")
