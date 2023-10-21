extends Node2D

class_name Game

@export var inventory: Inventory

func _ready():
	get_node("TestButton/Button").sent_serum.connect(inventory.insert)
	get_node("TestButton/Button2").used_serum.connect(inventory.delete)
