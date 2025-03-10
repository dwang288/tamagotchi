extends Resource

class_name InventoryResource

signal updated

# TODO: Change this so we're initializing the slots through code and not
# onload in the menu_lower GUI
@export var slots: Array[InventorySlotResource]

func insert(item: InventoryItemResource):
	for slot in slots:
		if slot.item == item && slot.amount < item.maxAmount:
			slot.amount += 1
			updated.emit()
			return

	for slot in slots:
		if !slot.item:
			slot.item = item
			slot.amount = 1
			updated.emit()
			return
			
func delete(slot: InventorySlotResource):
	if slot.item:
		slot.amount -= 1
		if slot.amount == 0:
			slot.item = null
		updated.emit()
		return
	print("Could not find item to be deleted")
