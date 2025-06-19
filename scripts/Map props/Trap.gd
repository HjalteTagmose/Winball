extends BasicSticker
class_name TrapSticker

@export var BumperToSpawn_Bottom : PackedScene
@export var BumperToSpawn : PackedScene
@export var Radius : float
@export var Animate : bool
@export var AnimTime : float = 1.2

var savedVelocity : Vector2
var spawnedBumpers : Array
var positionsOnArrays : Array
var boundPlayer

func Interact(player : Player):
	OneTimeUse = false

	FreezePlayer(player)
	SpawnBumpers()
	AnimateSpawn(Animate)

func FreezePlayer(player : Player):
	savedVelocity = player.linear_velocity
	player.linear_velocity = Vector2.ZERO
	player.set_deferred("freeze", true)
	player.locked = true

	boundPlayer = player

# point = new Vector2(point.x + radius * Mathf.Cos(angle), point.y + radius * Mathf.Sin(angle));
func SpawnBumpers():
	var firstBumper : BasicBumper = BumperToSpawn.instantiate()

	var wheelLength : float = 2 * PI * Radius
	var bumperCircle : CircleShape2D = firstBumper.CollisionShape.shape
	var bumper2xRadius : float = bumperCircle.radius * 2 * firstBumper.scale.x
	var bumperCount : int = wheelLength / bumper2xRadius
	var angleStep : int = 360 / bumperCount

	print(" bumper 2 radius " , bumper2xRadius, " wheel ", wheelLength)
	for i in range(0, bumperCount):
		var bumper : BasicBumper

		if i == 0:
			bumper = firstBumper
		else:
			bumper = BumperToSpawn.instantiate()

		# print("angle ", i * angleStep, " step " , angleStep)
		# print("pos ", global_position + Vector2(Radius * cos(i * angleStep) , Radius * sin(i * angleStep)))
		positionsOnArrays.append(global_position + Vector2(Radius * cos(deg_to_rad(i * angleStep) ) , Radius * sin(deg_to_rad(i * angleStep) )))
		spawnedBumpers.append(bumper)

		self.get_parent().call_deferred("add_child", bumper)
		bumper.position = position


func AnimateSpawn(animatePos : bool) -> void:
	for i in spawnedBumpers.size():
		var bumper = spawnedBumpers.get(i)
		var pos = positionsOnArrays.get(i)
		var tween = get_tree().create_tween()
		var time : float
		
		if animatePos:
			time = AnimTime
		else:
			time = 0.0

		tween.tween_property(bumper, "global_position", pos, time)
	
	if Animate:
		print("tween callback")

		var tween = get_tree().create_tween()
		tween.tween_callback(UnfreezePlayer).set_delay(AnimTime)
	else:
		UnfreezePlayer()
		Despawn()

func UnfreezePlayer() -> void:
	print("unlock")
	boundPlayer.linear_velocity = savedVelocity
	boundPlayer.set_deferred("freeze", false)
	boundPlayer.locked = false
	savedVelocity = Vector2.ZERO
	boundPlayer = null
	Despawn()

func Despawn() -> void:
	queue_free()
