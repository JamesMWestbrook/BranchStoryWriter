extends Panel

@export var scene_header: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _unhandled_input(event):
	print("Unhandled")
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:
			if LineUser.has_line:
				var textedit = _spawn_scene(event.position)
				var line_finish_pos = textedit.get_node("Left").global_position
				LineUser._finish_node(line_finish_pos)
			else:
				_spawn_scene(event.position)
			
		


func _spawn_scene(pos:Vector2):
	var textedit = scene_header.instantiate()
	add_child(textedit)
	textedit.position = pos
	return textedit

func _on_area_2d_input_event(viewport, event, shape_idx):
	print(event.position)
