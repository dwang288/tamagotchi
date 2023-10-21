extends Button

signal used_serum(item: InventoryItem)
# Called when the node enters the scene tree for the first time.


func _on_pressed():
	var serum_item = load("res://items/serum.tres")
	print("serum sending: ", serum_item.name)
	used_serum.emit(serum_item)
