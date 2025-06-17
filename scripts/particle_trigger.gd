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
func _process(delta: float) -> void:	
	#wait for fisnished
	for particles in particles:
		if particles.emitting:
			return
	
	queue_free()
