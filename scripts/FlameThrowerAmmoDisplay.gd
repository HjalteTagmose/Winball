extends VSlider

@export var flameDisplay : Node
@export var regularDisplay : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func ammo_changed():
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flameDisplay.visible = Global.flamethrower_ammo > 0
	regularDisplay.visible = Global.flamethrower_ammo <= 0
	var percent : float = float(Global.flamethrower_ammo) / float(Global.flamethrower_max_ammo)	
	value = percent * 100
