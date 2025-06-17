extends RigidBody2D

class_name Player


@export var minLaunchPower : float = 100
@export var maxLaunchPower : float = 1000
@export var launchChargeDuration : float = 1

@export var killVelocityBeforeLaunch : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _getInputDirection() -> Vector2:
	return Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down").normalized()


var _launchClickTime : float

var _isCharging : bool

func handleLaunch() -> void:
	
	var timeNow = Time.get_unix_time_from_system()
	
	if(Input.is_action_just_pressed("launch")):
		if(Global.currentAmmo > 0):
			_launchClickTime = timeNow
			Global.currentAmmo -= 1
			_isCharging = true		
		
	var difference = timeNow - _launchClickTime
	var percent = clamp(difference / launchChargeDuration, 0, 1)
	var currentPower = lerp(minLaunchPower, maxLaunchPower, percent)		

	if(Input.is_action_just_released("launch")):		
		
		if(!_isCharging):
			return
		_isCharging = false
		print("============== LAUNCHING ==============")
		print("difference ", difference)
		print("percent ", percent)
		print("currentPower ", currentPower)
		print("=======================================")
		#PARTICLE
		var direction = (global_position - get_global_mouse_position())
		
		direction = direction.normalized();
		if(killVelocityBeforeLaunch):
			linear_velocity = Vector2.ZERO
		var impulse = direction * currentPower
		apply_central_impulse(impulse)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handleLaunch()	
	pass
