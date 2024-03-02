extends CanvasLayer

@onready var score_lbl: Label = $VBoxContainer/Score
@onready var time_lbl: Label = $VBoxContainer/Time
@onready var timer: Timer = $VBoxContainer/Timer

var elepsed_time: int = 0
var score: int = 0
func _ready() -> void:
	score_lbl.text = "Score: 0"
	time_lbl.text = "Time: " + str(elepsed_time)
	timer.start()

func score_update(score_up: int):
	score += score_up
	score_lbl.text = "Score: " + str(score)

func _on_timer_timeout() -> void:
	elepsed_time += 1
	time_lbl.text = "Time: " + str(elepsed_time)
