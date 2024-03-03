extends Node

@export var enemy_scene: PackedScene
@onready var timer: Timer = $Timer

var spawn_points = [176, 400, 624, 848, 1072, 1296, 1520, 1744]
var busy_points = [false, false, false, false, false, false, false, false]

var random
func _ready() -> void:
	random = RandomNumberGenerator.new()
	random.randomize()
	timer.start()

func _spawn(val: int):
	for i in val:
		var enemy = enemy_scene.instantiate()
		var search_pos = true
		get_tree().root.add_child(enemy)
		enemy.position.y = 64
		while search_pos:
			var pos = random.randi_range(1, spawn_points.size())
			if !busy_points[pos-1]:
				enemy.position.x = spawn_points[pos-1]
				busy_points[pos-1] = true
				search_pos = false
func _on_timer_timeout() -> void:
	for i in busy_points.size():
		busy_points[i] = false
	_spawn(random.randi_range(1, 3))
