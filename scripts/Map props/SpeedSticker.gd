extends BasicSticker
class_name SpeedSticker

@export var ForwardPoint : Node2D
@export var Power : float
@export var OverridesVelocity : bool
@export var ArrowsToAnimate : Array[Sprite2D]
@export var AnimationFPS : float

var timeToFlip : float
var currentTime : float

func _ready() -> void:
	super()
	timeToFlip = 60.0 / AnimationFPS
	currentTime = 0

func Interact(player:Player):
	var direction : Vector2 = ForwardPoint.global_position - global_position
	direction = direction.normalized()

	if OverridesVelocity:
		player.linear_velocity = Vector2.ZERO
	
	player.apply_central_impulse(direction * Power)

	pass

func _process(delta: float) -> void:
	currentTime += delta

	if currentTime >= timeToFlip:
		currentTime = 0

		for arrow : Sprite2D in ArrowsToAnimate:
			var frameID = 0 if arrow.frame == 1 else 1
			arrow.frame = frameID
			arrow.frame_coords.x = frameID
