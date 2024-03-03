extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker: Marker2D = $Marker2D
@export var bullet_scene: PackedScene
@onready var timer: Timer = $Timer

@export var SPEED = 100.0
var random
var enemy_type
var die_type

func _ready() -> void:
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
	
func shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.position = marker.global_position
	timer.start(random.randf_range(1, 3))


 
func die():
	var score = get_tree().root.get_node("Map/Score")
	score.score_update(100)
	die_type = random.randi_range(1, 2)
	match die_type:
		1:
			anim.play("DieV1")
		2:
			anim.play("DieV2")
	


func _on_animation_finished() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	shoot()
