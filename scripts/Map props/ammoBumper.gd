class_name AmmoBumper extends BasicBumper

@export var extraVisual: Node

var _HasBeenUsed = false;

func AdditionalBumpBehaviour(_collisionInfo:KinematicCollision2D, _player : Player) -> void:
	print("Ammo Bumper bumped")
	if(_HasBeenUsed):
		return
	
	Global.currentAmmo = Global.maxAmmo
	Global.reload.emit()
	_HasBeenUsed = true
	extraVisual.queue_free()
