extends TextEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grab_focus()
	set_caret_column(text.length())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
