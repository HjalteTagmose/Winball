extends Node2D
class_name ScoreLight

@export var collider : Area2D
@export var spriteOn : Sprite2D
@export var spriteOff : Sprite2D

var scoreLightRoot: ScoreLightRoot
var completionTime: float = 0

var _isOn = false;
var isOn : bool : 
	get: return _isOn

func _ready() -> void:
	collider.body_entered.connect(onEnter)
	turnOff()

func onEnter(_body: Node2D):
	print("OnEnter")
	turnOn()

func turnOn():
	_isOn = true;
	spriteOff.hide()
	spriteOn.show()
	completionTime = Time.get_unix_time_from_system()
	
func turnOff():
	_isOn = false;
	spriteOff.show()
	spriteOn.hide()
