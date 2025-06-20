class_name BasicBumper extends StaticBody2D

@export_category("Stats")
@export var CanDie : bool = false
@export var Life : int = 3
@export var Power : float = 35
@export var Score : Array[int] = [100, 50, 10]
@export var Saturation : Array[float] = [.75, .5, .35]

@export_category("Bias")
@export var Bias : Vector2 = Vector2.ZERO
@export var BiasPower : float = 15

@export_category("Setup")
@export var SoundOnHits : Array[AudioStream]
@export var ParticleOnHit : PackedScene


@export_category("Helpers")
@export var CollisionShape : CollisionShape2D

signal bumped
signal bumped_impulse
var timesHit : int
var isInStrom : bool
var _scoreIndex = 0

var _isDead = false

func _ready() -> void:
	add_to_group("bumper")
	timesHit = 0

func _physics_process(_delta: float) -> void:

	var collisions = move_and_collide(Vector2.UP, true)

	if collisions && collisions.get_collider() is Player:
		BumpPlayer(collisions, collisions.get_collider())


func BumpPlayer(collisionInfo:KinematicCollision2D, player : Player) -> void:
	if player.freeze:
		return
		
	# var customNormal = (player.global_position - global_position).normalized()
	var impulse : Vector2 = (collisionInfo.get_normal() * Power) + (Bias.normalized() * BiasPower)
	player.apply_central_impulse(impulse)

	PlayAnimation(collisionInfo)
	AddScore(collisionInfo)

	timesHit += 1
	bumped.emit()
	bumped_impulse.emit(impulse)
	
	if CanDie && timesHit >= Life:
		Die()
	
	AdditionalBumpBehaviour(collisionInfo, player)
	
	
func PlayParticle(collisionInfo: KinematicCollision2D):
	if(ParticleOnHit == null):
		return
		
	var direction = collisionInfo.get_normal()
	var impactPoint = collisionInfo.get_position()
	
	var instance: ParticleTrigger = ParticleOnHit.instantiate()
	instance.global_position = impactPoint
	# var globalPoint = instance.to_global(direction)	
	instance.rotation = direction.angle()
	get_tree().root.add_child(instance)
	
func AdditionalBumpBehaviour(_collisionInfo:KinematicCollision2D, _player : Player) -> void:
	return

func PlayAnimation(collisionInfo: KinematicCollision2D):
	OneShotSoundManager.play_sound(SoundOnHits.pick_random())
	PlayParticle(collisionInfo)

func AddScore(collisionInfo: KinematicCollision2D):
	if(Score.size() <= 0):
		return
	
	var scoreIndex = clamp(_scoreIndex, 0, Score.size()-1)
	var scoreToGive = Score[scoreIndex]
	
	_scoreIndex += 1

	# coud be nicer here 
	if isInStrom:
		ScoreManager.AddScore(scoreToGive*2)
		Global.DisplayFloatingScore(scoreToGive*2, collisionInfo.get_position())
	else:
		ScoreManager.AddScore(scoreToGive)
		Global.DisplayFloatingScore(scoreToGive, collisionInfo.get_position())
		
	# set saturation
	var saturationIndex = scoreIndex
	if self is AmmoBumper:
		saturationIndex -= 1
		if saturationIndex < 0:
			return
	var saturation = Saturation[saturationIndex]
	if $Sprite2D.material != null:
		$Sprite2D.material.set("shader_parameter/saturation", saturation);

func Die():
	if _isDead:
		return
	_isDead = true
	var tween: Tween = create_tween()
	tween.tween_interval(0.1)
	tween.tween_callback(queue_free)
	
	
