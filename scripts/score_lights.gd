extends Node2D
class_name ScoreLightRoot

@export var score: int = 100
@export var lights: Array[ScoreLight] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for light in lights:
		light.ScoreLightRoot = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for light in lights:
		if(!light.isOn):
			return
	
	Global.score += score
	
	for light in lights:
		light.turnOff()	
