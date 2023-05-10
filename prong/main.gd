extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var new_position

# Called when the node enters the scene tree for the first time.
func _ready():
	new_position = position

func _input(event):
	if event is InputEventMouse:
		new_position = event.global_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$Paddle/KinematicBody2D.move_and_slide(Vector2(0, new_position.y-position.y))
	$Paddle.position = Vector2($Paddle.position.x, new_position.y)
