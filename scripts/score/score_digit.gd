extends Sprite2D
class_name ScoreDigit

@export var digit_sprites : Array[Texture]

func set_digit(digit : int) -> void:
	texture = digit_sprites[digit]
