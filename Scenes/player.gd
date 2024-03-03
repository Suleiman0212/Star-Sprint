extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker: Marker2D = $Marker2D
@onready var timer: Timer = $Timer
@onready var score = get_tree().root.get_node("Map/Score")

@export var SPEED = 800.0
@export var bullet_scene: PackedScene
@export var die_scene: String
@export var LIVES: int = 3

enum PlayerStates {
	Idle,
	MoveL,
	MoveR,
	Hurt,
	Die
}

var current_state: PlayerStates = PlayerStates.Idle

var gun_reload = false

func _ready() -> void:
	anim.play("default")

func _physics_process(_delta: float) -> void:
	if current_state != PlayerStates.Die:
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
	
func _process(_delta: float) -> void:
	_state_changer()
	
func change_state(new_state: PlayerStates) -> void:
	current_state = new_state
	match current_state:
		PlayerStates.Idle:
			anim.play("Idle")
		PlayerStates.MoveL:
			anim.play("MoveL")
		PlayerStates.MoveR:
			anim.play("MoveR")
		PlayerStates.Hurt:
			anim.play("Hurt")
			if (anim.frame == anim.sprite_frames.get_frame_count("Hurt") - 1):
				current_state = PlayerStates.Idle
		PlayerStates.Die:
			anim.play("Die")
			if (anim.frame == anim.sprite_frames.get_frame_count("Die") - 1):
				GL.goto_scene(die_scene)

func _state_changer() -> void:
	if current_state != PlayerStates.Die and current_state != PlayerStates.Hurt:
		if velocity.x == 0:
			change_state(PlayerStates.Idle)
		elif velocity.x > 0:
			change_state(PlayerStates.MoveR)
		elif velocity.x < 0:
			change_state(PlayerStates.MoveL)
	elif current_state == PlayerStates.Die:
		change_state(PlayerStates.Die)
	elif current_state == PlayerStates.Hurt:
		change_state(PlayerStates.Hurt)

func shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.position = marker.global_position
	
func hurt():
	if current_state != PlayerStates.Hurt:
		LIVES -= 1
		score.lives_update(LIVES)
		if LIVES <= 0:
			change_state(PlayerStates.Die)
		else:
			change_state(PlayerStates.Hurt)
			
func health():
	if LIVES < 3:
		LIVES += 1
		score.lives_update(LIVES)

func die():
	change_state(PlayerStates.Die)

func _on_timer_timeout() -> void:
	gun_reload = false
