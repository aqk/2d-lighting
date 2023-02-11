extends Camera2D

func _ready():
	$"../Node2D/Car".connect("car_position", _car_position)

func _car_position(pos):
	print("got here",pos)
	position = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
