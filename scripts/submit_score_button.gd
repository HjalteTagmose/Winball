class_name SubmitScoreButton extends TextureButton

@export var player_name : LineEdit
@export var gameover_screen : GameOverScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_button_pressed)
	pass # Replace with function body.

func _button_pressed():
	ScoreManager.AddHighScore(ScoreManager.score, player_name.text)
	gameover_screen.show_restart_button()
