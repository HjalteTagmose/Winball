class_name RoomExit extends Area2D

signal exit_triggered(exit: RoomExit)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(onBodyEnter)
	pass # Replace with function body.

func onBodyEnter(body: Node2D):
	if(body is not Player):
		return
	
	exit_triggered.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
