extends Panel

@onready var itemIcon: TextureRect = $CenterContainer/Panel/item
@onready var amountLabel: Label = $CenterContainer/Panel/Label

func update(slot: InventorySlot):
	if slot.item:
		itemIcon.visible = true
		itemIcon.texture = slot.item.texture
		if slot.amount == 0 || slot.amount == 1:
			amountLabel.visible = false
		else:
			amountLabel.visible = true
			amountLabel.text = str(slot.amount)
	else:
		itemIcon.visible = false
		amountLabel.visible = false
		
	print(itemIcon.visible)
