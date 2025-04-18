extends Sprite2D

class_name Emote

@onready var emote_animation_player: AnimationPlayer = $AnimationPlayer
@onready var emote_animation_tree: AnimationTree = $AnimationTree
@onready var emote_state_machine: AnimationNodeStateMachinePlayback = emote_animation_tree["parameters/playback"]

# TODO: Weird flash when emote returns to reset mode. Check playback step by step to see where it's traveling

func animation_setup(resource: TamagotchiResource):
	if resource.emote_animation_library:
		emote_animation_player.add_animation_library("emote", resource.emote_animation_library)
	else:
		emote_animation_player.add_animation_library("emote", load("res://emotes/animations/emote.res"))

	if emote_state_machine is AnimationNodeStateMachinePlayback:
		var emote_state_machine_node = emote_animation_tree.tree_root

		# TODO: Change advance conditions in state machine to use the enum
		emote_state_machine_node.get_node("idle").get_node("idle").animation = "emote/idle"
		emote_state_machine_node.get_node("idle").get_node("reset").animation = "emote/reset"
		emote_state_machine_node.get_node("idle").get_node("hunger").animation = "emote/hunger"
		emote_state_machine_node.get_node("idle").get_node("hygiene").animation = "emote/hygiene"
		emote_state_machine_node.get_node("idle").get_node("happiness").animation = "emote/happiness"
		emote_state_machine_node.get_node("idle").get_node("health").animation = "emote/health"
		emote_state_machine_node.get_node("angry").animation = "emote/angry"
		emote_state_machine_node.get_node("annoyed").animation = "emote/annoyed"
		emote_state_machine_node.get_node("love").animation = "emote/love"
		emote_state_machine_node.get_node("silent").animation = "emote/silent"
		emote_state_machine_node.get_node("singing").animation = "emote/singing"
		emote_state_machine_node.get_node("unhappy").animation = "emote/unhappy"
