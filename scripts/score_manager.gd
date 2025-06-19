class_name _ScoreManager extends Node

class HighScoreValue:
	var Name: String
	var Score: int

signal highscores_changed

var HighScores: Array[HighScoreValue] = []

var score : int : 
	get: return _score
	set(value):
		if(Global.gameState != Global.GameStateEnum.Gameplay):
			push_warning("Trying to change score while not in gameplay state")
			return
		_score = value

var _score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_score = 0
	Global.game_started.connect(_on_start)
	pass # Replace with function body.

func _on_start():
	_score = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func AddScore(amount : int) -> void:
	score += amount
	print("current score, ", score)
	
func AddHighScore(score: int, name: String):
	var newScore = HighScoreValue.new()
	newScore.Score = score
	newScore.Name = name
	
	HighScores.append(newScore)

	print("================================================")
	print("================================================")
	
	for i in range(0, HighScores.size()):
		print("HighScore ", i, ": ", HighScores[i].Name, " - ", HighScores[i].Score)
	
	# Sort the high scores in descending order
	HighScores.sort_custom(_compare_high_scores)

	print("================================================")
	for i in range(0, HighScores.size()):
		print("HighScore ", i, ": ", HighScores[i].Name, " - ", HighScores[i].Score)
	print("================================================")
	print("================================================")
	
	print(HighScores)
	highscores_changed.emit()
	
func _compare_high_scores(a: HighScoreValue, b: HighScoreValue) -> int:
	return a.Score > b.Score
