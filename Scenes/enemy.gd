extends CharacterBody2D

@export var SPEED = 100.0
var random

func _ready() -> void:
	random = RandomNumberGenerator.new()
	random.randomize()
	SPEED = random.randi_range(70, 90)

func _physics_process(delta: float) -> void:
	if !get_tree().root.has_node("Map/Player"):
		queue_free()
	velocity.y = 1 * SPEED
	if position.y > 1096:
		if get_tree().root.has_node("Map/Player"):
			var player = get_tree().root.get_node("Map/Player")
			player.die()
		else:
			queue_free()
		queue_free()
	move_and_slide()

func die():
	var score = get_tree().root.get_node("Map/Score")
	score.score_update(100)
	queue_free()
	
