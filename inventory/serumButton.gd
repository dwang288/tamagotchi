extends Button

signal sent_serum(item: InventoryItem)
# Called when the node enters the scene tree for the first time.


func _on_pressed():
	var serum_item = load("res://items/itemResources/serum.tres")
	sent_serum.emit(serum_item)
