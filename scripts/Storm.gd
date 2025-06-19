extends Area2D
class_name Storm

@export var CollisionArea: CollisionShape2D
@export var Graphic: Sprite2D
@export var Line: Sprite2D
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
	Line.texture.size.x = size.x
	Line.position.y = -Graphic.texture.size.y/2
	Line.position.x = CameraRef.global_position.x
	

func _process(delta: float) -> void:
	if Global.gameState != Global.GameStateEnum.Gameplay:
		return
	
	if player:
		currentTIme += delta
		var percent = clamp(currentTIme / TimeToKill, 0, 1)
		Global.storm_charge_duration_percent_changed.emit(percent * 100)
		if currentTIme >= TimeToKill:
			Global.trigger_game_over()
			currentTIme = 0.0
			Global.storm_charge_duration_percent_changed.emit(-1)
			pass

	else:
		currentTIme = 0.0
		Global.storm_charge_duration_percent_changed.emit(-1)

func _physics_process(delta: float) -> void:
	move_local_y(-Speed * delta)
	
	if !CameraRef:
		return
		
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
