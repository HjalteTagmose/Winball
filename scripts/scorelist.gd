class_name HighScoreDisplay extends VBoxContainer

@export var rowsToDisplay: int = 10
@export var highScoreRow : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rebuild_highscore_list()
	ScoreManager.highscores_changed.connect(rebuild_highscore_list)
	pass # Replace with function body.

func rebuild_highscore_list():
	# remove all children
	for child in get_children():
		child.queue_free()
	
	var maxRows = min(rowsToDisplay, ScoreManager.HighScores.size())
	for i in range(0, maxRows):
		var scoreValue = ScoreManager.HighScores[i]
		var row: HighScoreRow = highScoreRow.instantiate()
		row.name = "HighScoreRow_" + str(i)
		row.set_score(scoreValue)
		add_child(row)
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
