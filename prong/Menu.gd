extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for control in $VBoxContainer.get_children():
		if control is Button:
			control.connect("pressed", self, "_on_button_pressed", [control.text])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_button_pressed(btn_text):
	match btn_text:
		"Host":
			for btn in $VBoxContainer.get_children():
				if btn is Button:
					btn.disabled = true
			$Network.host_game(false)
		"Client":
			for btn in $VBoxContainer.get_children():
				if btn is Button:
					btn.disabled = true
			$Network.join_game()
		"Start":
			$Network.server_start_game()
