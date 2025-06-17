extends Node2D

class_name RoomLoader

@export var roomCount : int = 10
@export var firstRoom : PackedScene
@export var roomToSpawns : Array[PackedScene] = []

var _nextSpawnPoint : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnRoom(firstRoom, 0)
	
	for n in range(0, roomCount):
		spawnRoom(roomToSpawns.pick_random(), n+1) #+1 because we already spawned a set first room
	pass # Replace with function body.


func spawnRoom(roomToSpawn: PackedScene, i: int) -> void:
	var spawned : Room = roomToSpawn.instantiate()
	spawned.name = spawned.name + "_" + str(i)
	add_child(spawned)
	spawned.global_position = _nextSpawnPoint
	var exit : RoomExit = spawned.roomExit
	_nextSpawnPoint = exit.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
