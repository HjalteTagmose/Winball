class_name RoomLoaderNode extends Node2D

@export var roomCount : int = 10
@export var firstRoom : PackedScene
@export var roomToSpawns : Array[PackedScene] = []

var triggeredExitsSet: Dictionary = {}
var _nextSpawnPoint : Vector2 = Vector2.ZERO
var _spawnedRooms : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup()
	Global.game_started.connect(_setup)
	pass # Replace with function body.

func _setup() -> void:
	
	_spawnedRooms = 0
	_nextSpawnPoint = Vector2.ZERO
	# Delete all children nodes
	for child in get_children():
		child.queue_free()
	
	_spawnRoom(firstRoom)
	
	for n in range(0, roomCount):
		_spawnRoom(roomToSpawns.pick_random())

func _spawnRoom(roomToSpawn: PackedScene) -> void:
	var spawned : Room = roomToSpawn.instantiate()
	spawned.name = spawned.name + "_" + str(_spawnedRooms)
	_spawnedRooms += 1
	call_deferred("add_child", spawned)
	spawned.global_position = _nextSpawnPoint
	var exit : RoomExit = spawned.roomExit
	exit.exit_triggered.connect(roomExitHit)
	_nextSpawnPoint = exit.global_position
	#print("Spawned " + spawned.name)

func roomExitHit(exit: RoomExit):
	#print(triggeredExitsSet)
	if(triggeredExitsSet.has(exit)):
		return
	triggeredExitsSet[exit] = true
	_spawnRoom(roomToSpawns.pick_random())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
