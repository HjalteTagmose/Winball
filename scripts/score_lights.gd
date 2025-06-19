extends Node2D
class_name ScoreLightRoot

@export var score: int = 100
@export var lights: Array[ScoreLight] = []
@export var OneShot : bool

var completed : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for light in lights:
		light.scoreLightRoot = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if completed && OneShot:
		return
		
	for light in lights:
		if(!light.isOn):
			return
	
	ScoreManager.score += score
	Global.DisplayFloatingScore(score, global_position)
	completed = true

	if !OneShot:
		for light in lights:
			light.turnOff()	
