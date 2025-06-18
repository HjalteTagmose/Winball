extends CanvasLayer

@export var gameplay_canvas: CanvasGroup
@export var game_over_canvas: CanvasGroup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameplay_canvas.visible = true
	Global.game_over.connect(_on_gameover)
	Global.game_started.connect(_on_game_start)
	pass # Replace with function body.


func _on_gameover() -> void:
	gameplay_canvas.visible = false
	game_over_canvas.visible = true
	
func _on_game_start() -> void:
	gameplay_canvas.visible = true
	game_over_canvas.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	pass
