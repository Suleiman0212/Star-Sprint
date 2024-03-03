extends Node2D

@export var SPEED = 900.0

func _physics_process(delta: float) -> void:
	global_position.y += SPEED * delta



func _on_area_entered(area: Area2D) -> void:
	if area.owner.name == "Player":
		if area.owner.has_method("die"):
			area.owner.die()
		queue_free()
