extends Node2D
class_name ParticleTrigger

var particles: Array[GPUParticles2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get all GPUParticlesystem2d in children
	for node: Node in get_children():
		if node is GPUParticles2D:
			particles.append(node)
	
	for particle in particles:
		# start emitting particles
		particle.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	#wait for fisnished
	for particle in particles:
		if particle.emitting:
			return
	
	queue_free()

func StopEmitting():
	for particle in particles:
		particle.emitting = false