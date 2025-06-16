extends Sprite2D

@export var scale_curve : Curve
@export var texture_speed_curve : Curve
@export var texture_scale_curve : Curve
@export var texture_rotate_curve : Curve
var scale_normal : Vector2
var animation_t : float = 0

func _ready() -> void:
	scale_normal = scale

func _process(delta: float) -> void:
	animation_t += delta
	hit_animation()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		animation_t = 0

func hit_animation() -> void:
	scale = scale_normal * scale_curve.sample(animation_t)
	material.set("shader_parameter/speed", texture_speed_curve.sample(animation_t))
	material.set("shader_parameter/scale", texture_scale_curve.sample(animation_t))
	material.set("shader_parameter/rotation", texture_rotate_curve.sample(animation_t))
	
