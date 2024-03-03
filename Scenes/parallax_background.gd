extends ParallaxBackground

@export var SPEED: int = 50
func _process(delta: float) -> void:
	scroll_offset.y += delta * SPEED
