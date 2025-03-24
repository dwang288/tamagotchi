extends Panel

class_name Slot

@onready var button: Button = $UseItemButton
@onready var item_icon: TextureRect = $CenterContainer/Panel/ItemTexture
@onready var selector_icon: TextureRect = $Selector
@onready var amount_label: Label = $CenterContainer/Panel/Label

@export var item_slot: InventorySlotResource
@export var slot_index: int

# For moving items around in inventory
var being_dragged = false

signal clicked_item(slot: InventorySlotResource)
signal swapped_item(slot1: Slot, slot2: Slot)

func update_slot(slot: InventorySlotResource):
	item_slot = slot
	item_icon.visible = true
	item_icon.texture = slot.item.texture
	if slot.amount == 0 || slot.amount == 1:
		amount_label.visible = false
	else:
		amount_label.visible = true
		amount_label.text = str(slot.amount)

func clear_slot():
	item_slot = null
	item_icon.visible = false
	item_icon.texture = null
	amount_label.visible = false
	amount_label.text = str(0)


func _on_button_use_item_pressed():
	if item_slot:
		clicked_item.emit(item_slot)

func _on_mouse_entered():
	button.grab_focus()
	if item_slot:
		MouseManager.set_cursor(MouseManager.HAND_POINT)

func _on_mouse_exited():
	button.release_focus()
	MouseManager.set_default()

func _on_button_use_item_focus_entered():
	selector_icon.visible = true

func _on_button_use_item_focus_exited():
	selector_icon.visible = false


# Inventory drag/drop logic

func _notification(what):
	if what == NOTIFICATION_DRAG_END and being_dragged:
		print("Drag ended on: ", self)
		MouseManager.set_default()
		item_icon.visible = true
		amount_label.visible = true

func _get_drag_data(at_position):
	if item_slot:
		being_dragged = true
		MouseManager.set_cursor(MouseManager.HAND_GRAB)

		var drag_preview = SceneManager.scenes["drag_preview"].instantiate()
		var item_node = SceneManager.scenes["item"].instantiate()
		item_node.item_resource = self.item_slot.item

		drag_preview.node = item_node

		set_drag_preview(drag_preview)

		item_icon.visible = false
		amount_label.visible = false

		return self

func _can_drop_data(at_position, data):
	return data is Slot && self.item_slot

func _drop_data(at_position, data):
	# The swap should change the actual InventoryResource
	swapped_item.emit(data, self)

	being_dragged = false

