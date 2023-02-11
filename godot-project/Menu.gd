extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	# When / if we have levels
	# get_tree.change_scene("res://Levels/Level_00.tscn")
	
	# Just hide the menu for now
	self.hide()
	

func _on_QuitButton_pressed():
	get_tree().quit()
