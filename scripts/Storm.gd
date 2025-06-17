extends Area2D
class_name Storm

@export var CollisionArea: CollisionShape2D
@export var Graphic: Sprite2D
@export var CameraRef: Camera2D
@export var TimeToKill: float = 3.0
@export var Speed: float = 4.0

var player: Player
var currentTIme: float


func _ready() -> void:
	var size = get_window().size
	size.y *= 4

	Graphic.texture.size = size
	CollisionArea.shape.size = size
	position.x = CameraRef.global_position.x
	position.y = size.y/1.5

func _process(delta: float) -> void:
	if player:
		currentTIme += delta

		if currentTIme >= TimeToKill:
			print("player DEAAAAD");

	else:
		currentTIme = 0.0


func _physics_process(delta: float) -> void:
	move_local_y(-Speed * delta)
	position.x = CameraRef.global_position.x
	pass

func _on_body_enter(body: Node2D):
	if body is Player:
		player = body
	
	if body is BasicBumper:
		body.isInStrom = true

func _on_body_exit(body: Node2D):
	if body is Player:
		player = null
	
	if body is BasicBumper:
		body.isInStrom = false
