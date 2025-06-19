extends Node2D
class_name Score

@export var digit_spacing : int = 50
@export var digit_prefab : PackedScene
@export var is_centered : bool = false 

var digits : Array[ScoreDigit]
var cur_number = -1

func _process(_delta: float) -> void:
	if Global.score == cur_number:
		return
	set_number(Global.score)

func set_number(number : int) -> void:
	cur_number = number
	var str = str(number)
	var len = str.length()
	
	for digit in digits:
		digit.hide()
	
	while digits.size() < str.length():
		spawn_digit()
	
	for i in range(0, len):
		var digit = digits[i]
		var value = int(str[i])
		digit.show()
		digit.set_digit(value)
		digit.position.x = i * digit_spacing
		if is_centered:
			digit.position.x -= digit_spacing * len / 2.0
	
func spawn_digit() -> void:
	var digit : ScoreDigit = digit_prefab.instantiate()
	add_child(digit)
	digits.append(digit)
