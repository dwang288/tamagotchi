extends Sprite2D

func react_to_item(item: InventoryItem):
	# TODO: Choose emotion based on item
	visible = true
	get_node("AnimationPlayer").play("Heart")

func _on_animation_player_animation_finished(anim_name):
	print("finished")
	visible = false
