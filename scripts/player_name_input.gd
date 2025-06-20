extends LineEdit

@export var scoreButton: SubmitScoreButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grab_focus()
	set_caret_column(text.length())
	Global.game_over.connect(grab_focus)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#grab_focus()
	pass


func _on_text_submitted(new_text: String) -> void:
	scoreButton.on_button_pressed()
	pass # Replace with function body.
