extends Button

signal add_coins(coins: int)

func _on_pressed():
	add_coins.emit(1111)
