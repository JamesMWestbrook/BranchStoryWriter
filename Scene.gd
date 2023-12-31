extends Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuButton.get_popup().id_pressed.connect(_resize)
	_resize(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _resize(id):
	print(id)
	var x:int
	var y:int
	if id % 2 == 0: #even, normal line
		x = 220
	else: #odd, long line
		x = 404
	if id == 0 or id == 1:
		y = 1
	elif id == 2 or id == 3:
		y = 2
	elif id == 4 or id == 5:
		y = 4
	$TextEdit.size = Vector2(x,32 * y)
	_resize_self()
func _on_text_edit_gui_input(event):
	_resize_self()

func _resize_self():
	size.x = $TextEdit.size.x + 60
	size.y = $TextEdit.size.y + 50.
	pass


func _on_menu_button_button_down():
	pass
	#var child: PopupMenu = $MenuButton.get_child(0)
	#child.id_pressed.connect(_resize)


func _on_right_button_down():
	var line = Line2D.new()
	$Right.add_child(line)
	line.add_point($Right/Node2D.position)
#	line.add_point(get_viewport().get_mouse_position())
	LineUser._assign_node(line)
