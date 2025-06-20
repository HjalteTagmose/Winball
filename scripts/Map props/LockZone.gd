extends Area2D
class_name LockZone

@export var Score : int
@export var Power : float
@export var PlayerBindPivot : Sprite2D
@export var Front : Node2D

@export var shootParticle : PackedScene

@export_category("Sounds")
@export var SoundPlayer: AudioStreamPlayer2D
@export var enterSoundEffect: AudioStream
@export var exitSoundEffect: AudioStream
@export var onRailSoundEffects: Array[AudioStream] = []

var boundPlayer : Player

func _process(_delta: float) -> void:
	
	if(Input.is_action_just_pressed("launch")):
		Launch()
		
	if !boundPlayer:
		if SoundPlayer.playing:
			SoundPlayer.stop()
		return

	if !SoundPlayer.playing:
		SoundPlayer.stream = onRailSoundEffects.pick_random()
		SoundPlayer.play()
		
	turnCanonToPoint(get_global_mouse_position())
	CenterPlayer()
	# PlayerBindPivot.transform.

func _on_body_enter(body:Node2D):
	if body is Player:
		boundPlayer = body
		turnCanonToPoint(boundPlayer.global_position)
		CenterPlayer()
		LockPlayer()
		ScoreManager.AddScore(Score)
		OneShotSoundManager.play_sound(enterSoundEffect)

func _on_body_exit(_body:Node2D):
	pass

func Launch() -> void:
	if !boundPlayer:
		return

	OneShotSoundManager.play_sound(exitSoundEffect)
	UnlockPlayer()
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	handleShootParticle(-direction)
	
	# if(Global.player_direction == Global.PlayerDirection.AwayFromMouse):
	# 	direction = -direction;
	
	boundPlayer.linear_velocity = (direction * Power)
	boundPlayer = null


func LockPlayer() -> void:
	boundPlayer.set_deferred("freeze", true)
	boundPlayer.linear_velocity = Vector2.ZERO
	boundPlayer.locked = true

func UnlockPlayer() -> void:
	boundPlayer.locked = false
	boundPlayer.set_deferred("freeze", false)

func CenterPlayer() -> void:
	boundPlayer.global_position = PlayerBindPivot.global_position


func turnCanonToPoint(point : Vector2):
	PlayerBindPivot.look_at(point)
	pass
	
	
func handleShootParticle(direction: Vector2):
	if(shootParticle == null):
		return
		
	var instance: ParticleTrigger = shootParticle.instantiate()
	instance.global_position = Front.global_position
	instance.rotation = direction.angle()

	get_tree().root.add_child(instance)
