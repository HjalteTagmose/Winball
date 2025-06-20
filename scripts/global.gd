extends Node
class_name _GlobalNode

var currentAmmo : int = 5
@export var maxAmmo : int = 10
@export var gameplay_scene: PackedScene
@export var player_direction: PlayerDirection
@export var floating_score : PackedScene

@export var playerWeapon : PlayerWeapon = PlayerWeapon.Flamethrower

@export var game_over_sound : AudioStream

var flamethrower_ammo : int = 0
@export var flamethrower_max_ammo : int = 100

@export_category("Music")
@export var musicPlayer : AudioStreamPlayer
@export var regularMusic : AudioStream
@export var flameThrowerMusic: AudioStream

enum PlayerDirection { TowardsMouse, AwayFromMouse }
enum GameStateEnum {Setup, Gameplay, GameOver }
enum PlayerWeapon {Regular, Flamethrower }

var scene : Node
var gameState: GameStateEnum = GameStateEnum.Setup

#signal for gameover
signal game_over
signal game_started
signal bullet_fired
signal flame_thrower_fired
signal reload

signal player_charge_duration_percent_changed(percent: float)
signal storm_charge_duration_percent_changed(percent: float)
signal weapon_change(weapon: PlayerWeapon)

func _input(event):
	if gameState != GameStateEnum.Setup:
		return
	if event is InputEventKey:
		if event.pressed:
			start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	
		
	
	if(Input.is_action_just_pressed("force_gameover")):
		trigger_game_over()
	
	#if(gameState == GameStateEnum.GameOver && Input.is_action_just_pressed("restart_game")):
		#start_game()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#start_game()
	pass

func start_game() -> void:
	
	if gameState == GameStateEnum.Gameplay:
		return
	
	if !musicPlayer.playing:
		musicPlayer.stream = regularMusic
		musicPlayer.play()
	
	if(scene != null):
		scene.queue_free()
		
	gameState = GameStateEnum.Gameplay
	scene = gameplay_scene.instantiate()
	add_child(scene)
	
	currentAmmo = maxAmmo
	flamethrower_ammo = 0
	playerWeapon = PlayerWeapon.Regular
	reload.emit()
	game_started.emit()
	
func trigger_game_over() -> void:
	if gameState == GameStateEnum.GameOver:
		return
	game_over.emit()
	OneShotSoundManager.play_sound(game_over_sound)
	gameState = GameStateEnum.GameOver
	Engine.time_scale = 1.0
	
func enable_flame_thrower():
	flamethrower_ammo = flamethrower_max_ammo
	weapon_change.emit(PlayerWeapon.Flamethrower)
	playerWeapon = PlayerWeapon.Flamethrower
	#musicPlayer.stop()
	#musicPlayer.stream = flameThrowerMusic
	#musicPlayer.play()
	
func enable_regular_weapon():
	weapon_change.emit(PlayerWeapon.Regular)
	playerWeapon = PlayerWeapon.Regular
	#musicPlayer.stop()
	#musicPlayer.stream = regularMusic
	#musicPlayer.play()

func DisplayFloatingScore(score:int, pos:Vector2):
	if gameState != GameStateEnum.Gameplay:
		return

	var floater : FloatingScore = floating_score.instantiate()
	get_tree().root.add_child(floater)
	floater.SetPos(pos)
	floater.set_number(score)
