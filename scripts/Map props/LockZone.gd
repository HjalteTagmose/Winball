extends Area2D
class_name LockZone

@export var Score : int
@export var Power : float
@export var PlayerBindPivot : Node2D

var boundPlayer : Player

func _process(_delta: float) -> void:
    if(Input.is_action_just_pressed("launch")):
        Launch()

func _on_body_enter(body:Node2D):
    if body is Player:
        boundPlayer = body
        CenterPlayer()
        LockPlayer()
        Global.AddScore(Score)

func _on_body_exit(_body:Node2D):

    pass

func Launch() -> void:
    if !boundPlayer:
        return

    UnlockPlayer()
    var direction = (get_global_mouse_position() - global_position).normalized()
    boundPlayer.linear_velocity = (direction * Power)
    boundPlayer = null


func LockPlayer() -> void:
    boundPlayer.set_deferred("freeze", true)
    boundPlayer.linear_velocity = Vector2.ZERO
    boundPlayer.locked = true

func UnlockPlayer() -> void:
    boundPlayer.locked = false
    boundPlayer.set_deferred("freeze", false)

func CenterPlayer() -> void:
    boundPlayer.global_position = PlayerBindPivot.global_position