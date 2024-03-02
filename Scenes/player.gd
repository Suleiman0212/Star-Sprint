extends CharacterBody2D

@export var SPEED = 800.0
@export var bullet_scene: PackedScene
@onready var marker: Marker2D = $Marker2D
@onready var timer: Timer = $Timer
@export var die_scene: String

var gun_reload = false

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("ui_accept"):
		if !gun_reload:
			shoot()
			gun_reload = true
			timer.start()
		
	global_position = global_position.clamp(Vector2(60, 0), Vector2(get_viewport_rect().size.x - 60, get_viewport_rect().size.y))
	move_and_slide()

func shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.position = marker.global_position

func die():
	GL.goto_scene(die_scene)

func _on_timer_timeout() -> void:
	gun_reload = false
