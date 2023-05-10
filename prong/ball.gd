extends Node2D

signal ball_state(velocity, position)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2(-100, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(320, 240)
	var polygon = $KinematicBody2D/Polygon2D
	$KinematicBody2D/CollisionPolygon2D.polygon = polygon.polygon
	print(polygon.polygon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# position += velocity * delta
	var collision = $KinematicBody2D.move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
	emit_signal("ball_state", velocity, position)

func set_ball_state(vel, pos):
	velocity = vel
	position = pos
