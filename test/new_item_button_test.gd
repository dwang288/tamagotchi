extends Button

signal sent_item(item: InventoryItemResource)
# Called when the node enters the scene tree for the first time.


func _on_pressed():
	var item = load("res://items/itemResources/candy.tres")
	sent_item.emit(item)
