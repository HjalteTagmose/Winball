extends Score
class_name FloatingScore

@export var Lifetime : float


func _ready() -> void:
	is_centered = true

func _process(_delta: float) -> void:
	return

func SetPos(pos:Vector2) -> void:
	global_position = pos
	scale = Vector2.ZERO
	# rotation = frange(-0.2, 0.2).pick_random()
	rotation = randf_range(-.3, .3)

func set_number(number : int) -> void:
	super(number)

	Animate()

func Animate() -> void:
	var tween : Tween = get_tree().create_tween().set_ignore_time_scale(true)
	tween.tween_property(self, "scale", Vector2.ONE, Lifetime).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "scale", Vector2.ZERO, Lifetime).set_delay(Lifetime/2).set_trans(Tween.TRANS_CUBIC)

	tween.tween_callback(self.queue_free).set_delay(Lifetime*1.5)
