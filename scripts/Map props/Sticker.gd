extends Area2D
class_name BasicSticker

@export var score : int
@export var OneTimeUse : bool = true
@export var AudioPlayer : AudioStreamPlayer2D
@export var InteractionSFX : AudioStream
@export var ParticleOnHit : GPUParticles2D

var hasBeenUsed : bool = false

func _ready() -> void:
	AudioPlayer.stream = InteractionSFX

func _on_body_enter(body:Node2D):
	if hasBeenUsed && OneTimeUse:
		return

	if body is Player:
		Interact(body)
	
	hasBeenUsed = true

func Interact(player : Player):
	PlayAnimation()
	Global.score += score
	print("current score ", Global.score)


func PlayAnimation():
	AudioPlayer.play()
	if ParticleOnHit:
		ParticleOnHit.emitting = true
