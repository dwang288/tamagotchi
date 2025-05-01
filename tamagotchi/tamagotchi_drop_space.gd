extends Control

class_name DropSpace

signal item_dropped(resource: InventoryItemResource)

func _can_drop_data(_at_position, data):
	return data is Slot && data.item_slot

func _drop_data(_at_position, data):
	# Emit item consumed
	# Should decrease item count by one and also use on tamagotchi
	item_dropped.emit(data.item_slot)
