extends Node
class_name _GlobalNode

var score : int = 0
@export var maxAmmo : int = 10
var currentAmmo : int = 10
@export var gameplay_scene: PackedScene

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
	game_started.emit()
	
func trigger_game_over() -> void:
	game_over.emit()
	gameState = GameStateEnum.GameOver
func AddScore(amount : int) -> void:
	score += amount
	print("current score, ", score)

