class_name Player extends RigidBody2D


@export_category("Launch")
@export var minLaunchPower : float = 100
@export var maxLaunchPower : float = 1000
@export var launchChargeDuration : float = 1
@export var killVelocityBeforeLaunch : bool = true
@export var pityBulletDelay : float = 3

@export_category("FlameThrower")
@export var flame_thrower_power : float = 100
@export var flame_thrower_delay : float = 0.1
@export var flame_thrower_particles : PackedScene
@export var flame_thrower_max_linear_velocity : float = 500

@export_category("Slowdown")
@export var slowdownPower : Curve
@export var max_slowdown_duration: float = 5.0
@export var SlowdownEndBehaviour: SlowdownEndBehaviourEnum = SlowdownEndBehaviourEnum.AmmoWasted

enum SlowdownEndBehaviourEnum { AmmoWasted, Launch }

@export_category("Sound")
@export var RegularShotSounds : Array[AudioStream] = []
@export var FlameThrowerSounds : Array[AudioStream] = []

@export_category("Setup")
@export var showLog : bool = false

@export var shootParticle : PackedScene
@export var bumpAnythingParticle : PackedScene
@export var stormParticle : GPUParticles2D
@export var playerGun : Node2D
@export var slowmoSprite: Node2D
@export var flameSprite: Node2D


var _pityBulletCounter = 0

var InStorm: bool:
	set(value):
		stormParticle.emitting = value

var flame_thrower_counter = 0;
var currentlyPlayerParticle : ParticleTrigger
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
		Engine.time_scale = 1.0 #little hacky
		_isCharging = false
		slowmoSprite.visible = false
		Global.player_charge_duration_percent_changed.emit(0)
		return

	if Global.currentAmmo == 0:
		_pityBulletCounter += delta
		if _pityBulletCounter > pityBulletDelay:
			Global.currentAmmo += 1
			Global.reload.emit()
	else:
		_pityBulletCounter = 0
		
	if currentlyPlayerParticle:
		currentlyPlayerParticle.StopEmitting()
		currentlyPlayerParticle = null

	var timeNow = Time.get_unix_time_from_system()
	
	if(Input.is_action_just_pressed("launch")):
		if(Global.currentAmmo > 0):
			_launchClickTime = timeNow
			_isCharging = true
			_slowdownCounter = 0
			slowmoSprite.visible = true
			slowmoSprite.global_rotation = 0
			
			rotate_gun()

	if _isCharging:
		_slowdownCounter += u.to_unscaled_delta_time(delta)
		var slow_percent = clamp(_slowdownCounter / max_slowdown_duration, 0, 1)
		Engine.time_scale = slowdownPower.sample(slow_percent * 100)
		Global.player_charge_duration_percent_changed.emit(slow_percent * 100)
		
		# Rotate slowmoSprite to look at direction
		rotate_gun()
		
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
		
	rotate_gun()

func rotate_gun():
	var direction = get_direction()
	slowmoSprite.global_position = global_position
	slowmoSprite.global_rotation = direction.angle()
	flameSprite.global_position = global_position
	flameSprite.global_rotation = direction.angle()
	

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
	
	slowmoSprite.visible = false
	OneShotSoundManager.play_sound(RegularShotSounds.pick_random())

	

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
	if Global.gameState == Global.GameStateEnum.GameOver:
		return
		
	Engine.time_scale = 1.0
	if !Input.is_action_pressed("launch") || locked:
		TurnOffFlame()
		return
	
	flameSprite.visible = true
	flameSprite.global_rotation = 0
	
	rotate_gun()
	
	if flame_thrower_counter < flame_thrower_delay:
		return
	var direction = get_direction()
	
	var dot = linear_velocity.normalized().dot(direction)
	dot = -dot # Reverse dot product, so a vector going against me will be positive
	dot /= 2 # go from -1 to 1, to -0.5 to 0.5 
	dot += 1.5 # go from -0.5 to 0.5, to 1 to 2
	
	if(linear_velocity.length() > flame_thrower_max_linear_velocity):
		linear_velocity = linear_velocity.normalized() * flame_thrower_max_linear_velocity
		
	flame_thrower_counter = 0
	var impulse = direction * flame_thrower_power * dot
	apply_central_impulse(impulse)
	handleFlameParticle(direction)
	OneShotSoundManager.play_sound(FlameThrowerSounds.pick_random())
	Global.flamethrower_ammo -= 1
	
	Global.flame_thrower_fired.emit()
	
	if Global.flamethrower_ammo <= 0:
		Global.enable_regular_weapon()
		TurnOffFlame()

func handleFlameParticle(direction: Vector2):
	if currentlyPlayerParticle == null:
		currentlyPlayerParticle = flame_thrower_particles.instantiate()
		get_tree().root.add_child(currentlyPlayerParticle)
	
	currentlyPlayerParticle.global_position = playerGun.global_position
	currentlyPlayerParticle.rotation = direction.angle()

func TurnOffFlame():
	if currentlyPlayerParticle:
		currentlyPlayerParticle.StopEmitting()
		currentlyPlayerParticle = null

	flameSprite.visible = false
	flameSprite.global_rotation = 0
	shootFlame = false

var shootFlame : bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flame_thrower_counter += delta

	if(Global.playerWeapon == Global.PlayerWeapon.Flamethrower && Input.is_action_just_pressed("launch") && !locked):
		shootFlame = true

	if shootFlame:
		handleFlameThrower(delta)

	if(Global.playerWeapon == Global.PlayerWeapon.Regular):
		handleLaunch(delta)
	pass
