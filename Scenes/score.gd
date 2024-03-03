extends CanvasLayer

@onready var score_lbl: Label = $VBoxContainer/Score
@onready var time_lbl: Label = $VBoxContainer/Time
@onready var lives_lbl: Label = $VBoxContainer/Lives
@onready var timer: Timer = $VBoxContainer/Timer

var elepsed_time: int = 0
var score: int = 0
func _ready() -> void:
	score_lbl.text = "Score: 0"
	time_lbl.text = "Time: " + str(elepsed_time)
	lives_lbl.text = "Lives: 2"
	timer.start()

func score_update(score_up: int):
	score += score_up
	score_lbl.text = "Score: " + str(score)
	
func lives_update(lives_count: int):
	lives_lbl.text = "Lives: " + str(lives_count - 1)

func _on_timer_timeout() -> void:
	elepsed_time += 1
	time_lbl.text = "Time: " + str(elepsed_time)
