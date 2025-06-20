class_name GameOverScreen extends CanvasGroup

@export var score_submit_section : Node
@export var restart_button: Node
@export var flyInCurve: Curve
@export var flyInDuration : float = 1.0
@export var colorCurve : Curve
@export var coverColor : Color

var _flyInCounter :float = 0.0

func _ready() -> void:
	reset_display()
	Global.game_over.connect(reset_display)
	visibility_changed.connect(_on_visibility_changed)

func reset_display():
	score_submit_section.visible = true
	restart_button.visible = false
	_flyInCounter = 0
	
func show_restart_button():
	score_submit_section.visible = false
	restart_button.visible = true

func _process(delta: float) -> void:
	_flyInCounter += delta
	var percent = clamp(_flyInCounter / flyInDuration, 0, 1)
	position.y = flyInCurve.sample(percent)
	$"../Cover".color = lerp(Color(0,0,0,0), coverColor, colorCurve.sample(percent))

func _on_visibility_changed():
	$"../Cover".visible = visible
	$"../Cover".color = Color(0,0,0,0)
