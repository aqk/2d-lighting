extends KinematicBody2D

export var MAX_SPEED = 15
export var ACCEL = 1
export var DECEL = 3

var velocity = Vector2.ZERO
var speed = 0
var speed_target = 0
var turn = 0
var turn_target = 0

var last_fps_time = 0
var fps = 0
var acc = 0

var pi = 3.141592653

func sigmoid(x):
	return 1.0 / (1.0 + exp(-x))

func _ready():
	pass

func _input(event):
	turn_target = 0
	
	if event.is_action_pressed("brake"):
		speed_target = 0
	elif event.is_action_pressed("accel"):
		speed_target = MAX_SPEED
	else:
		if speed_target > MAX_SPEED / 5:
			speed_target = MAX_SPEED / 5
	
	if event.is_action_pressed("left"):
		turn_target = -100
	elif event.is_action_pressed("right"):
		turn_target = 100

func _process(delta):
	pass
	
func _physics_process(delta):
	if abs(turn_target - turn) > 40:
		if turn_target > turn:
			turn = turn + 10
		else:
			turn = turn - 10
	else:
		turn = (turn + turn_target) / 2

	if abs(speed_target - speed) > 10:
		if speed_target > speed:
			speed += ACCEL
		else:
			speed -= DECEL
	else:
		speed = speed_target

	var car_dir = turn / (pi * 100)
	var car_cos = cos(car_dir)
	var car_sin = sin(car_dir)
	
	var new_velocity_x = car_cos * speed
	var new_velocity_y = car_sin * speed
	
	var new_velocity = Vector2(new_velocity_x, new_velocity_y)
	var vel_diff = new_velocity - velocity
	
	# XXX If vel_diff is too large, skid
	velocity = new_velocity
	
	rotation = car_dir
	
	position.x += new_velocity_x
	position.y += new_velocity_y
	
	$"CameraTransform".scale.x = speed / 30.0
	$"CameraTransform".scale.y = speed / 30.0
