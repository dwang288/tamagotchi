extends Control

class_name TamaInfoWindow

@export var active_tamagotchi_resource: TamagotchiResource

# Information that needs to be updated on just the info page:
# Pfp
# Name
# Lvl
# Exp
# Current stat
# Max stat

#func update_active_tamagotchi(tamagotchi_resource: TamagotchiResource):
#
	## Disconnect previous tamagotchi's signals from GUI
	#if active_tamagotchi_resource:
		#if active_tamagotchi_resource.stat_changed.is_connected(update_stats):
			#active_tamagotchi_resource.stat_changed.disconnect(update_stats)
#
	#active_tamagotchi_resource = tamagotchi_resource
	#
	## Connect new signals to GUI
	#active_tamagotchi_resource.stat_changed.connect(update_stats)
	#
	## Update the GUI once
	#update_stats(active_tamagotchi_resource)
