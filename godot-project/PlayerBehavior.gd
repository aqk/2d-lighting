extends KinematicBody2D

func _ready():
	$"../Car".connect("car_position", self, "_car_position")

func _car_position(pos):
	print("got here",pos)
	position = pos

func _physics_process(delta):
	pass
