class_name Player extends RigidBody2D


@export_category("Launch")
@export var minLaunchPower : float = 100
@export var maxLaunchPower : float = 1000
@export var launchChargeDuration : float = 1
@export var killVelocityBeforeLaunch : bool = true

@export_category("FlameThrower")
@export var flame_thrower_power : float = 100
@export var flame_thrower_delay : float = 0.1

@export_category("Slowdown")
@export var slowdownPower : float = 0.35
@export var max_slowdown_duration: float = 5.0
@export var SlowdownEndBehaviour: SlowdownEndBehaviourEnum = SlowdownEndBehaviourEnum.AmmoWasted

enum SlowdownEndBehaviourEnum { AmmoWasted, Launch }

@export_category("Setup")
@export var showLog : bool = false

@export var shootParticle : PackedScene
@export var bumpAnythingParticle : PackedScene
@export var stormParticle : GPUParticles2D
@export var playerGun : Node2D

var InStorm: bool:
	set(value):
		stormParticle.emitting = value

var flame_thrower_counter = 0;
var locked : bool = false
var _slowdownCounter = 0.0

func _getInputDirection() -> Vector2:
	return Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down").normalized()


var _launchClickTime : float

var _isCharging : bool

func _ready() -> void:
	body_entered.connect(onBodyEntered)
	
func onBodyEntered(_body: Node):
	handleBumpParticle()	

func handleLaunch(delta: float) -> void:

	if locked or Global.gameState == Global.GameStateEnum.GameOver:
		return

	var timeNow = Time.get_unix_time_from_system()
	
	if(Input.is_action_just_pressed("launch")):
		if(Global.currentAmmo > 0):
			_launchClickTime = timeNow
			_isCharging = true
			_slowdownCounter = 0

	if _isCharging:
		Engine.time_scale = slowdownPower
		_slowdownCounter += u.to_unscaled_delta_time(delta)
		var slow_percent = clamp(_slowdownCounter / max_slowdown_duration, 0, 1)
		Global.player_charge_duration_percent_changed.emit(slow_percent * 100)
		
		if(_slowdownCounter > max_slowdown_duration):
			if SlowdownEndBehaviour == SlowdownEndBehaviourEnum.AmmoWasted:
				_isCharging = false
				Global.currentAmmo -= 1
				Global.bullet_fired.emit()
			if SlowdownEndBehaviour == SlowdownEndBehaviourEnum.Launch:
				launch()
			Engine.time_scale = 1.0
			Global.player_charge_duration_percent_changed.emit(-1)
			return
		
	else:
		Engine.time_scale = 1.0

	if(Input.is_action_just_released("launch")):
		launch()
		
			
func launch():
	if(!_isCharging):
		return
		
	var timeNow = Time.get_unix_time_from_system()
	var difference: float = timeNow - _launchClickTime
	var percent= clamp(difference / launchChargeDuration, 0, 1)
	var currentPower = lerp(minLaunchPower, maxLaunchPower, percent)
	
	_isCharging = false
	Global.currentAmmo -= 1
	Global.bullet_fired.emit()
	#PARTICLE
	
	
	
	if(killVelocityBeforeLaunch):
		linear_velocity = Vector2.ZERO
	
	var direction = get_direction()
	var impulse = direction * currentPower
		
	apply_central_impulse(impulse)
	handleShootParticle(direction)
	Global.player_charge_duration_percent_changed.emit(-1)

func get_direction() -> Vector2:
	var direction: Vector2 = (global_position - get_global_mouse_position()).normalized()
	if(Global.player_direction == Global.PlayerDirection.AwayFromMouse):
		direction = -direction
	return direction

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

func handleFlameThrower(delta: float) -> void:
	if !Input.is_action_pressed("launch"):
		return
	
	if flame_thrower_counter < flame_thrower_delay:
		return
	
	flame_thrower_counter = 0
	var direction = get_direction()
	var impulse = direction * flame_thrower_power
	apply_central_impulse(impulse)
	handleShootParticle(direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flame_thrower_counter += delta
	if(Global.playerWeapon == Global.PlayerWeapon.Flamethrower):
		
		handleFlameThrower(delta)
	if(Global.playerWeapon == Global.PlayerWeapon.Regular):
		handleLaunch(delta)
	pass
