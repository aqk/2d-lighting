extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var show_menu = true

func toggle_show():
	show_menu = !show_menu
	if show_menu:
		self.show()
	else:
		self.hide()
	print(show_menu)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_show()
		

func _on_StartButton_pressed():
	# When / if we have levels
	# get_tree.change_scene("res://Levels/Level_00.tscn")
	
	# Just hide the menu for now
	self.hide()
	

func _on_QuitButton_pressed():
	get_tree().quit()
