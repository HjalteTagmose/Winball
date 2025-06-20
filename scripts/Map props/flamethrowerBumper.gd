@tool
class_name FlameThrowerBumper extends BasicBumper

@export var extraVisual: Sprite2D
@export var Enabled: bool:
	get: return enabled
	set(value):
		if extraVisual:
			extraVisual.visible = value
		enabled = value
	
@export_category("No touchy")
@export var enabled : bool

var _HasBeenUsed = false;

func AdditionalBumpBehaviour(_collisionInfo:KinematicCollision2D, _player : Player) -> void:
	#print("Ammo Bumper bumped")
	if(_HasBeenUsed || !Enabled):
		return
	
	Global.enable_flame_thrower()
	_HasBeenUsed = true
	extraVisual.queue_free()
