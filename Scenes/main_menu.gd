extends Control

@onready var start_game: Button = $MarginContainer/HBoxContainer/VBoxContainer/StartGame
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

@export var game_scene: String
@export var settings_scene: String

func _ready() -> void:
	audio.volume_db = GL.db()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_on_start_game_pressed()
	if Input.is_action_just_pressed("ui_select"):
		_on_settings_pressed()

func _on_start_game_pressed() -> void:
	audio.volume_db = GL.db()
	audio.play()
	GL.goto_scene(game_scene)


func _on_settings_pressed() -> void:
	audio.volume_db = GL.db()
	audio.play()
	GL.goto_scene(settings_scene)
