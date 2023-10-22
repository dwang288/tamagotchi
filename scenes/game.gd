extends Node2D

class_name Game

@export var inventory: Inventory


func _ready():
	get_node("TestButton/Button").sent_serum.connect(inventory.insert)
	
	# Connect on click signal between menu item and inventory slot
	for slot in get_node("Menu_lower/HBoxContainer").get_children():
		slot.used_item.connect(inventory.delete)
		print("connected")
	
	# Connect on change signal between tamagotchi stat and stat menu
	get_node("Tamagotchi").on_stat_change.connect(get_node("Stats/HungerBar").update)
	get_node("Menu_lower/HBoxContainer").get_child(0).get_node("ButtonUseItem").grab_focus
	
