extends Panel

@onready var button: Button = $ButtonUseItem
@onready var item_icon: TextureRect = $CenterContainer/Panel/item
@onready var amount_label: Label = $CenterContainer/Panel/Label

@export var item_slot: InventorySlotResource

signal clicked_item(slot: InventorySlotResource)

func update(slot: InventorySlotResource):

	if slot.item:
		item_slot = slot
		item_icon.visible = true
		item_icon.texture = slot.item.texture
		if slot.amount == 0 || slot.amount == 1:
			amount_label.visible = false
		else:
			amount_label.visible = true
			amount_label.text = str(slot.amount)
	else:
		item_slot = null
		item_icon.visible = false
		amount_label.visible = false


func _on_button_use_item_pressed():
	if item_slot:
		clicked_item.emit(item_slot)


func _on_mouse_entered():
	$ButtonUseItem.grab_focus()
	if item_slot:
		MouseManager.set_cursor(MouseManager.HAND_POINT)

func _on_mouse_exited():
	$ButtonUseItem.release_focus()
	MouseManager.set_default()

func _on_button_use_item_focus_entered():
	$Selector.visible = true

func _on_button_use_item_focus_exited():
	$Selector.visible = false
