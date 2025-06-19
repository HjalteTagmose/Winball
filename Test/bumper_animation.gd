extends Sprite2D

@export var scale_curve : Curve
var scale_normal : Vector2
var animation_t : float = 0

func _ready() -> void:
	var bumper : BasicBumper = u.find_parent_with_type(self, BasicBumper)
	if bumper == null:
		set_process(false)
		return
	bumper.bumped.connect(_on_bumped)
	scale_normal = scale

func _process(delta: float) -> void:
	animation_t += delta
	hit_animation()
	
func _on_bumped() -> void:
	animation_t = 0

func hit_animation() -> void:
	scale = scale_normal * scale_curve.sample(animation_t)
