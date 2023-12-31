extends Panel

@export var scene_header: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _unhandled_input(event):
	#if LineUser.has_node:
		#LineUser.current_node.set_point_position(1, event.position)
		#print(event.position)
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:
			print("Click/unclick at: ", event.position)
			var textedit = scene_header.instantiate()
			add_child(textedit)
			textedit.position = event.position
			#textedit.size.x = 60
			#textedit.size.y = 50
			#textedit.wrap_mode=TextEdit.LINE_WRAPPING_BOUNDARY
			#textedit.scroll_fit_content_height = true
		




func _on_area_2d_input_event(viewport, event, shape_idx):
	print(event.position)
	pass # Replace with function body.
