extends Sprite2D

@export var bulletPrefab: PackedScene

var _bullets : Array[BulletDisplay] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node: Node in get_children():
		if node is BulletDisplay:
			_bullets.append(node)
	if(Global != null):
		Global.bullet_fired.connect(on_bullet_fired)
		Global.reload.connect(reload)
		reload()

func on_bullet_fired():
	if(_bullets.size() <= 0 ):
		return
	
	var firstBullet = _bullets.pop_back()
	firstBullet.fire()
	return

func reload():
	print("Reloading")
	# Instantiate a new bullet from the prefab and add it to the array until the array is full.
	while _bullets.size() < Global.maxAmmo:
		var bullet: BulletDisplay = bulletPrefab.instantiate()
		var currentIndex = _bullets.size()
		bullet.name = "Bullet_" + str(currentIndex)
		add_child(bullet)
		_bullets.append(bullet)
		var position = Vector2(0, -45)
		position.y += currentIndex * 22.5
		bullet.position = position
		print("Loading " + bullet.name)
		