extends Node2D

@export var SPEED = 400.0

func _physics_process(delta: float) -> void:
	if !get_tree().root.has_node("Map/Player"):
		queue_free()
	if position.y > 1096:
			queue_free()
	global_position.y += SPEED * delta

func _on_area_entered(area: Area2D) -> void:
	if area.owner.name == "Player":
		if area.owner.has_method("speed_up_attack"):
			area.owner.speed_up_attack()
		queue_free()
