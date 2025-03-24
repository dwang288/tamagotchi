extends Node

@export var timer: Timer = Timer.new()
@export var SAVE_INTERVAL: float = 5.0
@export var game_state: GameStateResource = preload("res://game_states/default_save.tres")

# TODO: Have option to make a new game and erase old save files,
# will need to keep a copy of starting stats

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = SAVE_INTERVAL
	timer.autostart = true
	timer.timeout.connect(save_game)
	add_child(timer)

# TODO: Create new resource from resource files on disk, not just duplicate resource file with embeds
func new_game():
	# create a new GameState resource with default child resources (unique)
	print("creating new game")
	pause_autosave()
	# overwrite existing file
	# TODO: Doesn't work, might need to go in 
	ResourceSaver.save(load("res://game_states/default_save_backup.tres").duplicate(true), game_state.get_path())
	# quit window
	get_tree().quit()

func pause_autosave():
	timer.stop()

func resume_autosave():
	timer.start()

func save_game():
	print("Saving")
	ResourceSaver.save(game_state, game_state.get_path())


func add_tamagotchi(resource: TamagotchiResource):
	game_state.tamagotchis.append(resource)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
