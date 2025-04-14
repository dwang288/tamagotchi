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

signal hovered(item_description: String)
signal exited_hover

func update_slot(slot: InventorySlotResource):
	item_slot = slot
	item_icon.texture = item_slot.item.texture
	amount_label.text = str(item_slot.amount)
	set_slot_visibility(true)

func clear_slot():
	item_icon.visible = false
	amount_label.visible = false
	item_slot = null
	item_icon.texture = null
	amount_label.text = str(0)

func set_slot_visibility(is_visible):
	item_icon.visible = is_visible
	if item_slot.amount == 0 || item_slot.amount == 1:
		amount_label.visible = false
	else:
		amount_label.visible = is_visible


func _on_button_use_item_pressed():
	if item_slot and not item_slot.item.is_grabbable:
		clicked_item.emit(item_slot)

func _on_mouse_entered():
	button.grab_focus()
	if item_slot:
		# Update tooltip info
		hovered.emit(construct_item_tooltip())
		# Update cursor depending on if item is grabbable
		if item_slot.item.is_grabbable:
			MouseManager.set_cursor(MouseManager.HAND_OPEN)
		else:
			MouseManager.set_cursor(MouseManager.HAND_POINT)

func _on_mouse_exited():
	button.release_focus()
	exited_hover.emit()
	MouseManager.set_default()

func _on_button_use_item_focus_entered():
	selector_icon.visible = true

func _on_button_use_item_focus_exited():
	selector_icon.visible = false

# TODO: Break tooltip creation into its own builder class
func construct_item_tooltip() -> String:
	var item = item_slot.item
	var item_attr = {"name": item.name, "description": item.description, "hunger": item.hunger, "hygiene": item.hygiene, "happiness": item.happiness, "health": item.health, "rest": item.rest}
	# TODO: Only add stat if the stat value is non zero
	var item_format = """{name}
<<hunger>> {hunger}
<<hygiene>> {hygiene}
<<happiness>> {happiness}
<<health>> {health}
<<rest>> {rest}
"""
	return item_format.format(item_attr)

# Inventory drag/drop logic

# TODO: Figure out how to forward these notifications into a component that can be reused
func _notification(what):
	if what == NOTIFICATION_DRAG_END and being_dragged:

		set_slot_visibility(true)
		being_dragged = false
		MouseManager.set_default()

		# print("slot_index: ", slot_index, " being dragged: ", being_dragged, " amount_label visible: ", amount_label.visible, " amount_label: ", amount_label.text)

func _get_drag_data(_at_position):
	if item_slot:
		being_dragged = true
		MouseManager.set_cursor(MouseManager.HAND_GRAB)

		var drag_preview_control = SceneManager.scenes["drag_preview_control"].instantiate()
		var item_node = SceneManager.scenes["item"].instantiate()
		item_node.item_resource = self.item_slot.item
		drag_preview_control.node = item_node
		set_drag_preview(drag_preview_control)

		set_slot_visibility(false)

		return self

func _can_drop_data(_at_position, data):
	return data is Slot && self.item_slot

func _drop_data(_at_position, data):
	# The swap should change the actual InventoryResource
	swapped_item.emit(data, self)
