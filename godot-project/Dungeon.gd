extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../../Player".connect("car_position", self, "_car_position")

# Car at 0, Ground at 0
# next boundary.
# therefore: 
func _car_position(pos):
	var world_step = $"..".WORLD_GRID_STEP
	var p_x_int = int(pos.x)
	var p_y_int = int(pos.y)
	var grid_tile_x = (p_x_int + (world_step / 2)) / world_step
	var grid_tile_y = (p_y_int + (world_step / 2)) / world_step
	print(grid_tile_x, ", ", grid_tile_y)
	position = Vector2(float(grid_tile_x * world_step), float(grid_tile_y * world_step))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
