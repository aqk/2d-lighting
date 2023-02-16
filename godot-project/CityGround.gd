extends Node2D

var WORLD_GRID_STEP = 1248 * 2

# Called when the node enters the scene tree for the first time.
func _ready():
	var _error = $"../Player".connect("car_position", self, "_car_position")
	for i in range(3):
		for j in range(3):
			var index = (3 * i) + j
			var tile_node = self.get_child(index)
			var node_pos = Vector2((j - 1) * WORLD_GRID_STEP, (i - 1) * WORLD_GRID_STEP)
			tile_node.position = node_pos

func _car_position(pos):
	var world_step = WORLD_GRID_STEP
	var p_x_int = int(pos.x)
	var p_y_int = int(pos.y)
	var grid_tile_x = (p_x_int + (world_step / 2)) / world_step
	var grid_tile_y = (p_y_int + (world_step / 2)) / world_step
	# print("Car position in CityGround: (", grid_tile_x, ", ", grid_tile_y, ")")
	for i in range(3):
		for j in range(3):
			var index = (3 * i) + j
			var tile_node = self.get_child(index)
			var node_pos = Vector2(((j - 1) + grid_tile_x) * world_step, ((i - 1) + grid_tile_y) * world_step)
			tile_node.position = node_pos
