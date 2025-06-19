extends Node
class_name _GlobalNode

var currentAmmo : int = 10
@export var maxAmmo : int = 10
@export var gameplay_scene: PackedScene
@export var player_direction: PlayerDirection
@export var floating_score : PackedScene

@export var playerWeapon : PlayerWeapon = PlayerWeapon.Flamethrower

var flamethrower_ammo : int = 100
@export var flamethrower_max_ammo : int = 100

enum PlayerDirection { TowardsMouse, AwayFromMouse }
enum GameStateEnum {Setup, Gameplay, GameOver }
enum PlayerWeapon {Regular, Flamethrower }

var scene : Node
var gameState: GameStateEnum = GameStateEnum.Setup

#signal for gameover
signal game_over
signal game_started
signal bullet_fired
signal reload

signal player_charge_duration_percent_changed(percent: float)
signal storm_charge_duration_percent_changed(percent: float)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if(Input.is_action_just_pressed("force_gameover")):
		trigger_game_over()
	
	if(gameState == GameStateEnum.GameOver && Input.is_action_just_pressed("restart_game")):
		start_game()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game()

func start_game() -> void:
	
	if gameState == GameStateEnum.Gameplay:
		return
		
	if(scene != null):
		scene.queue_free()
		
	gameState = GameStateEnum.Gameplay
	scene = gameplay_scene.instantiate()
	add_child(scene)
	
	currentAmmo = maxAmmo
	
	game_started.emit()
	
func trigger_game_over() -> void:
	if gameState == GameStateEnum.GameOver:
		return
	game_over.emit()
	gameState = GameStateEnum.GameOver
	Engine.time_scale = 1.0



func DisplayFloatingScore(score:int, pos:Vector2):
	if gameState != GameStateEnum.Gameplay:
		return

	var floater : FloatingScore = floating_score.instantiate()
	get_tree().root.add_child(floater)
	floater.SetPos(pos)
	floater.set_number(score)
