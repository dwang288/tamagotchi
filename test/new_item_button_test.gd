extends Button

@export var items: Array[InventoryItemResource]

signal sent_item(item: InventoryItemResource)
# Called when the node enters the scene tree for the first time.

func _on_pressed():
	if items.size() > 0:
		var item = items.pick_random()
		sent_item.emit(item)
