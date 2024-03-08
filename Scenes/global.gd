extends Node

var current_scene = null

var volume = 40

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	current_scene.queue_free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
func set_volume(val):
	volume = val
	
func db() -> float:
	var min_db = -80.0
	var max_db = 24.0
	var db_range = max_db - min_db
	var db_val = (volume / 100.0) * db_range + min_db
	return db_val
