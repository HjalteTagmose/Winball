class_name _OneShotSoundManager extends Node

@export_category("Sound")
@export var oneShotSoundPrefab : PackedScene

func play_sound(sound: AudioStream):
	if sound == null:
		return
	
	# instantiate the OneShotSound prefab
	var oneShotSound: OneShotSound = oneShotSoundPrefab.instantiate()
	oneShotSound.name = "OneShotSound_" + str(sound.resource_name)
	get_tree().root.add_child(oneShotSound)
	oneShotSound.play_sound(sound)
