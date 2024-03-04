extends Node

@export var enemy_scene: PackedScene
@onready var timer: Timer = $Timer
@onready var score = get_tree().root.get_node("Map/Score")

enum GameState {
	Easy,
	Normal,
	Hard,
	Impossible
}

var current_state = GameState.Easy

var spawn_points = [176, 400, 624, 848, 1072, 1296, 1520, 1744]
var busy_points = [false, false, false, false, false, false, false, false]
var random

func _ready() -> void:
	random = RandomNumberGenerator.new()
	random.randomize()
	timer.start()
	
func _process(_delta: float) -> void:
	_state_changer()
	
func _state_changer():
	if score.elepsed_time > 0 and score.elepsed_time < 30:
		current_state = GameState.Easy
	elif score.elepsed_time > 30 and score.elepsed_time < 120:
		current_state = GameState.Normal
	elif score.elepsed_time > 120 and score.elepsed_time < 240:
		current_state = GameState.Hard
	elif score.elepsed_time > 240:
		current_state = GameState.Impossible
	

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

	match current_state:
		GameState.Easy:
			_spawn(random.randi_range(1, 1))
		GameState.Normal:
			_spawn(random.randi_range(1, 2))
		GameState.Hard:
			_spawn(random.randi_range(2, 3))
		GameState.Impossible:
			_spawn(random.randi_range(3, 5))
