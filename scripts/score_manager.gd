class_name _ScoreManager extends Node

@export_category("Sound")
@export var ScoreSounds : Array[AudioStream] = []

var HighScores: Array[HighScoreResource] = []

signal highscores_changed

var score : int : 
	get: return _score
	set(value):
		if(Global.gameState != Global.GameStateEnum.Gameplay):
			push_warning("Trying to change score while not in gameplay state")
			return
		OneShotSoundManager.play_sound(ScoreSounds.pick_random())
		_score = value

var _score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_score = 0
	Global.game_started.connect(_on_start)
	load_scores()
	pass # Replace with function body.

func load_scores():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var saveDict = save_file.get_var(true)
	print("Loaded", saveDict)
	
	var playerNames = saveDict.playernames
	var playerScores = saveDict.playerscores
	
	# Clear existing high scores
	HighScores.clear()
	for i in range(0, playerNames.size()):
		var newScore = HighScoreResource.new()
		newScore.Score = playerScores[i]
		newScore.Name = playerNames[i]
		HighScores.append(newScore)
	
	highscores_changed.emit()
	
func _on_start():
	_score = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func AddScore(amount : int) -> void:
	score += amount
	print("current score, ", score)
	
func AddHighScore(score: int, name: String):
	var newScore = HighScoreResource.new()
	newScore.Score = score
	newScore.Name = name
	
	HighScores.append(newScore)
	
	# Sort the high scores in descending order
	HighScores.sort_custom(_compare_high_scores)

	for i in range(0, HighScores.size()):
		print("HighScore ", i, ": ", HighScores[i].Name, " - ", HighScores[i].Score)
	
	highscores_changed.emit()
	
	var playerNames : Array[String] = []
	var playerScores : Array[int] = []
	
	for highscore in HighScores:
		playerNames.append(highscore.Name)
		playerScores.append(highscore.Score)
	
	var d : Dictionary = {}
	d.playernames = playerNames
	d.playerscores = playerScores
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.store_var(d, true)	
	
func _compare_high_scores(a: HighScoreResource, b: HighScoreResource) -> int:
	return a.Score > b.Score
	
	
