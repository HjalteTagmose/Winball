extends Node
class_name _GlobalNode

var score : int = 0

@export var maxAmmo : int = 10
var currentAmmo : int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentAmmo = maxAmmo
	pass # Replace with function body.

func AddScore(amount : int) -> void:
	score += amount
	print("current score, ", score)