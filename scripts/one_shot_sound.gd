class_name OneShotSound extends AudioStreamPlayer

var sound : AudioStream

func _ready() -> void:
	stream = sound
	finished.connect(queue_free)
	play()
