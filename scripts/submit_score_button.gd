extends Button

@export var player_name : TextEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_button_pressed)
	pass # Replace with function body.

func _button_pressed():
	ScoreManager.AddHighScore(ScoreManager.score, player_name.text)
