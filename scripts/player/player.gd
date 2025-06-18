class_name Player extends RigidBody2D


@export var slowdownPower : float = 0.35
@export var minLaunchPower : float = 100
@export var maxLaunchPower : float = 1000
@export var launchChargeDuration : float = 1

@export var killVelocityBeforeLaunch : bool = true
@export var showLog : bool = false

@export var shootParticle : PackedScene
@export var bumpAnythingParticle : PackedScene

@export var playerGun : Node2D



var locked : bool = false

func _getInputDirection() -> Vector2:
	return Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down").normalized()


var _launchClickTime : float

var _isCharging : bool

func _ready() -> void:
	body_entered.connect(onBodyEntered)
	
func onBodyEntered(_body: Node):
	handleBumpParticle()	

func handleLaunch() -> void:

	if locked or Global.gameState == Global.GameStateEnum.GameOver:
		return

	var timeNow = Time.get_unix_time_from_system()
	
	if(Input.is_action_just_pressed("launch")):
		if(Global.currentAmmo > 0):
			_launchClickTime = timeNow
			Global.currentAmmo -= 1
			_isCharging = true
		
	var difference: float = timeNow - _launchClickTime
	
	var percent= clamp(difference / launchChargeDuration, 0, 1)
	var currentPower = lerp(minLaunchPower, maxLaunchPower, percent)		

	if _isCharging:
		Engine.time_scale = slowdownPower
	else:
		Engine.time_scale = 1.0

	if(Input.is_action_just_released("launch")):
		
		if(!_isCharging):
			return
		_isCharging = false
		
		if(showLog):
			print("============== LAUNCHING ==============")
			print("difference ", difference)
			print("percent ", percent)
			print("currentPower ", currentPower)
			print("=======================================")
		#PARTICLE
		var direction: Vector2 = (global_position - get_global_mouse_position()).normalized()
		
		if(killVelocityBeforeLaunch):
			linear_velocity = Vector2.ZERO
		var impulse = direction * currentPower
		
		if(Global.player_direction == Global.PlayerDirection.AwayFromMouse):
			impulse = -impulse
			
		apply_central_impulse(impulse)
		handleShootParticle(direction)
			

func handleBumpParticle():
	if(bumpAnythingParticle == null):
		return
		
	if(showLog):
		print("bumpAnythingParticle particle")
	
	var instance: ParticleTrigger = bumpAnythingParticle.instantiate()
	instance.global_position = global_position
	get_tree().root.add_child(instance)

func handleShootParticle(direction: Vector2):
	if(shootParticle == null):
		return
		
	if(showLog):
		print("shooting particle")
	var instance: ParticleTrigger = shootParticle.instantiate()
	instance.global_position = playerGun.global_position
	
	instance.rotation = direction.angle()
	get_tree().root.add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	handleLaunch()
	pass
