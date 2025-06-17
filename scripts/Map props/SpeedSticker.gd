extends BasicSticker
class_name SpeedSticker

@export var ForwardPoint : Node2D
@export var Power : float
@export var OverridesVelocity : bool

func Interact(player:Player):
	var direction : Vector2 = ForwardPoint.global_position - global_position
	direction = direction.normalized()

	if OverridesVelocity:
		player.linear_velocity = Vector2.ZERO
	
	player.apply_central_impulse(direction * Power)

	pass
