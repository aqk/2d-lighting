extends Node2D

signal mouse_pos(y)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event is InputEventMouse:
		emit_signal("mouse_pos", event.global_position.y)
	
func set_server_mouse_pos(y):
	$Paddle2.position.y = y
	
func set_client_mouse_pos(y):
	$Paddle2.position.y = y
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
