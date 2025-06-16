extends RigidBody2D
@export var launchPower : float = 100
@export var killVelocityBeforeLaunch : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _getInputDirection() -> Vector2:
	return Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down").normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(Input.is_action_just_pressed("launch")):
		var direction = _getInputDirection()
		if(direction.length() < 1):
			direction = Vector2.UP
		if(killVelocityBeforeLaunch):
			linear_velocity = Vector2.ZERO
		apply_impulse(direction * launchPower)
	pass
