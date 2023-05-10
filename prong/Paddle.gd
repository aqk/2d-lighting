extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position
	var polygon = $KinematicBody2D/Polygon2D
	$KinematicBody2D/CollisionPolygon2D.polygon = polygon.polygon
	print(polygon.polygon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
