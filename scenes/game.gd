extends Node2D

class_name Game

@export var inventory: Inventory


func _ready():
	# Test add serum button
	get_node("TestButton/Button").sent_serum.connect(inventory.insert)
	
	# Connect on click signal between menu item and inventory slot
	for slot in get_node("Menu_lower/HBoxContainer").get_children():
		slot.clicked_item.connect(click_item)
		print("connected")
	
	# Connect on change signal between tamagotchi stat and stat menu
	get_node("Tamagotchi").stat_changed.connect(get_node("Stats").update)
	
	get_node("Tamagotchi").item_consumed.connect(inventory.delete)
	
	# TODO: Clean this up
	inventory.insert(load("res://items/itemResources/lollipop.tres"))
	
	get_node("Menu_lower/HBoxContainer/Slot1/ButtonUseItem").grab_focus()
	
func click_item(slot: InventorySlot):
	get_node("Tamagotchi").use_item_in_slot(slot)
