extends Node2D

class_name RoomLoader

@export var roomToSpawns : Array(PackedScene)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var spawned = roomToSpawn.instantiate()
	add_child(spawned)	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
