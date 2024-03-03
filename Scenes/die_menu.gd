extends Control

@onready var start_game: Button = $MarginContainer/HBoxContainer/VBoxContainer/StartGame

@export var game_scene: String

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_on_start_game_pressed()

func _on_start_game_pressed() -> void:
	GL.goto_scene(game_scene)
