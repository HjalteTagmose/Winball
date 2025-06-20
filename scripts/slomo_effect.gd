class_name SlomoEffect extends TextureRect
@export var enabled: bool = true
@export var abbarationCurve : Curve
@export var abbarationPowerCurve : Curve

func _ready() -> void:
	Global.player_charge_duration_percent_changed.connect(charge_changed)
	pass # Replace with function body.

func charge_changed(newValue: float):
	if !enabled:
		visible = false
		return
	
	var shaderMat = material as ShaderMaterial
	
	
	var radius = abbarationCurve.sample(newValue)
	var power = abbarationPowerCurve.sample(newValue)
	shaderMat.set_shader_parameter("radius", radius)
	shaderMat.set_shader_parameter("chromatic_intesity", power)
	if newValue > 0:
		visible = true
	else:
		visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var newSize = get_window().size
	size = newSize	
	pass
