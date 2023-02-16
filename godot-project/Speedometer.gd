extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var car_speed = 0.0
export var CAR_TOP_SPEED = 2200.0
export var SPEEDOMETER_TOP = 140.0
export var SPEEDOMETER_LEFT_MARGIN = -115.0
export var SPEEDOMETER_RIGHT_MARGIN = 115.0
var pi = 3.14159

func _ready():
	var _error = $"../../YSort/Player".connect("car_speed", self, "_on_Player_speed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var car_show_speed = car_speed / CAR_TOP_SPEED
	var speed_angle = SPEEDOMETER_LEFT_MARGIN + (car_show_speed * (SPEEDOMETER_RIGHT_MARGIN - SPEEDOMETER_LEFT_MARGIN)) / (360 / (2 * pi))
	$Needle.rotation = speed_angle


func _on_Player_speed(speed):
	car_speed = speed
