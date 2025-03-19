extends Button

signal new_game

# Called when the node enters the scene tree for the first time.
func _on_pressed():
	new_game.emit()
