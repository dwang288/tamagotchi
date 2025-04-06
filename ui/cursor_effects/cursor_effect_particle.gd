extends TextureRect

@export var sprite: Texture2D
@export var duration: float
# Called when the node enters the scene tree for the first time.
func _ready():
	texture = sprite
	$DeletionTimer.wait_time = duration
	$DeletionTimer.start()

func _on_deletion_timer_timeout():
	if is_instance_valid(self):
		queue_free()
