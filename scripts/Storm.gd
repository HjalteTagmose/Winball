extends Area2D
class_name Storm

@export var CollisionArea: CollisionShape2D
@export var Graphic: Sprite2D
@export var Line: Sprite2D
@export var CameraRef: Camera2D
@export var TimeToKill: float = 3.0
@export var TimeToCoverScreenSize: float = 4.0
@export var screensToCatch : int = 3

var player: Player	
var currentTIme: float
var screenSize : Vector2
var screenToStormMult : float
var stormSpeed
var lineBaseScale : float

func _ready() -> void:	
	var size = get_window().size
	Graphic.texture.size.x = size.x
	CollisionArea.shape.size.x = size.x
	Line.texture.size.x = size.x

	global_position.y = size.y
	screenSize = size

	screenToStormMult = size.y / Graphic.texture.get_size().y
	stormSpeed = screenToStormMult / TimeToCoverScreenSize
	lineBaseScale = Line.scale.y
	

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
	scale.y += (stormSpeed * delta)
	Line.scale.y = lineBaseScale/scale.y
	
	if CameraRef:
		position.x = CameraRef.global_position.x
	
	print( (scale.y * Graphic.texture.get_size().y + CameraRef.global_position.y ) / screenSize.y, " storm distance") 
	if ( (scale.y * Graphic.texture.get_size().y - CameraRef.global_position.y) ) / screenSize.y < -screensToCatch:
		scale.y += screenToStormMult
		

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
