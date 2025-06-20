extends Camera2D


@export var player: Player
@export var camera_speed : float = 5.0

@export var slomoZoomCurve: Curve

var cur_camera_speed = 5.0
var override_target_pos : Vector2


func _ready():
	cur_camera_speed = camera_speed
	Global.player_charge_duration_percent_changed.connect(charge_changed)
	
	#await get_tree().create_timer(0.1).timeout
	#var bumpers = get_tree().get_nodes_in_group("bumper")
	#for bumper in bumpers:
		#bumper.bumped_impulse.connect(_on_bumped)

func _process(delta: float) -> void:
	var target_pos : Vector2 = player.global_position
	
	if Global.playerWeapon == Global.PlayerWeapon.Flamethrower:
		global_position = target_pos
		return
	
	if override_target_pos:
		target_pos = override_target_pos
		if override_target_pos.distance_to(global_position) < 100:
			override_target_pos = Vector2.ZERO
	
	global_position = lerp(global_position, target_pos, delta * cur_camera_speed)

#func _on_bumped(impulse :  Vector2) -> void:
	#override_target(player.global_position)# - impulse.normalized() * 200)
	#print("bump impulse: ", impulse)
	
func override_target(override_pos : Vector2) -> void:
	override_target_pos = override_pos
	
func charge_changed(newValue: float):
	
	if newValue <= 0:
		cur_camera_speed = camera_speed
		zoom = Vector2.ONE
		return
	elif zoom == Vector2.ONE:
		cur_camera_speed = camera_speed * 3
		
	var value = slomoZoomCurve.sample(newValue)
	zoom = Vector2(value, value)


#func _draw() -> void:
	#draw_circle(Vector2.ZERO, 5, Color(Color.WHITE, 0.4))
	#draw_circle(override_target_pos - global_position, 10, Color(Color.RED, 0.8))
