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
	get_node("Tamagotchi").on_stat_change.connect(get_node("Stats/HBoxContainer/HungerPanel/HungerIndicator").update)
	
func click_item(slot: InventorySlot):
	get_node("Tamagotchi").use_item(slot.item)
	inventory.delete(slot)
