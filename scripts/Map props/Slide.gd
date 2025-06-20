extends Line2D
class_name Slide

@export var SlideSpeed : float = 15
@export var EndShotPower : float = 1400

@export_category("Sounds")
@export var SoundPlayer: AudioStreamPlayer2D
@export var enterSoundEffect: AudioStream
@export var exitSoundEffect: AudioStream
@export var onRailSoundEffects: Array[AudioStream] = []


var boundPlayer : Player
var currentNode : int
var currentLerpTime : float = 0

func _process(delta: float) -> void:
	if !boundPlayer:
		if SoundPlayer.playing:
			SoundPlayer.stop()
		return

	if !SoundPlayer.playing:
		SoundPlayer.stream = onRailSoundEffects.pick_random()
		SoundPlayer.play()
	
	var firstPoint = to_global(points[currentNode])
	var secondPoint = to_global(points[currentNode + 1])
	var direction = (secondPoint - firstPoint).normalized()
	var dist : float = firstPoint.distance_to(secondPoint)
	var time = dist / SlideSpeed
	time = currentLerpTime / time
	currentLerpTime += delta

	var value : Vector2 = lerp(firstPoint, secondPoint, time)
	boundPlayer.global_position = value

	if time >= 1:
		currentNode += 1
		currentLerpTime = 0
	
	if currentNode >= points.size() - 1:
		ShootPlayer(direction)
		

func _on_body_entered(body:Node2D) -> void:
	if body is Player:
		boundPlayer = body
		CenterPlayer()
		LockPlayer()
		PrepSlide()
		OneShotSoundManager.play_sound(enterSoundEffect)

func LockPlayer() -> void:
	boundPlayer.set_deferred("freeze", true)
	boundPlayer.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	boundPlayer.linear_velocity = Vector2.ZERO
	boundPlayer.locked = true

func PrepSlide() -> void:
	currentNode = 0;
	currentLerpTime = 0

func UnlockPlayer() -> void:
	boundPlayer.freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
	boundPlayer.locked = false
	boundPlayer.set_deferred("freeze", false)

func CenterPlayer() -> void:
	boundPlayer.global_position = to_global(points[currentNode])

func ShootPlayer(direction : Vector2) -> void:
	UnlockPlayer()
	boundPlayer.linear_velocity = direction * EndShotPower
	boundPlayer = null
	OneShotSoundManager.play_sound(exitSoundEffect)
