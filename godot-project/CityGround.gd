extends Node2D

onready var rightward_street = preload("res://CityRoadRight.tscn")
onready var upward_street = preload("res://CityRoadUp.tscn")
onready var empty_tile = preload("res://EmptyTile.tscn")

var grid_tile_x = 0
var grid_tile_y = 0
var WORLD_GRID_STEP = 1248 * 2
var WORLD_GRID = [
	"    |    ",
	"=========",
	"    |    "
]

func update_to_tile(new_tile_x, new_tile_y):
	grid_tile_x = new_tile_x
	grid_tile_y = new_tile_y
	print(grid_tile_x, ", ", grid_tile_y)
	var tiles_to_display = get_surface_tiles(grid_tile_x, grid_tile_y)
	for i in range(3):
		for j in range(3):
			var index = (3 * i) + j
			var tile_node = $"ActiveTerrain".get_child(index)
			if tile_node != null:
				$"ActiveTerrain".remove_child(tile_node)

	for i in range(3):
		for j in range(3):
			var index = (3 * i) + j
			var from_tile_node = tiles_to_display[index]
			var node_pos = Vector2(((j - 1) + grid_tile_x) * WORLD_GRID_STEP, ((i - 1) + grid_tile_y) * WORLD_GRID_STEP)
			from_tile_node.position = node_pos
			$"ActiveTerrain".add_child(from_tile_node)


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../Player".connect("car_position", self, "_car_position")
	update_to_tile(0,0)

func get_surface_tiles(tx,ty):
	var grid_width = len(WORLD_GRID[0])
	var grid_height = len(WORLD_GRID)
	print(grid_width, ", ", grid_height)
	var tx_in_grid = (tx + 1) % grid_width
	var ty_in_grid = (ty + 1) % grid_height
	var left_edge = (tx_in_grid + grid_width - 1) % grid_width
	var top_edge = (ty_in_grid + grid_height - 1) % grid_height
	var right_edge = (tx_in_grid + 1) % grid_width
	var bottom_edge = (ty_in_grid + 1) % grid_height
	var x_grid_coords = [left_edge, tx_in_grid, right_edge]
	var y_grid_coords = [top_edge, ty_in_grid, bottom_edge]
	var result = []
	for i in range(3):
		for j in range(3):
			var index = (3 * i) + j
			var tile_node = $"ActiveTerrain".get_child(index)
			var x_in_grid = x_grid_coords[j]
			var y_in_grid = y_grid_coords[i]
			var char_of_grid = WORLD_GRID[y_in_grid][x_in_grid]
			if char_of_grid == '|':
				result.append(upward_street.instance())
			elif char_of_grid == "=":
				result.append(rightward_street.instance())
			else:
				result.append(empty_tile.instance())
	return result

func _car_position(pos):
	var p_x_int = int(pos.x)
	var p_y_int = int(pos.y)
	var new_tile_x = (p_x_int + (WORLD_GRID_STEP / 2)) / WORLD_GRID_STEP
	var new_tile_y = (p_y_int + (WORLD_GRID_STEP / 2)) / WORLD_GRID_STEP
	if new_tile_x != grid_tile_x || new_tile_y != grid_tile_y:
		update_to_tile(new_tile_x, new_tile_y)
