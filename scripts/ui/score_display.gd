class_name ScoreDisplay extends RichTextLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = "Score: " + str(Global.score)
	pass
