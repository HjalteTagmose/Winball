class_name Rail extends Line2D

@export var SlideSpeed : float = 15
@export var RailFollower : Node2D
@export var railBehaviour : RailBehaviour = RailBehaviour.PingPong

enum RailBehaviour { TeleportToStart, PingPong }

var currentNode : int
var currentLerpTime : float = 0

func _process(delta: float) -> void:
	if !RailFollower:
		return
	
	var firstPoint = to_global(points[currentNode])
	var secondPoint = to_global(points[currentNode + 1])
	var dist : float = firstPoint.distance_to(secondPoint)
	var time = dist / SlideSpeed
	time = currentLerpTime / time
	currentLerpTime += delta

	var value : Vector2 = lerp(firstPoint, secondPoint, time)
	RailFollower.global_position = value

	if time >= 1:
		currentNode += 1
		currentLerpTime = 0
	
	if currentNode >= points.size() - 1:
		HandleLastNode()
		

func HandleLastNode():
	
	if(railBehaviour == RailBehaviour.PingPong):
		# Reverse direction
		print("before", points)
		var currentPoints = points
		currentPoints.reverse()
		points = currentPoints
		print("after", points)
	PrepSlide()

func PrepSlide() -> void:
	currentNode = 0;
	currentLerpTime = 0
