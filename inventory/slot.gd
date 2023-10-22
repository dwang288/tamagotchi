extends Panel

@onready var itemIcon: TextureRect = $CenterContainer/Panel/item
@onready var amountLabel: Label = $CenterContainer/Panel/Label

@export var itemSlot: InventorySlot

signal clicked_item(slot: InventorySlot)

func update(slot: InventorySlot):

	if slot.item:
		itemSlot = slot
		itemIcon.visible = true
		itemIcon.texture = slot.item.texture
		if slot.amount == 0 || slot.amount == 1:
			amountLabel.visible = false
		else:
			amountLabel.visible = true
			amountLabel.text = str(slot.amount)
	else:
		itemSlot = null
		itemIcon.visible = false
		amountLabel.visible = false


func _on_button_use_item_pressed():
	print("pressed")
	if itemSlot:
		clicked_item.emit(itemSlot)
		print("emitted")
