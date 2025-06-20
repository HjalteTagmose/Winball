class_name BulletDisplay extends Sprite2D

@export var animationSheet : Texture2D
@export var animationFPS : int
@export var animationTime : float

var fps

func fire():
	Animate()

func Animate():
	texture = animationSheet
	hframes = 8

	var frames : Tween = get_tree().create_tween().set_loops(8)
	frames.tween_callback(MoveAnimation).set_delay(0.1)

	var position : Tween = get_tree().create_tween()
	position.tween_property(self, "position", self.position + Vector2(2, -1) * 80, animationTime).set_trans(Tween.TRANS_QUAD)
	position.tween_callback(queue_free).set_delay(animationTime)

var currentframe := -1

func MoveAnimation():
	currentframe += 1
	frame = currentframe
	frame_coords.x = currentframe
