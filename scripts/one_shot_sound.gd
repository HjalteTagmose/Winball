class_name OneShotSound extends AudioStreamPlayer

func play_sound(sound: AudioStream):
	stream = sound
	finished.connect(queue_free)
	play()
