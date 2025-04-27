extends VBoxContainer

@export var active_tamagotchi_resource: TamagotchiResource

@onready var name_label: RichTextLabel = %NameLabel
@onready var level_label: RichTextLabel = %LevelLabel
@onready var exp_label: RichTextLabel = %ExpLabel

# For the text colors
@export var full_color: Color
@export var mid_color: Color
@export var empty_color: Color

@onready var hunger_label: RichTextLabel = %HungerLabel
@onready var hygiene_label: RichTextLabel = %HygieneLabel
@onready var happiness_label: RichTextLabel = %HappinessLabel
@onready var health_label: RichTextLabel = %HealthLabel
@onready var rest_label: RichTextLabel = %RestLabel

func update_active_tamagotchi(tamagotchi_resource: TamagotchiResource):

	# Disconnect previous tamagotchi's signals from GUI
	if active_tamagotchi_resource:
		if active_tamagotchi_resource.leveled_up.is_connected(update_level):
			active_tamagotchi_resource.leveled_up.disconnect(update_level)
		if active_tamagotchi_resource.exp_changed.is_connected(update_exp):
			active_tamagotchi_resource.exp_changed.disconnect(update_exp)
		if active_tamagotchi_resource.stat_changed.is_connected(update_stats):
			active_tamagotchi_resource.stat_changed.disconnect(update_stats)

	active_tamagotchi_resource = tamagotchi_resource
	
	# Connect new signals to GUI
	active_tamagotchi_resource.leveled_up.connect(update_level)
	active_tamagotchi_resource.exp_changed.connect(update_exp)
	active_tamagotchi_resource.stat_changed.connect(update_stats)
	
	# Update the GUI once
	update_profile(active_tamagotchi_resource)
	update_stats(active_tamagotchi_resource)

func update_profile(tamagotchi_resource: TamagotchiResource):
	name_label.text = Utils.replace_keywords(tamagotchi_resource.name)
	update_level(tamagotchi_resource)

func update_level(tamagotchi_resource: TamagotchiResource):
	# Update level and max exp
	level_label.text = "Level " + "[color=#00a1ce]" + str(tamagotchi_resource.stats.level) + "[/color]"
	exp_label.text = "Exp " + "[color=#00a1ce]" + str(int(round(tamagotchi_resource.stats.exp))) + "[/color]" + "/" + str(int(round(tamagotchi_resource.stats.exp_cap)))

func update_exp(tamagotchi_resource: TamagotchiResource):
	exp_label.text = "Exp " + "[color=#00a1ce]" + str(int(round(tamagotchi_resource.stats.exp))) + "[/color]" + "/" + str(int(round(tamagotchi_resource.stats.exp_cap)))

func update_stats(tamagotchi_resource: TamagotchiResource):
	hunger_label.text = Utils.replace_keywords("<<hunger>> " + "[color=" + update_color(tamagotchi_resource.stats.get_hunger_ratio()).to_html(false) + "]" + str(int(round(tamagotchi_resource.stats.hunger))) + "[/color]" + "/" + str(int(round(tamagotchi_resource.stats.max_hunger))))
	hygiene_label.text = Utils.replace_keywords("<<hygiene>> " + "[color=" + update_color(tamagotchi_resource.stats.get_hygiene_ratio()).to_html(false) + "]" + str(int(round(tamagotchi_resource.stats.hygiene))) + "[/color]" + "/" + str(int(round(tamagotchi_resource.stats.max_hygiene))))
	happiness_label.text = Utils.replace_keywords("<<happiness>> " + "[color=" + update_color(tamagotchi_resource.stats.get_happiness_ratio()).to_html(false) + "]" + str(int(round(tamagotchi_resource.stats.happiness))) + "[/color]" + "/" + str(int(round(tamagotchi_resource.stats.max_happiness))))
	health_label.text = Utils.replace_keywords("<<health>> " + "[color=" + update_color(tamagotchi_resource.stats.get_health_ratio()).to_html(false) + "]" + str(int(round(tamagotchi_resource.stats.health))) + "[/color]" + "/" + str(int(round(tamagotchi_resource.stats.max_health))))
	rest_label.text = Utils.replace_keywords("<<rest>> " + "[color=" + update_color(tamagotchi_resource.stats.get_rest_ratio()).to_html(false) + "]" + str(int(round(tamagotchi_resource.stats.rest))) + "[/color]" + "/" + str(int(round(tamagotchi_resource.stats.max_rest))))

# TODO: Put the color lerping out into Utils class
func update_color(value: float) -> Color:
	var text_color: Color
	if value < .5 && value >= 0:
		text_color = empty_color.lerp(mid_color, value*2)
	elif value == .5:
		text_color = mid_color
	elif value > .5 && value <= 1:
		text_color = mid_color.lerp(full_color, (value-.5)*2)
	else:
		# Should never hit this case, error case
		text_color = Color.BLUE
	return text_color
