extends Node2D
class_name ScoreLight

@export var collider : Area2D
@export var sprite : Sprite2D

@export var offColor : Color
@export var onColor : Color

var scoreLightRoot: ScoreLightRoot

var _isOn = false;
var isOn : bool : 
	get: return _isOn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collider.body_entered.connect(onEnter)
	sprite.self_modulate = offColor
	pass # Replace with function body.

func onEnter(_body: Node2D):
	print("OnEnter")
	turnOn()

func turnOn():
	_isOn = true;
	sprite.self_modulate = onColor
	
func turnOff():
	_isOn = false;
	sprite.self_modulate = offColor
