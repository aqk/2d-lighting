extends CharacterBody2D

var speed = 150
var move_direction = Vector2(0,0)
var cycle_secs = 4
var secs = 0.0
var dir = -0.5

@onready var path_follow = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	path_follow = get_parent()


func _physics_process(delta):
	secs += delta
	if secs > cycle_secs:
		secs = 0.0
		dir *= -1
	#var dir = (int(secs) % cycle_secs) - (cycle_secs)
	#print(delta, " ", dir)
	move_direction = Vector2(0, -dir)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var movement = move_direction.normalized() * speed
	#print(movement)
	set_velocity(movement)
	move_and_slide()
	var _velocity = velocity

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		print("Player hit Enemy!")
