extends Panel

var scene:Array
var active_window
@export var WritingWindowScene:PackedScene

var connected_scenes:Array
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


func _on_right_button_down():
	var line = Line2D.new()
	get_window().add_child(line)
	line.add_point($Right.get_global_position())
	LineUser._assign_node(line,self)


func _on_left_button_down():
	if LineUser.has_line and LineUser.current_parent != self:
		#LineUser.current_parent.connected_scenes.append(self)
		LineUser._finish_node($Left.get_global_position(),self)


func _on_write_button_down():
	if is_instance_valid(active_window):
		active_window.show()
	else:
		active_window = WritingWindowScene.instantiate()
		add_child(active_window)
		active_window.updated_dialog.connect(_update_scene)
		active_window.position = get_viewport().get_mouse_position()
func _update_scene():
	scene = active_window.all_dialog
