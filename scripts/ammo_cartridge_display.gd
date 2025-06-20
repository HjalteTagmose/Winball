extends Sprite2D

@export var bulletPrefab: PackedScene

@export_category("Reload Animation")
@export var reload_animation_duration : float = 1.0
@export var reload_curve_y : Curve
@export var reload_curve_x : Curve

@export_category("Shot Animation")
@export var shot_animation_duration : float = 1.0
@export var shot_curve_y : Curve
@export var shot_curve_x : Curve

@export_category("Sound")
@export var oneShotSoundPrefab : PackedScene
@export var ScoreSound : AudioStream

@export var bullet_spawn_point: Node2D

var _bullets : Array[BulletDisplay] = []
var _start_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_pos = position
	for node: Node in bullet_spawn_point.get_children():
		if node is BulletDisplay:
			_bullets.append(node)
			
	if(Global != null):
		Global.flame_thrower_fired.connect(shot_anim)
		Global.bullet_fired.connect(on_bullet_fired)
		Global.reload.connect(reload)
		reload()

func on_bullet_fired():
	if(_bullets.size() <= 0 ):
		return
	
	var firstBullet = _bullets.pop_back()
	firstBullet.fire()
	shot_anim()
	return

func reload():
	
	# No need to reload if we are on full ammo
	if _bullets.size() >= Global.maxAmmo:
		return
	
	play_sound(ScoreSound)
	reload_anim()
	# Instantiate a new bullet from the prefab and add it to the array until the array is full.
	while _bullets.size() < Global.currentAmmo:
		var bullet: BulletDisplay = bulletPrefab.instantiate()
		var currentIndex = _bullets.size()
		bullet.name = "Bullet_" + str(currentIndex)
		bullet_spawn_point.add_child(bullet)
		_bullets.append(bullet)
		var position = Vector2(0, -45)
		position.y += currentIndex * 22.5
		bullet.position = position
		print("Loading " + bullet.name)
		
func reload_anim():
	var reload_tween = create_tween()
	reload_tween.set_loops(1)
	reload_tween.tween_method(reload_tween_function, 0, 100, reload_animation_duration)

func reload_tween_function(value: float):
	var percent = value / 100.0
	var x = reload_curve_x.sample(percent)
	var y = reload_curve_y.sample(percent)
	position = _start_pos + Vector2(x, y)
	
func shot_anim():
	var shot_tween = create_tween()
	shot_tween.set_loops(1)
	shot_tween.tween_method(shot_tween_function, 0, 100, shot_animation_duration)

func shot_tween_function(value: float):
	var percent = value / 100.0
	var x = shot_curve_y.sample(percent)
	var y = shot_curve_y.sample(percent)
	position = _start_pos + Vector2(x, y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_sound(sound: AudioStream):
	if sound == null:
		return
	
	# instantiate the OneShotSound prefab
	var oneShotSound: OneShotSound = oneShotSoundPrefab.instantiate()
	oneShotSound.name = "OneShotSound_" + str(sound.resource_name)
	get_tree().root.add_child(oneShotSound)
	oneShotSound.play_sound(sound)
