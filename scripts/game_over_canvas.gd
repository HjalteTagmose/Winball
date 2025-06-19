class_name GameOverScreen extends CanvasGroup

@export var score_submit_section : Node
@export var restart_button: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_display()
	Global.game_over.connect(reset_display)
	pass # Replace with function body.

func reset_display():
	score_submit_section.visible = true
	restart_button.visible = false
	
func show_restart_button():
	score_submit_section.visible = false
	restart_button.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
