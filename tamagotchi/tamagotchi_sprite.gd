extends Sprite2D

class_name TamagotchiSprite

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

# TODO: Weird flicker when emote returns to reset mode. Check playback step by step to see where it's traveling. Hunger isn't flicking tho!

func animation_setup(resource: TamagotchiResource):
	animation_player.add_animation_library("animation", resource.animation_library)

	if state_machine is AnimationNodeStateMachinePlayback:
		var state_machine_node = animation_tree.tree_root

		# TODO: Change advance conditions in state machine to use the enum
		state_machine_node.get_node("idle").get_node("idle").animation = "animation/idle"
		state_machine_node.get_node("idle").get_node("unwell").animation = "animation/unwell"
		state_machine_node.get_node("happy").animation = "animation/feed"
		state_machine_node.get_node("clean").animation = "animation/clean"
		state_machine_node.get_node("sleep").animation = "animation/sleep"
		state_machine_node.get_node("unhappy").animation = "animation/unhappy"
