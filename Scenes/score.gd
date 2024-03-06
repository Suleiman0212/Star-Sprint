extends CanvasLayer

@onready var score_lbl: Label = $VBoxContainer/Score
@onready var time_lbl: Label = $VBoxContainer/Time
@onready var lives_lbl: Label = $VBoxContainer/Lives
@onready var timer: Timer = $ElepsedTime
@onready var remain_bar: ProgressBar = $VBoxContainer/RemainBar

@export var boost_sec: int = 15

var elepsed_time: int = 0
var score: int = 0
var remain_time: int
var attack_accelerated: bool = false

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
	
func remainder():
	attack_accelerated = true
	remain_bar.max_value = boost_sec
	remain_bar.value = boost_sec
	remain_time = boost_sec
	remain_bar.show()

func _on_timer_timeout() -> void:
	elepsed_time += 1
	time_lbl.text = "Time: " + str(elepsed_time)
	if remain_time > 0:
		remain_time -= 1
		remain_bar.value = remain_time
	else:
		attack_accelerated = false
		remain_bar.value = 0
		remain_bar.hide()
