extends BasicBumper
class_name AmmoBumper

@export var extraVisual: Node

var _HasBeenUsed = false;

func AdditionalBumpBehaviour(collisionInfo:KinematicCollision2D, player : Player) -> void:
	print("Ammo Bumper bumped")
	if(_HasBeenUsed):
		return
	
	Global.currentAmmo = Global.maxAmmo
	_HasBeenUsed = true
	extraVisual.queue_free()
