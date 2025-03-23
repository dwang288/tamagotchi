extends Resource

class_name InventoryResource

signal updated

# inventory_capacity should be a multiple of the number of inventory UI columns
@export var inventory_capacity: int = 12
@export var slot_resources: Array[InventorySlotResource]

func insert(item: InventoryItemResource):
	print(slot_resources.size())
	# slot_resources is the array of all actual items in the inventory
	# first check if item already exists, at which point add to the existing one
	for slot_resource in slot_resources:
		if slot_resource.item == item && slot_resource.amount < item.maxAmount:
			slot_resource.amount += 1
			updated.emit()
			return

	# if the item doesn't exist or has reached max capacity, then as long as we're still under inventory_capacity,
	# create a new slot_resource with the item and add it to slot_resources
	if slot_resources.size() < inventory_capacity:
		var slot_resource = InventorySlotResource.new()
		slot_resource.item = item
		slot_resource.amount = 1
		slot_resources.append(slot_resource)
		updated.emit()
		return
			
func delete(slot_resource: InventorySlotResource):
	if slot_resource.item:
		slot_resource.amount -= 1
		if slot_resource.amount == 0:
			slot_resources.erase(slot_resource)
		updated.emit()
		return
	print("Could not find item to be deleted")

func swap_items_by_index(index1: int, index2: int):
	var temp = slot_resources[index2]
	slot_resources[index2] = slot_resources[index1]
	slot_resources[index1] = temp
	updated.emit()
