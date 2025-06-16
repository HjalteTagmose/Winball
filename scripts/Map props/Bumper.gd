extends StaticBody2D
class_name BasicBumper

@export var Power : float = 35
@export var Score : int = 15

func _physics_process(delta):
	var collisions = move_and_collide(Vector2.ZERO, true)
	if collisions && collisions.get_collider() is Player:
		BumpPlayer(collisions, collisions.get_collider())

pass

func BumpPlayer(collisionInfo:KinematicCollision2D, player : Player) -> void:
	var velocity = collisionInfo.get_travel().bounce(collisionInfo.get_normal())
	player.linear_velocity = velocity
	player.apply_impulse(velocity.normalized() * Power)
pass # Replace with function body.
