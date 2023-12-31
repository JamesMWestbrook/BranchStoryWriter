extends TextEdit

signal create_dialog(origin)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if has_focus():
		if event is InputEventKey and event.is_pressed():
			print(event.keycode)
			if event.keycode == KEY_ENTER:
				create_dialog.emit()
				get_viewport().set_input_as_handled()
func _on_text_set():
	print("Set")
	pass # Replace with function body.

