extends Resource

class_name InventoryResource

signal updated

# TODO: Change this so we're initializing the slots through code and not
# onload in the menu_lower GUI
@export var slot_resources: Array[InventorySlotResource]

func insert(item: InventoryItemResource):
	for slot_resource in slot_resources:
		if slot_resource.item == item && slot_resource.amount < item.maxAmount:
			slot_resource.amount += 1
			updated.emit()
			return

	for slot_resource in slot_resources:
		if !slot_resource.item:
			slot_resource.item = item
			slot_resource.amount = 1
			updated.emit()
			return
			
func delete(slot_resource: InventorySlotResource):
	if slot_resource.item:
		slot_resource.amount -= 1
		if slot_resource.amount == 0:
			slot_resource.item = null
		updated.emit()
		return
	print("Could not find item to be deleted")
