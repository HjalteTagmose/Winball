extends Score
class_name FloatingScore

@export var Lifetime : float

func _ready() -> void:
	is_centered = true

func _process(_delta: float) -> void:
	return

func SetPos(pos:Vector2) -> void:
	global_position = pos

func set_number(number : int) -> void:
	super(number)

	Animate()

func Animate() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(global_position.x, global_position.y*1.1), Lifetime)
	tween.tween_callback(self.queue_free).set_delay(Lifetime)
