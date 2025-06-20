class_name _OneShotSoundManager extends Node

@export_category("Sound")
@export var oneShotSoundPrefab : PackedScene

@export var minPitch := 0.75
@export var maxPitch := 1.25

func play_sound(sound: AudioStream, shiftPitch: bool = true):
	if sound == null:
		return
	
	# instantiate the OneShotSound prefab
	var oneShotSound: OneShotSound = oneShotSoundPrefab.instantiate()
	oneShotSound.name = "OneShotSound_" + str(sound.resource_name)
	if shiftPitch:
		oneShotSound.pitch_scale = randf_range(minPitch, maxPitch)
	oneShotSound.sound = sound
	get_tree().root.add_child.call_deferred(oneShotSound)
