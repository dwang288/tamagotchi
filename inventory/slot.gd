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
	if itemSlot:
		clicked_item.emit(itemSlot)


func _on_mouse_entered():
	get_node("ButtonUseItem").grab_focus()
	print(get_node("ButtonUseItem").has_focus())

func _on_mouse_exited():
	get_node("ButtonUseItem").release_focus()
	print(get_node("ButtonUseItem").has_focus())

func _on_button_use_item_focus_entered():
	get_node("Selector").visible = true

func _on_button_use_item_focus_exited():
	get_node("Selector").visible = false
