extends Control

class_name TooltipControl

@export var text: String
@onready var name_label: RichTextLabel = %NameLabel
@onready var hunger_label: RichTextLabel = %HungerLabel
@onready var hygiene_label: RichTextLabel = %HygieneLabel
@onready var happiness_label: RichTextLabel = %HappinessLabel
@onready var health_label: RichTextLabel = %HealthLabel
@onready var rest_label: RichTextLabel = %RestLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update(item: InventoryItemResource):

	var item_attr = {
		"name": item.name,
		"description": item.description,
		"hunger": Utils.print_float_clean(item.hunger),
		"hygiene": Utils.print_float_clean(item.hygiene),
		"happiness": Utils.print_float_clean(item.happiness),
		"health": Utils.print_float_clean(item.health),
		"rest": Utils.print_float_clean(item.rest)
		}
	# TODO: Only add stat if the stat value is non zero
	var item_format = "{name} <<hunger>> {hunger} <<hygiene>> {hygiene} <<happiness>> {happiness} <<health>> {health} <<rest>> {rest}"
	name_label.parse_bbcode(Utils.replace_keywords("{name}").format(item_attr))
	hunger_label.parse_bbcode(Utils.replace_keywords("<<hunger>> {hunger}%").format(item_attr))
	hygiene_label.parse_bbcode(Utils.replace_keywords("<<hygiene>> {hygiene}%").format(item_attr))
	happiness_label.parse_bbcode(Utils.replace_keywords("<<happiness>> {happiness}%").format(item_attr))
	health_label.parse_bbcode(Utils.replace_keywords("<<health>> {health}%").format(item_attr))
	rest_label.parse_bbcode(Utils.replace_keywords("<<rest>> {rest}%").format(item_attr))
	visible = true

func close():
	visible = false
