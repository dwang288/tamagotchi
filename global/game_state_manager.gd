extends Node

@export var save_interval: float = 5.0
@export var game_state: GameStateResource = preload("res://game_states/default_save.tres")

# TODO: Have option to make a new game and erase old save files,
# will need to keep a copy of starting stats

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.wait_time = save_interval
	timer.autostart = true
	timer.timeout.connect(save_game)
	add_child(timer)

# TODO: Add new game function
func new_game():
	# create a new GameState resource with default child resources (unique)
	pass

func save_game():
	ResourceSaver.save(game_state, game_state.get_path())


func add_tamagotchi(resource: TamagotchiResource):
	game_state.tamagotchis.append(resource)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
