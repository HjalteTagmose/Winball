extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_charge_duration_percent_changed.connect(charge_changed)
	pass # Replace with function body.

func charge_changed(newValue: float):
	value = newValue
	if value > 0:
		visible = true
	else:
		visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
