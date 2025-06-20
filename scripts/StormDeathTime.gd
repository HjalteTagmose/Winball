extends HSlider

@export var flyInCurve: Curve
@export var flyInDuration : float = 1.0
var _flyInCounter :float = 0.0

func _ready() -> void:
	Global.storm_charge_duration_percent_changed.connect(charge_changed)
	visibility_changed.connect(_on_visibility_changed)

func charge_changed(newValue: float):
	value = newValue
	if value > 0:
		show()
	else:
		hide()

func _process(delta: float) -> void:
	_flyInCounter += delta
	var percent = clamp(_flyInCounter / flyInDuration, 0, 1)
	position.y = flyInCurve.sample(percent)
	
func _on_visibility_changed():
	_flyInCounter = 0
