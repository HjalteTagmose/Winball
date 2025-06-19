extends Camera2D


@export var player: Player
@export var camera_speed : float = 5.0
var override_target_pos : Vector2

func _process(delta: float) -> void:
	var target_pos : Vector2 = player.global_position
	if override_target_pos:
		target_pos = override_target_pos
	
	global_position = lerp(global_position, target_pos, delta * camera_speed)

func override_target(override_pos : Vector2) -> void:
	override_target_pos = override_pos
