class_name HighScoreRow extends HBoxContainer

@export var name_text : RichTextLabel
@export var score_text : RichTextLabel

func set_score(highscore: ScoreManager.HighScoreValue):
	name_text.text = highscore.Name
	score_text.text = str(highscore.Score)
