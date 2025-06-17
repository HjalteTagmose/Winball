extends Sprite2D

@export var distanceToPlayer : float = 50
@export var playerRef : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var dir = (get_global_mouse_position() - playerRef.global_position).normalized()
	var distance = dir * distanceToPlayer
	
	global_position = playerRef.global_position + distance;	
	
	pass
