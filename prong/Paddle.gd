extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func offset_polygon_points(center: Vector2, polygon: PoolVector2Array):
	var adjusted_points = []
	for point in polygon:
		adjusted_points.append(point-center)
	return adjusted_points

func get_polygon_center(polygon: PoolVector2Array):
	var center_weight = polygon.size()
	var center = Vector2(0,0)
	
	for point in polygon:
		center.x += point.x / center_weight
		center.y += point.y / center_weight
	return center

# Called when the node enters the scene tree for the first time.
func _ready():
	var polygon = $KinematicBody2D/Polygon2D
	
	var polygon_center = get_polygon_center(polygon.polygon)	
	var new_points = offset_polygon_points(polygon_center, polygon.polygon)
	polygon.polygon = new_points

	$KinematicBody2D/CollisionPolygon2D.polygon = polygon.polygon
	print(polygon.polygon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
