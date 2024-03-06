extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker: Marker2D = $Marker2D
@onready var timer: Timer = $ShootTimer
@onready var state_timer: Timer = $StateTimer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

@export var bullet_scene: PackedScene
@export var repair_kit: PackedScene
@export var amunitions: PackedScene
@export var SPEED = 35.0
@export var SHOOT_RESCHARGE = [4, 5]

var SHOOT_AUD := preload("res://Sprites/Audio/shoot.ogg")
var DEATH_AUD := preload("res://Sprites/Audio/death.ogg")

var random
var enemy_type
var die_type
var game_state
var is_dying = false
func _ready() -> void:
	audio.volume_db = GL.db()
	random = RandomNumberGenerator.new()
	random.randomize()
	SPEED = random.randi_range(70, 90)
	enemy_type = random.randi_range(1, 3)
	match enemy_type:
		1:
			anim.play("EnemyV1")
		2:
			anim.play("EnemyV2")
		3:
			anim.play("EnemyV3")
	timer.start(random.randf_range(1, 3))

func _physics_process(_delta: float) -> void:
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

func _state_changer():
	if get_tree().root.has_node("Map/EnemySpawner"):
		var enemy_spawner = get_tree().root.get_node("Map/EnemySpawner")
		game_state = enemy_spawner.current_state
		match game_state:
			enemy_spawner.GameState.Easy:
				SPEED = 65
				SHOOT_RESCHARGE = [4, 5]
			enemy_spawner.GameState.Normal:
				SPEED = 70
				SHOOT_RESCHARGE = [3, 4]
			enemy_spawner.GameState.Hard:
				SPEED = 75
				SHOOT_RESCHARGE = [2, 3]
			enemy_spawner.GameState.Impossible:
				SPEED = 100
				SHOOT_RESCHARGE = [1, 3]

func shoot():
	if !is_dying:
		audio.stream = SHOOT_AUD
		audio.play()
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.position = marker.global_position
		timer.start(random.randf_range(SHOOT_RESCHARGE[0], SHOOT_RESCHARGE[1]))
 
func die():
	is_dying = true
	audio.stop()
	audio.stream = DEATH_AUD
	audio.play()
	if get_tree().root.has_node("Map/Score"):
		var score = get_tree().root.get_node("Map/Score")
		score.score_update(100)
	die_type = random.randi_range(1, 2)
	match die_type:
		1:
			anim.play("DieV1")
		2:
			anim.play("DieV2")


func _on_animation_finished() -> void:
	if random.randi_range(1, 20) == random.randi_range(1, 20):
		match random.randi_range(1, 2):
			1:
				var rep_kit = repair_kit.instantiate()
				get_tree().root.add_child(rep_kit)
				rep_kit.position = global_position
			2:
				var amunition = amunitions.instantiate()
				get_tree().root.add_child(amunition)
				amunition.position = global_position
	queue_free()


func _on_timer_timeout() -> void:
	shoot()

func _on_state_timer_timeout() -> void:
	_state_changer()
	state_timer.start()
