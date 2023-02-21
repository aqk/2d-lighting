extends Control


func _ready():
	Global.push_ui(self)
	$VBoxContainer/StartButton.grab_focus()


func toggle_show_menu():
	if Global.ui_is_visible(self):
		Global.pop_ui()
	else:
		Global.push_ui(self)
		$VBoxContainer/StartButton.grab_focus()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_show_menu()
		

func _on_StartButton_pressed():
	# When / if we have levels
	# get_tree.change_scene("res://Levels/Level_00.tscn")

	# Just hide the menu for now
	Global.pop_ui()
	

func _on_ControlsButton_pressed():
	Global.push_ui($VBoxContainer/ControlsButton/PopupDialog)


func _on_QuitButton_pressed():
	get_tree().quit()


