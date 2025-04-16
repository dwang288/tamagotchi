extends Node

@export var scenes: Dictionary[String, PackedScene] = {
	"item": preload("res://items/item.tscn"),
	"drag_preview_control": preload("res://ui/drag_preview_control.tscn"),
	"cursor_effect": preload("res://ui/cursor_effects/cursor_effect.tscn"),
	"cursor_effect_particle": preload("res://ui/cursor_effects/cursor_effect_particle.tscn"),
	"toast_notification": preload("res://ui/toast_notifications/toast_notification.tscn"),
}
