extends KinematicBody2D

export var MAX_SPEED = 150
export var IDLE_CREEP = 30
export var ACCEL = 8
export var DECEL = 15
export var STOP_DUR = 0.5
export var REVERSE_DUR = 1.0
export var TURN_TIGHTNESS = 100
# TURN_INCREMENT is bogus, because if depends on physics calc interval
# Turn radius also doesn't depend on movement (car can turn like a tank)
export var TURN_INCREMENT = 5
export var TURN_AGGRESSIVE = 40
export var TURN_AGGRESSIVE_INC = 10
export var ACCEL_HARD_DIFF = 10

export var POSITION_TOO_FAR = 600
export var POSITION_WARP_BACK = 1000


var lock_steering = false
var velocity = Vector2.ZERO
var speed = 0
var speed_target = 0
# turn and turn_target are absolute angles, not relative
var turn = 0
var turn_target = 0
var stop_timeout = 0
var reverse_timeout = 0

var brake = false
var accel = false
var left = false
var right = false

# Sound State
var playing_brake = false
var playing_vroom = false

var last_fps_time = 0
var fps = 0
var acc = 0

var pi = 3.141592653

signal car_speed
signal car_position

func sigmoid(x):
	return 1.0 / (1.0 + exp(-x))

func _ready():
	pass

func read_input():
	if Input.is_action_just_pressed("brake"):
		brake = true
	if Input.is_action_just_released("brake"):
		brake = false
		
	if Input.is_action_just_pressed("accel"):
		accel = true
	if Input.is_action_just_released("accel"):
		accel = false
		
	if Input.is_action_just_pressed("left"):
		left = true
	if Input.is_action_just_released("left"):
		left = false
		
	if Input.is_action_just_pressed("right"):
		right = true
	if Input.is_action_just_released("right"):
		right = false

func handle_input():		
	speed_target = IDLE_CREEP
	if brake:
		speed_target = 0
	elif accel:
		speed_target = MAX_SPEED
		reverse_timeout = 0
	else:
		if speed_target > MAX_SPEED / 5:
			speed_target = MAX_SPEED / 5

	if lock_steering:
		turn_target = 0
		if left && !right:
			turn_target = -TURN_TIGHTNESS
		elif right && !left:
			turn_target = TURN_TIGHTNESS
	else:
		if left && !right:
			turn_target -= TURN_INCREMENT
		elif right && !left:
			turn_target += TURN_INCREMENT


func handle_sound():
	if brake == true and playing_brake == false:
		playing_brake = true
		$Braking.play(0.3)
	if (brake == false and playing_brake == true) or speed < 40:
		playing_brake = false
		$Braking.stop()
	if brake == true and accel == true and playing_vroom == false:
		# TODO: Add timer before starting vroom
		playing_vroom = true
		$Vroom.play(0.4)
	if playing_vroom and (brake == false or accel == false):
		# TODO: Speed Boost when releasing a vroom, depending on how long held
		playing_vroom = false
		$Vroom.stop()
		
func _process(_delta):
	read_input()
	handle_sound()
	handle_input()
	emit_signal("car_speed", speed)
	emit_signal("car_position", position)

func do_backup_physics():
	if abs(turn_target - turn) > TURN_AGGRESSIVE:
		if turn_target > turn:
			turn = turn + TURN_AGGRESSIVE_INC
		else:
			turn = turn - TURN_AGGRESSIVE_INC
	else:
		turn = (turn + turn_target) / 2

	speed = (speed - speed_target)	/ 2

	var car_dir = turn / (pi * 100)
	var car_cos = cos(car_dir)
	var car_sin = sin(car_dir)
	var new_velocity_x = car_cos * speed
	var new_velocity_y = car_sin * speed
	
	var new_velocity = Vector2(new_velocity_x, new_velocity_y)
	rotation = car_dir
	return new_velocity
		

func do_normal_physics():
	if abs(turn_target - turn) > TURN_AGGRESSIVE:
		if turn_target > turn:
			turn = turn + TURN_AGGRESSIVE_INC
		else:
			turn = turn - TURN_AGGRESSIVE_INC
	else:
		turn = (turn + turn_target) / 2

	if abs(speed_target - speed) > ACCEL_HARD_DIFF:
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
	var _vel_diff = new_velocity - velocity
	
	# XXX If vel_diff is too large, skid
	rotation = car_dir
	return new_velocity
	
func _physics_process(delta):
	if stop_timeout > 0:
		stop_timeout -= delta
		return
		
	var new_velocity = Vector2.ZERO
	if reverse_timeout > 0:
		reverse_timeout -= delta
		speed = -ACCEL
		new_velocity = do_backup_physics()
	else:
		new_velocity = do_normal_physics()
		
	velocity = new_velocity

	var collision = move_and_collide(new_velocity * delta)	
	if collision:
		stop_timeout = STOP_DUR
		reverse_timeout = STOP_DUR + REVERSE_DUR

func _on_Burnout_finished():
	print("stopping ", name)
	$Burnout.stop()
	
