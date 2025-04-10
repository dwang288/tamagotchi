extends Node2D

class_name CursorEffect

@export var effect_type: EffectType

@onready var freq_timer: Timer = $FrequencyTimer # For setting frequency of particle spawns 

enum EffectType { BUBBLE, SPARKLE, FLOWER, FIRE, BINARY }

var effect_map = {
	EffectType.BUBBLE: { # TODO: move contents into an EffectTypeResource
		"sprites": [ load("res://assets/gui/cursors/cursor_effects/bubble/bubble1.png"),
			load("res://assets/gui/cursors/cursor_effects/bubble/bubble2.png"),
			load("res://assets/gui/cursors/cursor_effects/bubble/bubble3.png"), ],
		"frame_size_px": 8,
		"duration": 0.3,
		"spawn_frequency": 0.03,
		"jitter_range": 9.0
	},
	EffectType.SPARKLE: { # TODO: move contents into an EffectTypeResource
		"sprites": [ load("res://assets/gui/cursors/cursor_effects/sparkle/sparkle1.png"),
			load("res://assets/gui/cursors/cursor_effects/sparkle/sparkle2.png"),
			load("res://assets/gui/cursors/cursor_effects/sparkle/sparkle3.png"), ],
		"frame_size_px": 8,
		"duration": 0.3,
		"spawn_frequency": 0.03,
		"jitter_range": 10.0
	},
	EffectType.FLOWER: { # TODO: move contents into an EffectTypeResource
		"sprites": [ load("res://assets/gui/cursors/cursor_effects/flower/flower1.png"),
			load("res://assets/gui/cursors/cursor_effects/flower/flower2.png"),
			load("res://assets/gui/cursors/cursor_effects/flower/flower3.png"),
			load("res://assets/gui/cursors/cursor_effects/flower/flower4.png"),
			load("res://assets/gui/cursors/cursor_effects/flower/flower5.png"), ],
		"frame_size_px": 8,
		"duration": 0.3,
		"spawn_frequency": 0.03,
		"jitter_range": 10.0
	},
	EffectType.FIRE: { # TODO: move contents into an EffectTypeResource
		"sprites": [ load("res://assets/gui/cursors/cursor_effects/fire/fire1.png"),
			load("res://assets/gui/cursors/cursor_effects/fire/fire2.png"),
			load("res://assets/gui/cursors/cursor_effects/fire/fire4.png"), ],
		"frame_size_px": 8,
		"duration": 0.3,
		"spawn_frequency": 0.03,
		"jitter_range": 8.0
	},
	EffectType.BINARY: { # TODO: move contents into an EffectTypeResource
		"sprites": [ load("res://assets/gui/cursors/cursor_effects/binary/binary1.png"),
			load("res://assets/gui/cursors/cursor_effects/binary/binary2.png"),
			load("res://assets/gui/cursors/cursor_effects/binary/binary3.png"), ],
		"frame_size_px": 8,
		"duration": 0.3,
		"spawn_frequency": 0.03,
		"jitter_range": 10.0
	}
}

func _ready():
	freq_timer.wait_time = effect_map[effect_type]["spawn_frequency"]
	freq_timer.start()


func _on_frequency_timer_timeout():
	var jitter = Vector2(
		randf_range(-effect_map[effect_type]["jitter_range"], effect_map[effect_type]["jitter_range"]),
		randf_range(-effect_map[effect_type]["jitter_range"], effect_map[effect_type]["jitter_range"])
		)
	var particle = SceneManager.scenes["cursor_effect_particle"].instantiate()
	particle.sprite = effect_map[effect_type]["sprites"][randi() % effect_map[effect_type]["sprites"].size()]
	particle.duration = effect_map[effect_type]["duration"]
	particle.position = get_viewport().get_mouse_position() + jitter
	get_tree().current_scene.add_child(particle)
