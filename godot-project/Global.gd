extends Node2D

var ui_state_stack = Array()

func _ready():
	# Push current scene to the UI Stack at startup
	var root = get_tree().root
	ui_state_stack.push_back(root.get_child(root.get_child_count() - 1))

func current_scene():
	return ui_state_stack.back()

func ui_is_visible(node):
	return ui_state_stack.find(node) != -1

func print_ui_state():
	print(ui_state_stack)

func push_ui(scene_node):
	scene_node.show()
	ui_state_stack.push_back(scene_node)
	print_ui_state()

func pop_ui():
	if ui_state_stack.size() > 1:
		var node = ui_state_stack.pop_back()
		node.hide()
	print_ui_state()
	
