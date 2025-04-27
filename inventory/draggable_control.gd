extends Control

@export var parent_control: Control
@export var preview_scene: PackedScene

var being_dragged: bool

signal slot_visibility_changed(is_visible: bool)

func _notification(what):
	if what == NOTIFICATION_DRAG_END and being_dragged:

		slot_visibility_changed.emit(true)
		being_dragged = false
		#MouseManager.set_default()

		# print("slot_index: ", slot_index, " being dragged: ", being_dragged, " amount_label visible: ", amount_label.visible, " amount_label: ", amount_label.text)

func _get_drag_data(at_position):
	if parent_control.item_slot:
		being_dragged = true
		MouseManager.set_cursor(MouseManager.HAND_GRAB)

		var drag_preview_control = SceneManager.scenes["drag_preview_control"].instantiate()
		var item_node = SceneManager.scenes["item"].instantiate()
		item_node.item_resource = self.item_slot.item
		drag_preview_control.node = item_node
		set_drag_preview(drag_preview_control)

		slot_visibility_changed.emit(false)

		return self
