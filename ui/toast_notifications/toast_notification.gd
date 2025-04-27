extends RichTextLabel

@export var duration: float

# TODO: Should pop into position
# TODO: Outline of text is getting cut off, maybe not enough space?
func _ready() -> void:
	modulate.a = 0.0  # Start fully transparent
	# TODO: Position at this point isn't final position yet, not aligned inside vboxcontainer
	position.y += 3  # Start 3px below final position
	# print(global_position)
	show()

	# Animate fade-in
	self.create_tween().tween_property(self, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Animate slide-up
	#self.create_tween().tween_property(self, "position:y", position.y - 3, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	$DeletionTimer.wait_time = duration
	$DeletionTimer.start()

func _on_deletion_timer_timeout():
	if is_instance_valid(self):
		# Animate fade-out
		var tween = self.create_tween()
		tween.tween_property(self, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		await tween.finished
		queue_free()
