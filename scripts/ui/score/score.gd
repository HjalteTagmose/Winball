extends Node2D

@export var digit_spacing = 50
@export var digit_prefab : PackedScene

var digits : Array[ScoreDigit]
var cur_number = -1

func _process(delta: float) -> void:
	if Global.score == cur_number:
		return
	set_number(Global.score)

func set_number(number : int) -> void:
	cur_number = number
	var str = str(number)
	var start = 0
		
	for digit in digits:
		digit.hide()
	
	while digits.size() < str.length():
		spawn_digit()
	
	for i in range(0, str.length()):
		var digit = digits[i]
		var value = int(str[i])
		digit.show()
		digit.set_digit(value)
		digit.position.x = i * digit_spacing
	
func spawn_digit() -> void:
	var digit : ScoreDigit = digit_prefab.instantiate()
	add_child(digit)
	digits.append(digit)
