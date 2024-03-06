extends Control

@export var menu_scene: String
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var h_slider: HSlider = $MarginContainer/HBoxContainer/VBoxContainer/HSlider

func _ready() -> void:
	audio.volume_db = GL.db()
	h_slider.value = GL.volume

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		_on_back_pressed()

func _on_value_changed(value: float) -> void:
	GL.set_volume(value)


func _on_back_pressed() -> void:
	audio.play()
	GL.goto_scene(menu_scene)
