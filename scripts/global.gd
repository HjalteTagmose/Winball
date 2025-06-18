extends Node
class_name _GlobalNode

var score : int : 
	get: return _score
	set(value):
		if(gameState != GameStateEnum.Gameplay):
			push_warning("Trying to change score while not in gameplay state")
			return
		_score = value

var _score : int = 0

@export var maxAmmo : int = 10
var currentAmmo : int = 10
@export var gameplay_scene: PackedScene
@export var player_direction: PlayerDirection

enum PlayerDirection { TowardsMouse, AwayFromMouse }
enum GameStateEnum {Setup, Gameplay, GameOver }

var scene : Node
var gameState: GameStateEnum = GameStateEnum.Setup

#signal for gameover
signal game_over
signal game_started

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(Input.is_action_just_pressed("force_gameover")):
		trigger_game_over()
	
	if(gameState == GameStateEnum.GameOver && Input.is_action_just_pressed("restart_game")):
		start_game()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game()

func start_game() -> void:
	if(scene != null):
		scene.queue_free()
		
	gameState = GameStateEnum.Gameplay
	scene = gameplay_scene.instantiate()
	add_child(scene)
	
	currentAmmo = maxAmmo
	score = 0
	
	game_started.emit()
	
func trigger_game_over() -> void:
	game_over.emit()
	gameState = GameStateEnum.GameOver
	Engine.time_scale = 1.0

func AddScore(amount : int) -> void:
	score += amount
	print("current score, ", score)
