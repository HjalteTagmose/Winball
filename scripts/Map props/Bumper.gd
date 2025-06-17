extends StaticBody2D
class_name BasicBumper

@export var CanDie : bool = false
@export var Life : int = 3
@export var Power : float = 35
@export var Score : int = 15
@export var AudioPlayer : AudioStreamPlayer2D
@export var SoundOnHIt : AudioStream
@export var ParticleOnHit : GPUParticles2D
@export var Bias : Vector2 = Vector2.ZERO
@export var BiasPower : float = 15

var timesHit : int
var isInStrom : bool
var currentFrame : int = 0

func _ready() -> void:
	AudioPlayer.stream = SoundOnHIt
	timesHit = 0

func _process(delta):

	if currentFrame == Engine.get_physics_frames():
		return

	var collisions = move_and_collide(Vector2.ZERO, true)
	if collisions:
		print(collisions.get_collider().name)

	if collisions && collisions.get_collider() is Player:
		BumpPlayer(collisions, collisions.get_collider())

	currentFrame = Engine.get_physics_frames()

func BumpPlayer(collisionInfo:KinematicCollision2D, player : Player) -> void:
	# var customNormal = (player.global_position - global_position).normalized()
	var impulse : Vector2 = (collisionInfo.get_normal() * Power) + (Bias.normalized() * BiasPower)
	player.apply_impulse(impulse)

	PlayAnimation()
	AddScore()

	timesHit += 1
	if CanDie && timesHit >= Life:
		Die()

func PlayAnimation():
	AudioPlayer.play()
	if ParticleOnHit:
		ParticleOnHit.emitting = true

func AddScore():
	Global.score += Score

	if isInStrom:
		Global.score += Score
	
	print("Current score: ", Global.score, name)

func Die():
	queue_free()
	pass
