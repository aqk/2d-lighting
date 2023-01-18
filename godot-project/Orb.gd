extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var l1 = get_node("./Light2D")
onready var l2 = get_node("./Light2D2")

var max_energy = 1
var dim_distance = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = $"../Player"
	#var player = get_node("Player")
	var d = player.position.distance_to(position)
	# print(name, ":", d)
	
	

	if d < dim_distance:
		l1.energy = max_energy * (1 / (dim_distance - d))
		l2.energy = max_energy * (1 / (dim_distance - d))
